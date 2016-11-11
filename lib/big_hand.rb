# coding: utf-8

module Poker

  # this is the big hand implementation which works with a hand
  # of an arbitrary number of cards.
  class BigHand
    attr_reader :value, :hand, :rest
    
    def initialize(cards)
      @value = evaluate(cards.sort.reverse )
    end
    
    def to_s
      "#<%s: »%s« with @hand=|%s| @rest=|%s| @value=0x%06x >" %
        [self.class, name, @hand.join("|"), @rest.join("|"), @value]
    end

    def type
      @value & 0xf_00000
    end

    def name
      Values[@value & 0xf_00000]
    end

    private
    def evaluate(cards)
      
      # Group cards by suit. Investigate groups with at least five cards
      # This assumes group_by keeps the order
      suits = cards.group_by { |c| c.suit }.values.select { |g| g.size > 4 }

      # do we have any straight flush?
      sf = suits.map { |g| seq(g) }.compact.sort_by { |s| s[0].rank }.last
      return compute_hand(ROYAL, sf, cards - sf) if sf

      # let's go for n-of-a-kind now:
      ns = [nil, [], [], [], []]
      cards.chunk { |c| c.rank }.each do |r,g|
        ns[g.length] << g
      end
      
      # do we have 4 of a kind?
      if f = ns[4].shift
        cards -= f
        return compute_hand(FOUR, f << cards.shift, cards)
      end

      # a full house?
      three = ns[3].shift
      if three && !(pair = ns[2..3].map { |g| g.first || [] }.max).empty?
        hand = three + pair[0..1]
        return compute_hand(FULLHOUSE, hand, cards - hand)
      end

      # a flush?
      unless suits.empty?
        hand = suits.max[0..4]
        return compute_hand(FLUSH, hand, cards - hand)
      end

      # a straight?
      if str = seq(cards)
        return compute_hand(STRAIGHT, str, cards - str)
      end

      # three of a kind?
      if three
        hand = three + ns[1][0] + ns[1][1] 
        return compute_hand(THREE, hand, cards - hand)
      end

      # two pairs?
      if ns[2].length > 1
        hand = ns[2][0..1].flatten << ((ns[2][2] || []) + (ns[1][0] || [])).max
        return compute_hand(TWO_PAIRS, hand, cards - hand)
      end
      
      # one pair?
      if hand = ns[2][0]
        hand += ns[1][0..2].flatten
        return compute_hand(ONE_PAIR, hand, cards - hand)
      end

      # high card
      hand = ns[1][0..4].flatten
      return compute_hand(HIGHEST, hand, cards - hand)
    end

    def seq(cards)
      # this implementation is not the most efficient but good enough ;-)
        
      downseq = cards.uniq { |c| c.rank }

      streets = downseq.chunk_while { |a,b| a.rank-1 == b.rank }
      str = streets.find { |g| g.size > 4 }
      
      return str[0..4] if str

      # special case: low ace
      if (cards.first.rank == Ranks[:a])    # this is a high ace!
        if (downseq[-4].rank == 5)          # yes, we have 5 4 3 2 a
          return (downseq[-4..-1] << cards.first)
        end
      end

      return nil   # no straight found
    end

    def compute_hand(value, hand, rest)
      @hand = hand
      @rest = rest
      return (value | rankbits(hand))
    end

    def rankbits(hand)
      v = 0
      hand.each_with_index do |c,i|
        v |= (c.rank << (4-i)*4)
      end
      v
    end
  end
end
