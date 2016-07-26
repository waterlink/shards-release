require "yaml"

module Shards::Release
  ZERO = 0

  class ShardConfig
    def self.parse(string)
      new(YAML.parse(string))
    end

    def initialize(@value : YAML::Any)
    end

    def major_part
      part(0)
    end

    def minor_part
      part(1)
    end

    def patch_part
      part(2)
    end

    def version
      @value["version"].to_s
    end

    def bump(new_version)
      new_config = @value.dup
      new_config.as_h["version"] = new_version
      ShardConfig.new(new_config)
    end

    delegate to_yaml, to: @value

    private def part(index)
      parts[index].to_i
    end

    private def parts
      version.split(".")
    end
  end

  class Major
    def initialize(@shard_config : ShardConfig)
    end

    def bump
      @shard_config.bump("#{next_major_part}.#{ZERO}.#{ZERO}")
    end

    private def next_major_part
      @shard_config.major_part + 1
    end
  end

  class Minor
    def initialize(@shard_config : ShardConfig)
    end

    def bump
      @shard_config.bump("#{major_part}.#{next_minor_part}.#{ZERO}")
    end

    private def next_minor_part
      @shard_config.minor_part + 1
    end

    private delegate major_part, to: @shard_config
  end

  class Patch
    def initialize(@shard_config : ShardConfig)
    end

    def bump
      @shard_config.bump(
        "#{major_part}.#{minor_part}.#{next_patch_part}"
      )
    end

    private def next_patch_part
      @shard_config.patch_part + 1
    end

    private delegate major_part, minor_part, to: @shard_config
  end

  class VersionBumperFactory
    def create(name, shard_config)
      return Minor.new(shard_config) if name == "minor"
      return Major.new(shard_config) if name == "major"
      Patch.new(shard_config)
    end
  end

  abstract class Executor
    abstract def execute(command)
  end

  class GitTag
    def initialize(@version : String, @executor : Executor)
    end

    def create
      @executor.execute("git tag v#{@version}")
    end
  end

  class GitPush
    def initialize(@executor : Executor)
    end

    def push
      @executor.execute("git push origin master")
    end
  end

  class GitPushTags
    def initialize(@executor : Executor)
    end

    def push
      @executor.execute("git push --tags")
    end
  end

  class StockExecutor < Executor
    def execute(command)
      system(command)
    end
  end
end
