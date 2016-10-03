module Beaker
  module DSL
    module Helpers
      module BeakerQaI18n
        module I18nStringGenerator
          CHINESE_CHARACTERS =[*"\u4E00".."\u4E20"]
          GERMAN_CHARACTERS  =["\u00C4", "\u00E4", "\u00D6", "\u00F6", "\u00DC", "\u00FC"]
          ENGLISH_CHARACTERS =[*"\u0041".."\u007A"]
          NUMERIC_CHARACTERS =[*"\u0030".."\u0039"]


          WHITE_SPACE_CHARACTERS=[" ", *"\u2002".."\u200B"]
          MAX_LENGTH_CHARACTERS =["\u00DF"]
          SYNTAX_CHARACTERS     =['&', '+', '/', '\\', '"', "'", '(', ')', '?', '.', '#', '@', '_', '-', '~']

          # Gets a random number generator with optional seed
          # @param [Int] seed - Random seed for re-playing random value.
          # @return [Object] - an instance of the Random class
          def get_rng(seed = nil)
            seed ||= Random.new_seed
            logger.debug "random seed used: #{seed}"
            Random.new(seed)
          end

          # Gets a string consisting of all values in this library for the specified character type
          # @param [Symbol] character_type - :chinese, :german, :english, :numeric, :max_length, :white_space, :syntax
          # @return [String] - a string containing all of the characters from the character type
          def get_i18n_string(character_type)
            array = instance_eval("#{character_type.to_s.upcase}_CHARACTERS")
            get_strings_of_length_from_char_array(array, nil)[0]
          end

          # produces a random multiple language string including Chinese, German and English characters
          # @param [Int] length - Length of string desired
          # @param [Int] seed - Random seed for re-playing random value.
          # @return [String] - The random string
          def random_multi_lang(length, seed=nil)
            random_characters([CHINESE_CHARACTERS, ENGLISH_CHARACTERS, GERMAN_CHARACTERS], length, seed)
          end

          # produces a random multiple language sentence including Chinese, German and English characters
          # @param [Int] length - Length of string desired
          # @param [Int] seed - Random seed for re-playing random value.
          # @return [String] - The random string
          def random_multi_lang_sentence(length, seed = nil)
            raise('length of sentence must be at least 2') unless length > 1
            chars = random_characters([CHINESE_CHARACTERS, ENGLISH_CHARACTERS, GERMAN_CHARACTERS], length, seed)
            index = 0
            while index + 13 < length
              index = index + (1..12).to_a.sample(1)[0]
              chars.insert(index, ' ')
            end
            chars[0..(length-2)] + '.'
          end

          def get_test_string(len = 5)
            CHINESE_CHARACTERS[0...len] + ENGLISH_CHARACTERS[0...len] + GERMAN_CHARACTERS[0...len] + SYNTAX_CHARACTERS[0...len]
          end

          # produces a random Chinese language string
          # The Chinese, Japanese and Korean (CJK) scripts share a common background, collectively known as CJK characters
          # @param [Int] length - Length of string desired
          # @param [Int] seed - Random seed for re-playing random value.
          # @return [String] - The random string
          def random_chinese_characters(length, seed = nil)
            random_characters(CHINESE_CHARACTERS, length, seed)
          end

          # produces a random English language string
          # @param [Int] length - Length of string desired
          # @param [Int] seed - Random seed for re-playing random value.
          # @return [String] - The random string
          def random_english(length, seed = nil)
            random_characters(ENGLISH_CHARACTERS, length, seed)
          end

          # produces a random English language sentence
          # @param [Int] length - Length of string desired
          # @param [Int] seed - Random seed for re-playing random value.
          # @return [String] - The random string
          def random_english_sentence(length, seed = nil)
            raise('length of sentence must be at least 2') unless length > 1
            chars = random_characters(ENGLISH_CHARACTERS, length, seed)
            index = 0
            while index + 13 < length
              index = index + (1..12).to_a.sample(1)
              chars.insert(index, ' ')
            end
            chars[0..(length-1)] + '.'
          end

          # produces a random English alpha-numeric string
          # @param [Int] length - Length of string desired
          # @param [Int] seed - Random seed for re-playing random value.
          # @return [String] - The random string
          def random_alpha_numeric(length, seed = nil)
            random_characters([ENGLISH_CHARACTERS, NUMERIC_CHARACTERS], length, seed)
          end

          # produces a random German string
          # @param [Int] length - Length of string desired
          # @param [Int] seed - Random seed for re-playing random value.
          # @return [String] - The random string
          def random_german(length, seed = nil)
            random_characters(GERMAN_CHARACTERS, length, seed)
          end

          # Generate random strings from various utf8 character ranges. Can repeat characters.
          # @param [Array<Array<Char>>] utf8_ranges - an array of an array of character ranges
          # @param [Int] length - Length of string desired
          # @param [Int] seed - Random seed for re-playing random value.
          # @return [String] - The random string
          def random_characters(utf8_ranges, length, seed = nil)
            (length.times.map { utf8_ranges.flatten }).flatten # flatten the arrays to a single array, then duplicate the array length
                .sample(length, random: get_rng(seed)).join("") # Sample the resultant array with a seeded random number generator
          end

          # Creates an array of strings of a certain length, then iterates through them passing each string
          # to a block for testing. You can optionally exclude syntax and white space chararcters if the
          # input being tested does not allow them.
          # Example: iterates through array of strings of length 10, testing all special characters according to the block
          # test_i18n_strings(10) { |test_string|
          #   # Enter data
          #   create_user("User#{test_string})
          #   # Validate data
          #   verify_user_name_exists("User#{test_string}")
          # }
          #
          # @param [Int] string_length - The length of the string you want to test with
          # @param [Array<Symbol>] exclude - String types to exclude from testing :syntax or :white_space
          def test_i18n_strings(string_length, exclude=[], &block)
            raise("test_i18n_strings requires a block with arity of 1") unless block_given? && block.arity == 1

            logger.debug('Testing Chinese characters')
            get_strings_of_length_from_char_array(CHINESE_CHARACTERS, string_length).each { |string|
              yield string
            }
            logger.debug 'Testing German characters'
            get_strings_of_length_from_char_array(GERMAN_CHARACTERS, string_length).each { |string|
              yield string
            }
            logger.debug 'Testing max length characters'
            get_strings_of_length_from_char_array(MAX_LENGTH_CHARACTERS, string_length).each { |string|
              yield string
            }
            logger.debug 'Testing syntax characters' unless exclude.include?(:syntax)
            get_strings_of_length_from_char_array(SYNTAX_CHARACTERS, string_length).each { |string|
              yield string
            } unless exclude.include?(:syntax)
            logger.debug 'Testing white space characters' unless exclude.include?(:white_space)
            get_strings_of_length_from_char_array(WHITE_SPACE_CHARACTERS, string_length).each { |string|
              yield string
            } unless exclude.include?(:white_space)
          end


          def get_strings_of_length_from_char_array(array, string_length)
            string_length ||= array.length
            strings = []
            if (array.length == string_length)
              strings.push(array.join('').encode('UTF-8'))
            elsif (array.length < string_length)
              my_string = array.join('').encode!('UTF-8')
              while (my_string.length < string_length)
                my_string = (my_string + array.join('')).encode('UTF-8')
              end
              strings.push(my_string[0...string_length].encode('UTF-8'))
            else
              my_string = array.join('')
              while (my_string.length > string_length)
                strings.push(my_string.slice!(0...string_length).encode('UTF-8'))
              end
              # For the final characters, add the first characters from the array to equal the expected string length
              strings.push(my_string + array[0...(string_length - my_string.length)].join('').encode('UTF-8'))
            end
          end

          private :get_strings_of_length_from_char_array
        end
      end
    end
  end
end

