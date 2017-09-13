module BotCommand
  class AddSecret < Base
    def should_start?
      text =~ /.+/
    end

    def start
      user.update_attribute(:secret, text)
      remove_keyboard("Секретный код записан: #{user.secret}, #{user.nickname}\n")
      question = "Персональные настройки. Выберите что вы хотите просмотреть/изменить"
      send_keyboard(%w(Имя Секретный\ код Название\ команды Телефон Отменить), question)
      user.set_next_bot_command('BotCommand::SettingsRouter')
    end
  end
end
