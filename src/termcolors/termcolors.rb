# frozen_string_literal: true

256.times do |code|
  number = format('%3<number>d', number: code)
  bg = "\e[48;5;#{code}m #{number}\e[0m"
  fg = "\e[38;5;#{code}m#{number}\e[0m"
  print("#{bg} #{fg}")
  print(((code + 1) % 8).zero? ? "\n" : ' ')
end
