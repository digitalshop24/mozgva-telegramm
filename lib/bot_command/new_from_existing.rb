module BotCommand
  class NewFromExisting < Base
    def should_start?
      ["Написать название еще раз", "Зарегистрироваться как новая команда"].include?(text)
    end

    def start
      if text == "Написать название еще раз"
        send_keyboard("Отменить", "Как называется Ваша команда? Напишите, пожалуйста, название в точь точь как на сайте mozgva.com")
        user.set_next_bot_command('BotCommand::TeamChecker')
      elsif text == "Зарегистрироваться как новая команда"
        url = URI.parse("#{@mozgva_url}/api/v1/games/schedule?id=#{@id}")
        schedule = JSON.parse(Net::HTTP.get(url))
        msg = []
        schedule.each do |key, value|
          value.each do |time|
            msg << key
          end
        end
        msg << "Отменить"
        question = "На какую дату вы хотите зарегистрироваться?"
        send_keyboard(msg, question)
        user.set_next_bot_command('BotCommand::NewTeamDate')

      end
    end

    def undefined
      send_message("Пожалуйста, выберите из списка снизу")
    end
  end
end
