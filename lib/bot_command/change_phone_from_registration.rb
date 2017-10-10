module BotCommand
  class ChangePhoneFromRegistration < Base
    def should_start?
      text =~ /^[7]\d{8,}/
    end

    def start
      user.update_attribute(:phone_number, text)
      user.set_next_bot_command('BotCommand::TeamPhone')
      question = "Ваш номер телефона #{user.phone_number}"
      send_keyboard(%w(Да Нет Отменить), question)
    end

    def undefined
      question =  I18n.t('number_format_alert')
      send_keyboard("Отменить", question)
    end
  end
end
