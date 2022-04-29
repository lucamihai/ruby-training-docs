require "rspec"
require 'spec_helper'

require "./lib/arguments_parser.rb"

RSpec.describe ArgumentsParser do
  describe ".parse" do
    context "Given show command" do
      subject { ArgumentsParser.parse(["show", "faraday"]) }
      it "returns expected entity" do
        expect(subject.name).to eq "faraday"
        expect(subject.search_term).to eq ""
        expect(subject.search_limit).to eq 0
      end
    end

    context "Given search command" do
      subject { ArgumentsParser.parse(["search", "faraday"]) }
      it "returns expected entity" do
        expect(subject.name).to eq ""
        expect(subject.search_term).to eq "faraday"
        expect(subject.search_limit).to eq 0
        expect(subject.license).to eq ""
        expect(subject.order_by_downloads_descending).to eq false
      end
    end

    context "Given search command with optional arguments" do
      subject { ArgumentsParser.parse(["search", "faraday", "--limit", "3", "--license", "MIT", "--most-downloads-first"]) }
      it "returns expected entity" do
        expect(subject.name).to eq ""
        expect(subject.search_term).to eq "faraday"
        expect(subject.search_limit).to eq 3
        expect(subject.license).to eq "MIT"
        expect(subject.order_by_downloads_descending).to eq true
      end
    end
  end
end