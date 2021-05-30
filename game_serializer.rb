# frozen_string_literal: true

require 'csv'

class GameSerializer
  ALIVE_TOKEN = '1'
  DEAD_TOKEN = '0'

  def initialize(world)
    @world = world
  end

  def to_s
    CSV.generate do |csv|
      @world.grid.each do |row|
        csv << row.map { |col| col ? ALIVE_TOKEN : DEAD_TOKEN }
      end
    end
  end

  def from_string(str)
    CSV.new(str).map.with_index do |row, y|
      row.map.with_index do |col, x|
        @world.set(x, y, col == ALIVE_TOKEN)
      end
    end
  end
end
