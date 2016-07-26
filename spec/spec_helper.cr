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

class MockExecutor < Shards::Release::Executor
  getter executed_commands

  def initialize
    @executed_commands = [] of String
  end

  def execute(command)
    @executed_commands << command
  end
end
