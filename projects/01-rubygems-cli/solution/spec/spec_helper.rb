require 'dotenv/load'

RSpec.configure do |c|
    c.filter_run_when_matching :focus
end