SUITE = [2, 3, 4, 5, 6, 7, 8, 9, 10, "J", "Q", "K", "A"]

class Player
  attr_accessor :cards, :amount , :is_playing, :bet
  
  def initialize(amount, cards, player_number)
    @amount = amount
    @cards = cards
    @is_playing = true
    @bet = 0
    @player_number = player_number    
  end
  
  def blackjack()
    return (@cards.length == 2 and value() == 21)
  end
    
  def print_hand()
    puts "Hand: #{@cards} Value: #{value()}"
  end
  
  # Gets the value of the hand for the player
  def value()
    sum = 0
    # Partition the array by String and integer then reverse to put aces at back
    @cards.partition{|x| x.is_a? String}.map(&:sort).flatten.reverse_each do |i|
      if ["Q", "J", "K"].include?(i)
        sum += 10
      elsif i == "A"
        if sum + 11 > 21
          sum += 1
        else
          sum += 11
        end
      else 
        sum += i
      end
    end    
    return sum
  end

  def reset()
    @cards = Array.new
    @is_playing = true
    @bet = 0
  end
  
end

class Blackjack 
  
  def initialize()
    
    @players =  {} # Players array
    @num_players = 0
    @num_decks = 4 # Number of card decks
    @cards = Array.new # Universal cards that are held with the dealer
    @dealer = Player.new(0, Array.new, -1) # Dealer
    
    init_game()
    play_game()

  end
  
  def play_game()
    # game will continue until people have run out of money
    while (true)
      init_round()
      round()
    end
  end
  
  def init_round()
    
    # Initializing the card deck
    deck_size = @num_decks * 4
    deck_size.times {@cards += SUITE}
    
    @players.each do |k, p|
      p.reset()
    end
    
    @dealer.cards = [get_card, get_card]
    
    # Check if players are bust
    @players.delete_if{|k, p| p.amount <= 0}
    
    if @players.size == 0
      puts "Game Ended"
      exit()
    end
   
    puts "============================="
    puts "|         NEW ROUND          |"
    puts "============================="
    
    # give each player 2 initial cards and get their bets
    @players.each do |k, p| 

      p.cards = [get_card, get_card]
      
      while (p.bet <=0 or p.bet > p.amount)
        puts "Player #{k}, please enter your bet, a number less than or equal to #{p.amount}"
        p.bet = gets.to_i
      end
      
      
    end
    
    print_game()
    
  end
  
  def round()
    
    @players.each do |k, p|
      puts "## PLAYER #{k} ##"
      while p.is_playing
        
        if p.blackjack()
          puts "Blackjack was acheived!"
          p.print_hand
          break
        elsif p.value == 21
          puts "21 was acheived!"
          p.print_hand
          break
        elsif p.value() > 21
          puts p.print_hand
          puts "You got bust!"
          break
        end
        
        p.print_hand() 
        puts "Please choose from the following {hit, stay, split, double}:"
        decision = gets.chomp
        
        if decision == "hit"
          p.cards.push(get_card)
        elsif decision ==  "stay"
          p.is_playing = false
        elsif decision == "split"
          puts "Not implemented split functionality"
        elsif decision == "double"
          p.cards.push(get_card)
          p.is_playing = false
          p.print_hand
          puts "double was called"
        end
      end
    end
    
    end_round()
  end
  
  def print_game()
    
    puts "============================="
    puts "|         GAME STATE         |"
    puts "============================="
    puts "|        DEALER CARD  |#{@dealer.cards[0]}|    |"
    puts "============================="
        
    @players.each do |k, p|
       puts "|        PLAYER: #{k}   #{p.cards[0]}, #{p.cards[1]}    |"
       puts "============================="
    end
    
  end
  
  def end_round()
    
    puts "We reached the end of the round"
    
    # Reveal dealers last card
    while @dealer.value() < 17
      @dealer.cards.push(get_card)
    end
    puts "The dealer got the following hand:"
    @dealer.print_hand()
    
    dealer_value = @dealer.value()
    
    if dealer_value > 21
      #blackjack case
      puts "The dealer lost."
      @players.each do |k, p|
        if p.blackjack()
          p.amount += (p.bet * 1.5)
          puts "Player #{k} got blackjack and has #{p.amount} left in their account"
        else
          p.amount += p.bet
          puts "Player #{k} won and has #{p.amount} left in their account"
        end
      end
    else
      @players.each do |k, p|
        if p.blackjack()
          p.amount += (p.bet * 1.5)
          puts "Player #{k} got blackjack and has #{p.amount} left in their account"
        elsif p.value() > dealer_value and p.value() <= 21
          p.amount += p.bet
          puts "Player #{k} won and has #{p.amount} left in their account"
        elsif p.value() == dealer_value
          puts "Player #{k} drawn and has #{p.amount} left in their account"
        else
          p.amount -= p.bet
          puts "Player #{k} lost and has #{p.amount} left in their account"
        end
        
      end
    end
    
  end

  def init_game()
    
    puts "============================="
    puts "|         BLACKJACK          |"
    puts "============================="
    
    # Waiting to enter the number of players
    puts "Please enter the number of players for the game:"
    n = 0
    
    while n <= 0
      puts "Enter a number greater than 0"
      n = gets.to_i
    end
    
    # Initialize the players (there is atleast one player - sorry hardcoded!)
    for i in 1...n+1
      @players[i] = Player.new(1000, Array.new, i)
    end
  end
  
  # Gets a random card from the deck
  def get_card()
    return @cards.delete_at(rand(@cards.length))
  end
  
end 

b = Blackjack.new()