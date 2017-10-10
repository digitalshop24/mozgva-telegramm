module BotCommand
  class ChangePhone < Base
    def should_start?
      %w(Да Нет).include?(text)
    end

    def start
      case text
      when "Да"
        question = I18n.t('number_format_alert')
        send_keyboard("Отменить", question)
        user.set_next_bot_command('BotCommand::AddPhone')
      when "Нет"
        question = I18n.t('personal_settings')
        send_keyboard(I18n.t('personal_settings_keyboard'), question)
        user.set_next_bot_command('BotCommand::SettingsRouter')
      end
    end

    def undefined
      question = "Я понимаю только Да или Нет"
      send_keyboard(%w(Да Нет Отменить), question)
    end
  end
end
