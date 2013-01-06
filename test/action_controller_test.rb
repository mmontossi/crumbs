require 'test_helper'

class ActionControllerRefererTest < ActionDispatch::IntegrationTest

  test "should remember last requests in the same path" do

    get '/'
    assert_equal [
      { :base_url => 'http://www.example.com', :path => '/', :fullpath => '/' }
    ], session[:referer]
    assert_select 'a', false
    
    get '/static'
    assert_equal [
      { :base_url => 'http://www.example.com', :path => '/', :fullpath => '/' },
      { :base_url => 'http://www.example.com', :path => '/static', :fullpath => '/static' }    
    ], session[:referer]
    assert_select 'a', :count => 1
    assert_select 'a[href="/"]', 'Home'

    get '/static/nested'
    assert_equal [
      { :base_url => 'http://www.example.com', :path => '/', :fullpath => '/' },
      { :base_url => 'http://www.example.com', :path => '/static', :fullpath => '/static' },
      { :base_url => 'http://www.example.com', :path => '/static/nested', :fullpath => '/static/nested' } 
    ], session[:referer]
    assert_select 'a', :count => 2 
    assert_select 'a[href="/"]', 'Home'
    assert_select 'a[href="/static"]', 'Static'      

    get '/'
    assert_equal [
      { :base_url => 'http://www.example.com', :path => '/', :fullpath => '/' }
    ], session[:referer]
    assert_select 'a', false

  end

  test "should remember last request with parameters in the same path" do

    get '/?p1=p1'
    assert_equal [
      { :base_url => 'http://www.example.com', :path => '/', :fullpath => '/?p1=p1' }
    ], session[:referer]
    assert_select 'a', false
    
    get '/static?p2=p2'
    assert_equal [
      { :base_url => 'http://www.example.com', :path => '/', :fullpath => '/?p1=p1' },
      { :base_url => 'http://www.example.com', :path => '/static', :fullpath => '/static?p2=p2' }    
    ], session[:referer]
    assert_select 'a', :count => 1
    assert_select 'a[href="/?p1=p1"]', 'Home'

    get '/static/nested?p3=p3'
    assert_equal [
      { :base_url => 'http://www.example.com', :path => '/', :fullpath => '/?p1=p1' },
      { :base_url => 'http://www.example.com', :path => '/static', :fullpath => '/static?p2=p2' },
      { :base_url => 'http://www.example.com', :path => '/static/nested', :fullpath => '/static/nested?p3=p3' } 
    ], session[:referer]
    assert_select 'a', :count => 2 
    assert_select 'a[href="/?p1=p1"]', 'Home'
    assert_select 'a[href="/static?p2=p2"]', 'Static'

    get '/'
    assert_equal [
      { :base_url => 'http://www.example.com', :path => '/', :fullpath => '/' }
    ], session[:referer]
    assert_select 'a', false

  end

  test "gaps shouldn't cause any error and should generate crumbs either" do

    get '/?p1=p1'
    assert_equal [
      { :base_url => 'http://www.example.com', :path => '/', :fullpath => '/?p1=p1' }
    ], session[:referer]
    assert_select 'a', false
    
    get '/static/nested?p3=p3'
    assert_equal [
      { :base_url => 'http://www.example.com', :path => '/', :fullpath => '/?p1=p1' },
      { :base_url => 'http://www.example.com', :path => '/static/nested', :fullpath => '/static/nested?p3=p3' } 
    ], session[:referer]
    assert_select 'a', :count => 2
    assert_select 'a[href="/?p1=p1"]', 'Home'
    assert_select 'a[href="/static"]', 'Static'

    get '/'
    assert_equal [
      { :base_url => 'http://www.example.com', :path => '/', :fullpath => '/' }
    ], session[:referer]
    assert_select 'a', false

  end

  test "empty crumbs shouldn't cause any error and should't generate crumbs" do

    get '/?p1=p1'
    assert_equal [
      { :base_url => 'http://www.example.com', :path => '/', :fullpath => '/?p1=p1' }
    ], session[:referer]
    assert_select 'a', false

    get '/empty?p2=p2'
    assert_equal [
      { :base_url => 'http://www.example.com', :path => '/', :fullpath => '/?p1=p1' },
      { :base_url => 'http://www.example.com', :path => '/empty', :fullpath => '/empty?p2=p2' }    
    ], session[:referer]
    assert_select 'a', :count => 1
    assert_select 'a[href="/?p1=p1"]', 'Home'

    get '/empty/nested?p3=p3'
    assert_equal [
      { :base_url => 'http://www.example.com', :path => '/', :fullpath => '/?p1=p1' },
      { :base_url => 'http://www.example.com', :path => '/empty', :fullpath => '/empty?p2=p2' },
      { :base_url => 'http://www.example.com', :path => '/empty/nested', :fullpath => '/empty/nested?p3=p3' } 
    ], session[:referer]
    assert_select 'a', :count => 1
    assert_select 'a[href="/?p1=p1"]', 'Home'

    get '/'
    assert_equal [
      { :base_url => 'http://www.example.com', :path => '/', :fullpath => '/' }
    ], session[:referer]
    assert_select 'a', false

  end

  test "params shouldn't cause any error and can be use alter crumb name" do

    get '/?p1=p1'
    assert_equal [
      { :base_url => 'http://www.example.com', :path => '/', :fullpath => '/?p1=p1' }
    ], session[:referer]
    assert_select 'a', false
    
    get '/param?p2=p2'
    assert_equal [
      { :base_url => 'http://www.example.com', :path => '/', :fullpath => '/?p1=p1' },
      { :base_url => 'http://www.example.com', :path => '/param', :fullpath => '/param?p2=p2' }    
    ], session[:referer]
    assert_select 'a', :count => 1
    assert_select 'a[href="/?p1=p1"]', 'Home'

    get '/param/1?p3=p3'
    assert_equal [
      { :base_url => 'http://www.example.com', :path => '/', :fullpath => '/?p1=p1' },
      { :base_url => 'http://www.example.com', :path => '/param', :fullpath => '/param?p2=p2' },
      { :base_url => 'http://www.example.com', :path => '/param/1', :fullpath => '/param/1?p3=p3' }
    ], session[:referer]
    assert_select 'a', :count => 2
    assert_select 'a[href="/?p1=p1"]', 'Home'
    assert_select 'a[href="/param?p2=p2"]', ''

    get '/param/1/nested?p4=p4'
    assert_equal [
      { :base_url => 'http://www.example.com', :path => '/', :fullpath => '/?p1=p1' },
      { :base_url => 'http://www.example.com', :path => '/param', :fullpath => '/param?p2=p2' },
      { :base_url => 'http://www.example.com', :path => '/param/1', :fullpath => '/param/1?p3=p3' },
      { :base_url => 'http://www.example.com', :path => '/param/1/nested', :fullpath => '/param/1/nested?p4=p4' } 
    ], session[:referer]
    assert_select 'a', :count => 3
    assert_select 'a[href="/?p1=p1"]', 'Home'
    assert_select 'a[href="/param?p2=p2"]', ''
    assert_select 'a[href="/param/1?p3=p3"]', '1'

    get '/'
    assert_equal [
      { :base_url => 'http://www.example.com', :path => '/', :fullpath => '/' }
    ], session[:referer]
    assert_select 'a', false

  end

  test "going back shouldn't cause any error and should retain history" do

    get '/?p1=p1'
    assert_equal [
      { :base_url => 'http://www.example.com', :path => '/', :fullpath => '/?p1=p1' }
    ], session[:referer]
    assert_select 'a', false
    
    get '/param?p2=p2'
    assert_equal [
      { :base_url => 'http://www.example.com', :path => '/', :fullpath => '/?p1=p1' },
      { :base_url => 'http://www.example.com', :path => '/param', :fullpath => '/param?p2=p2' }    
    ], session[:referer]
    assert_select 'a', :count => 1
    assert_select 'a[href="/?p1=p1"]', 'Home'

    get '/param/1?p3=p3'
    assert_equal [
      { :base_url => 'http://www.example.com', :path => '/', :fullpath => '/?p1=p1' },
      { :base_url => 'http://www.example.com', :path => '/param', :fullpath => '/param?p2=p2' },
      { :base_url => 'http://www.example.com', :path => '/param/1', :fullpath => '/param/1?p3=p3' }
    ], session[:referer]
    assert_select 'a', :count => 2
    assert_select 'a[href="/?p1=p1"]', 'Home'
    assert_select 'a[href="/param?p2=p2"]', ''

    get '/param/1/nested?p4=p4'
    assert_equal [
      { :base_url => 'http://www.example.com', :path => '/', :fullpath => '/?p1=p1' },
      { :base_url => 'http://www.example.com', :path => '/param', :fullpath => '/param?p2=p2' },
      { :base_url => 'http://www.example.com', :path => '/param/1', :fullpath => '/param/1?p3=p3' },
      { :base_url => 'http://www.example.com', :path => '/param/1/nested', :fullpath => '/param/1/nested?p4=p4' } 
    ], session[:referer]
    assert_select 'a', :count => 3
    assert_select 'a[href="/?p1=p1"]', 'Home'
    assert_select 'a[href="/param?p2=p2"]', ''
    assert_select 'a[href="/param/1?p3=p3"]', '1'

    get '/param'
    assert_equal [
      { :base_url => 'http://www.example.com', :path => '/', :fullpath => '/?p1=p1' },
      { :base_url => 'http://www.example.com', :path => '/param', :fullpath => '/param' }
    ], session[:referer]
    assert_select 'a', :count => 1
    assert_select 'a[href="/?p1=p1"]', 'Home'

  end

  test "using t method shouldn't cause any error" do

    get '/?p1=p1'
    assert_equal [
      { :base_url => 'http://www.example.com', :path => '/', :fullpath => '/?p1=p1' }
    ], session[:referer]
    assert_select 'a', false

    get '/i18n?p2=p2'
    assert_equal [
      { :base_url => 'http://www.example.com', :path => '/', :fullpath => '/?p1=p1' },
      { :base_url => 'http://www.example.com', :path => '/i18n', :fullpath => '/i18n?p2=p2' }    
    ], session[:referer]
    assert_select 'a', :count => 1
    assert_select 'a[href="/?p1=p1"]', 'Home'

    get '/i18n/nested?p3=p3'
    assert_equal [
      { :base_url => 'http://www.example.com', :path => '/', :fullpath => '/?p1=p1' },
      { :base_url => 'http://www.example.com', :path => '/i18n', :fullpath => '/i18n?p2=p2' },
      { :base_url => 'http://www.example.com', :path => '/i18n/nested', :fullpath => '/i18n/nested?p3=p3' } 
    ], session[:referer]
    assert_select 'a', :count => 2
    assert_select 'a[href="/?p1=p1"]', 'Home'
    assert_select 'a[href="/i18n?p2=p2"]', 'Hello world'

    get '/?p1=p1'
    assert_equal [
      { :base_url => 'http://www.example.com', :path => '/', :fullpath => '/?p1=p1' }
    ], session[:referer]
    assert_select 'a', false

  end

end
