# frozen_string_literal: true

require "test_helper"

class AddServiceTest < ActiveSupport::TestCase
  def test_add_empty_string
    service = AddService.new("")

    assert_equal 0, service.process
  end

  def test_add_comma_separated_strings
    service = AddService.new("11,22,33,44,55,66")

    assert_equal 231, service.process
  end
end
