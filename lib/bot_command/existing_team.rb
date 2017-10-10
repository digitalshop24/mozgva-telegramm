module BotCommand
  class ExistingTeam < Base
    def should_start?
      text =~ /.+/
    end

    def start
      keys = []
      keys << user.team_name if user.team_name.present?
      keys << "Отменить"
      send_keyboard(keys, I18n.t('team_name_question'))
      user.set_next_bot_command('BotCommand::TeamChecker')
    end

    def undefined
      send_message("existing_team")
    end

  end

end
