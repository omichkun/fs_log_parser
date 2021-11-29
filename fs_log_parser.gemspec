Gem::Specification.new do |s|
  s.name        = 'fs_log_parser'
  s.version     = '0.0.1'
  s.summary     = "Freeswitch log parser"
  s.description = "Simple log parser for Freeswitch"
  s.authors     = ["Omich Kun"]
  s.email       = 'omich.kun@gmail.com'
  s.files = Dir['{lib/**/*}'] +
    %w(fs_log_parser.gemspec)
  s.homepage    =
    'https://rubygems.org/gems/fs_log_parser'
  s.license       = 'MIT'
end