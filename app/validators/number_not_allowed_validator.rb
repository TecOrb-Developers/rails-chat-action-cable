# Validate 'yahoo.com' can not be use in specifing field
class NumberNotAllowedValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
  	if !value.scan(/\d/).empty?
      record.errors.add(attribute, :on_number_detected)
    end
  end
end