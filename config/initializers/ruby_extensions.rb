class Object

  def self.valid_subclass?(klass)
    subclasses.include? klass
  end

  def self.list_subclasses
    subclasses
  end

end


class Array

  attr_accessor :total

  def to_label
    self.map { |item| item.to_label }.join(',')
  end

end
