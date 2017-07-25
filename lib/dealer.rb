require_relative 'card'

class Dealer 
    def initialize(name)
        @hand = []
    end

    #Put a card in the player's hand
    def give_card(card)
        @hand.push(card)
    end

    def burn_hand
        @hand = []
    end

    #Returns total value of cards in hand closest to 21
    def count_hand
        total = 0

        #p @hand
        #skip aces first run 
        @hand.each {|card| total += card.value if card.rank != :A}

        #now add aces without breaking
        #If its gonna break no matter what, just count all Aces as 1s & return
        ace_ct = @hand.count {|card| card.rank == :A}
        if total + ace_ct >= 21 then return total + ace_ct end
        
        @hand.each do |card|
            if card.rank == :A
                if total + 11 <= 21
                    total += 11
                else total += 1 end
            end
        end

        total
    end

    #Returns true if hit, false if pass
    def take_a_hit?
        if(!@turn_over)
            return count_hand < 17
        end
    end

    #Prints first card in dealer's hand
    def print_top
        card = @hand[0]
        puts
        puts "Dealer top card:"
        printf("       %8s",  "-----------")
        puts
        printf("   + | %8s  |", card.rank.to_s)
        puts
        printf("     | %8s  |", 'of')
        puts
        printf("     | %8s  |", card.suit.to_s)
        puts
        printf("       %8s",  "-----------")
        puts
    end

    #Prints all cards in dealer's hand
    def print_hand
        puts
        puts "Dealer's Hand:"
        @hand.each{|card| printf("       %8s",  "-----------")}
        puts
        @hand.each{|card| printf("   + | %8s  |", card.rank.to_s)}
        puts
        @hand.each{|card| printf("     | %8s  |", 'of')}
        puts
        @hand.each{|card| printf("     | %8s  |", card.suit.to_s)}
        puts
        @hand.each{|card| printf("       %8s",  "-----------")}
        puts
        puts "Total value: #{count_hand}"
        puts
    end
end