# frozen_string_literal: true

require_relative 'tile'
require_relative 'game_serializer'

class World
  attr_reader :world

  def initialize(grid_size, window_size)
    @tile_size = begin
                   tile_size_y = window_size[:height].to_f / grid_size[:height]
                   tile_size_x = window_size[:width].to_f / grid_size[:width]
                   [tile_size_y, tile_size_x].min
                 end
    @tile = Tile.new(@tile_size / Tile::SPRITE_SIZE)
    @rows = grid_size[:height]
    @cols = grid_size[:width]
    generate
  end

  def update
    next_grid = @grid.map.with_index do |row, y|
      row.map.with_index do |alive, x|
        if alive
          alive_neighbours(x, y).between?(2, 3)
        else
          alive_neighbours(x, y) == 3
        end
      end
    end
    @grid = next_grid
  end

  def click(x, y)
    col = (x / @tile_size).to_i
    row = (y / @tile_size).to_i
    set(row, col, !@grid[row][col])
  end

  def set(col, row, value)
    return unless col < @cols && row < @rows

    @grid[row][col] = value
  end

  def draw
    @grid.each_with_index do |row, y|
      row.each_with_index do |alive, x|
        @tile.draw(x * @tile_size, y * @tile_size, alive)
      end
    end
  end

  def generate
    @grid = @rows.times.map do
      @cols.times.map do
        rand(100) > 80
      end
    end
  end

  def clear
    @grid = @rows.times.map do
      @cols.times.map do
        false
      end
    end
  end

  def save_to(filename)
    File.open(filename, 'w') do |f|
      f.write(GameSerializer.new(self).to_s)
    end
  end

  def load_from(filename)
    File.open(filename, 'r') do |f|
      GameSerializer.new(self).from_string(f.read)
    end
  end

  private

  def alive_neighbours(x, y)
    [
      [x, y - 1], # up
      [x + 1, y - 1], # up-right
      [x + 1, y], # right
      [x + 1, y + 1], # down-right
      [x, y + 1], # down
      [x - 1, y + 1], # down-left
      [x - 1, y], # left
      [x - 1, y - 1] # up-left
    ].map do |nx, ny|
      nx >= 0 && ny >= 0 && ny < @rows && nx < @cols && @grid[ny][nx] ? 1 : 0
    end.sum
  end
end
