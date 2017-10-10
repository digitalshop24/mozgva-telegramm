module BotCommand
  class NewTeam < Base
    def should_start?
      text =~ /\A\/new_team/
    end

    def start
      url = URI.parse("#{@mozgva_url}/api/v1/games/schedule?id=#{@id}")
      schedule = JSON.parse(Net::HTTP.get(url))
      msg = []
      schedule.each do |key, value|
        value.each do |time|
          msg << key
        end
      end
      msg << "Отменить"
      question =  I18n.t('choose_the_date')
      send_keyboard(msg, question)
      user.set_next_bot_command('BotCommand::NewTeamDate')
    end
  end
end
