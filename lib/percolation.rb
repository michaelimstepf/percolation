require "percolation/version"

module Percolation

# This class tests a grid to see if there are enough open 
# locations to connect the top of the grid with the bottom of the 
# grid. It uses an two dimensional array of integers to represent 
# the grid, and an instructor supplied WeightedQuickUnionUF object 
# to keep track of the connections between open sites in the grid. 
# 
# The percolates() method returns true if a path can be found from a 
# site at the top to the bottom. These two sites are are not actually 
# represented in the grid, although they are represented in the  
# union-find object at locations 0 and N*N + 2. They are "located"   
# above and below the grid, and each connects to all the sites  
# immediately above or below it. This simplifies the pathfinding 
# process. 
class Percolation
  # Initializes an empty perculation data structure.
  # @param rows [Integer] height of grid
  # @param columns [Integer] width of grid
  # @raise [ArgumentError] if height or width < 1
  def initialize(rows, columns)
    raise ArgumentError, 'number of rows or columns is < 1' if (rows < 1 || columns < 1)
    
    @rows = rows
    @columns = columns
    @grid = {}
    @cells = []
    @number_of_open_sites = 0

    @rows.times do |row|
      row += 1 # start at 1
      @grid[row] = {}
      @columns.times do |column|      
        column += 1 # start at 1
        @grid[row][column] = false
        @cells < "#{row}_#{column}"        
      end
    end

    @union_find = UnionFind::UnionFind.new(@cells)
  end

  # Opens cell.
  # @param row [Integer] row
  # @param column [Integer] column
  # @return [Integer] number of open sites
  # @raise [IndexError] if row or column not in range of grid
  def open(row, column)
    if (row < 1 || column < 1 || row > @rows || column > @columns)
      raise IndexError, 'row or column not in range of grid'
    end

    @grid[row][column] = true
    @number_of_open_sites += 1
  end

  # Checks if cell is open.
  # @param row [Integer] row
  # @param column [Integer] column
  # @return [Boolean]
  # @raise [IndexError] if row or column not in range of grid
  def open?(row, column)
    if (row < 1 || column < 1 || row > @rows || column > @columns)
      raise IndexError, 'row or column not in range of grid'
    end

    @grid[row][column]
  end
end

end
