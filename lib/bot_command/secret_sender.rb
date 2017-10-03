module BotCommand
  class SecretSender < Base
    def should_start?
      text =~ /.+/
    end

    def start
      if text == "Выслать мне секретный код"
        team_name = URI.encode(user.registration_data.team_name)
        response = %x[curl -X GET --header 'Accept: application/json' '#{@mozgva_url}/api/v1/teams/find?name=#{team_name}']
        begin
          id = JSON.parse(response)["team"]["id"]
        rescue Exception
          false
        end
        response = %x[curl -X GET --header 'Accept: application/json' '#{@mozgva_url}/api/v1/teams/#{id}/send_secret']
        begin
          result = JSON.parse(response)
        rescue Exception
          false
        end
        status = result["status"]
        message = result["message"]
        if status
          send_keyboard("Отменить", "Пожалуйста, введите код")
          user.set_next_bot_command('BotCommand::SecretSender')
        else
          send_keyboard(["Выслать мне секретный код", "Отменить"], "Что-то пошло не так:\n#{message}\nВведите код еще раз или отмените")
          user.set_next_bot_command('BotCommand::SecretSender')
        end


      else
        if text == "Ввести новый секретный код"
          send_keyboard("Отменить", "Введите код")
          user.set_next_bot_command('BotCommand::SecretSender')
        else
          if text == "Да"
            user.registration_data.update_attribute(:secret, user.secret)
          else
            user.update_attribute(:secret, text)
            user.registration_data.update_attribute(:secret, text)
          end

          response = register_team(user.registration_data)
          status = response["success"] if response.present?
          mess = response["message"] if response.present?
          if status
            message = "Все в порядке: команда #{user.registration_data.team_name} в количестве #{user.registration_data.member_amount} зарегистрирована на игру. Имя капитана и его телефон:\n#{user.nickname || (user.first_name.to_s + " " + user.last_name.to_s)} #{user.registration_data.phone} \nЧто бы продолжить нажмите /help"
            remove_keyboard(message)
            user.reset_next_bot_command
            user.registration_data.destroy if user.registration_data.present?
          else
            if mess == "Вы уже записались на эту игру"
              remove_keyboard("Вы уже записались на эту игру\nЧто бы продолжить нажмите /help")
              user.reset_next_bot_command
            else
              send_keyboard(["Выслать мне секретный код", "Отменить"], "Давайте попробуем еще раз")
              user.set_next_bot_command('BotCommand::SecretSender')
            end
          end
        end
      end

    end

    def undefined
      send_message("SecretChecker")
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
      secret = registration_data.secret
      response = %x[curl -X POST --header 'Content-Type: application/x-www-form-urlencoded' --header 'Accept: application/json' -d 'id=#{id}&date=#{date}&time=#{time}&phone=#{phone}&name=#{captain_name}&persons=#{persons}&api_key=#{api_key}&team_name=#{team_name}&secret=#{secret}' '#{endpoint_url}']

      JSON.parse(response)
    end
  end
end
