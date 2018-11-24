
url = attribute("app_url")

control 'http_healthcheck' do
  describe http("http://#{url}") do
    its('status') { should eq 200 }
    its('body') { should match (/Welcome to nginx!/) }
  end
end
