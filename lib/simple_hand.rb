
module Poker

  # this is the plain hand implementation which works with a hand
  # of exactly five cards.
  class SimpleHand
    attr_reader :value
    
    def initialize(cards)
      @cards = cards.sort_by { |c| c.rank }
      evaluate
      @value = compute_value
    end
    
    def to_s
      "#<%s @cards=|%s| @value=0x%06x >" % [self.class, @cards.join("|"), @value]
    end

    private
    def evaluate
      @flush = (@cards.chunk { |c| c.suit }.size == 1)
      @singles = []
      @pairs = []
      @three = nil
      @four = nil
      @straight = nil
      
      if !@flush  # a flush has never n of a kind 
        # collect cards with same rank
        @cards.chunk(&:rank).each do |r, a|
          case a.size
          when 1
            @singles << r
          when 2
            @pairs << r
          when 3
            @three = r
          when 4
            @four = r
          end
        end
      else
        @singles = @cards.map(&:rank)
      end
      
      # a straight is only possible if there are no n of a kind
      if @singles.length == 5
        highest = @singles.last
        if @singles.first + 4 == highest # found a straight
          @straight = highest
        elsif highest == Ranks[:a] # special case: maybe low ace?
          highest = @singles[-2]
          if highest == 5 # found a straight with low ace
            @straight = highest
            # we also could reorder (but does not matter for value comparison)
            # @singles = @singles[0..-2].unshift(Ranks[:l]) # update/reorder!
          end
        end
      end
    end

    def compute_value
      # we represent the hand as one integer value
      # each rank can be represented in 4 bit (1 to 14)
      # Each category has a high bits number, the lower bits give
      # the ranks of the combination cards and the remaining single cards
      case
      when @straight && @flush
        ROYAL
      when @four
        FOUR | (@four << 4)
      when @three && !@pairs.empty?
        FULLHOUSE | (@three << 4) | (@pairs[0] << 3)
      when @flush
        FLUSH
      when @straight
        STRAIGHT
      when @three
        THREE | (@three << 4)
      when @pairs.length == 2
        TWO_PAIRS | (@pairs[1] << 4) | (@pairs[0] << 3)
      when @pairs.length == 1
        ONE_PAIR
      else
        HIGHEST
      end | singles_bits
    end
    
    def singles_bits
      v = 0
      @singles.each_with_index do |r,i|
        v |= (r << i*4)
      end
      v
    end
    
  end
end
