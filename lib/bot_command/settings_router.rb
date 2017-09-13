module BotCommand
  class SettingsRouter < Base
    def should_start?
      %w(Имя Секретный\ код Название\ команды Телефон).include?(text)
    end

    def start
      case text
      when "Имя"
        question = "Текущее имя: #{user.nickname || (user.first_name.to_s + " " + user.last_name.to_s) }\nХочешь изменить его?"
        send_keyboard(%w(Да Нет Отменить), question)
        user.set_next_bot_command('BotCommand::ChangeName')
      when "Секретный код"
        question = "Текущий секретный код: #{user.secret}\nХочешь изменить его?"
        send_keyboard(%w(Да Нет Отменить), question)
        user.set_next_bot_command('BotCommand::ChangeSecret')
      when "Название команды"
        question = "Текущее название команды: #{user.team_name}\nХочешь изменить его?"
        send_keyboard(%w(Да Нет Отменить), question)
        user.set_next_bot_command('BotCommand::ChangeTeamName')
      when "Телефон"
        question = "Текущий номер: #{user.phone_number}\nХочешь изменить его?"
        send_keyboard(%w(Да Нет Отменить), question)
        user.set_next_bot_command('BotCommand::ChangePhone')
      end
    end

    def undefined
      question = "Я понимаю только\nИмя, Секретный код, Название команды, Телефон"
      send_keyboard("Отменить", question)
    end
  end
end
