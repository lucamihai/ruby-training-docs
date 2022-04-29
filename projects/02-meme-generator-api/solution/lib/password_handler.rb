require 'bcrypt'

class PasswordHandler
  def encrypt_password(password)
    BCrypt::Password.create(password).to_s
  end

  def is_same_password(password, encrypted_password)
    BCrypt::Password.new(encrypted_password) == password
  end
end
