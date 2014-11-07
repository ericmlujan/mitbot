require 'cinch'

# Plugin definition
class Hello
    # Pull in dem dependencies
    include Cinch::Plugin
    # Look for the word "hello" in messages
    match "hello"
    # Actually do something with that
    def execute(m)
        m.reply "Hello, #{m.user.nick}"
    end
end

# Set some basic configuration and define the bot object.
bot = Cinch::Bot.new do
    configure do |c|
        c.server = "irc.freenode.net"
        c.channels = ["#lujan"]
        c.nick = "lujan-bot"
        c.plugins.plugins = [Hello]
    end
end

# Let it run!
bot.start
