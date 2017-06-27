require 'test_helper'

class CrumbsTest < ActionDispatch::IntegrationTest

  test 'links' do
    get '/'
    assert_equal Hash.new, session[:referers]
    assert_select 'a', count: 1
    assert_select 'a[href=?]', 'http://www.example.com', text: /home/, count: 1

    get '/admin/users?query='
    assert_equal(
      { 'http://www.example.com/admin/users' => 'query=' },
      session[:referers]
    )
    assert_select 'a', count: 2
    assert_select 'a[href=?]', 'http://www.example.com', text: /home/, count: 1
    assert_select 'a[href=?]', 'http://www.example.com/admin/users?query=', text: /users/, count: 1

    get '/admin/users/7'
    assert_equal(
      { 'http://www.example.com/admin/users' => 'query=' },
      session[:referers]
    )
    assert_select 'a', count: 3
    assert_select 'a[href=?]', 'http://www.example.com', text: /home/, count: 1
    assert_select 'a[href=?]', 'http://www.example.com/admin/users?query=', text: /users/, count: 1
    assert_select 'a[href=?]', 'http://www.example.com/admin/users/7', text: /user 7/, count: 1

    get '/admin/reports/deliveries'
    assert_equal(
      { 'http://www.example.com/admin/users' => 'query=' },
      session[:referers]
    )
    assert_select 'a', count: 2
    assert_select 'a[href=?]', 'http://www.example.com', text: /home/, count: 1
    assert_select 'a[href=?]', 'http://www.example.com/admin/reports/deliveries', text: /deliveries/, count: 1
  end

end
