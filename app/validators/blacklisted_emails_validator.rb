# Validate list of words that can not be use in specifing field
class BlacklistedEmailsValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add(attribute, :blacklisted_email) if blacklist.include? value.to_s.downcase
  end

  private

  def blacklist
    File.readlines(Rails.root.join('config', 'blacklist', 'blacklisted_emails.txt')).map(&:strip)
  end
end