module BotCommand
  class Start < Base
    def should_start?
      text =~ /\A\/start/
    end

    def start
      user
      send_message(@greeting)
      question = I18n.t('welcome', user.nickname || (user.first_name.to_s + " " + user.last_name.to_s))
      send_keyboard(I18n.t('y_n_c_keyboard'), question)
      user.set_next_bot_command('BotCommand::Introduce')
    end
  end
end
