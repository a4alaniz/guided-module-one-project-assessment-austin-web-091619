class CommandLineInterface
    attr_accessor :player
    def new_game
        # returns user input
        puts "Pokemon Sumo"
        puts "Welcome to the amazing world of Pokemon competing by weight"
        puts "Enter 1 for a New Game or 2 to continue:"
        valid_array = ["1", "2"]
        user_input(valid_array)
    end
    def new_user
        puts "What's your name, trainer?"
        username = user_text_input
        @player = User.create(name: username)
    end

    def bad_input
        puts "Invalid input"
    end
    def quit
        # should exit the program
        
    end
    def user_text_input
        # a method to get text from the user
        # used for name
        gets.chomp
    end
    def user_input(valid_array)
        valid_array <<"quit"
        valid_array <<"exit"
        available = "Your options are: "
        valid_array.each {|str| available += str + " - "}
        command = gets.chomp
        while !valid_array.include?(command)
            puts available
            command = gets.chomp
        end
        if command == "quit" || command == "exit"
            quit
        end
        command.to_i
    end
 
    def select_difficulty
        puts "Select your difficulty level #{self.player.name}"
        puts "Enter 1 for easy, 2 for moderate, or 3 for difficult:"
        valid_array = ["1","2","3"]
        user_input(valid_array)
    end
    def returning_user
        # will have to set @user so that the program knows the current user
        puts "Welcome back! What was your user name?"
        username = user_text_input
        while !User.find_by(name: username)
            puts "User name not found, enter another user name"
            username = user_text_input
        end
        @player = User.find_by(name: username)
    end

    def first_pokemon(difficulty)
        if difficulty == 1
            Pokemon.create(name: Faker::Games::Pokemon.name, weight: Faker::Number.between(from:30, to:40) )
        elsif difficulty == 2
            Pokemon.create(name: Faker::Games::Pokemon.name, weight: Faker::Number.between(from:20, to:30) )
        elsif difficulty == 3
            Pokemon.create(name: Faker::Games::Pokemon.name, weight: Faker::Number.between(from:10, to:20) )
        end
    end

    def pokemon_ownership(pokemon)
        UserPokemon.create(user_id: self.player.id, pokemon_id: pokemon.id)
    end
    def main_menu
        puts "Welcome #{self.player.name}"
        puts "You can:"
        puts "1 -- Battle the next boss"
        puts "2 -- Train against a pokemon"
        puts "3 -- View your pokemon"
        puts "4 -- Restart your game"
        valid_array=["1", "2","3","4"]
        user_input(valid_array)
    end
    def weight_category(pokemon)
        if pokemon.weight < 10
            return "tiny"
        elsif  pokemon.weight <20
            return "small"
        elsif pokemon.weight <30
            return "normal"
        elsif pokemon.weight <40
            return "large"
        elsif pokemon.weight <50
            return "huge"
        end
    end
    def view_pokemon
        pokemons = self.player.pokemons
        puts "You own the following pokemon:"
        pokemons.each do |pokemon|
            puts "A #{weight_category(pokemon)} #{pokemon.name} that weighs #{pokemon.weight}"
        end
    end

    def run
        input = new_game
        if input == 1
            new_user
            d = select_difficulty
            p = first_pokemon(d)
            pokemon_ownership(p)
            puts "Congratulations, #{self.player.name}, you've got a new #{p.name} that weighs #{p.weight} pounds."
        elsif input == 2
            returning_user
        end
        input = main_menu
        case input
        when 3
            view_pokemon
        end
    end
end
