require_relative 'deck'
require_relative 'player'
require_relative 'cpu'

class Blackjack
    def initialize(players)
        @players = players
        @deck = Deck.new()
        @game_over = false
        @min_bet = players[0].min_bet
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
    end

    #Deal one card to specified player
    def deal_card(player)
        player.give_card(@deck.draw)
    end

    #Start game loop
    def run_game
        @game_over = false
        @deck.shuffle
        deal_hand

        #Print players in game
        puts "---- Welcome to BlackJack. ----"
        puts "Starting Cash: $#{@players[0].cash} | Table Minimum: $#{@min_bet}"
        puts
        @players.each do |player|
            puts "#{player.name} has joined the game."
        end
        puts "\n"

        #Get player bets after dealing
        @players.each {|player| player.make_bet}

        #Bets are made, take players' money
        @players.each {|player| player.cash -= player.bet} 

        player_ranks = Hash.new()
        players_in = @players.collect{|player| player.name}

        #Take each player's hit or pass
        while !@game_over
            @players.each do |player|
                if player.count_hand <=21 && player.take_a_hit?
                    deal_card(player)
                elsif players_in.include? player.name
                        #Players is out, only display this round 
                        players_in -= [player.name]
                        player.display_out if player.count_hand > 21
                        player_ranks[player.name] = player
                end
            end

            if players_in.length == 0
                @game_over = true
                break
            end
        end

        #Sort players by score
        player_ranks.sort_by{|k, player| player.count_hand} .reverse

        #Print wins, ties, losses
        winners = []
        losers = []
        max_score = 0
        player_ranks.each do |key, player|
            if player.count_hand <= 21 && player.count_hand >= max_score
                max_score = player.count_hand
                winners.push(player)
            else losers.push(player)
            end
        end

        puts
        puts "###########################"
        puts "# ------ GAME OVER ------ #"
        puts "###########################"
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

#Debug
