# Validate list of words that can not be use in specifing field
class BlacklistValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add(attribute, :on_blacklist) if blacklist.include? value
  end

  private

  def blacklist
    File.readlines(Rails.root.join('config', 'blacklist.txt')).map(&:strip)
  end
end