# frozen_string_literal: true
require 'json'
require 'yaml'
class GameSession

  def initialize
    super
    @win_state = false
    @user_word_array = []
    @letters_guessed = []
    @attempts_left = 7
    @session_id = 0
    generate_word
    make_words_to_array
  end

  def get_win_state
    @win_state
  end

  def get_word
    @word
  end
  def get_attempts_left
    @attempts_left
  end

  def get_letters_guessed
    @letters_guessed
  end

  def get_session_id
    @session_id
  end

  def get_user_word_array
    @user_word_array
  end



  def set_word(word)
    @word = word
  end

  def reduce_attempts_left
    @attempts_left = @attempts_left-1
  end

  def add_letter(letter)
    @letters_guessed.push(letter)
  end

  def load_game(save_name)
    file = File.read(save_name)
    data_hash = JSON.parse(file)
    @word = data_hash["word"]
    @letters_guessed = data_hash["letters_guessed"]
    @attempts_left = data_hash["attempts_left"]
    @session_id = data_hash["session_id"]
  end

  def save_game(save_name)
    file_name ="./lib/saves/" + save_name + ".json"
    if !File.file?(file_name)
      new_file = File.new(file_name,"w")
      saves_list = YAML.load(File.read("./lib/list_of_saves.yaml"))
      saves_list["saves"] = saves_list["saves"].push(file_name)
      File.open("./lib/list_of_saves.yaml","w"){|f|f.write(saves_list.to_yaml)}
    end

    data_hash = {}
    data_hash["word"] = @word
    data_hash["letters_guessed"] = @letters_guessed
    data_hash["attempts_left"] = @attempts_left
    data_hash["session_id"] = @session_id

    File.open(file_name,"w"){|f|f.write(data_hash.to_json)}
  end

  def process_letter(letter)
    successful_letter = ""
    successful_letter_index = 0
    goal_word_array = @word.chars
    goal_word_array.each_with_index do |e,index |

    end
  end
  def hangman_list

  end

  def generate_word
    random = Random.new
    num = random.rand(9893)
    words = []
    file = File.open("./lib/dictionary.txt","r").each do |row|
      words.push(row)
    end
    @word = words[num]
  end

  def make_words_to_array

    i = 1
    while i < @word.length
      @user_word_array.push("-")
      i = i + 1
    end
  end

  def is_letter_in_word?(letter)
    if @word.chars.include?(letter)
      letter_in_word(letter)
    else
      @attempts_left = @attempts_left - 1
      @letters_guessed.push(letter).uniq!
      puts "The letter '#{letter}' is not found in the word."
    end
  end

  def letter_in_word(letter)
    letter_hash = {}
    letters = @word.chars
    letters.each_with_index do |e, i|
      if e == letter
        puts "letter is " + e
        puts "index is " + i.to_s
        @user_word_array[i] = e
        @letters_guessed.push(letter).uniq!
      end
    end
    if !@user_word_array.include?("-")
      @win_state = true
    end
  end

  def display_session_status
    if @attempts_left > 0
      puts "Attempts left: " + get_attempts_left.to_s
      puts "Letters guessed: " + get_letters_guessed.to_s
      #puts "User word is : " + get_word
      puts "The user's current progress: " + get_user_word_array.to_s
    else
      puts "You have no guess attempts left.\rGAME OVER"
      puts "Correct word was " + @word
      @win_state = nil
    end
  end
end
