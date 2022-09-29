# Validate 'yahoo.com' can not be use in specifing field
class NoYahooEmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
  	if value.include? "yahoo.com"
      record.errors.add(attribute, :on_yahoo_email)
    end
  end
end