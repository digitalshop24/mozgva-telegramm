module BotCommand
  class Cancel < Base
    def should_start?
      true
    end

    def start
      remove_keyboard("Отменено\nЧто бы продолжить нажмите /help")
      user.reset_next_bot_command
    end
  end
end
