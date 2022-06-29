
require "confirmation_message"

describe ConfirmationMessage do
  context "initially" do
    it "check the status of the order" do
      order = double(:fake_order, confirmed?:true)
      message = ConfirmationMessage.new(order)
      expect(message.order_status).to eq true
    end

    it "fails to construct if the order has not been confirmed" do
      order = double(:fake_order, confirmed?: false)
      expect {ConfirmationMessage.new(order)}.to raise_error "Please confirm your order."
    end
  end

  context "before sending the confirmation message" do
    it "calculates arrival time for the order" do
      order = double(:fake_order, confirmed?:true)
      message = ConfirmationMessage.new(order)
      @fake_time_now = (Time.new + 1800).strftime("%k:%M")
      # @fake_time_now = (Time.new(2022, 06, 29, 13, 18, 30) + 1800).strftime("%k:%M")
      # expect(message.arrival_time).to eq "13:48"
      expect(message.arrival_time).to eq "#{@fake_time_now}" #tested both ways. it has to be either manually updated or we can replace the result with @fake_time_now
    end

    it "collects the name and the phone number of the customer" do
      order = double(:fake_order, confirmed?:true)
      message = ConfirmationMessage.new(order)
      expect(message).to receive(:puts).with("Your name:").ordered
      expect(message).to receive(:gets).and_return("Alice").ordered
      expect(message).to receive(:puts).with("Your phone number:").ordered
      expect(message).to receive(:gets).and_return(ENV['MY_PHONE_NUMBER']).ordered
      message.get_contact
      expect(message.customer_name).to eq "Alice"
      expect(message.customer_phone_number).to eq ENV['MY_PHONE_NUMBER']
    end
  
    it "sends the confirmation to the client" do
      message_object= double(:fake_message)
      client = double(:fake_client, messages: message_object)
       allow(message_object).to receive(:create).with(
        body: "Hello Alice, thank you for your order! It was placed and will be delivered before 13:48.",
        from: ENV['MY_TWILIO_MESSAGE_SID'],
        to: ENV['MY_PHONE_NUMBER']
       )
      allow(client).to receive(:messages).and_return(message_object) 
      order = double(:fake_order, confirmed?:true)
      message = ConfirmationMessage.new(order)
      @fake_time_now = (Time.new + 1800).strftime("%k:%M")
      expect(message.arrival_time).to eq @fake_time_now
      expect(message).to receive(:puts).with("Your name:").ordered
      expect(message).to receive(:gets).and_return("Alice").ordered
      expect(message).to receive(:puts).with("Your phone number:").ordered
      expect(message).to receive(:gets).and_return(ENV['MY_PHONE_NUMBER']).ordered
      message.get_contact
      message.message
    end
  end
end