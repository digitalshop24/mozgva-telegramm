module BotCommand
  class ChangeSecret < Base
    def should_start?
      %w(Да Нет).include?(text)
    end

    def start
      case text
      when "Да"
        question = "Введи код"
        send_keyboard("Отменить", question)
        user.set_next_bot_command('BotCommand::AddSecret')
      when "Нет"
        question = "Персональные настройки. Выберите что вы хотите просмотреть/изменить"
        send_keyboard(%w(Имя Секретный\ код Название\ команды Телефон Отменить), question)
        user.set_next_bot_command('BotCommand::SettingsRouter')
      end
    end

    def undefined
      question = "Я понимаю только Да или Нет"
      send_keyboard(%w(Да Нет Отменить), question)
    end
  end
end
