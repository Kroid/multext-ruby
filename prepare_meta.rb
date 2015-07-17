require 'json'

result = []

raw = File.read('meta/category_attr_position.json')
category_attr_position = JSON.parse(raw)

File.foreach('meta/table_of_values.txt') do |line|
  arr = line.split(':')

  ele = {}
  ele[:value]     = arr.shift()
  ele[:code]      = arr.shift()
  ele[:attribute] = arr.shift()
  ele[:category]  = arr.shift()
  ele[:languages] = []

  arr.each do |lang|
    lang = lang.strip
    ele[:languages] << lang if lang.length > 0
  end

  category_attr_position.each do |e|
    next unless e['attribute'] == ele[:attribute] and e['category'] == ele[:category]

    ele[:position] = e['position']
    break
  end

  result << ele
end




File.open('meta/structure.json', 'w') do |file|
  file.write JSON.pretty_generate(result)
end