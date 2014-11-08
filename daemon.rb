require 'daemons'

# Current directory
pwd = File.dirname( File.expand_path(__FILE__))
file = pwd + "/bot.rb"

# Set some options
options = {
	:app_name    =>"ircbotd",
	:multiple   => true,
	:mode       => :load,
	:log_output => true,
	:monitor    => true
}

# Run the bot and daemonize it
Daemons.run_proc('ircbotd',options) do
	exec "ruby #{file}"
end