class AddService
  def initialize(numbers_string)
    @numbers = numbers_string
    @sum = 0
  end

  def process
    return 0 if @numbers.empty?

    add
  end

  private

    def add
      delimiter
      current_number = 0
      current_delimiter = ""

      @numbers.each_char do |character|
        current_delimiter, current_number = process_character(character, current_number, current_delimiter)
      end

      @sum += current_number
    end

    def process_character(character, current_number, current_delimiter)
      return "", current_number * 10 + character.to_i if digit_and_not_delimiter?(character, current_delimiter)

      raise ArgumentError, argument_error_message(current_delimiter) if invalid_delimiter?(character, current_delimiter)

      if delimiter.present?
        current_delimiter += character

        return current_delimiter, current_number if current_delimiter != delimiter
      end

      @sum += current_number
      return current_delimiter, 0
    end

    def digit_and_not_delimiter?(character, current_delimiter)
      character.match?(/\d/) &&
        (
          current_delimiter.empty? ||
          current_delimiter == delimiter
        )
    end

    def invalid_delimiter?(character, current_delimiter)
      character.match?(/\d/) &&
      current_delimiter.present? &&
      current_delimiter != delimiter &&
      !delimiter.start_with?(current_delimiter)
    end

    def argument_error_message(current_delimiter)
      "Invalid delimiter found in the string: #{current_delimiter[..-2]}"
    end

    def delimiter
      @_delimiter ||= @numbers.start_with?("//") ?
        @numbers.slice!(/\/\/(.+)\n/).strip[2..] :
        ""
    end
end
