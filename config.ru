require './adapter.rb'
require 'thin'

# Thin::Server.start('0.0.0.0', 3000) do
#   use Rack::CommonLogger
  map '/validate' do
    run BranchChecker.new
  end
# end
