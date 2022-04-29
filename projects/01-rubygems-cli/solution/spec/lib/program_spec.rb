require "rspec"
require 'spec_helper'

require "./lib/program"
require "./lib/my_gem"

RSpec.describe Program do
  describe ".execute" do
    context "Given show command" do
      it "calls RubyGemsApi.gem_by_name method with the correct argument" do
        ruby_gems_api_mock = double('ruby_gems_api', gem_by_name: MyGem.new("faraday", "some info", ["MIT"], 10))

        program = Program.new(ruby_gems_api_mock)

        expect(ruby_gems_api_mock).to receive(:gem_by_name).with("faraday")
        program.execute(["show", "faraday"])
      end
    end

    context "Given search command" do
      it "calls RubyGemsApi.search_gems method with the correct arguments" do
        ruby_gems_api_mock = double('ruby_gems_api', search_gems: [MyGem.new("faraday", "some info", ["MIT"], 10)] )

        program = Program.new(ruby_gems_api_mock)

        expect(ruby_gems_api_mock).to receive(:search_gems).with("faraday", 0, '', false)
        program.execute(["search", "faraday"])
      end
    end

    context "Given search command with optional arguments" do
      it "calls RubyGemsApi.search_gems method with the correct arguments" do
        ruby_gems_api_mock = double('ruby_gems_api', search_gems: [MyGem.new("faraday", "some info", ["MIT"], 10)] )
        
        program = Program.new(ruby_gems_api_mock)

        expect(ruby_gems_api_mock).to receive(:search_gems).with("faraday", 3, "MIT", true)
        program.execute(["search", "faraday", "--limit", 3, "--license", "MIT", "--most-downloads-first"])
      end
    end
  end
end