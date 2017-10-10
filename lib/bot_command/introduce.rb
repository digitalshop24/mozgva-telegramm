module BotCommand
 class Introduce < Base
  def should_start?
    %w(Да Нет).include?(text)
  end

  def start
    if text == "Да"
      remove_keyboard(I18n.t('intoduce_greeting'))
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
