require "./key"
class KeyServerModel
  THREAD_LIFE = 300
  DEALLOCATION_TIME = 60

  attr_accessor :keys_in_use
  attr_accessor :available_keys
  attr_accessor :deleted_keys

  def generate_key
    key = Key.new()
  end

end