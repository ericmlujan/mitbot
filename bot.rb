require 'cinch'

# Plugin definition
class Hello
    # Pull in dem dependencies
    include Cinch::Plugin

    # Define string patterns and their corresponding methods
    match(/help$/, method: :help)
    match(/ping$/, method: :ping)

    # Define the help method
    def help(m)
        # Open the current file in the current directory
        pwd = File.dirname( File.expand_path(__FILE__))
        file = pwd + "/helptext.txt"
        help_text = File.open(file, "r")
        m.user.send "Hi, #{m.user.name}! I'm a helpful IRC bot coded by Eric Lujan!"
        # Send the help text line by line
        help_text.each_line do |line|
            m.user.send line
        end
        help_text.close
    end

    # Define the test method for ping
    def ping(m)
        m.reply "Pong!"
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
