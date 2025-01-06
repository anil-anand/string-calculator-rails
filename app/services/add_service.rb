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
      sum = 0

      return sum if numbers.empty?

      current_number = 0

      numbers.each_char do |character|
        current_number = current_number * 10 + character.to_i and next if character.match?(/\d/)

        sum += current_number
        current_number = 0
      end

      sum += current_number
    end
end
