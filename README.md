[![Gem Version](https://badge.fury.io/rb/crumbs.svg)](http://badge.fury.io/rb/crumbs) [![Code Climate](https://codeclimate.com/github/museways/crumbs/badges/gpa.svg)](https://codeclimate.com/github/museways/crumbs) [![Build Status](https://travis-ci.org/museways/crumbs.svg?branch=master)](https://travis-ci.org/museways/crumbs)

# Crumbs

Adds a handy crumbs variable available in your views in rails.

## Install

Put this line in your Gemfile:
```ruby
gem 'crumbs'
```

Then bundle:
```
$ bundle
```

## Configuration

Generate the configuration file:
```
rails g ads:install
```

The defaults values are:
```ruby
Crumbs.configure do |config|
  config.show_last = false
end
```

## Usage

In your controllers add crumbs to the actions you want:
```ruby
crumb :home, 'Home'
```

You can use a lambda, proc or block too, will receive the corresponding url parameters:
```ruby
crumb :product, proc { |params| Product.find(params[:id]).name }
```

Then in your views would be available a crumbs variable:
```erb
<% @crumbs.each do |crumb| %>
  &gt; <%= link_to crumb[:name], crumb[:path] %>
<% end %>
```

## Last crumb

If you want to show the last crumb, change the default:
```ruby
Crumbs.configure do |config|
  config.crumbs.show_last = true
end
```

## Credits

This gem is maintained and funded by [museways](http://museways.com).

## License

It is free software, and may be redistributed under the terms specified in the MIT-LICENSE file.
