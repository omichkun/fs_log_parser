module FsLogParser
  class Call
    def initialize(**params)
      @params = params
      @lines = []
    end

    attr_reader :params
    attr_accessor :lines
  end
end