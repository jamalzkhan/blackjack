SUITE = [2, 3, 4, 5, 6, 7, 8, 9, 10, "J", "Q", "K", "A"]

class Player
  attr_accessor :cards, :amount , :is_playing, :bet
  
  def initialize(amount, cards, is_dealer, player_number)
    
    @amount = amount
    @cards = cards
    @is_playing = true
    @bet = 0
    @is_dealer = is_dealer
    @player_number = player_number
    
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

  attr_accessor :players
  
  def initialize()
    
    @players =  {}#Array.new # Players
    @num_decks = 4 # Number of card decks
    @cards = Array.new # Universal cards that are held with the dealer
    
    @dealer = Player.new(0, Array.new, true, -1)
    
    init_game()
    game()

  end
  
  def game()
    
    while (true)
      init_round()
      round()
    end
    
  end
    
  
  def round()
    
    @players.each do |k, p|
      puts "## PLAYER #{k} ##"
      while p.is_playing
        
        if p.value() == 21 and p.cards.length() == 2
          puts "Blackjack was acheived"
          p.print_hand
          break
        elsif p.value() > 21
          puts "You lost"
          puts p.print_hand
          break
        end
        
        p.print_hand() 
        print "Please choose from the following {hit, stay, split}"
        decision = gets.chomp
        
        case decision
        
        when "hit"
          p.cards.push(get_card)
          
        when "stand"
          p.is_playing = false

        when "split"
          puts "Not implemented dudu"
          
        end
      end
    end
    
    end_game()
  end
  
  def print_game()
    
    puts "============================="
    puts "|         BLACKJACK          |"
    puts "============================="
    
    puts "DEALER CARD  |#{@dealer.cards[0]}|"
    
    @players.each do |k, p|
       puts "PLAYER #{k}: #{p.cards[0]}, #{p.cards[1]} "
      
    end
    
  end
  
  def end_game()
    
    # Reveal dealers last card
    # Determine who who won and do the debiting
    
  end
  
  def game_loop()
    
    @dealer.cards = [get_card, get_card]
    
    #Give each player 2 initial cards and get their bets
    @players.each do |k, p| 

      p.cards = [get_card, get_card]

      puts "Player #{k}, please enter your bet"
      p.bet = gets.to_i
    end
    
    print_game()
    
    game_loop()
    
  end
  
  def init_game()
    
    # Waiting to enter the number of players
    puts "Please enter the number of players for the game:"
    n = gets.to_i
    
    # Initialize the players (there is atleast one player - sorry hardcoded!)
    for i in 1..n
      @players[i] = Player.new(1000, Array.new, false, i)
    end
    
    # Initializing the card deck
    deck_size = @num_decks * 4
    deck_size.times {@cards += SUITE}
    
  end
  
  # Gets a random card from the deck
  def get_card()
    return @cards.delete_at(rand(@cards.length))
  end
  
end 

b = Blackjack.new()