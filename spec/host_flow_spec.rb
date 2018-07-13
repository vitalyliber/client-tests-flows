describe 'Host' do
  include_context "categories"
  include_context "headers"
  include_context "urls"
  include_context "cities"
  include_context "genders"

  it 'set role host' do
    # reset user role
    Excon.put(
        set_role_url,
        headers: headers,
        body: { role: 'guest' }.to_json
    )

    response = Excon.put(
      set_role_url,
      headers: headers,
      body: { role: 'host' }.to_json
    )
    expect(response.body).to eq("{\"status\":\"OK\"}")
    expect(response.status).to eq(200)
  end

  it 'get error via repeated set the same role' do
    # TODO this behavior needs to remove from API
    response = Excon.put(
      set_role_url,
      headers: headers,
      body: { role: 'host' }.to_json
    )
    expect(response.body).to eq("{\"errors\":[\"User role has the specified value\"]}")
    expect(response.status).to eq(409)
  end

  it 'create an event' do
    body = {
      category_id: categories.dig(0, 'id'),
      tags: [
          'private'
      ],
      start_date: Time.now.strftime('%Y-%m-%d'),
      time: Time.now.strftime('%H:%M'),
      amount: 1000,
      currency: 'USD',
      place_id: cities.dig(0, 'place_id')
    }.to_json

    response = Excon.post(
      create_event_url,
      headers: headers,
      body: body
    )
    expect(response.status).to eq(200)
    expect(JSON.parse(response.body).dig('id')).to be_a(String)
  end

  it 'send profile info' do
    body = {
      first_name: "TestName",
      gender: genders[:male],
      age: 21,
      height: 180,
      weight: 70,
      hair: 'brown',
      hide_me: false,
      eye: 'brown',
      features: ['Not smoking', 'No tattoos'],
      languages: ['Русский', 'English'],
      send_push_guests: false,
      send_push_messages: true
    }.to_json
    response = Excon.put(
      update_profile_url,
      headers: headers,
      body: body
    )
    expect(response.status).to eq(200)
    expect(JSON.parse(response.body).dig('id')).to be_a(String)
  end

  it 'get default filter' do
    response = Excon.get(
      filters_url,
      headers: headers,
    )
    expect(response.status).to eq(200)
    hash = JSON.parse(response.body)
    expect(hash['role']).to eq('host')
  end

  context 'edit filters' do
    age = '20,23'
    height = '175,200'
    weight = '45,55'
    features = []
    filter_client_default = false
    gender = '1,2'
    body = {
        gender: gender,
        age: age,
        height: height,
        weight: weight,
        features: features,
        filter_client_default: filter_client_default
    }

    it 'set new filter' do
      response = Excon.put(
          filters_url,
          headers: headers,
          body: body.to_json
      )
      expect(response.status).to eq(200)
      hash = JSON.parse(response.body)
      expect(hash['role']).to eq('host')
      expect(hash['age']).to eq(age)
      expect(hash['height']).to eq(height)
      expect(hash['weight']).to eq(weight)
      expect(hash['features']).to eq(features)
      expect(hash['filter_client_default']).to eq(filter_client_default)
    end

    it 'hide filter' do
      filter_client_default = true
      new_body = body.clone
      new_body[:filter_client_default] = filter_client_default
      response = Excon.put(
          filters_url,
          headers: headers,
          body: new_body.to_json
      )
      expect(response.status).to eq(200)
      hash = JSON.parse(response.body)
      expect(hash['filter_client_default']).to eq(filter_client_default)
    end
  end

end