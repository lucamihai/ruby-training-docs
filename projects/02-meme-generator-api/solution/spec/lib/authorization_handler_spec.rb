require "rspec"
require 'spec_helper'

require "./lib/authorization_handler"
require "./lib/my_exception"
require "./entities/user"

RSpec.describe AuthorizationHandler do
  describe ".signup" do
    context "with nil username" do
      it "raises expected error" do
        password_handler_mock = double('password_handler', encrypt_password: 'encrypted' )
        user_repository_mock = double('user_repository', user_exists: false )
        token_handler_mock = double('token_handler_mock')

        authorization_handler = AuthorizationHandler.new(password_handler_mock, user_repository_mock, token_handler_mock)

        expect{ authorization_handler.signup(nil, 'password') }.to raise_error{ |error| 
          error.should be_a(MyException)
          error.message.should eq 'username must not be empty'
          error.http_code.should eq 400 }
      end
    end

    context "with empty username" do
      it "raises expected error" do
        password_handler_mock = double('password_handler', encrypt_password: 'encrypted' )
        user_repository_mock = double('user_repository', user_exists: false )
        token_handler_mock = double('token_handler_mock')

        authorization_handler = AuthorizationHandler.new(password_handler_mock, user_repository_mock, token_handler_mock)

        expect{ authorization_handler.signup('', 'password') }.to raise_error{ |error| 
          error.should be_a(MyException)
          error.message.should eq 'username must not be empty'
          error.http_code.should eq 400 }
      end
    end

    context "with nil password" do
      it "raises expected error" do
        password_handler_mock = double('password_handler', encrypt_password: 'encrypted' )
        user_repository_mock = double('user_repository', user_exists: false )
        token_handler_mock = double('token_handler_mock')

        authorization_handler = AuthorizationHandler.new(password_handler_mock, user_repository_mock, token_handler_mock)

        expect{ authorization_handler.signup('username', nil) }.to raise_error{ |error| 
          error.should be_a(MyException)
          error.message.should eq 'password must not be empty'
          error.http_code.should eq 400 }
      end
    end

    context "with empty password" do
      it "raises expected error" do
        password_handler_mock = double('password_handler', encrypt_password: 'encrypted' )
        user_repository_mock = double('user_repository', user_exists: false )
        token_handler_mock = double('token_handler_mock')

        authorization_handler = AuthorizationHandler.new(password_handler_mock, user_repository_mock, token_handler_mock)

        expect{ authorization_handler.signup('username', '') }.to raise_error{ |error| 
          error.should be_a(MyException)
          error.message.should eq 'password must not be empty'
          error.http_code.should eq 400 }
      end
    end

    context "with existing username" do
      it "raises expected error" do
        password_handler_mock = double('password_handler', encrypt_password: 'encrypted' )
        user_repository_mock = double('user_repository', user_exists: true )
        token_handler_mock = double('token_handler_mock')

        authorization_handler = AuthorizationHandler.new(password_handler_mock, user_repository_mock, token_handler_mock)

        expect{ authorization_handler.signup('username', 'password') }.to raise_error{ |error| 
          error.should be_a(MyException)
          error.message.should eq 'user already exists'
          error.http_code.should eq 409 }
      end
    end

    it "checks if user already exists" do
      password_handler_mock = double('password_handler', encrypt_password: 'encrypted' )
      user_repository_mock = double('user_repository', user_exists: false, add_user: User.new('username', 'password') )
      token_handler_mock = double('token_handler_mock')

      authorization_handler = AuthorizationHandler.new(password_handler_mock, user_repository_mock, token_handler_mock)

      expect(user_repository_mock).to receive(:user_exists).with("username")
      authorization_handler.signup('username', 'password')
    end

    it "encrypts provided password" do
      password_handler_mock = double('password_handler', encrypt_password: 'encrypted' )
      user_repository_mock = double('user_repository', user_exists: false, add_user: User.new('username', 'password') )
      token_handler_mock = double('token_handler_mock')

      authorization_handler = AuthorizationHandler.new(password_handler_mock, user_repository_mock, token_handler_mock)

      expect(password_handler_mock).to receive(:encrypt_password).with("password")
      authorization_handler.signup('username', 'password')
    end

    it "adds the user with encrypted password" do
      password_handler_mock = double('password_handler', encrypt_password: 'encrypted' )
      user_repository_mock = double('user_repository', user_exists: false, add_user: User.new('username', 'password') )
      token_handler_mock = double('token_handler_mock')

      authorization_handler = AuthorizationHandler.new(password_handler_mock, user_repository_mock, token_handler_mock)

      expect(user_repository_mock).to receive(:add_user).with("username", "encrypted")
      authorization_handler.signup('username', 'password')
    end
  end

  describe ".login" do
    context "with nil username" do
      it "raises expected error" do
        password_handler_mock = double('password_handler', encrypt_password: 'encrypted' )
        user_repository_mock = double('user_repository', user_exists: false )
        token_handler_mock = double('token_handler_mock')

        authorization_handler = AuthorizationHandler.new(password_handler_mock, user_repository_mock, token_handler_mock)

        expect{ authorization_handler.login(nil, 'password') }.to raise_error{ |error| 
          error.should be_a(MyException)
          error.message.should eq 'username must not be empty'
          error.http_code.should eq 400 }
      end
    end

    context "with empty username" do
      it "raises expected error" do
        password_handler_mock = double('password_handler', encrypt_password: 'encrypted' )
        user_repository_mock = double('user_repository', user_exists: false )
        token_handler_mock = double('token_handler_mock')

        authorization_handler = AuthorizationHandler.new(password_handler_mock, user_repository_mock, token_handler_mock)

        expect{ authorization_handler.login('', 'password') }.to raise_error{ |error| 
          error.should be_a(MyException)
          error.message.should eq 'username must not be empty'
          error.http_code.should eq 400 }
      end
    end

    context "with nil password" do
      it "raises expected error" do
        password_handler_mock = double('password_handler', encrypt_password: 'encrypted' )
        user_repository_mock = double('user_repository', user_exists: false )
        token_handler_mock = double('token_handler_mock')

        authorization_handler = AuthorizationHandler.new(password_handler_mock, user_repository_mock, token_handler_mock)

        expect{ authorization_handler.login('username', nil) }.to raise_error{ |error| 
          error.should be_a(MyException)
          error.message.should eq 'password must not be empty'
          error.http_code.should eq 400 }
      end
    end

    context "with empty password" do
      it "raises expected error" do
        password_handler_mock = double('password_handler', encrypt_password: 'encrypted' )
        user_repository_mock = double('user_repository', user_exists: false )
        token_handler_mock = double('token_handler_mock')

        authorization_handler = AuthorizationHandler.new(password_handler_mock, user_repository_mock, token_handler_mock)

        expect{ authorization_handler.login('username', '') }.to raise_error{ |error| 
          error.should be_a(MyException)
          error.message.should eq 'password must not be empty'
          error.http_code.should eq 400 }
      end
    end

    context "with wrong password" do
      it "raises expected error" do
        password_handler_mock = double('password_handler', is_same_password: false )
        user_repository_mock = double('user_repository', get_user: User.new('username', 'encrypted') )
        token_handler_mock = double('token_handler_mock')

        authorization_handler = AuthorizationHandler.new(password_handler_mock, user_repository_mock, token_handler_mock)

        expect{ authorization_handler.login('username', 'some_other_password') }.to raise_error{ |error| 
          error.should be_a(MyException)
          error.message.should eq 'incorrect password'
          error.http_code.should eq 401 }
      end
    end

    it "gets the user from repository" do
      password_handler_mock = double('password_handler', is_same_password: true )
      user_repository_mock = double('user_repository', get_user: User.new('username', 'encrypted') )
      token_handler_mock = double('token_handler_mock', generate_token: 'some very authentic token')

      authorization_handler = AuthorizationHandler.new(password_handler_mock, user_repository_mock, token_handler_mock)

      expect(user_repository_mock).to receive(:get_user).with("username")
      authorization_handler.login('username', 'password')
    end

    it "checks user's password" do
      password_handler_mock = double('password_handler', is_same_password: true )
      user_repository_mock = double('user_repository', get_user: User.new('username', 'encrypted') )
      token_handler_mock = double('token_handler_mock', generate_token: 'some very authentic token')

      authorization_handler = AuthorizationHandler.new(password_handler_mock, user_repository_mock, token_handler_mock)

      expect(password_handler_mock).to receive(:is_same_password).with("password", "encrypted")
      authorization_handler.login('username', 'password')
    end

    it "generates and returns a token" do
      password_handler_mock = double('password_handler', is_same_password: true )
      user_repository_mock = double('user_repository', get_user: User.new('username', 'encrypted') )
      token_handler_mock = double('token_handler_mock', generate_token: 'some very authentic token')

      authorization_handler = AuthorizationHandler.new(password_handler_mock, user_repository_mock, token_handler_mock)

      expect(token_handler_mock).to receive(:generate_token).with("username")
      returned_token = authorization_handler.login('username', 'password')
      expect(returned_token).to eq 'some very authentic token'
    end
  end

  describe ".authorize" do
    context "with not valid token" do
      it "raises expected error" do
        password_handler_mock = double('password_handler', encrypt_password: 'encrypted' )
        user_repository_mock = double('user_repository', user_exists: false )
        token_handler_mock = double('token_handler_mock', is_valid: false)

        authorization_handler = AuthorizationHandler.new(password_handler_mock, user_repository_mock, token_handler_mock)

        expect{ authorization_handler.authorize('very authentic token') }.to raise_error{ |error| 
          error.should be_a(MyException)
          error.message.should eq 'invalid token'
          error.http_code.should eq 401 }
      end
    end

    it "checks if token is valid" do
      password_handler_mock = double('password_handler')
      user_repository_mock = double('user_repository')
      token_handler_mock = double('token_handler_mock', is_valid: true)

      authorization_handler = AuthorizationHandler.new(password_handler_mock, user_repository_mock, token_handler_mock)

      expect(token_handler_mock).to receive(:is_valid).with("very authentic token")
      authorization_handler.authorize('very authentic token')
    end
  end
end