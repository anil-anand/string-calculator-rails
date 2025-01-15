class CalculatorController < ApplicationController
  def add
    result = AddService.new(calculator_params[:numbers].to_s, calculator_params[:odd_or_even]).process

    render json: { result: result }
  rescue ArgumentError => error
    render json: { error: error.message }, status: :unprocessable_entity
  end

  private

    def calculator_params
      params.permit(:numbers, :odd_or_even)
    end
end
