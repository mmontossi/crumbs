[![Gem Version](https://badge.fury.io/rb/crumbs.svg)](http://badge.fury.io/rb/crumbs)
[![Code Climate](https://codeclimate.com/github/mmontossi/crumbs/badges/gpa.svg)](https://codeclimate.com/github/mmontossi/crumbs)
[![Build Status](https://travis-ci.org/mmontossi/crumbs.svg)](https://travis-ci.org/mmontossi/crumbs)
[![Dependency Status](https://gemnasium.com/mmontossi/crumbs.svg)](https://gemnasium.com/mmontossi/crumbs)

# Crumbs

Handy crumbs variable for rails views.

## Why

I did this gem to:

- Have a dsl separate from the controllers to define crumbs.
- Make crumbs remember query parameters from previous requests.

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
$ bundle exec rails g crumbs:install
```

## Usage

### Definitions

In your config/crumbs.rb file add crumbs referencing the controller and action with the dsl:
```ruby
Crumbs.define do
  crumb 'pages#index', 'Home'
end
```

To translate names you can use the t shortcut method for "crumbs." keys:
```ruby
Crumbs.define do
  crumb 'pages#index', t('.home')
end
```

You can use a block for dynamic names, will receive the corresponding url parameters:
```ruby
Crumbs.define do
  crumb 'products#show' do |params|
    Product.find(params[:id]).name
  end
end
```

If you need to add multiple crumbs to the same controller:
```ruby
Crumbs.define do
  namespace :admin do
    controller :users do
      crumb :index, 'Users'
      crumb :edit, 'Edit user'
    end
  end
end
```

### Performance

To disable crumbs for any controller or action:
```ruby
class Api::BaseController < ApplicationController
  skip_before_action :set_crumbs
end
```

### Views

In your views would be available a crumbs variable:
```erb
<% @crumbs.each do |crumb| %>
  &gt; <%= link_to crumb[:name], crumb[:path] %>
<% end %>
```

## Credits

This gem is maintained and funded by [mmontossi](https://github.com/mmontossi).

## License

It is free software, and may be redistributed under the terms specified in the MIT-LICENSE file.
