require "spec"
require "../src/shards-release"

class Expecter(T)
  def initialize(@value : T)
  end

  def to(matcher)
    @value.call.should matcher
  end
end

def expect(value)
  Expecter.new(value)
end
