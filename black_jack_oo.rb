# black_jack_oo.rb

class Card
  attr_accessor :suit, :rank

  def initialize(s, r)
    @suit = s
    @rank = r
  end

  def readable_cards
    "#{rank} of #{suit}"
  end

  def to_s
    readable_cards
  end
end

class Deck
  attr_accessor :cards

  def initialize
    @cards = []
    %w(♥_Hearts ♠_Spades ♦_Diamonds ♣_Clubs).each do |suit|
      %w(2 3 4 5 6 7 8 9 10 Jack Queen King Ace).each do |rank|
        @cards << Card.new(suit, rank)
      end
    end
    multiply_deck
    shuffle
  end

  def multiply_deck
    @cards *= rand(2..6)
  end

  def shoe_size
    @cards.size / 52
  end

  def shuffle
    cards.shuffle!
  end

  def deal
    cards.pop
  end
end

module Hand
  def total
    card_values = cards.map { |card| card.rank }
    total = 0
    card_values.each do|r|
      if r == 'A'
        total += 11
      elsif r.to_i == 1
        total += 10
      elsif r.to_i == 0
        total += 10
      else
        total += r.to_i
      end
    end

    card_values.select { |e| e == 'A' }.count.times do
      total -= 10 if total > Blackjack::BLACKJACK
    end

    total
  end

  def add_card(new_card)
    cards << new_card
  end

  def busted?
    total > Blackjack::BLACKJACK
  end
end

class Player
  include Hand

  attr_accessor :name, :cards

  def initialize(name)
    @name = name
    @cards = []
  end

  def reveal_hand
    puts "\nYou have the #{cards[0]} and the #{cards[1]} worth #{total} points."
  end
end

class Dealer
  include Hand

  attr_accessor :cards

  def initialize
    @cards = []
  end

  def reveal_hand
    puts "\nThe dealer has the #{cards[1]} and a face-down card."
  end
end

class Blackjack
  attr_accessor :deck, :player, :dealer

  BLACKJACK = 21
  DEALER_MIN = 17

  def initialize
    @deck = Deck.new
    @player = Player.new("Player_1")
    @dealer = Dealer.new
  end

  def player_name
    puts "\nPlease enter your name."
    puts
    player.name = gets.chomp.capitalize
    puts "\nHi, #{player.name}! Let's play Blackjack!"
  end

  def deal_cards
    player.add_card(deck.deal)
    dealer.add_card(deck.deal)
    player.add_card(deck.deal)
    dealer.add_card(deck.deal)
  end

  def dealer_check
    # - Game ends immediately if dealer deals herself Blackjack

    if dealer.total == BLACKJACK
      puts "\nThe dealer has the #{dealer.cards[0]}" \
           " and the #{dealer.cards[1]} worth #{dealer.total} points."
      puts "\nSorry, #{player.name}. The dealer hit Blackjack." \
           ' Better luck next time.'
      replay?

    # - Game ends immediately if dealer deals herself AND the player Blackjack

    elsif dealer.total == BLACKJACK && player.total == BLACKJACK
      puts "\nThe dealer has the #{dealer.cards[0]}" \
           " and the #{dealer.cards[1]} worth #{dealer.total} points."
      puts "\nYou have the #{player.cards[0]}" \
           " and the #{player.cards[1]} worth #{player.total} points."
      puts "\nYou and the dealer both hit Blackjack. You tied."
      replay?
    end
  end

  def reveal_hands
    player.reveal_hand
    dealer.reveal_hand
  end

  def player_turn
    if player.total == BLACKJACK
      puts "\nYou hit Blackjack! You won, #{player.name}! Congratulations!"
      replay?
    end

    while !player.busted?
      puts "\nDo you want to [h]it or [s]tay, #{player.name}?" \
           " (Please enter 'h' or 's'.)"
      puts
      response = gets.chomp.downcase

      unless %w(h s).include?(response)
        puts "\nError. Invalid entry. Please enter either 'h' or 's'."
        next
      end

      if response == 's'
        puts "\nYou have #{player.total} points."
        puts "\nYou chose to stay."
        break
      end

      puts "\nYou chose to hit."
      new_card = deck.deal
      puts "\nYou were dealt the #{new_card}."
      player.add_card(new_card)
      puts "\nYou have #{player.total} points."

      if player.total == BLACKJACK
        puts "\nBlackjack! You won, #{player.name}! Congratulations!"
        replay?
      elsif player.busted?
        puts "\nSorry, #{player.name}. You busted. Better luck next time."
        replay?
      end
    end
  end

  def dealer_turn
    puts "\nThe dealer has the #{dealer.cards[1]}."
    puts "\nThe dealer reveals the #{dealer.cards[0]} as her second card."
    puts "\nThe dealer has #{dealer.total} points."

    while dealer.total < DEALER_MIN
      new_card = deck.deal
      puts "\nThe dealer drew the #{new_card}."
      dealer.add_card(new_card)
      puts "\nThe dealer has #{dealer.total} points."
      if dealer.total == BLACKJACK
        puts "\nSorry, #{player.name}. The dealer hit Blackjack." \
             ' Better luck next time.'
        replay?
      elsif dealer.busted?
        puts "\nThe dealer busted. Congratulations, #{player.name}! You won."
        replay?
      end
    end
    puts "\nThe dealer stays."
  end

  def winner?
    if dealer.total > player.total
      puts "\nThe dealer has #{dealer.total} points" \
           " and you have #{player.total} points."
      puts "\nSorry, #{player.name}. You lose. Better luck next time."
    elsif dealer.total < player.total
      puts "\nThe dealer has #{dealer.total} total points" \
           " and you have #{player.total} points."
      puts "\nCongratulations #{player.name}! You won!"
    else
      puts "\nThe dealer has #{dealer.total} total points" \
           " and you have #{player.total} points."
      puts "\nYou tied with the dealer."
    end
    replay?
  end

  def replay?
    response = ""
    while response != "y"
      puts "\nWould you like to play again, #{player.name}?" \
           " (Please enter 'y' or 'n'.)"
      puts
      response = gets.chomp.downcase

      unless %w(y n).include?(response)
        puts "\nError. Invalid entry. Please enter either 'y' or 'n'."
        next
      end

      if response == "y"
        puts "\nLoading new game..."
        sleep(3)
        deck = Deck.new
        player.cards = []
        dealer.cards = []
        run
      else
        puts "\nThanks for playing, #{player.name}. See you next time!"
        exit
      end
    end
  end

  def run
    system "clear"
    puts "\nWelcome to the Blackjack console game!"
    puts "\nWe're playing with #{deck.shoe_size} decks."
    player_name
    deal_cards
    dealer_check
    reveal_hands
    player_turn
    dealer_turn
    winner?
  end
end

game = Blackjack.new
game.run
