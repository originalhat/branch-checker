require 'thin'
require 'uri'
require 'cgi'

class BranchChecker
  def call(env)
    ref = parse_ref(env['REQUEST_URI'])

    if ref
      exit_status = validate_ref(ref)
      [
        exit_status == 0 ? 200 : 400,
        { 'Content-Type' => 'text/plain' },
        ["The branch \"#{ref}\" is #{exit_status == 0 ? 'valid' : 'invalid'}"]
      ]
    end
  end

  private

  def parse_ref(request_uri)
    CGI::parse(URI.parse(request_uri).query)["branch"].first
  end

  def validate_ref(ref)
    `git check-ref-format --branch #{ref}'`
    $?.exitstatus
  end
end
