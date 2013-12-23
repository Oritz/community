class Launcher < ActiveRecord::Base
  KEY_LEN = 16
  CRYPT_TYPE_EXTERNAL,
  CRYPT_TYPE_CRYPT_1 = *(0..32)

  validates_presence_of [:crypt_type, :protector, :protect_cmd, :root_key, :root_key_iv, :key_digest, :launcher, :launcher_name, :launcher_digest, :launch_cmd]
end
