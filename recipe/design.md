{{TAKEAWAY PROJECT}} Multi-Class Planned Design Recipe

1. Describe the Problem

As a customer
So that I can check if I want to order something
I would like to see a list of dishes with prices.

As a customer
So that I can order the meal I want
I would like to be able to select some number of several available dishes.

As a customer
So that I can verify that my order is correct
I would like to see an itemised receipt with a grand total.

Use the twilio-ruby gem to implement this next one. You will need to use doubles too.

As a customer
So that I am reassured that my order will be delivered on time
I would like to receive a text such as "Thank you! Your order was placed and will be delivered before 18:52" after I have ordered.


2. Design the Class System

                  ┌────────────────────────────┐
                  │ Order                      │
                  │                            │
                  │ - adds dishes to the menu  │
                  │ - shows the menu           │
                  │ - selects dishes to order  |
                  | - shows the selection      |
                  | - confims the order        |
                  | - issues detailes receipt  |
                  └───────────┬────────────────┘
                      │                   |
                      │ owns lists of     |
                      ▼                   ▼ 
┌─────────────────────────────┐      ┌─────────────────────────────┐ 
│ Dish(dish, price)           │      │ ConfirmationMessage(order)  │
│                             │      │                             │
│ - dish                      │      │ - checks order's status     │
│ - price                     │      │ - calculates arrival time   │
│   => @dish, @price          |      │ - gets customer's name      |
| - add the dish to the menu  |      | - gets customer's name      |
| - add the dish to the order |      | - sends confirmation        |
|                             |      |   to the customer           |
└─────────────────────────────┘      └─────────────────────────────┘

class Order
  def initialize
    @menu = [] # =an array of strings
    @confirmed  #  # boolean value - true if the order has been confirmed, false if it hasn't. Initially set to false.
  end

  def add(dish) # dish - instance of the Dish class
    # add dishes to the menu
  end

  def show_menu
    # returns @menu
  end

  def select
    #fails with  "Your order has been confirmed." if the order has not been confirmed
    #selects dishes to order
  end

  def order
    #returns the order
  end

  def confirm_order
    # fails with "What would you like to order?" if the order is empty
    # changes @confirmed to true
  end

  def confirmed?
    # returns @confirmed
  end

  def bill
    # fails with "Please confirm your order." if the order has not been confirmed
    # returs thanks and an itemised receipt for the order, as well as the total
  end
end

class Dish
  def initialize(name, price)
    @name   # string
    @price   # string
    @quantity  # integer - counts number of times the dish has been added to the order
    @on_the_menu  # boolean value - true if the dish is on the menu, false if it isn't. Initially set to false.
  end

  def name
    # returns name
  end

  def price
    # returns price
  end

  def add
    # adds the dish to the order by increasing @quantity by 1
  end

  def remove
    # fails with "You have not ordered this dish" if the @quantity is 0
    # removes the dish from the order by reducing @quantity by 1 
  end

  def quantity
    # returns @quantity
  end

  def on_the_menu
    # changes @on_the_menu to true if the dish is on the menu
  end

  def off_the_menu
    # changes @on_the_menu to false if the dish is taken off the menu
  end

  def menu?
    # return @on_the_menu
  end
end

class ConfirmationMessage 
  def initialize(order)   # instance of the Order class
    # fails with  "Please confirm your order." if the order has not been confirmed
  end

  def order_status
    returns @order_status
  end

  def arrival_time
    # calculates order's arrival time given the delivery time of 30 minutes.
    # returns the value in format "12:55" or "7.40"
  end

  def get_contact
    # gets customer name and phone number to send the confirmation to
  end 

  def customer_name
    # returns @customer_name
  end 

  def customer_phone_number
    # returns @customer_phone_number
  end 

  def message
    # send the message to the customer "Hello #{@customer_name}, thank you for your order! It was placed and will be delivered before #{arrival_time}."
  end
end 


3. Create Examples as Integration Tests

Create examples of the classes being used together in different situations and combinations that reflect the ways in which the system will be used.

