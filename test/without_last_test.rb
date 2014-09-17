require 'test_helper'

class WithoutLastTest < ActionDispatch::IntegrationTest

  setup do
    Crumbs.config.show_last = false
  end

  test 'remember last requests in the same path' do
    get '/'
    assert_equal [
      { base_url: 'http://www.example.com', path: '/', fullpath: '/' }
    ], session[:referers]
    assert_select 'a', false
    
    get '/static'
    assert_equal [
      { base_url: 'http://www.example.com', path: '/', fullpath: '/' },
      { base_url: 'http://www.example.com', path: '/static', fullpath: '/static' }    
    ], session[:referers]
    assert_select 'a', count: 1
    assert_select 'a[href="/"]', 'Home'

    get '/static/nested'
    assert_equal [
      { base_url: 'http://www.example.com', path: '/', fullpath: '/' },
      { base_url: 'http://www.example.com', path: '/static', fullpath: '/static' },
      { base_url: 'http://www.example.com', path: '/static/nested', fullpath: '/static/nested' } 
    ], session[:referers]
    assert_select 'a', count: 2 
    assert_select 'a[href="/"]', 'Home'
    assert_select 'a[href="/static"]', 'Static'      

    get '/'
    assert_equal [
      { base_url: 'http://www.example.com', path: '/', fullpath: '/' }
    ], session[:referers]
    assert_select 'a', false
  end

  test 'remember last request with parameters in the same path' do
    get '/?p1=p1'
    assert_equal [
      { base_url: 'http://www.example.com', path: '/', fullpath: '/?p1=p1' }
    ], session[:referers]
    assert_select 'a', false
    
    get '/static?p2=p2'
    assert_equal [
      { base_url: 'http://www.example.com', path: '/', fullpath: '/?p1=p1' },
      { base_url: 'http://www.example.com', path: '/static', fullpath: '/static?p2=p2' }    
    ], session[:referers]
    assert_select 'a', count: 1
    assert_select 'a[href="/?p1=p1"]', 'Home'

    get '/static/nested?p3=p3'
    assert_equal [
      { base_url: 'http://www.example.com', path: '/', fullpath: '/?p1=p1' },
      { base_url: 'http://www.example.com', path: '/static', fullpath: '/static?p2=p2' },
      { base_url: 'http://www.example.com', path: '/static/nested', fullpath: '/static/nested?p3=p3' } 
    ], session[:referers]
    assert_select 'a', count: 2 
    assert_select 'a[href="/?p1=p1"]', 'Home'
    assert_select 'a[href="/static?p2=p2"]', 'Static'

    get '/'
    assert_equal [
      { base_url: 'http://www.example.com', path: '/', fullpath: '/' }
    ], session[:referers]
    assert_select 'a', false
  end

  test 'gaps not cause any error and generate crumbs either' do
    get '/?p1=p1'
    assert_equal [
      { base_url: 'http://www.example.com', path: '/', fullpath: '/?p1=p1' }
    ], session[:referers]
    assert_select 'a', false
    
    get '/static/nested?p3=p3'
    assert_equal [
      { base_url: 'http://www.example.com', path: '/', fullpath: '/?p1=p1' },
      { base_url: 'http://www.example.com', path: '/static/nested', fullpath: '/static/nested?p3=p3' } 
    ], session[:referers]
    assert_select 'a', count: 2
    assert_select 'a[href="/?p1=p1"]', 'Home'
    assert_select 'a[href="/static"]', 'Static'

    get '/'
    assert_equal [
      { base_url: 'http://www.example.com', path: '/', fullpath: '/' }
    ], session[:referers]
    assert_select 'a', false
  end

  test 'empty crumbs not cause any error and not generate crumbs' do
    get '/?p1=p1'
    assert_equal [
      { base_url: 'http://www.example.com', path: '/', fullpath: '/?p1=p1' }
    ], session[:referers]
    assert_select 'a', false

    get '/empty?p2=p2'
    assert_equal [
      { base_url: 'http://www.example.com', path: '/', fullpath: '/?p1=p1' },
      { base_url: 'http://www.example.com', path: '/empty', fullpath: '/empty?p2=p2' }    
    ], session[:referers]
    assert_select 'a', count: 1
    assert_select 'a[href="/?p1=p1"]', 'Home'

    get '/empty/nested?p3=p3'
    assert_equal [
      { base_url: 'http://www.example.com', path: '/', fullpath: '/?p1=p1' },
      { base_url: 'http://www.example.com', path: '/empty', fullpath: '/empty?p2=p2' },
      { base_url: 'http://www.example.com', path: '/empty/nested', fullpath: '/empty/nested?p3=p3' } 
    ], session[:referers]
    assert_select 'a', count: 1
    assert_select 'a[href="/?p1=p1"]', 'Home'

    get '/'
    assert_equal [
      { base_url: 'http://www.example.com', path: '/', fullpath: '/' }
    ], session[:referers]
    assert_select 'a', false
  end

  test 'params not cause any error and can be use alter crumb name' do
    get '/?p1=p1'
    assert_equal [
      { base_url: 'http://www.example.com', path: '/', fullpath: '/?p1=p1' }
    ], session[:referers]
    assert_select 'a', false
    
    get '/param?p2=p2'
    assert_equal [
      { base_url: 'http://www.example.com', path: '/', fullpath: '/?p1=p1' },
      { base_url: 'http://www.example.com', path: '/param', fullpath: '/param?p2=p2' }    
    ], session[:referers]
    assert_select 'a', count: 1
    assert_select 'a[href="/?p1=p1"]', 'Home'

    get '/param/1?p3=p3'
    assert_equal [
      { base_url: 'http://www.example.com', path: '/', fullpath: '/?p1=p1' },
      { base_url: 'http://www.example.com', path: '/param', fullpath: '/param?p2=p2' },
      { base_url: 'http://www.example.com', path: '/param/1', fullpath: '/param/1?p3=p3' }
    ], session[:referers]
    assert_select 'a', count: 2
    assert_select 'a[href="/?p1=p1"]', 'Home'
    assert_select 'a[href="/param?p2=p2"]', 'Param'

    get '/param/1/nested?p4=p4'
    assert_equal [
      { base_url: 'http://www.example.com', path: '/', fullpath: '/?p1=p1' },
      { base_url: 'http://www.example.com', path: '/param', fullpath: '/param?p2=p2' },
      { base_url: 'http://www.example.com', path: '/param/1', fullpath: '/param/1?p3=p3' },
      { base_url: 'http://www.example.com', path: '/param/1/nested', fullpath: '/param/1/nested?p4=p4' } 
    ], session[:referers]
    assert_select 'a', count: 3
    assert_select 'a[href="/?p1=p1"]', 'Home'
    assert_select 'a[href="/param?p2=p2"]', 'Param'
    assert_select 'a[href="/param/1?p3=p3"]', 'Param1'

    get '/'
    assert_equal [
      { base_url: 'http://www.example.com', path: '/', fullpath: '/' }
    ], session[:referers]
    assert_select 'a', false
  end

  test 'going back not cause any error and retain history' do
    get '/?p1=p1'
    assert_equal [
      { base_url: 'http://www.example.com', path: '/', fullpath: '/?p1=p1' }
    ], session[:referers]
    assert_select 'a', false
    
    get '/param?p2=p2'
    assert_equal [
      { base_url: 'http://www.example.com', path: '/', fullpath: '/?p1=p1' },
      { base_url: 'http://www.example.com', path: '/param', fullpath: '/param?p2=p2' }    
    ], session[:referers]
    assert_select 'a', count: 1
    assert_select 'a[href="/?p1=p1"]', 'Home'

    get '/param/1?p3=p3'
    assert_equal [
      { base_url: 'http://www.example.com', path: '/', fullpath: '/?p1=p1' },
      { base_url: 'http://www.example.com', path: '/param', fullpath: '/param?p2=p2' },
      { base_url: 'http://www.example.com', path: '/param/1', fullpath: '/param/1?p3=p3' }
    ], session[:referers]
    assert_select 'a', count: 2
    assert_select 'a[href="/?p1=p1"]', 'Home'
    assert_select 'a[href="/param?p2=p2"]', 'Param'

    get '/param/1/nested?p4=p4'
    assert_equal [
      { base_url: 'http://www.example.com', path: '/', fullpath: '/?p1=p1' },
      { base_url: 'http://www.example.com', path: '/param', fullpath: '/param?p2=p2' },
      { base_url: 'http://www.example.com', path: '/param/1', fullpath: '/param/1?p3=p3' },
      { base_url: 'http://www.example.com', path: '/param/1/nested', fullpath: '/param/1/nested?p4=p4' } 
    ], session[:referers]
    assert_select 'a', count: 3
    assert_select 'a[href="/?p1=p1"]', 'Home'
    assert_select 'a[href="/param?p2=p2"]', 'Param'
    assert_select 'a[href="/param/1?p3=p3"]', 'Param1'

    get '/param'
    assert_equal [
      { base_url: 'http://www.example.com', path: '/', fullpath: '/?p1=p1' },
      { base_url: 'http://www.example.com', path: '/param', fullpath: '/param' }
    ], session[:referers]
    assert_select 'a', count: 1
    assert_select 'a[href="/?p1=p1"]', 'Home'
  end

  test 'translations not cause any error' do
    get '/?p1=p1'
    assert_equal [
      { base_url: 'http://www.example.com', path: '/', fullpath: '/?p1=p1' }
    ], session[:referers]
    assert_select 'a', false

    get '/i18n?p2=p2'
    assert_equal [
      { base_url: 'http://www.example.com', path: '/', fullpath: '/?p1=p1' },
      { base_url: 'http://www.example.com', path: '/i18n', fullpath: '/i18n?p2=p2' }    
    ], session[:referers]
    assert_select 'a', count: 1
    assert_select 'a[href="/?p1=p1"]', 'Home'

    get '/i18n/nested?p3=p3'
    assert_equal [
      { base_url: 'http://www.example.com', path: '/', fullpath: '/?p1=p1' },
      { base_url: 'http://www.example.com', path: '/i18n', fullpath: '/i18n?p2=p2' },
      { base_url: 'http://www.example.com', path: '/i18n/nested', fullpath: '/i18n/nested?p3=p3' } 
    ], session[:referers]
    assert_select 'a', count: 2
    assert_select 'a[href="/?p1=p1"]', 'Home'
    assert_select 'a[href="/i18n?p2=p2"]', 'Hello world'

    get '/?p1=p1'
    assert_equal [
      { base_url: 'http://www.example.com', path: '/', fullpath: '/?p1=p1' }
    ], session[:referers]
    assert_select 'a', false
  end

end
