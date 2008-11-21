module DotFiles
  @debug = true
  @force = false

  class << self
    attr_accessor :debug, :force
  end

end
