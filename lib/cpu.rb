require_relative 'player'
require_relative 'card'

class TablePlayer < Player

    attr_accessor :name, :cash, :hand, :bet, :min_bet, :turn_over

    def initialize(name, start_cash, min_bet)
        super
        @turn_over = false
    end

    #Sets player bet value based on strategy
    def make_bet
        #TODO: strategic, semi-random bet based on hand and cash
        @bet = @min_bet
    end

    def display_out
    end

    #CPU shouldn't print hand normally. Maybe implement if there was a god mode
    def print_hand
    end

    def take_a_hit?
        if(!@turn_over)
            return count_hand < 17
        end
    end

    def end_turn
        @turn_over = true
    end

end