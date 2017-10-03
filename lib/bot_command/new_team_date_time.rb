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
        question = "Давайте еще раз сверим имя вашей команды. Я правильно запомнил: #{user.team_name}?"
        send_keyboard(["Да", "Изменить название", "Отменить"], question)
        user.set_next_bot_command('BotCommand::AreYouSure')
      elsif user.registration_data.team_name.present?
        question = "Давайте еще раз сверим имя вашей команды. Я правильно запомнил: #{user.registration_data.team_name}?"
        send_keyboard(["Да", "Изменить название", "Отменить"], question)
        user.set_next_bot_command('BotCommand::AreYouSure')
      else
        question = "Как будет называться Ваша команда?"
        send_keyboard("Отменить", question)
        user.set_next_bot_command('BotCommand::NewTeamName')
      end
    end

    def undefined
      question = "Я понимаю даты только в формате 1 или 2 и т.д."
      send_keyboard("Отменить", question)
    end
  end
end
