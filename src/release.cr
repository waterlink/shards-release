require "./shards-release"

include Shards::Release

bumper_name = ARGV[0]?

shard_config = ShardConfig.parse(File.read("shard.yml"))
bumper = VersionBumperFactory.new.create(bumper_name, shard_config)
new_shard_config = bumper.bump
File.write("shard.yml", new_shard_config.to_yaml)

executor = StockExecutor.new
GitTag.new(new_shard_config.version, executor).create
GitPush.new(executor).push
GitPushTags.new(executor).push
