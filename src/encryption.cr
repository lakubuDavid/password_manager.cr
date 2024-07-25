require "openssl"
require "base64"
require "random/secure"
require "digest/sha256"



module Encryption  
    @@secret_key : Slice(UInt8)? 
    @@iv :  Slice(UInt8)? 
  # Function to set up the secret key from configuration
  def self.configure(secret_key : String,iv : String)
    sk_digest = Digest::SHA256.digest(secret_key)
    iv_digest = Digest::SHA256.digest(secret_key)

    puts sk_digest.inspect
    puts iv_digest.inspect
    
    @@secret_key = sk_digest
    @@iv = iv_digest 
    # @@secret_key = Base64.encode(secret_key)
    # @@iv = Base64.encode(iv) 
  end
  
  # def self.encrypt(value : Bytes, secret_key : Bytes) : Bytes
  # end

  # def self.decrypt(value : Bytes, secret_key : Bytes) : Bytes
  def self.encrypt(value : String) : String
    p! @@secret_key
    p! @@iv
    
    cipher = OpenSSL::Cipher.new("AES-256-CBC")
    cipher.encrypt
    cipher.key = @@secret_key
    cipher.iv = @@iv

    encrypted = cipher.update(value) + cipher.final
    # Encode the IV and the encrypted value as Base64 and join them with "--"
    "#{Base64.encode(@@iv)}--#{Base64.encode(encrypted)}"
  end

  def self.decrypt(value : String) : String
    # Split the IV and encrypted value
    parts = value.split("--")
    iv = Base64.decode(parts[0])
    encrypted = Base64.decode(parts[1])

    cipher = OpenSSL::Cipher.new("AES-256-CBC")
    cipher.decrypt
    cipher.key = @@secret_key
    cipher.iv = @@iv

    decrypted = cipher.update(encrypted) + cipher.final
    decrypted
  end  # end
end

