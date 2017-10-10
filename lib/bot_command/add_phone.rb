module BotCommand
  class AddPhone < Base
    def should_start?
      text =~ /^[7]\d{8,}/
    end

    def start
      user.update_attribute(:phone_number, text)
      remove_keyboard(I18n.t('add_phone_success', phone_number: user.phone_number, nickname: user.nickname || (user.first_name.to_s + " " + user.last_name.to_s)))
      question = I18n.t('personal_settings')
      send_keyboard(I18n.t('personal_settings_keyboard'), question)
      user.set_next_bot_command('BotCommand::SettingsRouter')
    end

    def undefined
      question = I18n.t('number_format_alert')
      send_keyboard("Отменить", question)
    end
  end
end