class AddService
  attr_reader :invalid_numbers, :invalid_delimiters

  def initialize(numbers, odd_or_even = nil)
    @numbers = numbers
    @odd_or_even = odd_or_even
  end

  def process
    return 0 if @numbers.empty?

    if @numbers.match?(/\d\*\d/)
      process_numbers_with_multiplication
    else
      delimiter = detect_delimiter
      number_list = extract_numbers(delimiter)

      compute_sum(number_list)
    end
  end

  private

    def compute_sum(number_list)
      if @odd_or_even.present?
        sum = 0

        number_list.each_with_index do |number, index|
          if @odd_or_even == "odd" && index.odd?
            sum += number
          elsif @odd_or_even == "even" && index.even?
            sum += number
          end
        end

        sum
      else
        number_list.reject { |number| number > 1000 }.sum
      end
    end

    def process_numbers_with_multiplication
      current_number = 0
      previous_number = 0
      sum = 0
      current_delimiter = ""

      @numbers.each_char do |character|
        if character.match?(/\d/)
          current_number = current_number * 10 + character.to_i
          next
        elsif character == "*"
          current_delimiter = character
          sum += current_number
          previous_number = current_number
          current_number = 0
          next
        end

        if current_delimiter == "*"
          sum -= previous_number
          number_to_add = previous_number * current_number
          sum += number_to_add
          current_delimiter = ""
        else
          sum += current_number
        end

        previous_number = current_number
        current_number = 0
      end

      sum += current_number
    end

    def detect_delimiter
      return /[,\n]/ unless @numbers.start_with?("//")

      custom_delimiter = @numbers.lines.first[2..-1].strip
      @numbers = @numbers.lines[1..].join

      if custom_delimiter.start_with?("[") && custom_delimiter.end_with?("]")
        allowed_delimiters = custom_delimiter[1..-2].split("][").map { |delimiter| Regexp.escape(delimiter) }
        Regexp.new(allowed_delimiters.join("|"))
      else
        Regexp.new(Regexp.escape(custom_delimiter))
      end
    end

    def extract_numbers(delimiter)
      parts = @numbers.split(delimiter)
      validate!(parts, delimiter)
      parts.map(&:to_i)
    end

    def validate!(parts, delimiter)
      validate_delimiters!(parts, delimiter)
      validate_numbers!(parts)
    end

    def validate_delimiters!(parts, delimiter)
      @invalid_delimiters = parts
        .select { |part| part.to_i.to_s != part && part.match?(/[^0-9]/) && part != delimiter }
        .map { |part| part.gsub(/[0-9]/, "") }

      return if invalid_delimiters.empty?

      raise ArgumentError, "Invalid delimiters detected: #{invalid_delimiters.uniq.join(', ')}"
    end

    def validate_numbers!(parts)
      @invalid_numbers = parts.select { |part| part.to_i < 0 }

      raise ArgumentError, "Negative numbers are not allowed: #{invalid_numbers.join(', ')}" if invalid_numbers.any?
    end
end
