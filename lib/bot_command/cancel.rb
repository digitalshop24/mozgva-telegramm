module BotCommand
  class Cancel < Base
    def should_start?
      true
    end

    def start
      remove_keyboard(I18n.t('cancel'))
      user.reset_next_bot_command
    end
  end
end
