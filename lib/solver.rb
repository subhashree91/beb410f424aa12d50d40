require File.expand_path(File.join(File.dirname(__FILE__), 'sudoku'))
require File.expand_path(File.join(File.dirname(__FILE__), 'builder'))

module SudokuBuilder
  class Solver < SudokuBuilder

    def initialize(sudoku)
      @sud = sudoku
      @pristine = sudoku
      @used = @sud.dup
    end

    # solve any given sudoku. If the sudoku is empty, it will build a complete one.
    def solve
      t = 0 ; o = 0
      key = 0                               # main key variable.
      loop do
        if @sud[key].class == Array         # skips pre-filled numbers.
          c = [] ; r = [] ; g = []          # build values for current grid, row, column.
          build_crg(key,c,r,g,@sud)              # updates the relevant variables for check.
          @sud[key] = []                    # makes a fresh possibilities array.
          for i in 1..9
            if check?(i, c,r,g) &&
              !@used[key].include?(i)   # checks for possible numbers.
              @sud[key] << i
            end
          end
          if @sud[key].count == 0           # backtrack if no possibilities.
            key -= 1
          else
            use = @sud[key].sample          # pick a random possibility.
            @sud[key]   = [use]             # uses the possibility.
            @used[key] << use               # also puts it into the used array.
            key += 1
          end
          if key == 0 || t > 104            # resets everything if we've reached a high amount
            @sud.each { |k,v| @sud[k] = [] } # of run throughs, or the key has wound down to 0.
            @used = @sud.dup
            key = 0 ; t = 0
          end
        else
          key += 1
        end
        break if key == 81                  # break if we've reached the last value.
        t += 1 ; o += 1                     # add the reporting variables
        break if o > 1000000                # there is the possibility to be given an
        # unsolvable puzzle, this breaks if the number
        # of run throughs is really really high.
      end
      Builder.new(@sud)
    end

  end
end
