class UserDecorator < Draper::Decorator
  delegate_all
  # rails generate decorator User

  def full_name
    if fname.blank? && lname.blank?
      'New User'
    else
      "#{fname} #{lname}".strip
    end
  end

  def joined_at
    created_at.strftime("%B %Y")
  end

  def contact_number
    "#{country_code} #{mobile_number}".strip
  end

end
