require "rocksdb"
require "colorize"

module PasswordStore
  extend self

  def add(key, password)
    # TODO : Encrypt passwords
    db = RocksDB::DB.new("./tmp/passman")

    db.put(key, password)

    db.close
  end

  def remove(key)
    db = RocksDB::DB.new("./tmp/passman")
    db.delete(key)
    db.close
    puts "Removed password for #{key.colorize(:cyan)}"
  end

  def get(key)
    db = RocksDB::DB.new("./tmp/passman")
    password = db.get? key

    db.close

    password
  end

  def update(key, new_value)
    db = RocksDB::DB.new("./tmp/passman")
    unless db.get?(key).nil?
      db.put(key, new_value)
    else
      puts "Warning : unknown key '#{key}' (ignored)".colorize(:yellow)
    end
  end

  def list(show_passwords)
    db = RocksDB::DB.new("./tmp/passman")

    iter = db.new_iterator
    iter.first
    puts show_passwords ? "| #{"Keys".colorize(:magenta)}\t\t  #{"Passwords".colorize(:magenta)}" : "| #{"Keys".colorize(:magenta)}"
    while (iter.valid?)
      # yield {iter.key, iter.value}
      show_passwords ? puts "| #{iter.key.colorize(:cyan)}\t\t  #{iter.value.colorize(:green)}" : puts "| #{iter.key.colorize(:cyan)}"
      iter.next
    end
    iter.close # memory leaks when you forget this

    db.close
  end

  def clear
    db = RocksDB::DB.new("./tmp/passman")

    iter = db.new_iterator
    iter.first
    while (iter.valid?)
      db.delete(iter.key)
      iter.next
    end
    iter.close # memory leaks when you forget this

    db.close
  end
end
