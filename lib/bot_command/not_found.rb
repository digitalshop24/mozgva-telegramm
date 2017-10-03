module BotCommand
  class NotFound < Base
    def should_start?
      true
    end

    def start
      send_message('А вот этого я пока не умею. Но это пока')
      send_message('Введи /help чтобы посмотреть, что я уже умею')
    end
  end
end
