# beaker qa-i18n helper

Methods to assist in i18n testing

# Examples

   Example: iterates through array of strings of length 10, testing all special characters according to the block
   ```
   test_i18n_strings(10) { |test_string|
     # Enter data
     create_user("User#{test_string})
     # Validate data
     verify_user_name_exists("User#{test_string}")
   }
   ```


