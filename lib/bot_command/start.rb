module BotCommand
  class Start < Base
    def should_start?
      text =~ /\A\/start/
    end

    def start
      user
      send_message(@greeting)
      question = "Могу ли я называть вас #{user.nickname || (user.first_name.to_s + " " + user.last_name.to_s) }?\n(имя используется в качестве имени капитана команды при регистрации на игру)"
      send_keyboard(%w(Да Нет Отменить), question)
      user.set_next_bot_command('BotCommand::Introduce')
    end
  end
end
