# Percolation IN PROGRESS

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'percolation'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install percolation

## Usage

Create a new instance of `Percolation` and pass in the number of rows (first argument) and columns (second argument):

```ruby
# Creates a grid with 4 rows and 6 columns
percolation = Percolation::Percolation.new(4,6)
```

Open sites (think of cells in a table) by passing in the row and column. Both rows and columns start at 1 (and not 0):

```ruby
# Opens site in 4th column of 1st row
percolation.open(1,4)
```

Check if two sites connect to each other:

```ruby
# Opens site: row 1 / column 4
percolation.open(1,4)
# Opens site: row 2 / column 4
percolation.open(2,4)
# Opens site: row 2 / column 3
percolation.open(2,3)
# Opens site: row 3 / column 3
percolation.open(3,3)
# Opens site: row 4 / column 3
percolation.open(4,3)
# Checks if two sites are connected
percolation.percolates({row: 1, column: 4}, {row: 4, column: 3})
=> true

X | X | X | O
X | X | O | O
X | X | O | X
X | X | O | X

```


## Contributing

1. Fork it ( https://github.com/[my-github-username]/percolation/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
