property :host, String

action :wait_on do
  Chef::Log.debug("Waiting on #{host}")
  begin
    Timeout.timeout(60) do
      loop do
        begin
          uri = URI.parse(host)
          http = Net::HTTP.new(uri.host, uri.port)
          request = Net::HTTP::Get.new("/")
          response = http.request(request)
          Chef::Log.debug("Found #{host}, got a #{response.code}")
          break
        rescue
          Chef::Log.debug("Cannot talk to #{host}, zzzzz")
          sleep 3
        end
      end
    end
  rescue Timeout::Error
    raise 'T/O waiting on Jenkins after 60s'
  end
end
