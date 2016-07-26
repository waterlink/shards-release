require "./spec_helper"

module Shards::Release
  describe Shards::Release do
    shard_config = ""
    subject = nil

    shard_config_parsed = -> { ShardConfig.parse(shard_config) }
    response = -> { subject.not_nil!.call.bump }

    major_part = -> { response.call.major_part }
    minor_part = -> { response.call.minor_part }
    patch_part = -> { response.call.patch_part }

    dumped_response = -> { response.call.to_yaml }

    describe Major do
      subject = -> { Major.new(shard_config_parsed.call) }

      it "increases major part of version" do
        shard_config = "version: 0.0.1"
        expect(major_part).to eq(1)
      end

      it "increases major part of version for different version" do
        shard_config = "version: 1.0.1"
        expect(major_part).to eq(2)
      end

      it "zeroes minor part" do
        shard_config = "version: 2.3.4"
        expect(minor_part).to eq(0)
      end

      it "zeroes patch part" do
        shard_config = "version: 2.3.4"
        expect(patch_part).to eq(0)
      end

      it "preserves other content" do
        shard_config = [
          "---",
          "version: 3.4.5",
          "authors:",
          "- John Smith",
          "- James King"
        ].join("\n")

        expect(dumped_response).to eq([
          "--- ",
          "version: 4.0.0",
          "authors: ",
          "  - John Smith",
          "  - James King"
        ].join("\n"))
      end
    end

    describe Minor do
      subject = -> { Minor.new(shard_config_parsed.call) }

      it "increases minor part" do
        shard_config = "version: 0.1.0"
        expect(minor_part).to eq(2)
      end

      it "increases minor part when it is different" do
        shard_config = "version: 0.3.0"
        expect(minor_part).to eq(4)
      end

      it "zeroes patch part" do
        shard_config = "version: 1.2.3"
        expect(patch_part).to eq(0)
      end

      it "preserves major part" do
        shard_config = "version: 2.3.4"
        expect(major_part).to eq(2)
      end

      it "preserves major part when it is different" do
        shard_config = "version: 3.4.5"
        expect(major_part).to eq(3)
      end
    end

    describe Patch do
      subject = -> { Patch.new(shard_config_parsed.call) }

      it "increases patch part" do
        shard_config = "version: 0.0.1"
        expect(patch_part).to eq(2)
      end

      it "increases patch part when it is different" do
        shard_config = "version: 0.0.3"
        expect(patch_part).to eq(4)
      end

      it "preserves major part" do
        shard_config = "version: 7.6.5"
        expect(major_part).to eq(7)
      end

      it "preserves major part when it is different" do
        shard_config = "version: 4.6.5"
        expect(major_part).to eq(4)
      end

      it "preserves minor part" do
        shard_config = "version: 7.6.5"
        expect(minor_part).to eq(6)
      end

      it "preserves minor part when it is different" do
        shard_config = "version: 7.11.5"
        expect(minor_part).to eq(11)
      end
    end

    describe VersionBumperFactory do
      name = ""
      factory = VersionBumperFactory.new
      version_bumper = -> { factory.create(name, shard_config_parsed.call) }

      it "creates Patch version bumper by default" do
        name = nil
        expect(version_bumper).to be_a(Patch)

        name = ""
        expect(version_bumper).to be_a(Patch)
      end

      it "creates Minor version bumper when name=minor" do
        name = "minor"
        expect(version_bumper).to be_a(Minor)
      end

      it "creates Major version bumper when name=major" do
        name = "major"
        expect(version_bumper).to be_a(Major)
      end
    end
  end
end
