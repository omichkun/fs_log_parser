module FsLogParser
  class Parser
    def initialize
      @calls = Calls.new
    end

    def parse_file(filename, call_uuid = nil)
      file = File.open(filename, 'r')
      file.each { |line| parse_line(line, filename) }
    end
  
    private
    def parse_line(line, filename)
      line = line.encode("UTF-8", invalid: :replace, replace: "")
      line_uuid = get_line_uuid(line)
      call = Calls.find_in_processing(line_uuid)
  
      case line
      when /New\sChannel/
        start_time = Time.parse(parse_time(line))
        call_uuid = get_call_uuid(line)
        caller = get_caller(line)
        caller_domain = caller.split('@').last
        call = Call.new(start_line: line, 
                        start_time: start_time, 
                        uuid: call_uuid, 
                        caller: caller,
                        caller_domain: caller_domain,
                        filename: filename)
        call.lines << line
        @calls << call
      when /Dialplan.+Absolute\sCondition/
        return if call.nil?

        route = get_route(line)
        call.params[:resulting_route] = route
      when /State\sDESTROY\sgoing\sto\ssleep/
        return if call.nil?

        end_time = Time.parse(parse_time(line))
        call.end_time = end_time
        call.lines << line
        @calls.finish(call)
      when /CombineCalls2Connection/
        return if call.nil?

        links = line.match(/\((.*)\)/)&.send(:[], 1).split.values_at(1,3)
        links.delete(line_uuid)
        call.links << links.first
      else
        return if call.nil?
  
        call.lines << line
      end
    end
  
    def parse_time(line)
      line.match(/\d{4}-\d{2}-\d{2}\s\d{2}:\d{2}:\d{2}\.\d{6}/).to_s
    end
  
    def get_call_uuid(line)
      line.match(/\[([0-9abcdef]{8}-[0-9abcdef]{4}-[0-9abcdef]{4}-[0-9abcdef]{4}-[0-9abcdef]{12})\]/)&.send(:[], 1).to_s
    end
  
    def get_line_uuid(line)
      line.match(/[0-9abcdef]{8}-[0-9abcdef]{4}-[0-9abcdef]{4}-[0-9abcdef]{4}-[0-9abcdef]{12}/).to_s
    end
  
    def get_route(line)
      line.match(/\[(.*)\]/)&.send(:[], 1).to_s
    end

    def get_caller(line)
      line.split[-2]
    end
  end
end