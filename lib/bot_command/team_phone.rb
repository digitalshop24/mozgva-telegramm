module BotCommand
  class TeamPhone < Base
    def should_start?
      text =~ /^[7]\d{8,}/ || %w(Да Нет).include?(text)
    end

    def start
      case text
      when /^[7]\d{8,}/, "Да"
        if text == "Да"
          user.registration_data.update_attribute(:phone, user.phone_number.to_i)
        else
          user.update_attribute(:phone_number, text.to_i)
          user.registration_data.update_attribute(:phone, text.to_i)
        end


        if user.registration_data.status == "from matching existing team"
          if user.secret.present?
            question = "Приятно общаться с коренным Мозгвичем. Но мне нужно знать точно, что вы- участник команды.
Напишите секретный код вашей команды. Если он вам не известен, спросите у вашего капитана. Если вы и есть капитан, самое время этот секретный код придумать на сайте в личной кабинете, раздел «секретный код»
\nИспользовать секретный код #{user.secret}?"
            send_keyboard(["Да", "Ввести новый секретный код", "Отменить"], question)
            user.set_next_bot_command('BotCommand::SecretSender')
          else
            question = "Приятно общаться с коренным Мозгвичем. Но мне нужно знать точно, что вы- участник команды.
Напишите секретный код вашей команды. Если он вам не известен, спросите у вашего капитана. Если вы и есть капитан, самое время этот секретный код придумать на сайте в личной кабинете, раздел «секретный код»"
            send_keyboard(["Выслать мне секретный код", "Отменить"], question)
            user.set_next_bot_command('BotCommand::SecretSender')
          end

        else

          response = register_team(user.registration_data)
          status = response["success"]
          message = response["message"]

          if status
            message = "Все в порядке: команда #{user.registration_data.team_name} в количестве #{user.registration_data.member_amount} зарегистрирована на игру. Имя капитана и его телефон:\n#{user.nickname || (user.first_name.to_s + " " + user.last_name.to_s)} #{user.registration_data.phone} \nЧто бы продолжить нажмите /help"
            remove_keyboard(message)
            user.reset_next_bot_command
          else
            remove_keyboard(message.to_s + "\nЧто бы продолжить нажмите /help")
            user.reset_next_bot_command
          end
        end

      when "Нет"
        question = "Введите номер телефона в формате 7 xxx xxx xx xx (минимум 9 цифр) здесь или укажите в настойках /settings"
        send_keyboard("Отменить", question)
        user.set_next_bot_command('BotCommand::ChangePhoneFromRegistration')
      end

    end


    def undefined
      question = "Введите номер телефона в формате 7 xxx xxx xx xx (минимум 9 цифр)"
      send_keyboard("Отменить", question)
    end


    def register_team(registration_data)
      endpoint_url = "#{@mozgva_url}/api/v1/games/booking"
      api_key = @mozgva_api_key
      date = registration_data.date
      id = 1
      time = registration_data.games.first.time
      phone = registration_data.phone
      captain_name = user.nickname || user.last_name || user.first_name
      persons = registration_data.member_amount
      team_name = URI.encode(registration_data.team_name)
      response = %x[curl -X POST --header 'Content-Type: application/x-www-form-urlencoded' --header 'Accept: application/json' -d 'id=#{id}&date=#{date}&time=#{time}&phone=#{phone}&name=#{captain_name}&persons=#{persons}&api_key=#{api_key}&team_name=#{team_name}' '#{endpoint_url}']

      JSON.parse(response)
    end
  end
end
