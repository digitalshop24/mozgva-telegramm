module BotCommand
  class Schedule < Base

    def should_start?
      text =~ /\A\/schedule/
    end

    def start
      url = URI.parse("#{@mozgva_url}/api/v1/games/schedule?id=#{@id}")
      schedule = JSON.parse(Net::HTTP.get(url))
      message = ""
      schedule.each do |key, value|
        value.each do |time|
          message += key + " (" + time.first + " Минкульт)" + "\n"
        end
      end

      send_message(I18n.t('schedule', message: message))
      user.reset_next_bot_command
    end
  end
end
