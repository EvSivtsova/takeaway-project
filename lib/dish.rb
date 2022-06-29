class Dish
  def initialize(name, price)
    @name = name
    @price = price
    @quantity = 0
    @on_the_menu = false
  end

  def name
    @name
  end

  def price
    @price
  end

  def add
    @quantity +=1
  end

  def remove
    fail "You have not ordered this dish" if @quantity == 0
    @quantity -=1
  end

  def quantity
    @quantity
  end

  def on_the_menu
    @on_the_menu = true
  end

  def off_the_menu
    @on_the_menu = false
  end

  def menu?
    return @on_the_menu
  end
end
