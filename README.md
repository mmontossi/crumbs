[![Gem Version](https://badge.fury.io/rb/crumbs.svg)](http://badge.fury.io/rb/crumbs)
[![Code Climate](https://codeclimate.com/github/mmontossi/crumbs/badges/gpa.svg)](https://codeclimate.com/github/mmontossi/crumbs)
[![Build Status](https://travis-ci.org/mmontossi/crumbs.svg)](https://travis-ci.org/mmontossi/crumbs)
[![Dependency Status](https://gemnasium.com/mmontossi/crumbs.svg)](https://gemnasium.com/mmontossi/crumbs)

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

Generate the initialization and definition files:
```
rails g crumbs:install
```

The defaults configuration values are:
```ruby
Crumbs.configure do |config|
  config.show_last = false
end
```

## DSL

In your config/crumbs.rb file add crumbs referencing the controller and action with the dsl:
```ruby
Crumbs.define do
  controller :site do
    action :index, 'Home'
  end
end
```

To translate names you can use the t method (keys starting with dot are  prepended with 'crumbs.'):
```ruby
Crumbs.define do
  controller :site do
    action :index, t('.home')
  end
end
```

If you don't like to prepend the namespace of the controller:
```ruby
Crumbs.define do
  namespace :admin do
    controller :products do
      action :index, 'Products'
    end
  end
end
```

You can use a block for dynamic names, will receive the corresponding url parameters:
```ruby
Crumbs.define do
  controller :products do
    action :show do |params|
      Product.find(params[:id]).name
    end
  end
end
```

## Performance

To disable crumbs for any controller or action:
```ruby
class Api::BaseController < ApplicationController
  skip_before_action :set_crumbs
end
```

## Views

In your views would be available a crumbs variable:
```erb
<% @crumbs.each do |crumb| %>
  &gt; <%= link_to crumb[:name], crumb[:path] %>
<% end %>
```

## Last crumb

If you want to show the last crumb, change the default in your config/initializers/crumbs.rb:
```ruby
Crumbs.configure do |config|
  config.crumbs.show_last = true
end
```

## Credits

This gem is maintained and funded by [mmontossi](https://github.com/mmontossi).

## License

It is free software, and may be redistributed under the terms specified in the MIT-LICENSE file.
