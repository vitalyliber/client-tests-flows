shared_context "cities", :shared_context => :metadata do
  let(:cities) do
    response = Excon.get(
        cities_url,
        headers: headers
    )
    JSON.parse(response.body)
  end
end