# -*- encoding : utf-8 -*-
require "time"

module TimeHelper
  def self.datestamp_to_js(datestamp)
    DateTime.strptime(datestamp.to_s, "%Y%m%d").to_time.to_i * 1000
  end

  def self.datestamp_to_string(datestamp)
    date = datestamp.to_i
    format("%04d-%02d-%02d", date / 10000, (date % 10000) / 100, date % 100)
  end
end
