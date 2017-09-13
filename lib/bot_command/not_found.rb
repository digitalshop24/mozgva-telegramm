module BotCommand
  class NotFound < Base
    def should_start?
      true
    end

    def start
      send_message('А вот это я еще не освоил, но я стараюсь')
      send_message('Введи /help чтобы посмотреть, что я уже умею')
    end
  end
end
