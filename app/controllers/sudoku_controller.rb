class SudokuController < ApplicationController
  SIZE = 9
  NUMBERS = (1..9).to_a

  def initialize
    @cell = Array.new(SIZE) {Array.new(SIZE,nil)}
  end

  def [](x,y)
    @cell[y][x]
  end

  def []=(x,y,value)
    raise "#{value} is not allowed in the row #{y}" unless allowed_in_row(y).include?(value)
    raise "#{value} is not allowed in the column #{x}" unless allowed_in_column(x).include?(value)
    raise "#{value} is not allowed in the square at #{x}, #{y}" unless allowed_in_square(x,y).include?(value)
    @cell[y][x] = value
  end

  def to_s
    @cell.map {|row| row.map{|x| if x.nil?; '-'; else x end}.join(' ')}.join("\n")
  end

  def row(y)
    Array.new(@cell[y])
  end

  def column(x)
    @cell.map {|row| row[x]}
  end

  def allowed_in_row(y)
    (NUMBERS - row(y)).uniq << nil
  end

  def allowed_in_column(x)
    (NUMBERS - column(x)).uniq << nil
  end

  def allowed_in_square(x,y)
    a = 3*(x/3)
    b = 3*(y/3)
    square = []
    3.times do |i|
      3.times do |j|
        square << @cell[b + j][a + i]
      end
    end

    (NUMBERS - square).uniq << nil
  end

  def allowed(x,y)
    allowed_in_row(y) & allowed_in_column(x) & allowed_in_square(x,y)
  end

  def empty
    result = []

    9.times do |y|
      9.times do |x|
        result << [x,y] if self[x,y].nil?
      end
    end

    result
  end

  def solved?
    empty.empty?
  end

  sudoku = Sudoku.new
  9.times do |y|
    gets.chop.split('').each_with_index do |value,x|
      sudoku[x,y] = value.to_i unless value == '-'
    end
  end

  def solve(sudoku)
    return true if sudoku.solved?
    x,y = sudoku.allowed(x,y).compact

    while !allowed.empty?
      sudoku[x,y] = allowed.shift

      begin
        return true if solve(sudoku)
        rescue Exception => e
      end

      sudoku[x,y] = nil
    end

    return  false
  end

  if solve(sudoku)
    puts sudoku
  else
    puts "unsolved"
  end

end
