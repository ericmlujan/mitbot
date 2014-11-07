require 'cinch'

# Set some basic configuration and define the bot object,
bot = Cinch::Bot.new do
    configure do |c|
        c.server = "irc.freenode.net"
        c.channels = ["#lujan"]
    end
end

# Let it run!
bot.start
