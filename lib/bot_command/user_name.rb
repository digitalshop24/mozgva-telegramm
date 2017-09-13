module BotCommand
 class UserName < Base
  def should_start?
    text =~ /\A\/change_username/
  end

  def start
    question = "Текущее имя: #{user.nickname || (user.first_name.to_s + " " + user.last_name.to_s) }\nХочешь изменить его?"
    send_keyboard(%w(Да Нет Отменить), question)
    user.set_next_bot_command('BotCommand::ChangeName')
  end
end
end
