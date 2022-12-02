# Validate 'yahoo.com' can not be use in specifing field
class BlacklistedDomainsValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    blacklist.map { |domain| record.errors.add(attribute, :blacklisted_domain) if value.to_s.downcase.include? domain}
  end

  private
  def blacklist
    File.readlines(Rails.root.join('config', 'blacklist', 'blacklisted_domains.txt')).map(&:strip)
  end
end