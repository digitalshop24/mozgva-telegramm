module BotCommand
  class NewTeamDateTime < Base
    def should_start?
      text =~ /^([0-9]|0[0-9]|1[0-9]|2[0-3]):[0-5][0-9]$/
    end

    def start
      user.registration_data.games.each do |game|
        game.destroy if game.time != text
      end
      if user.team_name.present?
        user.registration_data.update_attribute(:team_name, user.team_name)
        question = I18n.t('team_name_clarification', team_name: user.team_name)
        send_keyboard(["Да", I18n.t('change_name'), "Отменить"], question)
        user.set_next_bot_command('BotCommand::AreYouSure')
      elsif user.registration_data.team_name.present?
        question = I18n.t('team_name_clarification', team_name: user.registration_data.team_name)
        send_keyboard(["Да", I18n.t('change_name'), "Отменить"], question)
        user.set_next_bot_command('BotCommand::AreYouSure')
      else
        question = I18n.t('team_name_registration_qestion')
        send_keyboard("Отменить", question)
        user.set_next_bot_command('BotCommand::NewTeamName')
      end
    end

    def undefined
      question = I18n.t('unknown_date_format')
      send_keyboard("Отменить", question)
    end
  end
end
