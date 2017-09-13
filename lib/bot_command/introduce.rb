module BotCommand
 class Introduce < Base
  def should_start?
    %w(Да Нет).include?(text)
  end

  def start
    if text == "Да"
      remove_keyboard("Приятно познакомиться!\nЧто бы продолжить нажмите /help")
      user.reset_next_bot_command
    else
      question = "Как тебя зовут?"
      send_keyboard("Отменить", question)
      user.set_next_bot_command('BotCommand::Nickname')
    end
  end

  def undefined
    question = "Я понимаю только Да или Нет"
    send_keyboard(%w(Да Нет Отменить), question)
  end
end
end
