# Validate list of words that can not be use in specifing field
class BlacklistedWordsValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add(attribute, :blacklisted_email) if blacklist.include? value.to_s.downcase
  end

  private

  def blacklist
    File.readlines(Rails.root.join('config', 'blacklist', 'blacklisted_words.txt')).map(&:strip)
  end
end