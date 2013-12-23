# -*- encoding : utf-8 -*-
class Hash
  # # Recursively replace key names that should be symbols with symbols.
  # def key_strings_to_symbols!
    # r = Hash.new
    # self.each_pair do |k,v|
      # if ((k.kind_of? String) and k =~ /^:/)
        # v.key_strings_to_symbols! if v.kind_of? Hash and v.respond_to? :key_strings_to_symbols!
        # r[k.slice(1..-1).to_sym] = v
      # else
        # v.key_strings_to_symbols! if v.kind_of? Hash and v.respond_to? :key_strings_to_symbols!
        # r[k] = v
      # end
    # end
    # self.replace(r)
  # end

  def symbolize_keys!
    t = self.dup
    self.clear
    t.each_pair{|k, v| self[k.to_sym] = v}
    self
  end

end
