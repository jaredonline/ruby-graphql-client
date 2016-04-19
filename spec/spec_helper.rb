require 'graphql_client'

class Todo < GraphqlClient::Record
  graphql_fields :name
end

class User < GraphqlClient::Record
  graphql_fields :email
end

class Post < GraphqlClient::Record
  graphql_fields :title, :body, :author
end
