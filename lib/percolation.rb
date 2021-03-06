require "percolation/version"

module Percolation

# This class tests a grid to see if there are enough open sites to find  
# a path between two sites. It uses a nested Hash with Booleans 
# to represent closed and open sites and a UnionFind
# (Weighted Quick Union with Path Compression) object
# to keep track of the connections between open sites in the grid. 
class Percolation
  # Initializes a perculation object.
  # @param rows [Integer] height of grid
  # @param columns [Integer] width of grid
  # @raise [ArgumentError] if height or width < 1
  def initialize(rows, columns)
    raise ArgumentError, 'number of rows or columns is < 1' if (rows < 0 || columns < 0)
    
    @rows = rows
    @columns = columns
    @grid = {}
    @sites = []
    @number_of_open_sites = 0

    @rows.times do |row|
      row += 1 # start at 1
      @grid[row] = {}
      @columns.times do |column|      
        column += 1 # start at 1
        @grid[row][column] = false
        @sites << "#{row}_#{column}"        
      end
    end

    @union_find = UnionFind::UnionFind.new(@sites)
  end

  # Opens site and connects it to open neighboring sites.
  # @param row [Integer] row
  # @param column [Integer] column
  # @return [Integer, NilClass] number of open sites or nil if site is already open
  # @raise [IndexError] if row or column not in range of grid
  def open(row, column)
    raise_if_outside_grid(row, column)

    # return if already open
    return nil if @grid[row][column]
    
    @grid[row][column] = true
    @number_of_open_sites += 1

    # union with open neighbouring sites
    neighboring_sites = get_neighboring_sites(row, column)
    neighboring_sites.each do |side, neighboring_site|
      if open?(neighboring_site[:row], neighboring_site[:column])
        @union_find.union("#{row}_#{column}", "#{neighboring_site[:row]}_#{neighboring_site[:column]}")
      end
    end

    @number_of_open_sites
  end

  # Checks if cell is open.
  # @param row [Integer] row
  # @param column [Integer] column
  # @return [Boolean]
  # @raise [IndexError] if row or column not in range of grid
  def open?(row, column)
    raise_if_outside_grid(row, column)    

    @grid[row][column]
  end

  # Counts the number of open sites.
  # @return [Integer] number of open sites
  def count_open_sites
    @number_of_open_sites
  end

  # Counts the number of closed sites.
  # @return [Integer] number of closed sites
  def count_closed_sites
    @rows * @columns - @number_of_open_sites
  end

  # Checks whether all sites are open
  # @return [Boolean]
  def all_sites_open?
    count_closed_sites == 0
  end

  # Checks whether all sites are closed
  # @return [Boolean]
  def all_sites_closed?
    count_open_sites == 0
  end  

  # Checks whether two sites percolate
  # @return [Boolean]
  def percolates?(site_1, site_2)
    # make sure arguments come in the right form
    unless site_1.is_a?(Hash) && site_2.is_a?(Hash) && site_1.has_key?(:row) && site_1.has_key?(:column) && site_2.has_key?(:row) && site_2.has_key?(:column)
      raise ArgumentError, 'arguments are not Hashes or do not include the keys :row and :column'
    end

    # translate into text for union find
    site_1 = "#{site_1[:row]}_#{site_1[:column]}"
    site_2 = "#{site_2[:row]}_#{site_2[:column]}"
    @union_find.connected?(site_1, site_2)
  end

  # Checks whether the grid percolates from top to bottom
  # @return [Boolean]
  def percolates_from_top_to_bottom?
    open_top_sites
    open_bottom_sites
    percolates?({row: 1, column: 1}, {row: @rows, column: 1})
  end

  # Checks whether the grid percolates from bottom to top
  # @return [Boolean]
  def percolates_from_bottom_to_top?
    percolates_from_top_to_bottom?
  end

  # Checks whether the grid percolates from left to right
  # @return [Boolean]
  def percolates_from_left_to_right?
    open_left_sites
    open_right_sites
    percolates?({row: 1, column: 1}, {row: 1, column: @columns})
  end

  # Checks whether the grid percolates from left to right
  # @return [Boolean]
  def percolates_from_right_to_left?
    percolates_from_left_to_right?
  end    

  # Returns grid as a nested Hash.
  # Entries can be accessed through grid[row][column].
  # Open sites are marked as true, closed sites are marked as false.
  # @return [Hash] grid
  def get_grid
    @grid
  end  

  private

  # Checks if row number is in range of grid.
  # @param row [Integer] row
  # @return [Boolean]
  def row_in_grid?(row)
    (row > 0 && row <= @rows) ? true : false
  end

  # Checks if column number is in range of grid.
  # @param column [Integer] column
  # @return [Boolean]
  def column_in_grid?(column)
    (column > 0 && column <= @columns) ? true : false
  end

  # Raises error if row or column number is not in range of grid.
  # @param row [Integer] column  
  # @param column [Integer] column
  # @return [Boolean] false
  # @raise [IndexError] if row or column is not in range of grid
  def raise_if_outside_grid(row, column)
    unless row_in_grid?(row) && column_in_grid?(column)
      raise IndexError, 'row or column not in range of grid'
    end

    false
  end

  # Retrieves neighboring sites that share one side with a site.
  # @param row [Integer] column  
  # @param column [Integer] column
  # @return [Hash] neighboring sites
  # @raise [IndexError] if row or column is not in range of grid
  def get_neighboring_sites(row, column)
    raise_if_outside_grid(row, column)

    neighboring_sites = {}    
    neighboring_sites[:top] = {row: row-1, column: column} if row_in_grid?(row-1)
    neighboring_sites[:bottom] = {row: row+1, column: column} if row_in_grid?(row+1)
    neighboring_sites[:left] = {row: row, column: column-1} if column_in_grid?(column-1)
    neighboring_sites[:right] = {row: row, column: column+1} if column_in_grid?(column+1)

    neighboring_sites
  end

  # Opens all sites in top row.
  # @return [Integer] number of sites opened
  def open_top_sites
    @columns.times do |column|
      column += 1 # start at 1
      open(1, column)
    end
    @columns
  end

  # Opens all sites in bottom row.
  # @return [Integer] number of sites opened
  def open_bottom_sites
    @columns.times do |column|
      column += 1 # start at 1
      open(@rows, column)
    end
    @columns
  end

  # Opens all sites in left column.
  # @return [Integer] number of sites opened
  def open_left_sites
    @rows.times do |row|
      row += 1 # start at 1
      open(row, 1)
    end
    @rows
  end

  # Opens all sites in right column.
  # @return [Integer] number of sites opened
  def open_right_sites
    @rows.times do |row|
      row += 1 # start at 1
      open(row, @columns)
    end
    @rows
  end         
end

end
