class User

  @after_save_method = nil

  def User.after_save(method)
    @after_save_method = method
  end

  def User.after_destroy(method)
  end
  
  include Friendis::Friendable

  attr_accessor :id, :name, :picture

  

  friend_this track: [:name, :picture]

  

  def User.after_save_method
    @after_save_method
  end

  def initialize(id)
    @id = id
    @name = "Test #{rand(9000)+ 1000}"
    @picture = "http:/picturez.com/user/#{id}.jpg"
  end

  def save
    self.send(User.after_save_method)
  end

  def after_save(method)
    
  end
end