module Friendis
  module Friendable
    def self.included(base)
      base.class_eval do

        include InstanceMethods
        extend  ClassMethods

        after_save :_update_friendis_meta_data
        after_destroy :clear_friendis_data

        @friendis_fields
      end

    end

    module ClassMethods
      
      # Mark the list of fields to track in redis for fast access.
      def friend_this(options = {})
        configuration = {
          track: [:id]
        }.merge(options)
        configuration[:track] << :id
        self.friendis_fields = configuration[:track]
      end

      # Set trackable fields
      def friendis_fields=(new_field_list)
        @friendis_fields = new_field_list
      end

      # Retrieve trackable fields
      def friendis_fields
        @friendis_fields ||= []
      end

    end

    module InstanceMethods 

      

      def get_friendis_meta(uuid = nil)
        Friendis.redis.hgetall friendis_meta_key(uuid)
      end

      def send_friend_request(friend)
        Friendis.redis.multi do
          Friendis.redis.sadd friendis_outgoing_friend_requests_key, friend.id.to_s
          Friendis.redis.sadd friend.friendis_incoming_friend_requests_key, self.id.to_s
        end
      end

      def approve_friend_request(friend)
        if !(Friendis.redis.sismember(friendis_incoming_friend_requests_key, friend.id.to_s))
          return false
        else
          Friendis.redis.multi do
            Friendis.redis.srem friend.friendis_outgoing_friend_requests_key, self.id.to_s
            Friendis.redis.srem friendis_incoming_friend_requests_key, friend.id.to_s
            Friendis.redis.sadd friendis_my_friends_key, friend.id.to_s
            Friendis.redis.sadd friend.friendis_my_friends_key, self.id.to_s
          end
          return true
        end
      end

      def ignore_friend_request(friend)
        if !(Friendis.redis.sismember(friendis_incoming_friend_requests_key, friend.id.to_s))
          return false
        else

          # Ignoring a friend request, leaves the request in the requester queue, but removes
          # it from the pending requests list of the recipient.
          Friendis.redis.multi do
            Friendis.redis.srem friendis_incoming_friend_requests_key, friend.id.to_s
          end
          return true
        end
      end

      def unfriend(friend)
        Friendis.redis.multi do
          Friendis.redis.srem friendis_my_friends_key, friend.id
          Friendis.redis.srem friend.friendis_my_friends_key, self.id
        end
      end

      def friends
        Friendis.redis.smembers(friendis_my_friends_key).collect {|friend_id| get_friendis_meta(friend_id)}
      end

      def is_friends_with?(friend)
        Friendis.redis.sismember friendis_my_friends_key, friend.id.to_s
      end

      def pending_friend_requests
        Friendis.redis.smembers(friendis_incoming_friend_requests_key).collect {|friend_id| get_friendis_meta(friend_id)}
      end

      def sent_friend_requests
        Friendis.redis.smembers(friendis_outgoing_friend_requests_key).collect {|friend_id| get_friendis_meta(friend_id)}
      end

      def clear_friendis_data
        [friendis_meta_key, friendis_my_friends_key, friendis_incoming_friend_requests_key, friendis_outgoing_friend_requests_key].each do |friendis_key|
          Friendis.redis.del friendis_key
        end
      end

      def _update_friendis_meta_data
        Friendis.redis.multi do
          attr_hash = {}

          self.class.friendis_fields.each do |field|
            attr_hash[field] = self.send(field)
          end
          Friendis.redis.hmset friendis_meta_key, *attr_hash.to_a
        end
        true
      end

      def friendis_meta_key(uuid = nil)
        "#{self.class.name.downcase}:#{uuid || self.id}:friendis_meta"
      end

      def friendis_my_friends_key
        "#{self.class.name.downcase}:#{self.id}:friends"
      end

      def friendis_incoming_friend_requests_key
        "#{self.class.name.downcase}:#{self.id}:friend_requests"
      end

      def friendis_outgoing_friend_requests_key
        "#{self.class.name.downcase}:#{self.id}:requested_friendship"
      end
    end
  end
end
