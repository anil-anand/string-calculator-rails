# frozen_string_literal: true

require "test_helper"

class AddServiceTest < ActiveSupport::TestCase
  def test_add_empty_string
    service = AddService.new("")

    assert_equal 0, service.process
  end
end
