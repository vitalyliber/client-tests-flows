shared_context "headers", :shared_context => :metadata do
  let(:headers) {
    {
      'Authorization' => "Bearer #{ENV['TOKEN']}",
      'Content-Type' => 'application/json',
    }
  }
end