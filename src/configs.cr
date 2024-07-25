require "toml-config"

module Configs
  class PassManConfig < TOML::Config
    str secretKey
    str iv
    as_hash "redis"
  end

  def configure
    config = PassManConfig.parse_file("~/.config/passman/config.toml")

    @secret = secretKey
    @iv = iv
  end

  def secretKey
    @secret
  end

  def initializationVector
    @iv
  end
end
