require "test_helper"

class CalculatorControllerTest < ActionDispatch::IntegrationTest
  def test_add_action
    post calculator_add_url, params: { numbers: "1,2,3" }

    assert_response :success
    assert_equal({ "result" => 6 }, JSON.parse(@response.body))
  end
end
