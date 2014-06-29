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
        Percolation::Percolation.new(10, 12)
      end            
    end    
  end  
end  