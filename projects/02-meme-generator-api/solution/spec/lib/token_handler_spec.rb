require "rspec"
require 'spec_helper'

require "./lib/token_handler"

RSpec.describe TokenHandler do
  describe ".generate_token" do
    it "returns encrypted password" do
      user_repository_mock = double('user_repository', user_exists: true )
      token_handler = TokenHandler.new(user_repository_mock)
      
      token = token_handler.generate_token('username')

      expect(token).to_not eq 'username'
    end
  end

  describe ".is_valid" do
    context "for nil token" do
      it "returns false" do
        user_repository_mock = double('user_repository', user_exists: true )
        token_handler = TokenHandler.new(user_repository_mock)

        expect(token_handler.is_valid(nil)).to eq false
      end
    end

    context "for empty token" do
      it "returns false" do
        user_repository_mock = double('user_repository', user_exists: true )
        token_handler = TokenHandler.new(user_repository_mock)

        expect(token_handler.is_valid('')).to eq false
      end
    end

    context "for existing user" do
      it "returns true" do
        user_repository_mock = double('user_repository', user_exists: true )
        token_handler = TokenHandler.new(user_repository_mock)

        token = token_handler.generate_token('username')

        expect(token_handler.is_valid(token)).to eq true
      end
    end

    context "for not existing user" do
      it "returns false" do
        user_repository_mock = double('user_repository', user_exists: false )
        token_handler = TokenHandler.new(user_repository_mock)

        token = token_handler.generate_token('username')

        expect(token_handler.is_valid(token)).to eq false
      end
    end

    it "checks user from token exists" do
      user_repository_mock = double('user_repository', user_exists: true )
      token_handler = TokenHandler.new(user_repository_mock)

      token = token_handler.generate_token('username')

      expect(user_repository_mock).to receive(:user_exists).with('username')
      token_handler.is_valid(token)
    end
  end
end
