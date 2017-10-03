module BotCommand
  class AreYouSure < Base
    def should_start?
      ["Изменить название", "Да", "Перейти к регистрации существующей команды"].include?(text)
    end

    def start
      if text == "Изменить название"
        user.registration_data.update_attribute(:status, "in progress")
        question = "Так как же называть вашу команду?"
        send_keyboard("Отменить", question)
        user.set_next_bot_command('BotCommand::NewTeamName')
      elsif text == "Да"
        if team_exists?(user.team_name)
          question = "Такая команда уже существует"
          send_keyboard(["Изменить название", "Перейти к регистрации существующей команды", "Отменить"], question)
          user.set_next_bot_command('BotCommand::AreYouSure')
        else
          question = "Сколько человек в команде? Напоминаю, максимум 9"
          keys = %w(1 2 3 4 5 6 7 8 9 Отменить)
          send_keyboard(keys, question)
          user.set_next_bot_command('BotCommand::TeamMembers')
        end
      elsif text == "Перейти к регистрации существующей команды"
        user.registration_data.update_attribute(:status, "from matching existing team")
        question = "Сколько человек в команде? Напоминаю, максимум 9"
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
