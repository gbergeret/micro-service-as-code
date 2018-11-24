
url = attribute("app_url")

control 'http_ping_endpoint' do
  describe http("http://#{url}/ping") do
    its('status') { should eq 200 }
    its('body') { should cmp "Pong!" }
  end
end
