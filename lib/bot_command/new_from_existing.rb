module BotCommand
  class NewFromExisting < Base
    def should_start?
      [I18n.t('write_again_team_name'), I18n.t('register_as_new')].include?(text)
    end

    def start
      if text == I18n.t('write_again_team_name')
        send_keyboard("Отменить", I18n.t('team_name_question'))
        user.set_next_bot_command('BotCommand::TeamChecker')
      elsif text == I18n.t('register_as_new')
        url = URI.parse("#{@mozgva_url}/api/v1/games/schedule?id=#{@id}")
        schedule = JSON.parse(Net::HTTP.get(url))
        msg = []
        schedule.each do |key, value|
          value.each do |time|
            msg << key
          end
        end
        msg << "Отменить"
        question = I18n.t('choose_the_date')
        send_keyboard(msg, question)
        user.set_next_bot_command('BotCommand::NewTeamDate')

      end
    end

    def undefined
      send_message(I18n.t('wrong_date_alert'))
    end
  end
end
