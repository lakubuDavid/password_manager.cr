require "commander"
require "secrets"
require "colorize"
require "crypto"
require "base64"

require "./common.cr"
require "./store.cr"
require "./encryption.cr"

VERSION = "0.1.0"

cli = Commander::Command.new do |cmd|
  cmd.use = "passman"
  cmd.long = "A simple password manager."

  cmd.flags.add do |flag|
    flag.name = "verbose"
    flag.short = "-v"
    flag.long = "--verbose"
    flag.description = "Give more feedbacks"
    flag.default = true
    flag.persistent = true
  end

  # add command
  cmd.commands.add do |cmd|
    cmd.use = "add <key>"
    cmd.short = "Add a new password"
    cmd.long = cmd.short

    cmd.run do |options, arguments|
      key = ""

      unless arguments.size < 1
        key = arguments[0]
      else
        puts "Enter password key : "
        key = gets
        exit if key.nil?
      end
      secret = Secrets.gets prompt: "Enter your password:\n> ", hint: "*", empty_error: "Empty input, Try again!"
      PasswordStore.add key, secret
      puts "Added password for #{key.colorize(:cyan)}"
    end
  end

  # remove command
  cmd.commands.add do |cmd|
    cmd.use = "remove <key>"
    cmd.short = "Remove password"
    cmd.long = cmd.short

    cmd.run do |options, arguments|
      unless arguments.size < 1
        key = arguments[0]
        PasswordStore.remove(key)
      else
        puts "#{"Error : Please provide password key".colorize(:red)}"
        exit
      end
    end
  end

  # update command
  cmd.commands.add do |cmd|
    cmd.use = "update <key>"
    cmd.short = "Update a password"
    cmd.long = cmd.short

    cmd.run do |options, arguments|
      unless arguments.size < 1
        key = arguments[0]
        secret = Secrets.gets prompt: "Enter your password: ", hint: "*", empty_error: "Empty input, Try again!"

        PasswordStore.update(key, secret)
        puts "Updated password for #{key.colorize(:cyan)}"
      else
        puts "Error : Please provide existent password key".colorize(:red)
      end
    end
  end

  # list command
  cmd.commands.add do |cmd|
    cmd.use = "list"
    cmd.short = "List password keys"
    cmd.long = cmd.short

    cmd.flags.add do |flag|
      flag.name = "show"
      flag.short = "-S"
      flag.long = "--show"
      flag.default = false
      flag.description = "Show password"
    end

    cmd.run do |options, arguments|
      show_passwords = options.bool["show"]
      PasswordStore.list show_passwords
    end
  end

  # get command
  cmd.commands.add do |cmd|
    cmd.use = "get <key>"
    cmd.short = "Get a password"
    cmd.long = cmd.short

    cmd.run do |options, arguments|
      unless arguments.size < 1
        key = arguments[0]
        puts "Requested password for #{key.colorize(:cyan)}"
        password = PasswordStore.get key
        if password.nil?
          puts "#{"Not Found : password for '#{key}' not found".colorize(:yellow)}"
        else
          puts password
        end
      else
        puts "#{"Error : missing argument 'key'".colorize(:red)}"
      end
    end
  end

  cmd.commands.add do |cmd|
    cmd.use = "init"
    cmd.short = "Initialize passman and set the master key for encrypting passwords"
    cmd.long = cmd.short

    cmd.run do |options, arguments|
    end
  end

  # clear command
  cmd.commands.add do |cmd|
    cmd.use = "clear"
    cmd.short = "Clear all passwords"
    cmd.long = cmd.short

    cmd.run do |options, arguments|
      PasswordStore.clear
    end
  end

  cmd.run do |options, arguments|
    puts cmd.help # => Render help screen
  end
end

# random = Random.new

# # 10 MB of random data + 7 bytes to show padding
# # data = random.random_bytes(1024 + 7)
# data = "something".bytes

# key = random.random_bytes(32) # Random key
# iv = random.random_bytes(16)  # Random iv

# # Pad the data using PKCS7
# data = Crypto::Padding.pkcs7(data, Crypto::AES::BLOCK_SIZE)

# encrypted = Crypto::CBC.encrypt(to_slice(data), key, iv)
# decrypted = Crypto::CBC.decrypt(encrypted, key, iv)

# p! Base64.strict_encode(encrypted)
# p! Base64.strict_encode(decrypted)
# p! String.new(decrypted).strip("\a")

# puts data == decrypted.to_a
# puts data
# puts decrypted.to_a

# digest = Digest::SHA256.new("")
# digest << Random::Secure.random_bytes(32)
# puts digest.hexfinal

# Encryption.configure("secret","iv")

# something_encrypted = Encryption.encrypt(something)
# puts something_encrypted
# puts Encryption.decrypt(something_encrypted)

Commander.run(cli, ARGV)
