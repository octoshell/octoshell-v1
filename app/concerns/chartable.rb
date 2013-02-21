# coding: utf-8
module Chartable
  def default_options
    @default_options || {}
  end
  
  def default_options=(options)
    @default_options = options
  end
  
  def to_chart(type, options = {})
    options.merge!(default_options)
    send("to_#{type}_chart", options).to_json
  end
  
private
  
  def to_column_chart(options = {})
    tooltips = options[:tooltips] || begin
      map do |arr|
        "#{arr[0]}: #{arr[1]}"
      end
    end
    [{
      name: 'Количество',
      data: map(&:last),
      categories: map(&:first),
      tooltips: tooltips
    }]
  end
  
  def to_pie_chart(options = {})
    tooltips = options[:tooltips] || begin
      map do |arr|
        "#{arr[0]}: #{arr[1]}"
      end
    end
    [{
      type: 'pie',
      data: self,
      name: 'Количество',
      tooltips: tooltips
    }]
  end
end
