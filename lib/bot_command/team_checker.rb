module BotCommand
  class TeamChecker < Base
    def should_start?
      text =~ /.+/
    end

    def start
      user.update_attribute(:team_name, text)
      rd = RegistrationData.new(status: "from matching existing team", team_name: text)
      user.registration_data.destroy if user.registration_data.present?
      user.registration_data = rd
      user.registration_data.save
      if team_exists?(text)
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
      else
        question = I18n.t('no_such_team')
        keys = [I18n.t('write_again_team_name'), I18n.t('register_as_new'), "Отменить"]
        send_keyboard(keys, question)
        user.set_next_bot_command('BotCommand::NewFromExisting')
      end

      # send_message("Как называется Ваша команда? Напишите, пожалуйста, название в точь точь как на сайте mozgva.com")
      # user.set_next_bot_command('BotCommand::NewTeamDate')
    end

    def team_exists?(team_name)
      name = URI.encode(team_name)
      response = %x[curl -X GET --header 'Accept: application/json' '#{@mozgva_url}/api/v1/teams/find?name=#{name}']
      begin
        JSON.parse(response)["success"]
      rescue Exception
        false
      end
    end

    def undefined
      send_message("TeamChecker")
    end
  end
end
