module BotCommand
  class GameRegistration < Base
    def should_start?
      text =~ /\A\/game_registration/
    end

    def start
      send_message(I18n.t('game_registration_greeter'))
      user.reset_next_bot_command
    end

    def undefined
    end
  end
end