``` ruby
# 1
# when adding dishes to the menu, returns their names and prices in a list
order = Order.new
dish_1 = Dish.new("dish_1", "1.35")
dish_1.on_the_menu
order.add(dish_1)
dish_2 = Dish.new("dish_2", "5.99")
order.add(dish_2)
order.show_menu # => [dish_1]


# 2
# when the order basket is empty, 
# allows to add dishes and order dishes in different quantities
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
order.order # => [dish_1, dish_1, dish_2]

# 3
# when the order basket is empty, 
# fails to confirm order if no dishes were selected
order = Order.new
dish_1 = Dish.new("dish_1", "1.35")
dish_1.on_the_menu
order.add(dish_1)
dish_2 = Dish.new("dish_2", "7.50")  
dish_2.on_the_menu    
order.add(dish_2)
order.select
order.confirm_order # => raises error with "What would you like to order?"

# 4
# when there are dishes in the basket but the order has not been confirmed yet
# changes the quantity and omits dishes with 0 quantity from the order
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
order.order # => [dish_2, dish_4]
dish_4.remove
dish_3.add
order.select 
order.order # => [dish_2, dish_3]

# 5
# when there are dishes in the basket but the order has not been confirmed yet
# fails to deliver the receipt if the order has not been confirmed
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
order.bill # => raises error with "Please confirm your order."

# 6 
# when the order has been confirmed
# fails to change the order
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
order.select => # => raises error with " "Your order has been confirmed."

# 7
# when the order has been confirmed
# returns the receipt
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
order.bill # => "Thank you for your order:\ndish_1 x 2  £3.00\ndish_2 x 1  £7.50\nTotal: £10.50"

# 8
# ConfirmationMessage integration with other classes 
# initially checks the status of the order
order = Order.new
dish_1 = Dish.new("dish_1", "1.50")
dish_1.on_the_menu
dish_1.add
order.add(dish_1)
order.select
order.confirm_order
message = ConfirmationMessage.new(order)
message.order_status # => true

# 9
# fails to construct if the order has not been confirmed
order = Order.new
dish_1 = Dish.new("dish_1", "1.50")
dish_1.on_the_menu
dish_1.add
order.add(dish_1)
order.select
ConfirmationMessage.new(order) # => raises error with "Please confirm your order."

# 10
# before sending the confirmation message
#calculates arrival time for the order
order = Order.new
dish_1 = Dish.new("dish_1", "1.50")
dish_1.on_the_menu
dish_1.add
order.add(dish_1)
order.select 
order.confirm_order
message = ConfirmationMessage.new(order)
expect(message.arrival_time) # =>  Current time + 30 min 
#it has to be either manually updated or we can replace the result with a variable.  #tested both ways. 

# 11
# collects the name and the phone number of the customer
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
message.customer_name # => "Alice"
message.customer_phone_number # => ENV['MY_PHONE_NUMBER']

# 12
# sends a confirmation to the client
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
message.message # => "Hello Alice, thank you for your order! It was placed and will be delivered before 13:48."
# message received to my phone with correct time

```
4. Create Examples as Unit Tests

