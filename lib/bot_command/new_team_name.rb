module BotCommand
  class NewTeamName < Base
    def should_start?
      text =~ /.+/
    end

    def start
      if team_exists? text
        user.update_attribute(:team_name, text)
        user.registration_data.update_attribute(:team_name, text)
        question = "Такая команда уже существует"
        send_keyboard(["Изменить название", "Перейти к регистрации существующей команды", "Отменить"], question)
        user.set_next_bot_command('BotCommand::AreYouSure')
      else
        user.update_attribute(:team_name, text)
        user.registration_data.update_attribute(:team_name, text) if user.registration_data.status != "from matching existing team"
        question = "Давайте еще раз сверим имя вашей команды. Я правильно запомнил: #{user.registration_data.team_name}?"
        send_keyboard(["Да", "Изменить название", "Отменить"], question)
        user.set_next_bot_command('BotCommand::AreYouSure')
      end
    end

    def undefined
      question = "Введите название команды еще раз"
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
