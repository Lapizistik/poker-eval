# coding: utf-8

module Poker
  Suits = {  c: "♣", s: "♠", h: "♥", d: "♦" }
  Suitval = {
    c: 3, s: 2, h: 1, d: 0,
    "♣" => 3, "♠" => 2, "♥" => 1, "♦" => 0
  }
  
  Ranks = {
    l: 1,  # low rank ace
    t: 10, # to be able to write 10 with one char
    j: 11, # jack
    d: 12, # dame
    k: 13, # =>  king
    a: 14  # ace
  }
  RRanks = Ranks.invert
  RRanks.delete(10)
  
  class Card
    include Comparable
    
    attr_reader :suit, :rank
    
    def initialize(suit:, rank:)
      @suit = suit
      @rank = numeric(rank)
    end

    def to_s
      "#{(Suits[@suit] || @suit)}#{RRanks[@rank] || @rank}"
    end

    def inspect
      to_s
    end

    def <=>(other)
      self.value <=> other.value
    end

    protected
    def value
      (@rank << 2) | Suitval[@suit]
    end
    
    private
    def numeric(r)
      @rank = if (2..14).include? r
                r
              else
                Ranks[r] or raise "Illegal rank #{r}"
              end
    end
  end
end
