require 'cinch'
require 'net/http'
require 'json'
require 'time'
require 'forecast_io'

# Calculate differences in times
class Numeric
  def duration
    sec = self.to_i
    min = sec / 60
    hr = min / 60
    day = hr / 24
    if day > 0
      "#{day} days and #{hr % 24} hours"
    elsif hr > 0
      "#{hr} hours and #{min % 60} minutes"
    elsif min > 0
      "#{min} minutes and #{sec % 60} seconds"
    elsif sec >= 0
      "#{sec} seconds"
    else
      "It's here!"
    end
  end
end

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
        m.user.send "Hi, #{m.user.name}! I'm a helpful IRC bot coded by Eric Lujan on behalf of the MIT Class of 2019!"
        # Send the help text line by line
        help_text.each_line do |line|
            m.user.send line
        end
        help_text.close
    end

    # Define the test method for ping
    def ping(m)
        m.reply "Tim the Beaver here, reporting for duty!"
    end
end

# Class for MIT-specific stuff
class MIT
  # Moar dependencies
  include Cinch::Plugin

  # Set listeners
  match(/illuminati$/, method: :illuminati)
  match(/fact$/, method: :fact)
  match(/cpw$/, method: :cpw)
  match(/weather$/, method: :weather)
  match(/course ([^ ]+)/, method: :course)

  # Confirm that the illuminati exists
  def illuminati(m)
    m.reply "MIT has three letters. Illuminati has three I's. Illuminati confirmed."
  end

  # Display a random MIT fact
  def fact(m)
    # Open the current file in the current directory
    pwd = File.dirname( File.expand_path(__FILE__))
    file = pwd + "/mitfacts.txt"
    fact = File.readlines(file).sample
    m.reply fact
  end

  # Show time until CPW
  def cpw(m)
    cpwtime = 1429142400
    now = Time.now.to_i
    diff = (cpwtime - now).duration
    m.reply "There are #{diff} until the first day of MIT CPW."
  end

  # Get weather in Cambridge
  def weather(m)
    ForecastIO.api_key = "8826650e770499ac02d3d72d17afd3c8"
    forecast = ForecastIO.forecast(42.3598, -71.0921)
    humidity = (forecast.currently.humidity) * 100
    response = forecast.currently.summary + ", with a temperature of " + forecast.currently.temperature.to_s + " and humidity of " + humidity.to_s + "%."
    m.reply "Current weather at MIT (Kendall/MIT, Cambridge, MA):"
    m.reply response
  end

  def course(m, number)
    reply = ""
    number = number.downcase
    case number
    when "1"
      reply = "Civil and Environmental Engineering"
    when "2"
      reply = "Mechanical Engineering"
    when "3"
      reply = "Materials Science"
    when "4"
      reply = "Architecture"
    when "5"
      reply = "Chemistry"
    when "6"
      reply = "Electrical Engineering and Computer Science"
    when "6-1"
      reply = "Electrical Science and Engineering"
    when "6-2"
      reply = "Electrical Engineering and Computer Science"
    when "6-3"
      reply = "Computer Science and Engineering"
    when "7"
      reply = "Biology"
    when "8"
      reply = "Physics"
    when "9"
      reply = "Brain and Cognitive Sciences"
    when "10"
      reply = "Chemical Engineering"
    when "10b"
      reply = "Chemical-Biological Engineering"
    when "11"
      reply = "Urban Studies and Planning"
    when "12"
      reply = "Earth, Atmospheric, and Planetary Sciences"
    when "14"
      reply = "Economics"
    when "15"
      reply = "Management"
    when "16"
      reply = "AeroAstro"
    when "17"
      reply = "Political Science"
    when "18"
      reply = "Mathematics"
    when "18c"
      reply = "Mathematics with Computer Science"
    when "20"
      reply = "Biological Engineering"
    when "21"
      reply = "Humanities"
    when "21a"
      reply = "Anthropology"
    when "21f"
      reply = "Global Studies and Languages"
    when "21h"
      reply = "History"
    when "21l"
      reply = "Literature"
    when "21m"
      reply = "Music and Theater Arts"
    when "21w"
      reply = "Writing"
    when "22"
      reply = "Nuclear Science and Engineering"
    when "24"
      reply = "Linguistics and Philosophy"
    when "cms"
      reply = "Comparative Media Studies"
    when "csb"
      reply = "Computational and Systems Biology"
    when "esd"
      reply = "Engineering Systems"
    when "hst"
      reply = "Health Sciences and Technology"
    when "mas"
      reply = "Media Arts and Studies"
    when "sts"
      reply = "Science, Technology, and Society"
    else 
      reply = "I don't recognize that course number or acronym"
    end
    m.reply reply 
  end
end


# Set some basic configuration and define the bot object.
bot = Cinch::Bot.new do
    configure do |c|
        pwd = File.dirname( File.expand_path(__FILE__))
        cred = File.open(pwd + "/credfile", &:readline)
        c.server = "irc.freenode.net"
        c.channels = ["#mit2019"]
        c.nick = "mitbot"
        c.realname = "Tim the Beaver"
        c.user = "mit"
        c.password = cred
        c.plugins.plugins = [Hello, MIT]
    end

    on :message do |m|
    msg = m.message.downcase
    words = ['illuminati', 'triangle', 'conspiracy', 'three', 'confirmed', 'secret', 'society', 'chris', 'peterson']
    if (words.any? { |word| msg.include? word })
      m.reply "Did you hear that?!!!!! Illuminati confirmed by #{m.user.name}!"
    end
  end
end

# Let it run!
bot.start
