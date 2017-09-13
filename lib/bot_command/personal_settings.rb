module BotCommand
  class PersonalSettings < Base
    def should_start?
      text =~ /\A\/settings/
    end

    def start
      question = "Персональные настройки. Выберите что вы хотите просмотреть/изменить"
      send_keyboard(%w(Имя Секретный\ код Название\ команды Телефон Отменить), question)
      user.set_next_bot_command('BotCommand::SettingsRouter')
    end
  end
end
