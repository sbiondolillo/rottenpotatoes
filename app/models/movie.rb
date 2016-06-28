class Movie < ActiveRecord::Base
  def self.ratings
    {"G" => 1, "PG" => 1, "PG-13" => 1, "R" => 1}
  end
end
