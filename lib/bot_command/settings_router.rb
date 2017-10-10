module BotCommand
  class SettingsRouter < Base
    def should_start?
      %w(Имя Секретный\ код Название\ команды Телефон).include?(text)
    end

    def start
      case text
      when "Имя"
        question = I18n.t('current_name', username: user.nickname || (user.first_name.to_s + " " + user.last_name.to_s))
        send_keyboard(I18n.t('y_n_c_keyboard'), question)
        user.set_next_bot_command('BotCommand::ChangeName')
      when "Секретный код"
        question = I18n.t('current_secret', secret: user.secret)
        send_keyboard(I18n.t('y_n_c_keyboard'), question)
        user.set_next_bot_command('BotCommand::ChangeSecret')
      when "Название команды"
        question =I18n.t('current_team_name', team_name: user.team_name)
        send_keyboard(I18n.t('y_n_c_keyboard'), question)
        user.set_next_bot_command('BotCommand::ChangeTeamName')
      when "Телефон"
        question = I18n.t('current_phone_number', phone_number: user.phone_number)
        send_keyboard(I18n.t('y_n_c_keyboard'), question)
        user.set_next_bot_command('BotCommand::ChangePhone')
      end
    end

    def undefined
      question = I18n.t('router_undefined')
      send_keyboard("Отменить", question)
    end
  end
end
