class MustacheTemplate
  class MissingMustache < StandardError; end

  class << self
    # Load .mustache files in mustache_template dir
    def method_missing(name, *args, &block)
      begin
        super
      rescue NoMethodError
        instance.send(name, *args, &block)
      end
    end

    private
    def instance
      return @instance if @instance
      @instance = new(Rails.root.join("app", "mustache_templates").to_s)
      @instance
    end
  end

  def initialize(dir)
    @mustache_files = Hash.new
    @mustache_dirs = Hash.new
    missing_mustache("Missing mustache_templates directory") unless File.directory?(dir)
    @dir = dir
  end

  def method_missing(name, *args, &block)
    begin
      super
    rescue NoMethodError
      key = name.to_s
      # check files
      return @mustache_files[key] if @mustache_files.has_key?(key)
      Dir.foreach @dir do |file|
        next if file == "." || file == ".."
        next if File.extname(file) != ".mustache"
        basename = File.basename(file, ".mustache")
        next if basename != key

        @mustache_files[key] = File.read(File.join(@dir, file))
        return @mustache_files[key]
      end

      # check dirs
      return @mustache_dirs[key] if @mustache_dirs.has_key?(key)
      Dir.foreach @dir do |item|
        next if item == "." || item == ".."
        next unless File.directory?(item)

        if item == key
          @mustache_dirs[key] = self.class.new(File.join(@dir, item))
          return @mustache_dirs[key]
        end
      end

      # raising error
      missing_mustache("Missing mustache '#{key}' in '#{@dir}'")
    end
  end

  def missing_mustache(msg)
    raise MissingMustache, msg
  end
end