```ruby

class Dish 

# 1
# constructs
dish = Dish.new("dish", "1.35")
dish.name # => "dish"
dish.price # => "1.35"

# 2
# when changing quantity, adds quantity
dish = Dish.new("dish", "1.35")
dish.add # => 1
dish.add # => 2

# 3
# when changing quantity,removes quantity
dish = Dish.new("dish", "1.35")
dish.add # => 1
dish.remove # => 0

# 4
# it fails if the quanity is 0 when trying to remove a dish
dish = Dish.new("dish", "1.35")
expect(dish.add).to eq 1
expect(dish.remove).to eq 0
dish.remove # => raises error "You have not ordered this dish"

# 5
# when adding the dish to the menu, changes on_the_menu value to true
dish = Dish.new("dish", "1.35")
dish.on_the_menu 
dish.menu? # => true

# 6 when taking the dish off the menu, changes on_the_menu value to false
dish = Dish.new("dish", "1.35")
dish.on_the_menu 
dish.menu? # => true
dish.off_the_menu
dish.menu? # => false

class Order

# 1
# initially contructs
order = Order.new
order.show_menu # => []

# 2
# when adding dishes, adds and returns only those that should be on the menu
order = Order.new
dish_1 = double(:fake_dish_1, name: "dish_1", price: "1.35", menu?: true)
order.add(dish_1)
dish_2 = double(:fake_dish_2, name: "dish_2", price: "6.50", menu?: false)
order.add(dish_2)
order.show_menu # => [dish_1]

# 3
# when the order basket is empty, allows to add dishes and order dishes in different quantities
order = Order.new
dish_1 = double(:fake_dish_1, name: "dish_1", price: "1.35", menu?: true, quantity: 2)
order.add(dish_1)
dish_2 = double(:fake_dish_2, name: "dish_2", price: "7.50", menu?: true, quantity: 1)
order.add(dish_2)
dish_3 = double(:fake_dish_3, name: "dish_3", price: "2.50", menu?: true, quantity: 0)
order.add(dish_3)
order.select
order.order # => [dish_1, dish_1, dish_2]

# 4
# fails to confirm order if no dishes were selected
order = Order.new
dish_1 = double(:fake_dish_1, name: "dish_1", price: "1.35", menu?: true, quantity: 0)
order.add(dish_1)
dish_2 = double(:fake_dish_2, name: "dish_2", price: "7.50", menu?: true, quantity: 0)      
order.add(dish_2)
order.select
order.confirm_order # => raises error with "What would you like to order?"

# 5
# when there are dishes in the basket but the order has not been confirmed yet
# fails to deliver the receipt if the order has not been confirmed
order = Order.new
dish_1 = double(:fake_dish_1, name: "dish_1", price: "1.50", menu?: true, quantity: 2)
order.add(dish_1)
dish_2 = double(:fake_dish_2, name: "dish_2", price: "7.50", menu?: true, quantity: 1)      
order.add(dish_2)
order.select
order.bill # => raises error with "Please confirm your order."


# 6
# when the order has been confirmed
# fails to change the order
order = Order.new
dish_1 = double(:fake_dish_1, name: "dish_1", price: "1.35", menu?: true, quantity: 2)
order.add(dish_1)
dish_2 = double(:fake_dish_2, name: "dish_2", price: "7.50", menu?: true, quantity: 1)      
order.add(dish_2)
order.select
order.confirm_order
order.select # => raises_error "Your order has been confirmed."

# 7
# returns the detailed receipt
order = Order.new
dish_1 = double(:fake_dish_1, name: "dish_1", price: "1.50", menu?: true, quantity: 2)
order.add(dish_1)
dish_2 = double(:fake_dish_2, name: "dish_2", price: "7.50", menu?: true, quantity: 1)      
order.add(dish_2)
order.select 
order.confirm_order
order.bill => "Thank you for your order:\ndish_1 x 2  £3.00\ndish_2 x 1  £7.50\nTotal: £10.50"


class ConfirmationMessage

# 1
# initially check the status of the order
order = double(:fake_order, confirmed?:true)
message = ConfirmationMessage.new(order)
message.order_status # => true

# 2
# fails to construct if the order has not been confirmed 
order = double(:fake_order, confirmed?: false)
ConfirmationMessage.new(order) # => raises error with "Please confirm your order."

# 3 
# before sending the confirmation message
# calculates arrival time for the order
order = double(:fake_order, confirmed?:true)
message = ConfirmationMessage.new(order)
expect(message.arrival_time) # =>  Current time + 30 min 
#it has to be either manually updated or we can replace the result with a variable.  #tested both ways. 

# 4
# collects the name and the phone number of the customer
order = double(:fake_order, confirmed?:true)
message = ConfirmationMessage.new(order)
expect(message).to receive(:puts).with("Your name:").ordered
expect(message).to receive(:gets).and_return("Alice").ordered
expect(message).to receive(:puts).with("Your phone number:").ordered
expect(message).to receive(:gets).and_return(ENV['MY_PHONE_NUMBER']).ordered
message.get_contact
message.customer_name # => "Alice"
message.customer_phone_number # => ENV['MY_PHONE_NUMBER']


# 5
# sends the confirmation to the client 
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
message.message # => "Hello Alice, thank you for your order! It was placed and will be delivered before 13:48."

# run the program and reeived message to my phone with correct timing.
```

5. Implement the Behaviour

After each test you write, follow the test-driving process of red, green, refactor to implement the behaviour.

