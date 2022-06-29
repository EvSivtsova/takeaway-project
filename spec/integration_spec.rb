require "dish"
require "order"
require "confirmation_message"

describe "integration" do
  context "when adding dishes to the menu" do
    it "returns their names and prices in a list" do
      order = Order.new
      dish_1 = Dish.new("dish_1", "1.35")
      dish_1.on_the_menu
      order.add(dish_1)
      dish_2 = Dish.new("dish_2", "5.99")
      order.add(dish_2)
      expect(order.show_menu).to eq [dish_1]
    end
  end

  context "when the order basket is empty" do
    it "allows to add dishes and order dishes in different quantities" do
      order = Order.new
      dish_1 = Dish.new("dish_1", "1.35")
      dish_1.on_the_menu
      dish_1.add
      dish_1.add
      order.add(dish_1)
      dish_2 = Dish.new("dish_2", "7.50")
      dish_2.on_the_menu
      dish_2.add
      order.add(dish_2)
      dish_3 = Dish.new("dish_3", "2.50")
      dish_3.on_the_menu
      order.add(dish_3)
      order.select
      expect(order.order).to eq [dish_1, dish_1, dish_2]
    end

    it "fails to confirm order if no dishes were selected" do
      order = Order.new
      dish_1 = Dish.new("dish_1", "1.35")
      dish_1.on_the_menu
      order.add(dish_1)
      dish_2 = Dish.new("dish_2", "7.50")  
      dish_2.on_the_menu    
      order.add(dish_2)
      order.select
      expect { order.confirm_order }.to raise_error "What would you like to order?"
    end
  end

  context "when there are dishes in the basket but the order has not been confirmed yet" do
    it "changes the quantity and omits dishes with 0 quantity from the order" do
      order = Order.new
      dish_1 = Dish.new("dish_1", "1.35")
      dish_1.on_the_menu
      dish_1.add
      dish_1.remove
      order.add(dish_1)
      dish_2 = Dish.new("dish_2", "7.50")
      dish_2.on_the_menu
      dish_2.add
      order.add(dish_2)
      dish_3 = Dish.new("dish_3", "2.50")
      dish_3.on_the_menu
      order.add(dish_3)
      dish_4 = Dish.new("dish_4", "11.00")
      dish_4.on_the_menu
      dish_4.add
      dish_4.remove
      dish_4.add
      order.add(dish_4)
      order.select
      expect(order.order).to eq [dish_2, dish_4]
      dish_4.remove
      dish_3.add
      order.select
      expect(order.order).to eq [dish_2, dish_3]
    end

    it "fails to deliver the receipt if the order has not been confirmed" do
      order = Order.new
      dish_1 = Dish.new("dish_1", "1.50")
      dish_1.on_the_menu
      dish_1.add
      dish_1.add
      order.add(dish_1)
      dish_2 = Dish.new("dish_2", "7.50")
      dish_2.on_the_menu
      dish_2.add
      order.add(dish_2)
      order.select
      expect { order.bill }.to raise_error "Please confirm your order."
    end
  end

  context "when the order has been confirmed" do
    it "fails to change the order" do
      order = Order.new
      dish_1 = Dish.new("dish_1", "1.35")
      dish_1.on_the_menu
      dish_1.add
      dish_1.remove
      order.add(dish_1)
      dish_2 = Dish.new("dish_2", "7.50")
      dish_2.on_the_menu
      dish_2.add
      order.add(dish_2)
      order.select
      order.confirm_order
      expect {order.select}.to raise_error "Your order has been confirmed."
    end

    it "returns the receipt" do
      order = Order.new
      dish_1 = Dish.new("dish_1", "1.50")
      dish_1.on_the_menu
      dish_1.add
      dish_1.add
      order.add(dish_1)
      dish_2 = Dish.new("dish_2", "7.50")
      dish_2.on_the_menu
      dish_2.add
      order.add(dish_2)
      order.select
      order.confirm_order
      expect(order.bill).to eq "Thank you for your order:\ndish_1 x 2  £3.00\ndish_2 x 1  £7.50\nTotal: £10.50"
    end
  end

  describe "ConfirmationMessage integration with other classes" do
    context "initially" do
      it "checks the status of the order" do
        order = Order.new
        dish_1 = Dish.new("dish_1", "1.50")
        dish_1.on_the_menu
        dish_1.add
        order.add(dish_1)
        order.select
        order.confirm_order
        message = ConfirmationMessage.new(order)
        expect(message.order_status).to eq true
      end
  
      it "fails to construct if the order has not been confirmed" do
        order = Order.new
        dish_1 = Dish.new("dish_1", "1.50")
        dish_1.on_the_menu
        dish_1.add
        order.add(dish_1)
        order.select
        expect {ConfirmationMessage.new(order)}.to raise_error "Please confirm your order."
      end
    end
  
    context "before sending the confirmation message" do
      it "calculates arrival time for the order" do
        order = Order.new
        dish_1 = Dish.new("dish_1", "1.50")
        dish_1.on_the_menu
        dish_1.add
        order.add(dish_1)
        order.select
        order.confirm_order
        message = ConfirmationMessage.new(order)
        @fake_time_now = (Time.new + 1800).strftime("%k:%M")
        # @fake_time_now = (Time.new(2022, 06, 29, 13, 18, 30) + 1800).strftime("%k:%M")
        # expect(message.arrival_time).to eq "13:48"
        expect(message.arrival_time).to eq "#{@fake_time_now}" #tested both ways. it has to be either manually updated or we can replace the result with @fake_time_now
      end
  
      it "collects the name and the phone number of the customer" do
        order = Order.new
        dish_1 = Dish.new("dish_1", "1.50")
        dish_1.on_the_menu
        dish_1.add
        order.add(dish_1)
        order.select
        order.confirm_order
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
        order = Order.new
        dish_1 = Dish.new("dish_1", "1.50")
        dish_1.on_the_menu
        dish_1.add
        order.add(dish_1)
        order.select
        order.confirm_order
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
end
