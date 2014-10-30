# blackjack.rb

def total(cards)
  arr = cards.map { |e| e[0] }

  tot = 0
  arr.each do|val|
    if val == 'A'
      tot += 11
    elsif val.to_i == 1
      tot += 10
    elsif val.to_i == 0
      tot += 10
    else
      tot += val.to_i
    end
  end

  arr.select { |e| e == 'A' }.count.times do
    tot -= 10 if tot > 21
  end

  tot
end

# Start Game

puts "\nWelcome to the Blackjack console game!"
puts "\nPlease enter your name."
puts
player = gets.chomp.capitalize
puts "\nHi, #{player}! Let's play Blackjack!"

# Set up deck

suits = %w(♥_Hearts ♠_Spades ♦_Diamonds ♣_Clubs)
ranks = %w(2 3 4 5 6 7 8 9 10 Jack Queen King Ace)

deck = []

suits.each do |suit|
  ranks.each do |rank|
    deck << "#{rank} of #{suit}"
  end
end

# Multiply number of decks in play

deck *= rand(2..5)
deck.shuffle!

puts "\nWe're playing with #{decks} decks today."

# Deal cards

player_cards = []
dealer_cards = []

player_cards << deck.pop
dealer_cards << deck.pop
player_cards << deck.pop
dealer_cards << deck.pop

player_tot = total(player_cards)
dealer_tot = total(dealer_cards)

# Reveal cards

# Reveal dealer's second card under the following circumstance

if dealer_tot == 21
  puts "\nThe dealer has the #{dealer_cards[0]}" \
       " and the #{dealer_cards[1]} worth #{dealer_tot} points."
  puts "\nSorry, #{player}. The dealer hit Blackjack. Better luck next time."
  exit
elsif dealer_tot == 21 && player_tot == 21
  puts "\nThe dealer has the #{dealer_cards[0]}" \
       " and the #{dealer_cards[1]} worth #{dealer_tot} points."
  puts "\nYou have the #{player_cards[0]}" \
       " and the #{player_cards[1]} worth #{player_tot} points."
  puts "\nYou and the dealer both got Blackjack. You tied."
  exit
else

# Otherwise, hide dealer's second card

puts "\nThe dealer has the #{dealer_cards[1]} and a face-down card."
puts "\nYou have the #{player_cards[0]}" \
     " and the #{player_cards[1]} worth #{player_tot} points."
end

# Player's turn

if player_tot == 21
  puts "\nYou hit Blackjack! You won, #{player}! Congratulations!"
  exit
end

while player_tot < 21
  puts "\nDo you want to [h]it or [s]tay, #{player}?" \
       " (Please enter 'h' or 's'.)"
  puts
  player_turn = gets.chomp.downcase

  unless %w(h s).include?(player_turn)
    puts "\nError. Invalid entry. Please enter either 'h' or 's'."
    next # skips to next iteration in loop
  end

  if response == 's'
    puts "\nYou have #{player.total} points."
    puts "\nYou chose to stay."
    break
  end

  puts "\nYou chose to hit."
  new_card = deck.pop
  puts "\nYou were dealt the #{new_card}."
  player_cards << new_card
  player_tot = total(player_cards)
  puts "\nYou have #{player_tot} points."

  if player_tot == 21
    puts "\nBlackjack! You won, #{player}! Congratulations!"
    exit
  elsif player_tot > 21
    puts "\nSorry, #{player}. You busted. Better luck next time."
    exit
  end
end

# Dealer's turn

puts "\nThe dealer has the #{dealer.cards[1]}."
puts "\nThe dealer reveals the #{dealer.cards[0]} as her second card."
puts "\nThe dealer has #{dealer.total} points."

while dealer_tot < 17
  new_card = deck.pop
  puts "\nThe dealer drew the #{new_card}."
  dealer_cards << new_card
  dealer_tot = total(dealer_cards)
  puts "\nThe dealer has #{dealer_tot} points."
  if dealer_tot == 21
    puts "\nSorry, #{player}. The dealer hit Blackjack." \
         ' Better luck next time.'
    exit
  elsif dealer_tot > 21
    puts "\nThe dealer busted. Congratulations, #{player}! You won."
    exit
  end
end

puts "\nThe dealer stays."

# Comparing the players cards and the dealers cards

puts "\nThe dealers cards are:"
puts
puts dealer_cards

puts "\nYou cards are:"
puts
puts player_cards

if dealer_tot > player_tot
  puts "\nThe dealer has #{dealer_tot} total points" \
       " and you have #{player_tot} points."
  puts "\nSorry, #{player}. You lose. Better luck next time."
elsif dealer_tot < player_tot
  puts "\nThe dealer has #{dealer_tot} total points" \
       " and you have #{player_tot} points."
  puts "\nCongratulations #{player}! You won!"
else
  puts "\nThe dealer has #{dealer_tot} total points" \
       " and you have #{player_tot} points."
  puts "\nYou tied with the dealer."
end
