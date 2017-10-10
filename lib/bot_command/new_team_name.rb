module BotCommand
  class NewTeamName < Base
    def should_start?
      text =~ /.+/
    end

    def start
      if team_exists? text
        user.update_attribute(:team_name, text)
        user.registration_data.update_attribute(:team_name, text)
        question = I18n.t('team_already_exist')
        send_keyboard([I18n.t('change_name'), I18n.t('existing_team_registration'), "Отменить"], question)
        user.set_next_bot_command('BotCommand::AreYouSure')
      else
        user.update_attribute(:team_name, text)
        user.registration_data.update_attribute(:team_name, text) if user.registration_data.status != "from matching existing team"
        question = I18n.t('team_name_clarification', team_name: user.registration_data.team_name)
        send_keyboard(["Да", I18n.t('change_name'), "Отменить"], question)
        user.set_next_bot_command('BotCommand::AreYouSure')
      end
    end

    def undefined
      question = I18n.t('enter_team_name_again')
      send_keyboard("Отменить", question)
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
