module BotCommand
  class Nickname < Base
    def should_start?
      text =~ /.+/
    end

    def start
      user.update_attribute(:nickname, text)
      remove_keyboard("Спасибо, #{user.nickname}\nЧто бы продолжить нажмите /help")
      user.reset_next_bot_command
    end
  end
end
