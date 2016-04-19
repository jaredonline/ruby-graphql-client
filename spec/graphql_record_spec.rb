require 'spec_helper'

describe GraphqlClient::Record do
  it 'inherits correctly' do
    expect(Todo::respond_to?(:all)).to eq true
    expect(Todo::respond_to?(:find)).to eq true
  end

  it 'generates proxies' do
    expect(Todo::all).to be_a GraphqlClient::QueryProxy
    expect(Todo::find(1)).to be_a GraphqlClient::QueryProxy
  end
end

describe GraphqlClient::QueryProxy do
  it 'generates a query string' do
    proxy = Todo::all
    expect(proxy.query).to eq "query TodoQuery { todos: todos { name } }"

    proxy = User::all
    expect(proxy.query).to eq "query UserQuery { users: users { email } }"

    proxy = Todo::find(1)
    expect(proxy.query).to eq "query TodoQuery { todo: todo(id:1) { name } }"

    proxy = Post::find(1)
    expect(proxy.query).to eq "query PostQuery { post: post(id:1) { title,body,author } }"
  end

  it 'allows for custom fields' do
    proxy = Post::find(1, {
      fields: [
        :title,
        :body
      ]
    })
    expect(proxy.query).to eq "query PostQuery { post: post(id:1) { title,body } }"

    proxy = Post::all({
      fields: [
        :title,
        :author
      ]
    })

    expect(proxy.query).to eq "query PostQuery { posts: posts { title,author } }"
  end
end
