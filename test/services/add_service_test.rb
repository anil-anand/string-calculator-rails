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

  def test_add_comma_separated_strings_containing_newline_at_some_places_instead_of_comma
    service = AddService.new("11,22\n33,44,55\n66")

    assert_equal 231, service.process
  end

  def test_addition_with_custom_delimiters_works
    service = AddService.new("//---\n11---22---33---44---55---66")

    assert_equal 231, service.process
  end

  def test_incorrect_delimiter_raises_an_error
    service = AddService.new("//---\n11---22--33---44---55--66")

    error = assert_raises ArgumentError do
      service.process
    end

    assert_equal "Invalid delimiters detected: #{service.invalid_delimiters.uniq.join(', ')}", error.message
  end

  def test_negative_numbers_in_the_string_raises_an_error_for_comma_separated_input
    service = AddService.new("11,-22,33,-44,55,-66")

    error = assert_raises ArgumentError do
      service.process
    end

    assert_equal [ "-22", "-44", "-66" ], service.invalid_numbers
    assert_equal "Negative numbers are not allowed: #{service.invalid_numbers.join(', ')}", error.message
  end

  def test_negative_numbers_in_the_string_raises_an_error_for_custom_delimiter_input
    service = AddService.new("//---\n11----22---33---44----55---66")

    error = assert_raises ArgumentError do
      service.process
    end

    assert_equal [ "-22", "-55" ], service.invalid_numbers
    assert_equal "Negative numbers are not allowed: #{service.invalid_numbers.join(', ')}", error.message
  end

  def test_numbers_more_than_1000_are_ignored
    service = AddService.new("11,22,33,44,55,1001,66")

    assert_equal 231, service.process
  end

  def test_multiple_delimiters_are_supported
    service = AddService.new("//[----][%%%][**]\n11----22%%%33**44----55%%%66")

    assert_equal 231, service.process
  end

  def test_multiplication_and_addition_works_concurrently
    service = AddService.new("51,22*31,4,32,32")

    assert_equal 801, service.process
  end

  def test_addition_works_when_passing_odd_or_even_position_choice
    service = AddService.new("11,22,33,44,55,66", "odd")

    assert_equal 22 + 44 + 66, service.process
  end
end
