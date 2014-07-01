require 'spec_helper'

describe Percolation::Percolation do
  describe '#initialize' do    
    context 'when number of rows is < 1' do
      it 'raises an exception' do
        expect {Percolation::Percolation.new(0, 10)}.to raise_exception(ArgumentError)
      end            
    end

    context 'when number of columns is < 1' do
      it 'raises an exception' do
        expect {Percolation::Percolation.new(10, 0)}.to raise_exception(ArgumentError)
      end            
    end

    context 'when rows and columns are >= 1' do
      percolation = Percolation::Percolation.new(2, 3)

      it 'creates the grid' do
        grid = percolation.get_grid
        expect(grid.count).to eq 2
        expect(grid[1].count).to eq 3
        expect(grid[1][1]).to be_falsey
      end
    end    
  end

  describe '#open' do
    percolation = Percolation::Percolation.new(2, 3)
    
    context 'when passed in row or column is out of index' do
      it 'raises an exception' do
        expect {percolation.open(0,1)}.to raise_exception(IndexError)
        expect {percolation.open(1,4)}.to raise_exception(IndexError)
      end
    end

    context 'when passed in valid row or column' do    
      it 'opens the site' do
        percolation.open(1,1)
        expect(percolation.count_open_sites).to eq 1
        expect(percolation.count_closed_sites).to eq 2*3-1
        expect(percolation.open?(1,1)).to be_truthy
      end
    end
  end

  describe '#open?' do
    percolation = Percolation::Percolation.new(2, 3)
    
    context 'when passed in row or column is out of index' do
      it 'raises an exception' do
        expect {percolation.open?(0,1)}.to raise_exception(IndexError)
        expect {percolation.open?(1,4)}.to raise_exception(IndexError)
      end
    end

    context 'when passed in valid row or column' do        
      it 'opens the site' do
        percolation.open(1,1)
        expect(percolation.open?(1,1)).to be_truthy
        expect(percolation.open?(1,2)).to be_falsey      
      end
    end
  end

  describe '#count_open_sites' do
    percolation = Percolation::Percolation.new(2, 3)

    it 'returns correct number' do
      expect(percolation.count_open_sites).to eq 0      
      percolation.open(2,1)
      expect(percolation.count_open_sites).to eq 1
    end
  end

  describe '#count_closed_sites' do
    percolation = Percolation::Percolation.new(2, 3)

    it 'returns correct number' do
      expect(percolation.count_closed_sites).to eq 2*3      
      percolation.open(2,3)
      expect(percolation.count_closed_sites).to eq 2*3-1
    end
  end

  describe '#count_closed_sites' do
    percolation = Percolation::Percolation.new(2, 3)

    it 'returns correct number' do
      expect(percolation.count_closed_sites).to eq 2*3      
      percolation.open(2,3)
      expect(percolation.count_closed_sites).to eq 2*3-1
    end
  end

  describe '#all_sites_open?' do
    percolation = Percolation::Percolation.new(1, 2)

    it 'returns correct boolean' do
      expect(percolation.all_sites_open?).to be_falsey     
      percolation.open(1,1)
      percolation.open(1,2)
      expect(percolation.all_sites_open?).to be_truthy     
    end
  end

  describe '#all_sites_closed?' do
    percolation = Percolation::Percolation.new(1, 2)

    it 'returns correct boolean' do
      expect(percolation.all_sites_closed?).to be_truthy     
      percolation.open(1,1)
      expect(percolation.all_sites_closed?).to be_falsey
    end
  end

  describe '#get_grid' do
    percolation = Percolation::Percolation.new(1, 2)
    grid = percolation.get_grid

    it 'returns grid' do
      expect(grid.is_a?(Hash)).to be_truthy     
      expect(grid[1][1]).to be_falsey
      expect(grid[1][2]).to be_falsey
    end
  end

  describe '#percolates?' do
    context 'when grid does not percolate' do
      percolation = Percolation::Percolation.new(2, 3)
      
      it 'returns false' do
        expect(percolation.percolates?({row: 2, column: 2}, {row: 1, column: 1})).to be_falsey
        percolation.open(1,1)
        expect(percolation.percolates?({row: 2, column: 2}, {row: 1, column: 1})).to be_falsey
      end
    end

    context 'when grid does percolate' do
      percolation = Percolation::Percolation.new(2, 3)
  
      it 'returns true' do
        percolation.open(1,1)
        percolation.open(2,1)        
        expect(percolation.percolates?({row: 2, column: 2}, {row: 1, column: 1})).to be_falsey
        expect(percolation.percolates?({row: 1, column: 1}, {row: 2, column: 1})).to be_truthy
      end
    end    
  end

  describe '#percolates_from_top_to_bottom?' do
    context 'when grid does not percolate' do
      percolation = Percolation::Percolation.new(4, 4)
      
      it 'returns false' do
        expect(percolation.percolates_from_top_to_bottom?).to be_falsey
        expect(percolation.percolates_from_bottom_to_top?).to be_falsey        
        percolation.open(1,3)
        expect(percolation.percolates_from_top_to_bottom?).to be_falsey
        expect(percolation.percolates_from_bottom_to_top?).to be_falsey                
      end
    end

    context 'when grid does percolate' do
      percolation = Percolation::Percolation.new(4, 4)
  
      it 'returns true' do
        percolation.open(2,1)
        percolation.open(2,2)
        percolation.open(3,2)        
        expect(percolation.percolates_from_top_to_bottom?).to be_truthy
        expect(percolation.percolates_from_bottom_to_top?).to be_truthy                
      end
    end    
  end

  describe '#percolates_from_left_to_right?' do
    context 'when grid does not percolate' do
      percolation = Percolation::Percolation.new(4, 4)
      
      it 'returns false' do
        expect(percolation.percolates_from_left_to_right?).to be_falsey
        expect(percolation.percolates_from_right_to_left?).to be_falsey        
        percolation.open(1,2)
        expect(percolation.percolates_from_left_to_right?).to be_falsey
        expect(percolation.percolates_from_right_to_left?).to be_falsey                
      end
    end

    context 'when grid does percolate' do
      percolation = Percolation::Percolation.new(4, 4)
  
      it 'returns true' do
        percolation.open(1,2)
        percolation.open(2,2)
        percolation.open(2,3)        
        expect(percolation.percolates_from_left_to_right?).to be_truthy
        expect(percolation.percolates_from_right_to_left?).to be_truthy        
      end
    end    
  end                       
end  