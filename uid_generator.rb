require 'securerandom'

class UidGenerator
  ALPHABET = ('0'..'9').to_a + ('a'..'z').to_a + ('A'..'Z').to_a
  BASE = ALPHABET.size
  UID_SIZE = 8

  def initialize(maximum = BASE ** UID_SIZE)
    @maximum = maximum
  end

  def generate
    value = SecureRandom.random_number(@maximum)
    bijective_encode(value)
  end

  def bijective_encode(value)
    res = ''

    while value > 0
      res << ALPHABET[value.modulo(BASE)]
      value /= BASE
    end

    res << ALPHABET.first * (UID_SIZE - res.size)

    res.reverse
  end
end