require './branch_checker.rb'
require 'thin'

map '/validate' do
  run BranchChecker.new
end
