# encoding: utf-8

class String
  def to_bool
    return true if self == true || self =~ (/^(true|t|yes|y|on|1)$/i)
    return false if self == false || self.strip.empty? || self =~ (/^(false|f|no|n|off|0)$/i)
    raise ArgumentError.new("invalid value for Boolean: \"#{self}\"")
  end
end

class Fixnum
  def to_bool
    return true if self == 1
    return false if self == 0
    raise ArgumentError.new("invalid value for Boolean: \"#{self}\"")
  end
end

class TrueClass
  def to_i; 1; end
  def to_bool; self; end
end

class FalseClass
  def to_i; 0; end
  def to_bool; self; end
end

class NilClass
  def to_bool; false; end
end
