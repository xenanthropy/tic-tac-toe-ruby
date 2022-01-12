# frozen_string_literal: true

# The Game class which contains the entire game
class Game
  attr_accessor :board, :player1, :player2
  attr_reader :move_spots

  def initialize(board)
    self.board = board
    @move_spots = { 0 => 'a1', 1 => 'b1', 2 => 'c1',
                    3 => 'a2', 4 => 'b2', 5 => 'c2',
                    6 => 'a3', 7 => 'b3', 8 => 'c3' }
  end

  def start
    select_piece
    start_round('player 1', player1)
  end

  # lets player 1 select which piece (X or O) that they want
  def select_piece
    puts "What do you want your piece to be, X or O?\n(input 1 for X, 2 for O)"
    selection = gets.chomp
    while selection != '1' && selection != '2'
      puts 'Please select either 1 or 2'
      selection = gets.chomp
    end
    if selection == '1'
      self.player1 = 'X'
      self.player2 = 'O'
    else
      self.player1 = 'O'
      self.player2 = 'X'
    end
  end

  # Main method of the game. Takes player choice, validates it, then places the piece.
  # Afterwards, checks to see if there is a winner
  def start_round(player, player_piece)
    display_board
    puts "#{player}, select your spot. input column and row\nex: a2, b1, c3, etc."
    selection = gets.chomp
    until valid_move(selection)
      puts 'Please input a valid selection!'
      selection = gets.chomp
    end
    place_piece(player_piece, selection)
    check_for_winner(selection, player_piece)
  end

  # Checks to make sure the selected move is valid (isn't taken already or OOB)
  def valid_move(selection)
    valid_moves = []
    board.each_with_index do |spot, index|
      valid_moves.push(move_spots[index]) if spot == ' '
    end
    if valid_moves.include?(selection)
      true
    else
      false
    end
  end

  def place_piece(player, selection)
    move_spots.each do |key, value|
      board[key] = player if value == selection
    end
  end

  # Checks to see if a player has won, or if the board is tied
  def check_for_winner(selection, player_piece)
    index = 0
    move_spots.each do |key, value|
      index = key if selection == value
    end
    if board[0] == player_piece && board[3] == player_piece && board[6] == player_piece ||
       board[0] == player_piece && board[4] == player_piece && board[8] == player_piece ||
       board[0] == player_piece && board[1] == player_piece && board[2] == player_piece ||
       board[1] == player_piece && board[4] == player_piece && board[7] == player_piece ||
       board[2] == player_piece && board[4] == player_piece && board[6] == player_piece ||
       board[2] == player_piece && board[5] == player_piece && board[8] == player_piece ||
       board[3] == player_piece && board[4] == player_piece && board[5] == player_piece ||
       board[6] == player_piece && board[7] == player_piece && board[8] == player_piece
      display_board
      win_game(player_piece)
    elsif !board.include?(' ')
      win_game('tie')
    else
      start_round('Player 1', player1) if player_piece == player2
      start_round('Player 2', player2) if player_piece == player1
    end
  end

  def win_game(player_piece)
    puts 'Congratulations! Player 1 has won' if player_piece == player1
    puts 'Congratulations! Player 2 has won' if player_piece == player2
    puts "Oh no, it's a tie!" if player_piece == 'tie'
  end

  # displays the current tic-tac-toe board
  def display_board
    puts '   a     b     c'
    puts '      |     |     '
    puts "1  #{board[0]}  |  #{board[1]}  |  #{board[2]}  "
    puts ' _____|_____|_____'
    puts '      |     |     '
    puts "2  #{board[3]}  |  #{board[4]}  |  #{board[5]}  "
    puts ' _____|_____|_____'
    puts '      |     |     '
    puts "3  #{board[6]}  |  #{board[7]}  |  #{board[8]}  "
    puts '      |     |     '
  end
end

# Sets up an empty board
class Board
  attr_reader :board

  def initialize
    @board = [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ']
  end
end

game = Game.new(Board.new.board)
game.start
