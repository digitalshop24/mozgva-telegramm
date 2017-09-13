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

      send_message("Вы можете поиграть в Мозгву в эти даты: \n" + message + "\nЯ могу зарегистрировать Вас на игру. Только мне надо узнать кто вы новичек или бывалый Мозгвич. Для этого выберите одну из команд \n/new_team (Новая команда)\n /existing_team (Существующая команда)")
      user.reset_next_bot_command
    end
  end
end
