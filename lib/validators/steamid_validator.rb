class SteamidValidator < ActiveModel::EachValidator
  def validate_each(record, attributes, value)
    if value.to_i.to_s != value || value.to_i > ("FF"*8).hex
      record.errors[attributes] << (options[:message] || "is not a valid steamid")
    end
  end
end
