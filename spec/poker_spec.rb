require 'poker'

require 'pry'

include Poker

def HH(s)
  s.split(/\s+/).map { |s| Poker::C(s) }
end

describe Cards do
  it "has 52 cards" do
    Cards.length.must_equal 52
  end
end

describe Hand do

  describe "Hand with five" do
    
    it "has no rest" do
      h = Poker::H("sa sk s10 sj sd")
      h.hand.length.must_equal 5
      h.rest.length.must_equal 0
    end
    
    it "finds straight flush" do
      h = Poker::H("sa sk s10 sj sd")
      h.type.must_equal ROYAL
      puts h
    end

    it "finds four of a kind" do
      h = Poker::H("sk hk s10 dk ck")
      h.type.must_equal FOUR
      puts h
    end

    it "finds a full house" do
      h = Poker::H("sk h10 hk d10 ck")
      h.type.must_equal FULLHOUSE
      puts h
    end

    it "finds a flush" do
      h = Poker::H("sk s10 sd s8 s5")
      h.type.must_equal FLUSH
      puts h
    end    

    it "finds a straight" do
      h = Poker::H("sa hk s10 dj sd")
      h.type.must_equal STRAIGHT
      puts h
    end    

    it "finds a straight with low ace" do
      h = Poker::H("sa h4 s5 d2 s3")
      h.type.must_equal STRAIGHT
      puts h
    end    

    it "finds three of a kind" do
      h = Poker::H("sk h7 dk d5 ck")
      h.type.must_equal THREE
      puts h
    end    

    it "finds two pairs" do
      h = Poker::H("sk h7 dk d5 s7")
      h.type.must_equal TWO_PAIRS
      puts h
    end    

    it "finds one pair" do
      h = Poker::H("sk h7 d3 d5 s7")
      h.type.must_equal ONE_PAIR
      puts h
    end    

    it "finds high card" do
      h = Poker::H("sk h7 d3 d5 s6")
      h.type.must_equal HIGHEST
      puts h
    end    

  end
  
  describe "big hand" do
    it "has some rest" do
      h =  Poker::H("sd h9 h8 sj sa s10 h7 d5 c4")
      h.hand.length.must_equal 5
      h.rest.length.must_equal 4
    end

    it "finds straight flush" do
      h = Poker::H("sa sk h9 s10 sj sd")
      h.type.must_equal ROYAL
      h.rest.must_equal HH('h9')
      puts h
    end

    it "finds highest straight flush" do
      h = Poker::H("s9 d9 h9 d10 s8 dk h8 d8 s10 dd sj dj sd da")
      h.type.must_equal ROYAL
      h.hand.must_equal HH('da dk dd dj d10')
      puts h
    end

    it "finds four of a kind" do
      h = Poker::H("sk hk h9 s10 dk c2 ck")
      h.type.must_equal FOUR
      h.rest.must_equal HH('h9 c2')
      puts h
    end
    
    it "finds four of a kind in 4+4" do
      h = Poker::H("sk hk h9 s9 dk c9 ck d9")
      h.type.must_equal FOUR
      h.rest.must_equal HH('s9 h9 d9')
      puts h
    end

    it "finds four of a kind in 4+3" do
      h = Poker::H("sk hk h9 s9 c9 ck d9")
      h.type.must_equal FOUR
      h.rest.must_equal HH('sk hk')
      puts h
    end

    it "finds four of a kind in 4+2" do
      h = Poker::H("sj h9 s9 c9 cj d9")
      h.type.must_equal FOUR
      h.rest.must_equal HH('sj')
      puts h
    end

    it "finds a full house" do
      h = Poker::H("sk h10 d7 hk d10 c8 ck")
      h.type.must_equal FULLHOUSE
      puts h
    end

    it "finds a full house in 3+3" do
      h = Poker::H("sk h10 d7 hk d10 c8 c10 ck")
      h.type.must_equal FULLHOUSE
      h.hand.must_equal HH('ck sk hk c10 h10')
      puts h
    end

    it "finds a full house in 3+2+2" do
      h = Poker::H("sk h10 d7 hk d10 c8 c10 ck d8")
      h.type.must_equal FULLHOUSE
      h.hand.must_equal HH('ck sk hk c10 h10')
      puts h
    end

    it "finds a flush" do
      h = Poker::H("sk da dk s10 sd s8 s5")
      h.type.must_equal FLUSH
      h.hand.must_equal HH("sk sd s10 s8 s5")
      puts h
    end    

    it "finds the higher flush" do
      h = Poker::H("s2 d4 dk s10 d9 sd s8 d2 d5 s5 ha h6")
      h.type.must_equal FLUSH
      h.hand.must_equal HH("dk d9 d5 d4 d2")
      puts h
    end    

    it "finds a straight" do
      h = Poker::H("d2 c8 sa hk h7 s10 dj dd sd")
      h.type.must_equal STRAIGHT
      h.hand.must_equal HH("sa hk sd dj s10")
      puts h
    end    

    it "finds a straight with low ace" do
      h = Poker::H("sa d4 hk h4 c9 s5 d2 s3")
      h.type.must_equal STRAIGHT
      h.hand.must_equal HH("s5 h4 s3 d2 sa")
      puts h
    end    

    it "finds three of a kind" do
      h = Poker::H("sk h7 hj dk c8 d5 ck")
      h.type.must_equal THREE
      h.hand.must_equal HH("ck sk dk hj c8")
      puts h
    end    

    it "finds two pairs" do
      h = Poker::H("sk h7 dk c8 d5 dj s7")
      h.type.must_equal TWO_PAIRS
      h.hand.must_equal HH("sk dk s7 h7 dj")
      puts h
    end    

    it "finds two pairs from 2+2+2 with low single card" do
      h = Poker::H("sk h7 dk d5 s7 c5 c3")
      h.type.must_equal TWO_PAIRS
      h.hand.must_equal HH("sk dk s7 h7 c5")
      puts h
    end    

    it "finds two pairs from 2+2+2 with high single card" do
      h = Poker::H("sk h7 dk d5 s7 c5 ca")
      h.type.must_equal TWO_PAIRS
      h.hand.must_equal HH("sk dk s7 h7 ca")
      puts h
    end    

    it "finds one pair" do
      h = Poker::H("sk da h7 d3 c4 d5 s7")
      h.type.must_equal ONE_PAIR
      h.hand.must_equal HH("s7 h7 da sk d5")
      puts h
    end    

    it "finds high card" do
      h = Poker::H("sk h7 cj d3 sd d5 s6")
      h.type.must_equal HIGHEST
      h.hand.must_equal HH("sk sd cj h7 s6")
      puts h
    end    
  end
end

