require "rubygems"
require 'twilio-ruby'


class ConfirmationMessage 
  #IMPORTANT: initialize method needs to commented out when sending messages independent of Order class
  #KEEP Initialize when testing 'integration_spec.rb' and 'confirmation_message_spec.rb'
  def initialize(order)   
    @order_status = order.confirmed?
    fail "Please confirm your order." if @order_status == false
  end

  def order_status
    @order_status
  end

  def arrival_time
    @arrival_time = (Time.new + 1800).strftime("%k:%M")
  end

  def get_contact
    puts "Your name:"
    @customer_name = gets.chomp
    puts "Your phone number:"
    @customer_phone_number = gets.chomp
  end 

  def customer_name
    return @customer_name
  end 

  def customer_phone_number
    return @customer_phone_number
  end 

  def message
    account_sid = ENV['TWILIO_ACCOUNT_SID']
    auth_token = ENV['TWILIO_AUTH_TOKEN']
    message_sid = ENV['MY_TWILIO_MESSAGE_SID']
    @client = Twilio::REST::Client.new(account_sid, auth_token)
    message = @client.messages.create(
      body: "Hello #{@customer_name}, thank you for your order! It was placed and will be delivered before #{arrival_time}.",
      from: message_sid,
      to: @customer_phone_number
      )
  end
end 


# message = ConfirmationMessage.new
# message.arrival_time
# message.get_contact
# message.message
# puts message.sid

