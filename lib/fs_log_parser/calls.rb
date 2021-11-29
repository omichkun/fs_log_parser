module FsLogParser
  class Calls
    @@calls = []

    def initialize
      @@calls = []
    end

    def <<(call)
      @@calls << call
    end

    def self.all
      @@calls
    end
  
    def self.count
      @@calls.count
    end
    
    def self.find(uuid)
      @@calls.find {|c| c.params[:uuid] == uuid}
    end
  end
end