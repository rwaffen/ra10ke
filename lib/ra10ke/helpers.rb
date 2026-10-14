# frozen_string_literal: true

# Colors and status emojis for task output.
module Ra10ke
  def self.good_emoji
    ENV.fetch('GOOD_EMOJI', '👍')
  end

  def self.bad_emoji
    ENV.fetch('BAD_EMOJI', '😨')
  end

  def self.colorize(text, color_code)
    "\e[#{color_code}m#{text}\e[0m"
  end

  def self.red(text)
    colorize(text, 31)
  end

  def self.green(text)
    colorize(text, 32)
  end
end
