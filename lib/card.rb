class Card

    RANKS = [:A, 2, 3, 4, 5, 6, 7, 8, 9, 10, :J, :Q, :K]
    SUITS = [:clubs, :diamonds, :hearts, :spades]

    def getval(rank)
        case rank
        when 2..10
            return rank
        when :A
            return 1
        when :J, :Q, :K
            return 10
        end
    end

    def initialize(rank, suit)
        @rank = rank
        @suit = suit
        @value = getval(@rank)
    end

    attr_accessor :rank, :suit, :value

    def >(x)
        self.rank > x.rank
    end

    def <(x)
        self.rank < x.rank
    end

    def ==(x)
        self.rank == x.rank && self.suit == x.suit
    end


end