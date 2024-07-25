require "commander"
require "secrets"
require "colorize"

require "../src/store.cr"

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

Commander.run(cli, ARGV)
