require "securerandom"

class Key
  attr_accessor :key_name

  def initialize
      self.key_name = SecureRandom.hex(8)
  end
end