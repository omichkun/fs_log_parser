module FsLogParser
  class Call
    def initialize(**params)
      @params = params
      @start_time = params.delete(:start_time)
      @lines = []
      @call_length = 0
      @links = []
    end

    def end_time=(timestamp)
      @end_time = timestamp
      @call_length = @end_time - @start_time

      @end_time
    end

    def links_objects
      @links_objects ||= @links.map { |l| Calls.find(l) }
    end

    attr_reader :params, :end_time, :call_length, :links, :lines
  end
end