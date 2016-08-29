module Beaker
  module DSL
    module Helpers
      module BeakerQaI18n
        require 'stringify-hash'
        require 'beaker-qa-i18n/i18n_string_generator'
        require 'beaker-qa-i18n/version'
        Beaker::TestCase.send(:include, I18nStringGenerator)
      end
    end
  end
end
Beaker::DSL.register(Beaker::DSL::Helpers::BeakerQaI18n)
