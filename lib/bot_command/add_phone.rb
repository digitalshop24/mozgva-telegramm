module BotCommand
  class AddPhone < Base
    def should_start?
      text =~ /^[7]\d{8,}/
    end

    def start
      user.update_attribute(:phone_number, text)
      remove_keyboard("Телефон записан: #{user.phone_number}, #{user.nickname}\n")
      question = "Персональные настройки. Выберите что вы хотите просмотреть/изменить"
      send_keyboard(%w(Имя Секретный\ код Название\ команды Телефон Отменить), question)
      user.set_next_bot_command('BotCommand::SettingsRouter')
    end

    def undefined
      question = "Введите номер телефона в формате 7 xxx xxx xx xx (минимум 9 цифр)"
      send_keyboard("Отменить", question)
    end
  end
end
