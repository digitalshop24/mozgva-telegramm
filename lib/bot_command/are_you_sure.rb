module BotCommand
  class AreYouSure < Base
    def should_start?
      [I18n.t('change_name'), "Да", I18n.t('existing_team_registration')].include?(text)
    end

    def start
      if text == I18n.t('change_name')
        user.registration_data.update_attribute(:status, "in progress")
        question = I18n.t('team_name_question')
        send_keyboard("Отменить", question)
        user.set_next_bot_command('BotCommand::NewTeamName')
      elsif text == "Да"
        if team_exists?(user.team_name)
          question = I18n.t('team_already_exist')
          send_keyboard([I18n.t('change_name'), I18n.t('existing_team_registration'), "Отменить"], question)
          user.set_next_bot_command('BotCommand::AreYouSure')
        else
          question = I18n.t('members_amount_question')
          keys = %w(1 2 3 4 5 6 7 8 9 Отменить)
          send_keyboard(keys, question)
          user.set_next_bot_command('BotCommand::TeamMembers')
        end
      elsif text == I18n.t('existing_team_registration')
        user.registration_data.update_attribute(:status, "from matching existing team")
        question = I18n.t('members_amount_question')
        keys = %w(1 2 3 4 5 6 7 8 9 Отменить)
        send_keyboard(keys, question)
        user.set_next_bot_command('BotCommand::TeamMembers')
      end
    end

    def undefined
      send_message("????")
    end

    def team_exists?(team_name)
      name = URI.encode(team_name)
      response = %x[curl -X GET --header 'Accept: application/json' '#{@mozgva_url}/api/v1/teams/find?name=#{name}']
      begin
        JSON.parse(response)["success"]
      rescue Exception
        false
      end
    end
  end
end
