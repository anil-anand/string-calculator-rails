class AddService
  attr_reader :invalid_numbers, :invalid_delimiters

  def initialize(numbers)
    @numbers = numbers
  end

  def process
    return 0 if @numbers.empty?

    delimiter = detect_delimiter
    number_list = extract_numbers(delimiter)

    number_list.reject { |number| number > 1000 }.sum
  end

  private

  def detect_delimiter
    return /[,\n]/ unless @numbers.start_with?("//")

    custom_delimiter = @numbers.lines.first[2..-1].strip
    @numbers = @numbers.lines[1..].join
    Regexp.new(Regexp.escape(custom_delimiter))
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
