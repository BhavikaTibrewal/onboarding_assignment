require "./key"
class KeyServerModel
  KEY_LIFE = 300
  DEALLOCATION_TIME = 60

  attr_accessor :keys_in_use
  attr_accessor :available_keys
  attr_accessor :deleted_keys

  def initialize
    @keys_in_use = {}
    @available_keys = {}
    @deleted_keys = Set.new
  end
  def generate_key
    key = Key.new()
    if !@available_keys.key?(key.key_name) and !@keys_in_use.key?(key.key_name)
      @available_keys[key.key_name] = true
      key.key_name
    else
      generate_key
    end
  end

  def get_key
    return nil if @available_keys.size == 0
    key = @available_keys.shift[0]
    @keys_in_use[key] = Time.now.to_i
    key
  end

  def unblock_key(key)
    return false, "Key not in use." unless @keys_in_use.key? key
    @keys_in_use.delete key
    @available_keys[key] = true
    true
  end

  def delete_key(key)
    # check if key is valid
    return false, "Invalid key" unless @keys_in_use.key? key or @available_keys.key? key
    return false, "Key Already Deleted" if @deleted_keys.include?key
    @available_keys.delete key
    @keys_in_use.delete key
    @deleted_keys.add key
  end

  def refresh_key(key)
    return false, "Invalid key" unless @keys_in_use.key? key
    @keys_in_use[key] = Time.now.to_i
    true
  end

  def cron
    current_time = Time.now.to_i
    puts @available_keys, @keys_in_use, @deleted_keys
    @keys_in_use.each do |key, timestamp|
      next if timestamp.is_a?NilClass
      delete_key(key) if current_time - timestamp > KEY_LIFE
      unblock_key(key) if current_time - timestamp > DEALLOCATION_TIME
    end
  end
end