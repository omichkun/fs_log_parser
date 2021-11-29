# Usage

To use this gem you should just simply require it 

```ruby 
require 'fs_log_parser'
```

After this you should parse files to find calls there: 

```ruby
parser = FsLogParser.new
parser.parse_file("./search/freeswitch.log.2021-11-23-07-33-37.1")

# after parsing you'll have object FsLogParser::Calls with all calls in it
FsLogParser::Calls.all # get all calls in array
FsLogParser::Calls.find('<call_uuid_here>') # find specific call by uuid
FsLogParser::Calls.count # return calls count 

FsLogParser::Call # object stored in FsLogParser::Calls
FsLogParser::Call.params # stored call params like uuid, start_time, line (initial line call started)
```