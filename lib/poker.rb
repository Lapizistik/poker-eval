# coding: utf-8

require_relative 'card'
require_relative 'simple_hand'
require_relative 'big_hand'

# require 'pry-byebug'

module Poker
  
  HIGHEST   = 0
  ONE_PAIR  = 0x1_00000
  TWO_PAIRS = 0x2_00000
  THREE     = 0x3_00000
  STRAIGHT  = 0x4_00000
  FLUSH     = 0x5_00000
  FULLHOUSE = 0x6_00000
  FOUR      = 0x7_00000
  ROYAL     = 0x8_00000 # straight flush

  # only needed for nice display
  Values = {
    HIGHEST   => "high card",
    ONE_PAIR  => "one pair",
    TWO_PAIRS => "two pairs",
    THREE     => "three of a kind",
    STRAIGHT  => "straight",
    FLUSH     => "flush",
    FULLHOUSE => "full house",
    FOUR      => "four of a kind",
    ROYAL     => "straight flush",
  }
    

  Hand = BigHand
  
  # convenience methods for better handling/testing
  
  def self.C(c)
    s = Suits[c[0].downcase.to_sym] || c[0]
    r = Ranks[c[1].downcase.to_sym] || c[1..-1].to_i
    Card.new(suit: s,rank: r)
  end

  def self.H(*a)
    if a.length == 1
      a = a[0].split(/\s+/)
    end
    Hand.new(a.map { |s| C(s) })
  end

  Cards = Suits.values.map { |s|
    (2..14).map { |r| Card.new(suit: s, rank: r) }}.flatten


end
