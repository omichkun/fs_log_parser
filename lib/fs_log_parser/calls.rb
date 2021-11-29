module FsLogParser
  class Calls
    @@calls = []
    @@processing_calls = []

    def initialize
      @@calls = []
    end

    def <<(call)
      @@calls << call
      @@processing_calls << call
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

    def self.find_in_processing(uuid)
      @@processing_calls.find {|c| c.params[:uuid] == uuid}
    end

    def finish(call)
      @@processing_calls.delete(call)
    end
  end
end