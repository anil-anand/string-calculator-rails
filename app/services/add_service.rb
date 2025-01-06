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
      delimiter = ""

      return sum if numbers.empty?

      delimiter = numbers.slice!(/\/\/(.+)\n/).strip[2..] if numbers.start_with?("//")

      current_number = 0
      current_delimiter = ""

      numbers.each_char do |character|
        if character.match?(/\d/) && (current_delimiter.empty? || current_delimiter == delimiter)
          current_number = current_number * 10 + character.to_i
          current_delimiter = ""

          next
        end

        if character.match?(/\d/) && current_delimiter.present? && current_delimiter != delimiter && !delimiter.start_with?(current_delimiter)
          raise ArgumentError, "Invalid delimiter found in the string: #{current_delimiter[..-2]}"
        end

        if delimiter.present?
          current_delimiter += character

          next if current_delimiter != delimiter
        end

        sum += current_number
        current_number = 0
      end

      sum += current_number
    end
end
