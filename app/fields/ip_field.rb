require "administrate/field/base"

class IpField < Administrate::Field::Base
  def url
    "https://www.projecthoneypot.org/search_ip.php?ip=#{to_s}"
  end

  def to_s
    data
  end
end
