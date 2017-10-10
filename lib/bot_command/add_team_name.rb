module BotCommand
  class AddTeamName < Base
    def should_start?
      text =~ /.+/
    end

    def start
      user.update_attribute(:team_name, text)
      remove_keyboard(I18n.t('add_team_name_success', team_name: user.team_name, nickname: user.nickname || (user.first_name.to_s + " " + user.last_name.to_s)))
      question = I18n.t('personal_settings')
      send_keyboard(I18n.t('personal_settings_keyboard'), question)
      user.set_next_bot_command('BotCommand::SettingsRouter')
    end
  end
end
