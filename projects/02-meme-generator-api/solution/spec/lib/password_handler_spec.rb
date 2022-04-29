require "rspec"
require 'spec_helper'

require "./lib/password_handler"

RSpec.describe PasswordHandler do
  describe ".encrypt_password" do
    it "returns encrypted password" do
      password_handler = PasswordHandler.new
      
      encrypted_password = password_handler.encrypt_password('password')

      expect(encrypted_password).to_not eq 'password'
    end
    
  end

  describe ".is_same_password" do
    context "with same password" do
      it "returns true" do
        password_handler = PasswordHandler.new
        encrypted_password = password_handler.encrypt_password('password')

        expect(password_handler.is_same_password('password', encrypted_password)).to eq true
      end
    end

    context "with different password" do
      it "returns false" do
        password_handler = PasswordHandler.new
        encrypted_password = password_handler.encrypt_password('password')

        expect(password_handler.is_same_password('some other password', encrypted_password)).to eq false
      end
    end
  end
end
