require "test_helper"

class CalculatorControllerTest < ActionDispatch::IntegrationTest
  def test_add_action
    post calculator_add_url, params: { numbers: "1,2,3" }

    assert_response :success
    assert_equal({ "result" => 6 }, JSON.parse(@response.body))
  end

  def test_add_action_works_when_specifying_odd_or_even_preference
    post calculator_add_url, params: { numbers: "1,2,3", odd_or_even: "odd" }

    assert_response :success
    assert_equal({ "result" => 2 }, JSON.parse(@response.body))
  end
end
