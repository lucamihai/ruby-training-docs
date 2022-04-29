require './lib/program.rb'
require 'dotenv/load'

program = Program.new
program.execute(ARGV)

exit(true)
