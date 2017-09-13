require 'bot_command'

class BotActionRouter

  attr_accessor :command, :user

  MASTER_COMMANDS = {game_registration: 'GameRegistration', help: 'Help', start: 'Start', schedule: "Schedule", new_team: "NewTeam", change_username: 'UserName', cancel: 'Cancel', existing_team: "ExistingTeam", settings: 'PersonalSettings'}
  MASTER_COMMANDS.default = "NotFound"

  def initialize(user, command)
    @command = command
    @user = user
  end

  def fetch_action_object
    if ["/cancel", "Отменить"].include?(command)
      eval("BotCommand::Cancel")
    else
      class_name = user.get_next_bot_command || command_class_name
      begin
        eval(class_name)
      rescue NameError
        unknown_command
      end
    end
  end

  private

  def command_class_name
    "BotCommand::" + MASTER_COMMANDS[command.to_sym]
  end

  def unknown_command
    BotCommand::Undefined
  end


end
