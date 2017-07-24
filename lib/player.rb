class Player

    attr_accessor :name, :cash, :hand, :bet, :min_bet

    def initialize(name, start_cash, min_bet)
        @name = name
        @cash = start_cash
        @min_bet = min_bet
        @hand = []
        @bet = 0
    end

    #Put a card in the player's hand
    def give_card(card)
        @hand.push(card)
    end

    #Clears a player's hand
    def burn_hand
        @hand = []
    end

    #Prints all cards in a player's hand
    def print_hand
        puts
        puts "Current Hand:"
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
        puts "Current Bet: $#{bet} | Cash: $#{@cash}\n"
        puts
    end

    #Sets player bet value based on input
    def make_bet
        #TODO: Only print top card
        print_hand

        puts "Enter an amount to bet above $#{@min_bet}:"

        ubet = 0
        while user_input = STDIN.gets.chomp
            #Ensure input is integer
            uinput = Integer(user_input) rescue nil
            if uinput.nil?
                puts "Only plain integers are accepted as numbers."
                puts "Enter a number below #{@cash} and at least #{@min_bet}"
                next
            elsif @cash - uinput < 0
                puts "You don't have enough cash to make that bet."
                puts "Enter a number below #{@cash} and at least #{@min_bet}"
                next
            elsif uinput < @min_bet
                puts "The minimum bet is $#{@min_bet}."
                puts "Enter a number below #{@cash} and at least #{@min_bet}"
            else 
                ubet = uinput
                break
            end
        end

        @bet = ubet
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

    #Tells a player they are out
    def display_out
        puts "----- #{@name} busted, final hand count: #{count_hand}"
    end

    #Called if player has not broken, display hand and input hit or pass and return input
    #Returns true if hit, false if pass
    def take_a_hit?

        print_hand
        
        #Show and input hit or pass
        puts "Take a hit or stay? (hit/stay):"
        while user_input = STDIN.gets.chomp
            case user_input
            when "hit", "h"
                return true
            when "stay", "s"
                return false
            else 
                puts "Invalid input. Enter hit/h to hit, or stay/s to stay"
            end
        end
    end
end