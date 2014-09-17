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

## Configuration

If you want to show the last crumb, change the default in your application.rb:
```ruby
config.crumbs.show_last = true
```

## Credits

This gem is maintained and funded by [museways](http://museways.com).

## License

It is free software, and may be redistributed under the terms specified in the MIT-LICENSE file.
