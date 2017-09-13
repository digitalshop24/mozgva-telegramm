module BotCommand
  class ExistingTeam < Base
    def should_start?
      text =~ /.+/
    end

    def start
      keys = []
      keys << user.team_name if user.team_name.present?
      keys << "Отменить"
      send_keyboard(keys, "Как называется Ваша команда? Напишите, пожалуйста, название в точь точь как на сайте mozgva.com или выберите название из Вашего профиля(можно добавить в /settings")
      user.set_next_bot_command('BotCommand::TeamChecker')
    end

    def undefined
      send_message("existing_team")
    end

  end

end
