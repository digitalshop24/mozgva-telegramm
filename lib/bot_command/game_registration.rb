module BotCommand
  class GameRegistration < Base
    def should_start?
      text =~ /\A\/game_registration/
    end

    def start
      send_message("Я могу зарегистрировать Вас на игру. Правда вначале мне надо понять кто вы: новичок или коренной житель Мозгвы? Для этого выберите одну из команд\n /new_team (Новая команда)\n /existing_team (Существующая команда)")
      user.reset_next_bot_command
    end

    def undefined
    end
  end
end
