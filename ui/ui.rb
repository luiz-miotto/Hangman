# frozen_string_literal: true
require './models/game_session'
require 'yaml'
class UI

  def initialize
    super
    puts "Welcome to Hangman2"
    puts "Would you like to start a new game or load an existing one? To start a new game, type 'new'. To load an existing game, type 'load'."
    new_or_load
  end

  def new_or_load
    user_input = gets.chomp
    if user_input == "new"
      @game_session = GameSession.new()
      puts "cool. New game it is"
      @game_session.display_session_status
    elsif user_input == "load"
      @game_session - GameSession.new()
      puts "Select a game from below"
      display_saves
      save_name = gets.chomp
      save_name = "./lib/saves/" + save_name + ".json"
      @game_session.load_game(save_name)
      @game_session.display_session_status

    end
    game_state
  end

  def game_state
    while @game_session.get_win_state == false
      turn()
    end
    if @game_session.get_win_state == true
      puts "You won. The word was " + @game_session.get_word + "!"
    end

  end



  def display_saves
    save_files = YAML.load(File.read("./lib/list_of_saves.yaml"))["saves"]
    save_files.each do |e|
      e = e.to_s.split("/")[3]
      puts e = e.split(".json")[0]
    end
  end



  def turn
    puts "What letter would you like to try?"
    user_input = gets.chomp
    puts "user input is " + user_input
    @game_session.is_letter_in_word?(user_input)
    @game_session.display_session_status
  end
end
