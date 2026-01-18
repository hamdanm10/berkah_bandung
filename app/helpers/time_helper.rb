# frozen_string_literal: true

module TimeHelper
  def format_datetime(time)
    return "-" if time.blank?
    time.strftime("%d/%b/%Y %H:%M:%S")
  end
end
