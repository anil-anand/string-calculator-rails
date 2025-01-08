class CalculatorController < ApplicationController
  def add
    result = AddService.new(calculator_params[:numbers].to_s).process

    render json: { result: result }
  rescue ArgumentError => error
    render json: { error: error.message }, status: :unprocessable_entity
  end

  private

    def calculator_params
      params.permit(:numbers)
    end
end
