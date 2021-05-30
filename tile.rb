# frozen_string_literal: true

class Tile
  SPRITE_SIZE = 16
  SPRITE_PATH = 'media/0x72_16x16Tile.png'

  def initialize(scale)
    @sprites = Gosu::Image.load_tiles(SPRITE_PATH, SPRITE_SIZE, SPRITE_SIZE, tileable: true, retro: true)
    @scale = scale
  end

  def update

  end

  def draw(x, y, alive)
    @sprites[alive ? 1 : 0].draw(x, y, 1, @scale, @scale)
  end
end
