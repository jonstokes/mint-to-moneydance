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

class Mint2Md

  def process_input_file
    puts "Processing..."
  end

  def run
    if Arguments.invalid? || Arguments.help?
      puts "usage:"
      puts "  mint2md <input_file> <output_directory>"
    else
      process_input_file
    end
  end
end

Mint2Md.new.run

