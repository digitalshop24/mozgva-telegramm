module BotCommand
  class NewTeamDate < Base
    def should_start?
      text =~ /(0[1-9]|[12][0-9]|3[01])\.(0[1-9]|1[012])\.(19|20)\d\d/
    end

    def start
      date = text
      url = URI.parse("#{@mozgva_url}/api/v1/games/schedule?id=#{@id}")
      schedule = JSON.parse(Net::HTTP.get(url))
      msg = []
      if schedule[text]
        if user.registration_data.present?
          if user.registration_data.status == "from matching existing team"
            user.registration_data.date = date
            user.registration_data.save
          else
           user.registration_data.destroy
           rd = RegistrationData.new(status: "in progress", date: date)
           user.registration_data = rd
           user.registration_data.save
         end
       else
        rd = RegistrationData.new(status: "in progress", date: date)
        user.registration_data = rd
        user.registration_data.save
      end

        #save date to the game
        #user.current_registration.set_date
        #it sets date
        #it creates user.current_registrations.times << 1), 2) ...

        schedule[text].keys.each_with_index do |time, index|
          user.registration_data.games.create(selector: index+1, time: time)
          msg << time
        end
        msg << "Отменить"
        question = I18n.t('choose_the_time')
        send_keyboard(msg, question)
        user.set_next_bot_command('BotCommand::NewTeamDateTime')
      else
        send_message( I18n.t('choose_the_date'))
      end
    end

    def undefined
      question = I18n.t('wrong_date_format_alert')
      send_keyboard("Отменить", question)
    end
  end
end
