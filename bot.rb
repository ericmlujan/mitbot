require 'cinch'

# Plugin definition
class Hello
    # Pull in dem dependencies
    include Cinch::Plugin

    # Define the help method
    match(/help$/, method: :help)
    def help(m)
        help_text = File.open("helptext.txt", "r")
        m.user.send "Hi, #{m.user.name} my name is lujan-bot!"
        m.user.send help_text
        help_text.close
    end
end

# Set some basic configuration and define the bot object.
bot = Cinch::Bot.new do
    configure do |c|
        c.server = "irc.freenode.net"
        c.channels = ["#lujan"]
        c.nick = "lujan-bot"
        c.realname = "Eric Lujan's IRC Channel Support Bot"
        c.user = "ircservices"
        c.plugins.plugins = [Hello]
    end
end

# Let it run!
bot.start
