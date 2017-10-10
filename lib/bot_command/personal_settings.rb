module BotCommand
  class PersonalSettings < Base
    def should_start?
      text =~ /\A\/settings/
    end

    def start
      question = I18n.t('personal_settings')
      send_keyboard(I18n.t('personal_settings_keyboard'), question)
      user.set_next_bot_command('BotCommand::SettingsRouter')
    end
  end
end
