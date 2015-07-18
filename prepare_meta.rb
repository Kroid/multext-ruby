require 'json'

result = []

category_attr_position = JSON.parse(File.read('meta/category_attr_position.json'))

categories = {}
File.foreach('meta/table_of_categories.txt') do |line|
  arr = line.split(':')
  categories[arr[1]] = arr[2]
end


File.foreach('meta/table_of_values.txt') do |line|
  arr = line.split(':')

  ele = {}
  ele[:value]      = arr.shift()
  ele[:value_code] = arr.shift()
  ele[:attribute]  = arr.shift()
  ele[:category]   = arr.shift()
  ele[:category_code] = categories[ele[:category]]

  category_attr_position.each do |e|
    next unless e['attribute'] == ele[:attribute] and e['category'] == ele[:category]

    ele[:position] = e['position'].to_s
    break
  end

  arr.each do |lang|
    lang = lang.strip

    next if lang.length < 1

    copy = ele.dup

    copy[:language] = lang
    
    result << copy
  end
end




File.open('meta/structure.json', 'w') do |file|
  file.write JSON.pretty_generate(result)
end