# Validate list of words that can not be use in specifing field
class BlacklistedWordsValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    # For when we need to each word check of given value
    words = value.to_s.downcase.split(" ")
    words.map { |word| record.errors.add(attribute, :blacklisted_word) if blacklist.include? word }
  end

  private

  def blacklist
    File.readlines(Rails.root.join('config', 'blacklist', 'blacklisted_words.txt')).map(&:strip)
  end
end