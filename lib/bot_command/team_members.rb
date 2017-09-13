module BotCommand
  class TeamMembers < Base
    def should_start?
      text =~ /^[1-9]$/
    end

    def start
      user.registration_data.update_attribute(:member_amount, text.to_i)
      user.set_next_bot_command('BotCommand::TeamPhone')
      if user.phone_number.present?
        question = "Ваш номер телефона #{user.phone_number}"
        send_keyboard(%w(Да Нет Отменить), question)
      else
        question = "Введите номер телефона в формате 7 xxx xxx xx xx (минимум 9 цифр)\nТакже вы можете указать номер в настройках /settings, чтобы не вводить его каждый раз при регистрации."
        send_keyboard("Отменить", question)
      end

    end

    def undefined
      question = "Максимум 9 человек"
      send_keyboard("Отменить", question)
    end
  end
end
