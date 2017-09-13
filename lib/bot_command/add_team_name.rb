module BotCommand
  class AddTeamName < Base
    def should_start?
      text =~ /.+/
    end

    def start
      user.update_attribute(:team_name, text)
      remove_keyboard("Название команды записано: #{user.team_name}, #{user.nickname}")
      question = "Персональные настройки. Выберите что вы хотите просмотреть/изменить"
      send_keyboard(%w(Имя Секретный\ код Название\ команды Телефон Отменить), question)
      user.set_next_bot_command('BotCommand::SettingsRouter')
    end
  end
end
