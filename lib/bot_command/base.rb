module BotCommand
  require 'telegram/bot'
  require 'net/http'

  class Base
    attr_reader :user, :message, :api, :greeting

    def initialize(user, message)
      @user = user
      @message = message
      token = ENV['token']
      @api = ::Telegram::Bot::Api.new(token)
      @greeting = I18n.t('greeting')
      @mozgva_url = "https://mozgva.com"
      @mozgva_api_key = "Test_afisha_api_key_654321"
      @id = "1"

      # @mozgva_url = "https://mozgva-staging.herokuapp.com"
      # @mozgva_api_key = "test_bot_api_key"
      # @id = "11"
    end

    def should_start?
      raise NotImplementedError
    end

    def start
      raise NotImplementedError
    end

    protected

    def send_message(text, options={})
      @api.call('sendMessage', chat_id: @user.telegram_id, text: text)
    end

    def send_keyboard(buttons, question, options={})
      question = question
      answers =
        Telegram::Bot::Types::ReplyKeyboardMarkup
        .new(keyboard: buttons, one_time_keyboard: true)
      @api.call('sendMessage', chat_id: @user.telegram_id, text: question, reply_markup: answers)
    end

    def send_button(text, question, options={})
      button =
        Telegram::Bot::Types::KeyboardButton
        .new(text: text)
      @api.call('sendMessage', chat_id: @user.telegram_id, text: question, reply_markup: button)
    end

    def remove_keyboard(text)
      kb = Telegram::Bot::Types::ReplyKeyboardRemove.new(remove_keyboard: true)
      @api.call('sendMessage', chat_id: @user.telegram_id, text: text, reply_markup: kb)
    end

    def text
      @message[:message][:text]
    end

    def from
      @message[:message][:from]
    end
  end
end
