module BotCommand
  class GameRegistration < Base
    def should_start?
      text =~ /\A\/game_registration/
    end

    def start
      send_message("Я могу зарегистрировать Вас на игру. Только мне надо узнать кто вы новичек или бывалый Мозгвич. Для этого выберите одну из команд\n /new_team (Новая команда)\n /existing_team (Существующая команда)")
      user.reset_next_bot_command
    end

    def undefined
    end
  end
end
