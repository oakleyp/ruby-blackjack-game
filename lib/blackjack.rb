require_relative 'deck'
require_relative 'player'
require_relative 'dealer'
require_relative 'cpu'

class Blackjack
    def initialize(players)
        @players = players
        @deck = Deck.new()
        @game_over = false
        @start_cash = players[0].cash
        @min_bet = players[0].min_bet
        @dealer = Dealer.new("Dealer")
    end

    #Deal a new hand of 2 cards to all players
    def deal_hand
        @players.each do |player|
            player.burn_hand
            2.times do
                card = @deck.draw
                player.give_card(card)
            end
        end

        @dealer.burn_hand
        2.times do 
            card = @deck.draw
            @dealer.give_card(card)
        end
    end

    #Deal one card to specified player
    def deal_card(player)
        player.give_card(@deck.draw)
    end

    #Start game loop
    def run_game
        @game_over = false

        #Print players in game
        puts "------------ Welcome to BlackJack. ------------"
        puts " - Starting Cash: $#{@start_cash} | Table Minimum: $#{@min_bet} -"
        puts "-----------------------------------------------"
        puts

        @players.each do |player|
            puts "#{player.name} has joined the game."
        end
        puts 

        #Get player bets before dealing
        @players.each {|player| player.make_bet}

        #Bets are made, take players' money
        @players.each {|player| player.cash -= player.bet} 

        #Shuffle the deck and deal the hand
        @deck = Deck.new()
        @deck.shuffle
        deal_hand

        #Show dealer top card
        @dealer.print_top
        puts "     -----------------------------"
        puts

        #For each player, offer hit or stay until break or stay
        @players.each do |player|
            while player.count_hand <= 21 && player.take_a_hit?
                deal_card(player)
            end
            player.display_out if player.count_hand > 21
        end

        #End of round, show dealer hand and take cards while his hand < 17
        @dealer.print_hand

        while @dealer.take_a_hit? && @dealer.count_hand <= 21
            puts "Dealer draws."
            puts
            deal_card(@dealer)
            @dealer.print_hand
        end
        
        winners = []
        losers = []

        @players.each do |player|
            if player.count_hand <= 21 && player.count_hand > @dealer.count_hand 
                winners.push(player)
            elsif @dealer.count_hand > 21 && player.count_hand <= 21
                winners.push(player)
            else
                losers.push(player)
            end
        end

        puts
        puts "###################################"
        puts "# ---------- GAME OVER ---------- #"
        puts "###################################"
        puts
        puts "---- Winners: ----"
        winners.each do |winner|
            puts "- #{winner.name} won $#{winner.bet} with score #{winner.count_hand}\n"
            winner.cash += winner.bet * 2
            winner.bet = 0
            winner.print_hand
        end

        puts "\n---- Losers: ----"
        losers.each do |loser|
            puts "- #{loser.name} lost $#{loser.bet} with score #{loser.count_hand}\n"
            loser.bet = 0
            loser.print_hand
        end
        puts


        #TODO: Allow for multiple users, allow user to sit in a round w/o reset
        puts "Play the next hand? (y/n)"
        while user_input = STDIN.gets.chomp
            case user_input
            when "yes", "y"
                run_game
            when "no", "n"
                puts "bye"
                exit
            else 
                puts "Invalid input. Please enter either yes(y) or no(n)"
            end

        end

    end


end
