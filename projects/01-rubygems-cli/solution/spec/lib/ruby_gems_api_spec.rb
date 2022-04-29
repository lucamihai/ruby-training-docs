require "rspec"
require 'spec_helper'

require "./lib/ruby_gems_api.rb"
require "./lib/my_gem.rb"

RSpec::Matchers.define :has_expected_name do |name|
  match { |actual| actual.name == name }
end

RSpec::Matchers.define :has_expected_names do |names|
  match { |actual| actual.all? {|gem| names.include?(gem.name)} }
end

RSpec.describe RubyGemsApi do
  describe ".gem_by_name" do
    context "with empty cache" do
      it "performs the expected GET request" do
        http_service_mock = double('http_service', get: {'name' => 'faraday', 'info' => 'some info'} )
        cache_service_mock = double('cache_service', get_cached_show_result: nil, cache_show_result: {} )

        ruby_gems_api = RubyGemsApi.new(http_service_mock, cache_service_mock)

        expectedUri = "https://rubygems.org/api/v1/gems/faraday"
        expect(http_service_mock).to receive(:get).with(expectedUri)
        ruby_gems_api.gem_by_name("faraday")
      end

      it "caches the result" do
        http_service_mock = double('http_service', get: {'name' => 'faraday', 'info' => 'some info'} )
        cache_service_mock = double('cache_service', get_cached_show_result: nil, cache_show_result: {} )

        ruby_gems_api = RubyGemsApi.new(http_service_mock, cache_service_mock)

        expect(cache_service_mock).to receive(:cache_show_result).with("faraday", has_expected_name("faraday"))
        ruby_gems_api.gem_by_name("faraday")
      end

      it "returns expected entity" do
        http_service_mock = double('http_service', get: {'name' => 'faraday', 'info' => 'some info'} )
        cache_service_mock = double('cache_service', get_cached_show_result: nil, cache_show_result: {} )

        ruby_gems_api = RubyGemsApi.new(http_service_mock, cache_service_mock)

        entity = ruby_gems_api.gem_by_name("faraday")
        expect(entity.name).to eq "faraday"
        expect(entity.info).to eq "some info"
      end
    end

    context "with cached results" do
      it "queries the cache" do
        http_service_mock = double('http_service', get: {'name' => 'faraday', 'info' => 'some info'})
        cache_service_mock = double('cache_service', get_cached_show_result: MyGem.new("faraday", "some info", nil, 0) )

        ruby_gems_api = RubyGemsApi.new(http_service_mock, cache_service_mock)

        expect(cache_service_mock).to receive(:get_cached_show_result).with("faraday", 48)
        ruby_gems_api.gem_by_name("faraday")
      end

      it "returns expected entity" do
        http_service_mock = double('http_service')
        cache_service_mock = double('cache_service', get_cached_show_result: MyGem.new("faraday", "some info", nil, 0) )

        ruby_gems_api = RubyGemsApi.new(http_service_mock, cache_service_mock)

        entity = ruby_gems_api.gem_by_name("faraday")
        expect(entity.name).to eq "faraday"
        expect(entity.info).to eq "some info"
      end
    end
  end

  describe ".search_gems" do
    context "with empty cache" do
      it "performs the expected GET request" do
        http_service_mock = double('http_service', get: [{'name' => 'faraday', 'info' => 'some info'}, {'name' => 'faraday2', 'info' => 'some info2'}] )
        cache_service_mock = double('cache_service', get_cached_search_result: nil, cache_search_result: {} )

        ruby_gems_api = RubyGemsApi.new(http_service_mock, cache_service_mock)

        expectedUri = "https://rubygems.org/api/v1/search?query=faraday"
        expect(http_service_mock).to receive(:get).with(expectedUri)
        ruby_gems_api.search_gems("faraday", 0, nil, true)
      end

      it "caches the result" do
        http_service_mock = double('http_service', get: [{'name' => 'faraday', 'info' => 'some info'}, {'name' => 'faraday2', 'info' => 'some info2'}] )
        cache_service_mock = double('cache_service', get_cached_search_result: nil, cache_search_result: {} )

        ruby_gems_api = RubyGemsApi.new(http_service_mock, cache_service_mock)

        expect(cache_service_mock).to receive(:cache_search_result).with("faraday", has_expected_names(["faraday", "faraday2"]))
        ruby_gems_api.search_gems("faraday", 0, nil, true)
      end

      it "returns expected list" do
        http_service_mock = double('http_service', get: [{'name' => 'faraday', 'info' => 'some info'}, {'name' => 'faraday2', 'info' => 'some info2'}] )
        cache_service_mock = double('cache_service', get_cached_search_result: nil, cache_search_result: {} )

        ruby_gems_api = RubyGemsApi.new(http_service_mock, cache_service_mock)

        list = ruby_gems_api.search_gems("faraday", 0, '', false)
        expect(list.count).to eq 2
        expect(list[0].name).to eq "faraday"
        expect(list[0].info).to eq "some info"
        expect(list[1].name).to eq "faraday2"
        expect(list[1].info).to eq "some info2"
      end
    end

    context "with cached results" do
      it "queries the cache" do
        http_service_mock = double('http_service', get: [{'name' => 'faraday', 'info' => 'some info'}, {'name' => 'faraday2', 'info' => 'some info2'}] )
        cache_service_mock = double('cache_service', get_cached_search_result: [MyGem.new("faraday", "some info", nil, 0), MyGem.new("faraday2", "some info2", nil, 0)] )

        ruby_gems_api = RubyGemsApi.new(http_service_mock, cache_service_mock)

        expect(cache_service_mock).to receive(:get_cached_search_result).with("faraday", 48)
        ruby_gems_api.search_gems("faraday", 0, '', false)
      end

      it "returns expected list" do
        http_service_mock = double('http_service')
        cache_service_mock = double('cache_service', get_cached_search_result: [MyGem.new("faraday", "some info", nil, 0), MyGem.new("faraday2", "some info2", nil, 0)] )

        ruby_gems_api = RubyGemsApi.new(http_service_mock, cache_service_mock)

        list = ruby_gems_api.search_gems("faraday", 0, '', false)
        expect(list.count).to eq 2
        expect(list[0].name).to eq "faraday"
        expect(list[0].info).to eq "some info"
        expect(list[1].name).to eq "faraday2"
        expect(list[1].info).to eq "some info2"
      end
    end

    context "with limit provided" do
      it "returns expected list" do
        http_service_mock = double('http_service', get: [{'name' => 'faraday', 'info' => 'some info'}, {'name' => 'faraday2', 'info' => 'some info2'}] )
        cache_service_mock = double('cache_service', get_cached_search_result: nil, cache_search_result: {} )
  
        ruby_gems_api = RubyGemsApi.new(http_service_mock, cache_service_mock)
  
        list = ruby_gems_api.search_gems("faraday", 1, '', false)
        expect(list.count).to eq 1
        expect(list[0].name).to eq "faraday"
        expect(list[0].info).to eq "some info"
      end
    end
  end
end