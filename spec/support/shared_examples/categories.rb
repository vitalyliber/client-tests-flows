shared_context "categories", :shared_context => :metadata do
  let(:categories) do
    response = Excon.get(
        categories_url,
        headers: headers
    )
    JSON.parse(response.body)
  end
end