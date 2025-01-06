# frozen_string_literal: true

class AddService
  def initialize(numbers_string)
    @numbers_string = numbers_string
  end

  def process
    add(@numbers_string)
  end

  private

    def add(numbers)
      0 if numbers.empty?
    end
end
