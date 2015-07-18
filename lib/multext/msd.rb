require 'json'

class Multext::MSD
  attr_accessor :raw, :category_code_to_category, :category_to_category_code, :value, :parse_dictionary

  def initialize
    json = File.read("#{File.dirname(__FILE__)}/../../meta/structure.json")
    @raw = JSON.parse(json)

    @parse_dictionary = {}

    @category_code_to_category = {}
    @category_to_category_code = {}

    @value = {}

    @raw.each do |item|
      @category_code_to_category[item['category_code']] = item['category']
      @category_to_category_code[item['category']] = item['category_code']

      @parse_dictionary[item['language']] = {} if @parse_dictionary[item['language']].nil?
      @parse_dictionary[item['language']][item['category_code']] = {} if @parse_dictionary[item['language']][item['category_code']].nil?
      @parse_dictionary[item['language']][item['category_code']][item['position']] = {} if @parse_dictionary[item['language']][item['category_code']][item['position']].nil?
      @parse_dictionary[item['language']][item['category_code']][item['position']][item['value_code']] = item['attribute'] if @parse_dictionary[item['language']][item['category_code']][item['position']][item['value_code']].nil?

      @value[item['category_code']] = {} if @value[item['category_code']].nil?
      @value[item['category_code']][item['attribute']] = item['value'] if @value[item['category_code']][item['attribute']] .nil?
    end
  end


  def filter(params)
    @raw.find_all do |item|
      bool = true

      params.each do |arr|
        name  = arr.first.to_s.downcase
        value = arr.last

        if (value.respond_to? 'map')
          value = value.map { |ele| ele.to_s.downcase }
          bool = value.include?(item[name].to_s.downcase)
        else
          bool = item[name].to_s.downcase == value.to_s.downcase
        end

        break unless bool
      end

      bool
    end
  end

  def parse(str, language)
    result = { 
      language: language,
      category: {
        name: nil,
        code: nil
      },
      attributes: []
    }

    str.split('').each_with_index do |char, i|
      if i == 0
        result[:category][:code] = char
        result[:category][:name] = @category_code_to_category[char]
        next
      end

      next if char == '-'

      attribute = {
        position: i,
        value: {
          code: char
        }
      }
      
      attribute[:name] = @parse_dictionary[language.to_s][result[:category][:code]][i.to_s][attribute[:value][:code]]
      attribute[:value][:name] = @value[result[:category][:code]][attribute[:name]]

      result[:attributes] << attribute
    end

    result
  end

end




{
  language: {
    category_code: {
      position: {
        value_code: 'attribute'
      }
    }
  }
}

