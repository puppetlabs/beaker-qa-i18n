class ClassMixedWithDSLHelpers
  include Beaker::DSL::Helpers::BeakerQaI18n::I18nStringGenerator

  def logger
    RSpec::Mocks::Double.new('logger').as_null_object
  end
end

describe ClassMixedWithDSLHelpers do
  subject { ClassMixedWithDSLHelpers.new }

  describe '.test_i18n_strings' do

    it 'should execute code in block for each string' do
      (1..30).to_a.each { |str_length|
        subject.test_i18n_strings(str_length) { |int_string|
          puts "'#{int_string}'"
          expect(int_string.length).to eq(str_length)
        }
      }
    end
  end
  describe '.random_multi_lang' do
    it 'should return the correct number characters for random multi' do
      (1..30).to_a.each { |str_length|
        int_string = subject.random_multi_lang(str_length)
        puts "'#{int_string}'"
        expect(int_string.length).to eq(str_length)
      }
    end

    it 'should return expected string if seed is used' do
      int_string = subject.random_multi_lang(30, 90856893022021252569391894093740379386)
      puts "'#{int_string}'"
      expect(int_string).to eq('mNPEhDBOE\YF三Ce丒PE业E丁s且E_^丟ZeÄ')
    end
  end

  describe '.random_multi_lang_sentence' do
    it 'should return the correct number of characters for random multi sentence' do
      (2..30).to_a.each { |str_length|
        int_string = subject.random_multi_lang_sentence(str_length)
        puts "'#{int_string}'"
        expect(int_string.length).to eq(str_length)
      }
    end
  end
end
