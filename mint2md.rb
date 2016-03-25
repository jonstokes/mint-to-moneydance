require 'csv'

module Arguments
  def self.valid?
    return false unless input_file && output_directory
    File.exists?(input_file) && Dir.exists?(output_directory)
  end

  def self.input_file
    ARGV.first
  end

  def self.output_directory
    ARGV.last
  end

  def self.invalid?
    !valid?
  end

  def self.help?
    ARGV.first.downcase.include?("help")
  end
end

class Row
  attr_reader :date, :category
  def initialize(line)
    @date = line["Date"]
    @description = line["Description"]
    @memo = line["Original Description"]
    @amount = line["Amount"]
    @transaction_type = line["Transaction Type"]
    @category = line["Category"]
    @account_name = line["Account Name"]
  end

  def memo
    @memo.gsub(",", " ")
  end

  def description
    @description.gsub(",", " ")
  end

  def amount
    return "-#{@amount}" if debit?
    amount
  end

  private

  def debit?
    @transaction_type.downcase == "debit"
  end
end

class Mint2Md
  attr_reader :lines
  attr_reader :output

  def initialize(input:, output:)
    @lines = CSV.read(input, headers: true)
    @output_directory = output_directory
    @output = {}
  end

  def run
    lines.each do |line|
      account_name = line["Account Name"]
      @output[account_name] ||= []
      @output[account_name] << [
        line["Date"],
        line["Description"],
        line["Original Description"],
        line["Amount"]
      ]
    end
  end
end

if Arguments.invalid? || Arguments.help?
  puts "usage:"
  puts "  mint2md -i <input_file> -o <output_directory> -c <categories.yml>"
else
  processor = Mint2Md.new(input: Arguments.input_file, output: Arguments.output_directory)
  processor.run
end
