require 'open-uri'

namespace :telegram_bot do
  desc 'Sets webhook for telegram bot'

  task :set_webhook => :environment do
    url = `curl -s http://127.0.0.1:4040/status | grep -E "https://.*?ngrok.io" -oh`
    res = open("https://api.telegram.org/bot"+ ENV["token"] +"/setWebhook?url=#{url}/webhooks/telegram_ZYqi1sRosjp3UPFfKZHp").read
    p res
  end

  task :set_default => :environment do
    res = open('https://api.telegram.org/bot'+ ENV["token"] +'/setWebhook?url=https://mozgvabot.herokuapp.com/webhooks/telegram_ZYqi1sRosjp3UPFfKZHp').read
    p res
  end

end
