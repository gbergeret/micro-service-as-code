
url = attribute("app_url")

control 'http_root_endpoint' do
  describe http("http://#{url}") do
    its('status') { should eq 200 }
    its('body') { should cmp "Hello World!" }
  end
end

