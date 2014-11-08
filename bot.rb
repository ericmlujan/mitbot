require 'cinch'
require 'net/http'
require 'json'

# Basic plugin definition
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

# GitHub plugin definition
class GitHub
    include Cinch::Plugin
    # Define some info about the GitHub API
    base_url = "api.github.com"
    user = "ericluwolf"

    # Match commands to their individual methods
    # !gh commit <repository> <id>
    match(/gh commit ([^ ]+) (.+)/, method: :commit_search)

    # Define a way to search for Git commits by ID
    def commit_search(m, repo, id)
        uri = "/repos/#{user}/#{repo}/commits/#{id}"
        # Request the commit from GitHub and store the info
        res = request(uri, Net::HTTP::Get)
        if res
            m.reply "Git commit query for commit #{id}"
            m.reply "================================================="
            m.reply "Commit author: #{res["commit"]["author"]["name"]} <#{res["commit"]["author"]["email"]}>"
            m.reply "Commit date: #{res["commit"]["author"]["date"]}"
            m.reply "Commit message: #{res["commit"]["message"]}"
            m.reply "Modified file listing:"
            # Iterate through all file statistics
            res["files"].each do |file|
                m.reply "#{file["filename"]} - #{file["changes"]} changes (#{file["additions"]}+, #{file["deletions"]}-)"
            end
        end
    end

    # Define a generic method to communicate with GitHub's API
    private
    def request(uri, method, data = nil)
        uri = URI("https://#{BaseURL}#{uri}")
        # Create an HTTP requst
        Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
            req = method.new(uri.request_uri)
            req.body = data
            # Do the request and read the JSON into a variable
            resp = http.request(req)
            # Parse the JSON and return it as an object
            return JSON.parse(resp.body)
        end
    end

    # Match commands to their methods

    # 
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
