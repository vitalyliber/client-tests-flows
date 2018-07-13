shared_context "urls", :shared_context => :metadata do
  let(:set_role_url) {
    "#{ENV['HOST']}/Users/role"
  }

  let(:create_event_url) {
    "#{ENV['HOST']}/Events"
  }

  let(:categories_url) {
    "#{ENV['HOST']}/Events/categories"
  }

  let(:cities_url) {
    "#{ENV['HOST']}/Geo/geocoding?address=Moscow"
  }

  let(:update_profile_url) {
    "#{ENV['HOST']}/Users/profile"
  }

  let(:filters_url) {
    "#{ENV['HOST']}/Filters"
  }
end