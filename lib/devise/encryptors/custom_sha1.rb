require 'digest/sha1'

module Devise
  module Encryptable
    module Encryptors
      class CustomSha1 < Base
        def self.digest(password, stretches, salt, pepper)
          str = [password, 'kangaroo', salt].flatten.compact.join
          Digest::SHA1.hexdigest(str)
        end
      end
    end
  end
end
