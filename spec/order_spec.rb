require "order"

describe Order do
  context "initially" do
    it "contructs" do
      order = Order.new
      expect(order.show_menu).to eq []
    end
  end

  context "when adding dishes" do
    it "adds and returns only those that should be on the menu" do
      order = Order.new
      dish_1 = double(:fake_dish_1, name: "dish_1", price: "1.35", menu?: true)
      order.add(dish_1)
      dish_2 = double(:fake_dish_2, name: "dish_2", price: "6.50", menu?: false)
      order.add(dish_2)
      expect(order.show_menu).to eq [dish_1]
    end
  end

  context "when the order basket is empty" do
    it "allows to add dishes and order dishes in different quantities" do
      order = Order.new
      dish_1 = double(:fake_dish_1, name: "dish_1", price: "1.35", menu?: true, quantity: 2)
      order.add(dish_1)
      dish_2 = double(:fake_dish_2, name: "dish_2", price: "7.50", menu?: true, quantity: 1)
      order.add(dish_2)
      dish_3 = double(:fake_dish_3, name: "dish_3", price: "2.50", menu?: true, quantity: 0)
      order.add(dish_3)
      order.select
      expect(order.order).to eq [dish_1, dish_1, dish_2]
    end

    it "fails to confirm order if no dishes were selected" do
      order = Order.new
      dish_1 = double(:fake_dish_1, name: "dish_1", price: "1.35", menu?: true, quantity: 0)
      order.add(dish_1)
      dish_2 = double(:fake_dish_2, name: "dish_2", price: "7.50", menu?: true, quantity: 0)      
      order.add(dish_2)
      order.select
      expect { order.confirm_order }.to raise_error "What would you like to order?"
    end
  end

  context "when there are dishes in the basket but the order has not been confirmed yet" do
    it "fails to deliver the receipt if the order has not been confirmed" do
      order = Order.new
      dish_1 = double(:fake_dish_1, name: "dish_1", price: "1.50", menu?: true, quantity: 2)
      order.add(dish_1)
      dish_2 = double(:fake_dish_2, name: "dish_2", price: "7.50", menu?: true, quantity: 1)      
      order.add(dish_2)
      order.select
      expect { order.bill }.to raise_error "Please confirm your order."
    end
  end

  context "when the order has been confirmed" do
    it "fails to change the order" do
      order = Order.new
      dish_1 = double(:fake_dish_1, name: "dish_1", price: "1.35", menu?: true, quantity: 2)
      order.add(dish_1)
      dish_2 = double(:fake_dish_2, name: "dish_2", price: "7.50", menu?: true, quantity: 1)      
      order.add(dish_2)
      order.select
      order.confirm_order
      expect {order.select}.to raise_error "Your order has been confirmed."
    end

    it "returns the detailed receipt" do
      order = Order.new
      dish_1 = double(:fake_dish_1, name: "dish_1", price: "1.50", menu?: true, quantity: 2)
      order.add(dish_1)
      dish_2 = double(:fake_dish_2, name: "dish_2", price: "7.50", menu?: true, quantity: 1)      
      order.add(dish_2)
      order.select
      order.confirm_order
      expect(order.bill).to eq "Thank you for your order:\ndish_1 x 2  £3.00\ndish_2 x 1  £7.50\nTotal: £10.50"
    end
  end
end

 