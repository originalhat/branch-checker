require 'thin'

class SimpleAdapter
  def call(env)
    ref = env['PATH_INFO'][1..-1]

    `git check-ref-format --branch '#{ref}'`
    exit_status = $?.exitstatus

    [
      exit_status == 0 ? 200 : 400,
      { 'Content-Type' => 'text/plain' },
      ["The branch \"#{ref}\" is #{exit_status == 0 ? 'valid' : 'invalid'}"]
    ]
  end
end

Thin::Server.start('0.0.0.0', 3000) do
  use Rack::CommonLogger
  map '/test' do
    run SimpleAdapter.new
  end
end
