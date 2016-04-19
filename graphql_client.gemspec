Gem::Specification.new do |s|
  s.name        = "graphql_client"
  s.version     = "0.0.1"
  s.summary     = "A Ruby client for interacting with GraphQL servers over HTTP"
  s.description = "See da summary [="
  s.authors     = ["Jared McFarland"]
  s.email       = "jared.online@gmail.com"
  s.files       = ["lib/graphql_client.rb"]
  s.license     = "MIT"
  s.homepage    = "http://rubygems.org/gems/graphql_client"

  s.add_dependency 'activesupport'

  s.add_development_dependency 'rspec'
end
