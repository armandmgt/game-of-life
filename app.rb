# frozen_string_literal: true

require 'gosu'
require 'optparse'
require_relative 'world'
require_relative 'button'

class GOLWindow < Gosu::Window
  WINDOW_SIZE = { width: 1920, height: 1080 }
  GRID_SIZE = { width: 200, height: 100 }
  TICK_MS = 1

  def initialize(params)
    super(WINDOW_SIZE[:width], WINDOW_SIZE[:height], fullscreen: false)
    self.caption = 'GOL'

    @pause = false
    @world = World.new(GRID_SIZE, WINDOW_SIZE)
    @buttons = []
    @buttons << { button: ::Button.new(::Button::REGEN, 20, 20), action: -> { @world.generate } }
    @buttons << { button: ::Button.new(::Button::PLAY, 20, 60), action: -> { @pause = false }, show: -> { @pause} }
    @buttons << { button: ::Button.new(::Button::PAUSE, 20, 60), action: -> { @pause = true }, show: -> { !@pause } }
    @buttons << { button: ::Button.new(::Button::CLEAR, 20, 100), action: -> { @world.clear } }
    @buttons << { button: ::Button.new(::Button::SAVE, 20, 140), action: -> { @world.save_to(params[:save]) } }
    @buttons << { button: ::Button.new(::Button::LOAD, 20, 180), action: -> { @world.load_from(params[:save]) } }
  end

  def button_down(id)
    close if id == Gosu::KB_ESCAPE

    @click_start = { x: mouse_x, y: mouse_y } if id == Gosu::MS_LEFT
  end

  def button_up(id)
    if id == Gosu::MS_LEFT
      click_end = { x: mouse_x, y: mouse_y }
      return unless (@click_start[:x] - click_end[:x]).abs < Tile::SPRITE_SIZE && (@click_start[:y] - click_end[:y]).abs < Tile::SPRITE_SIZE

      @buttons.any? do |btn|
        next unless !btn.key?(:show) || btn[:show].call
        if btn[:button].clicked?(click_end[:x], click_end[:y])
          btn[:action].call
          return
        end
      end

      @world.click(click_end[:x], click_end[:y])
    end
  end

  def update
    return unless !@pause && new_tick?

    @world.update
  end

  def draw
    @world.draw

    @buttons.each do |btn|
      btn[:button].draw(false) if !btn.key?(:show) || btn[:show].call
    end
  end

  private

  def new_tick?
    @last_time ||= Gosu.milliseconds
    now = Gosu.milliseconds
    if now - @last_time > TICK_MS
      @last_time = now
      true
    else
      false
    end
  end
end

params = { }
OptionParser.new do |opts|
  opts.on('--save FILENAME')
end.parse!(into: params)
params[:save] ||= 'save.csv'

GOLWindow.new(params).show
