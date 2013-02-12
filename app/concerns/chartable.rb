module Chartable
  def to_chart(type, options = {})
    send("to_#{type}_chart", options).to_json
  end
  
private
  
  def to_column_chart(options = {})
    map do |arr|
      { name: arr[0], data: [arr[1]] }
    end
  end
  
  def to_pie_chart(options = {})
    [{ type: 'pie', data: self, name: options[:name] }]
  end
end
