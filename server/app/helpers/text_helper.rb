module TextHelper
  def self.valid_json?(value)
    return false unless TextHelper.is_string?(value)
    begin
      return JSON.parse(value, symbolize_names: true)
    rescue JSON::ParserError
      return false
    end
  end

  def self.is_string?(value)
    return value.class == String
  end

  def self.rand_time(from = 0.0, to = Time.now)
    DateTime.parse(Time.at(from + rand * (to.to_f - from.to_f)).to_s)
  end

  def self.string_for_sql(str)
    return str if str.blank?
    str.gsub("'", "''")
  end

  # `crossmatch?` - Is there a string-match between the two strings?
  def self.crossmatch?(s1, s2)
    (s1 =~ /#{Regexp.escape(s2)}/i) != nil || (s2 =~ /#{Regexp.escape(s1)}/i) != nil
  end
end
