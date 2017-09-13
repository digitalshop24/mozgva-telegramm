module BotCommand
  class ChangeName < Base
    def should_start?
     %w(Да Нет).include?(text)
   end

   def start
    if text == "Да"
      question = "Введи свое имя"
      send_keyboard("Отменить", question)
      user.set_next_bot_command('BotCommand::Nickname')
    else
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
