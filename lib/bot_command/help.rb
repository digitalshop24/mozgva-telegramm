module BotCommand
  class Help < Base
    def should_start?
      text =~ /\A\/help/
    end

    def start
      send_message(@greeting)
      user.reset_next_bot_command
    end
  end
end
