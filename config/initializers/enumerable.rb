module Enumerable
  def sum_of_count
    map(&:count).sum
  end
end
