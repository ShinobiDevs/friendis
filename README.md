# Friendis

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'friendis'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install friendis

## Usage

### Configuration

create an initializer in `config/initializers/friendis.rb`:

    Friendis.configure do |c|
      #...
    end

The following options exist:

* redis_connection: an existing Redis connection, defaults to a `Redis.new` instance.

### Adding to a Model

All you need to do is to include the `Friendable` module:

    include Friendis::Friendable

and to choose which attributes or methods will be cached in Redis for that user:

    friend_this track: [:name, :picture]

Those fields will be changed in Redis after everytime you save the instance, note that
your ORM needs to implement `after_save` and `after_destroy` since Friendis utilizes those callbacks to update and remove
the cached data from Redis.

The `id` attribute will automatically be cached.


## Examples
    
    class User < ActiveRecord::Base
      include Friendis::Friendable

      friend_this track: [:name, :picture]
    end 

### Friend Requests

    @user1 = User.create(name: "Elad Meidar", picture: "http://picturez.com/elad.jpg")
    @user2 = User.create(name: "Miki Bergin", picture: "http://picturez.com/miki.jpg")

    @user1.send_friend_request(@user2)

## Pending Friend Request

    @user2.pending_friend_requests

`pending_friend_requests` will return the cached attributes for the pending friend requests, in this case

    [{"name" => "Elad Meidar", "picture" => "http://picturez.com/elad.jpg", "id" => 1}]

## Sent Friend Request

    @user2.sent_friend_requests

`sent_friend_requests` will return the cached attributes for the sent friend requests, in this case

    [{"name" => "Miki Bergin", "picture" => "http://picturez.com/miki.jpg", "id" => 2}]

## Approving Friend Requests

    @user2.approve_friend_request(@user1)

## Lisiting Friends
    
    @user1.friends

`friends` will return the cached attributes of the currently approved friends, in this case

    [{"name" => "Miki Bergin", "picture" => "http://picturez.com/miki.jpg", "id" => 2}] 


## Check Friendship

    @user1.is_friends_with?(@user2) #= true
    @user1.is_friends_with?(@user3) #= false

## Unfriend

    @user1.unfriend(@user2)


## Contributing

1. Fork it ( http://github.com/<my-github-username>/friendis/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
