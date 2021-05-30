# frozen_string_literal: true

class Button
  REGEN = { text: 'Regenerate' }
  PLAY = { text: 'Play' }
  PAUSE = { text: 'Pause' }
  CLEAR = { text: 'Clear' }
  SAVE = { text: 'Save to file' }
  LOAD = { text: 'Load from file'}

  def initialize(button_config, x, y)
    @conf = button_config
    @x_pos = x
    @y_pos = y
    @sprite = Gosu::Image.from_text(button_config[:text], 32)
  end

  def clicked?(x, y)
    x >= @x_pos && x < @x_pos + @sprite.width && y >= @y_pos && y < @y_pos + @sprite.height
  end

  def draw(_pressed)
    @sprite.draw(@x_pos, @y_pos, 2)
    Gosu.draw_rect(@x_pos, @y_pos, @sprite.width, @sprite.height, Gosu::Color::GRAY)
  end
end
