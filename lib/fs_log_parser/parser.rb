module FsLogParser
  class Parser
    def initialize
      @calls = Calls.new
    end

    def parse_file(filename)
      file = File.open(filename, 'r')
      file.each_with_index do |line, index|
        begin
          parse(line)
        rescue => e
          # puts "#{e.message} : #{line}"
        end
      end
    end
  
    def parse(line)
      line = line.encode("UTF-8", invalid: :replace, replace: "")
      line_uuid = get_line_uuid(line)
      call = Calls.find_in_processing(line_uuid)
  
      if line =~ /New\sChannel/
        start_time = Time.parse(parse_time(line))
        call_uuid = get_call_uuid(line)
        call = Call.new(line: line, start_time: start_time, uuid: call_uuid)
        call.lines << line
        @calls << call
      elsif line =~ /State\sDESTROY\sgoing\sto\ssleep/
        end_time = Time.parse(parse_time(line))
        call.params[:end_time] = end_time
        call.lines << line
        @calls.finish(call)
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
  end
end