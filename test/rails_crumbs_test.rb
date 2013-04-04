require 'test_helper'

class RailsCrumbsTest < ActiveSupport::TestCase

  test 'truth' do
    assert_kind_of Module, Rails::Crumbs
  end

end
