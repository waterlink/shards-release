require "./shards-release"

include Shards::Release

action = ARGV[0]
shard_config = ShardConfig.parse(File.read("shard.yml"))
bumper = VersionBumperFactory.new.create(action, shard_config)
new_shard_config = bumper.bump
File.write("shard.yml", new_shard_config.to_yaml)
