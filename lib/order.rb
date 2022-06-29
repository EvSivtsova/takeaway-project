class Order
  def initialize
    @menu = []
    @confirmed = false
  end

  def add(dish)
    if dish.menu?
      @menu << dish
    end
  end

  def show_menu
    @menu
  end

  def select
    fail  "Your order has been confirmed." if @confirmed == true
    @order = []
    @menu.map do |dish|
      quantity = dish.quantity
      until quantity == 0
        @order << dish 
        quantity -= 1
      end
    end 
    # return @order
  end

  def order
    return @order
  end

  def confirm_order
    fail "What would you like to order?" if @order.empty?
    @confirmed = true
  end

  def confirmed?
    @confirmed
  end

  def bill
    fail "Please confirm your order." if @confirmed == false
    bill = ""
    bill += "Thank you for your order:\n"
    @total_price = 0
    @order.uniq.map do |dish|
      bill += "#{dish.name} x #{dish.quantity}  £#{'%.2f' % (dish.price.to_f.round(2) * dish.quantity)}\n"
      @total_price += (dish.price.to_f.round(2) * dish.quantity)
    end
    bill += "Total: £#{'%.2f' % @total_price}"
    return bill
  end
end