require "openssl"
require "base64"
require "random/secure"


module Encryption  
  # Function to set up the secret key from configuration
  def configure(secret_key : String,iv : String)
    @secret_key = OpenSSL::Digest::SHA256.digest(secret_key)[0, 32].to_slice
    @iv = Base64.decode(iv)  
  end
  
  # def self.encrypt(value : Bytes, secret_key : Bytes) : Bytes
  # end

  # def self.decrypt(value : Bytes, secret_key : Bytes) : Bytes
  def encrypt(value : String) : String
    cipher = OpenSSL::Cipher.new("AES-256-CBC")
    cipher.encrypt
    cipher.key = @secret_key
    cipher.iv = @iv

    encrypted = cipher.update(value) + cipher.final
    # Encode the IV and the encrypted value as Base64 and join them with "--"
    "#{Base64.encode(@iv)}--#{Base64.encode(encrypted)}"
  end

  def decrypt(value : String) : String
    # Split the IV and encrypted value
    parts = value.split("--")
    iv = Base64.decode(parts[0])
    encrypted = Base64.decode(parts[1])

    cipher = OpenSSL::Cipher.new("AES-256-CBC")
    cipher.decrypt
    cipher.key = @secret_key
    cipher.iv = iv

    decrypted = cipher.update(encrypted) + cipher.final
    decrypted
  end  # end
end

