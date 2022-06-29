require "dish"

describe Dish do
  it "constructs" do
    dish = Dish.new("dish", "1.35")
    expect(dish.name).to eq "dish"
    expect(dish.price).to eq "1.35"
  end

  context "when changing quantity" do
    it "adds quantity" do
      dish = Dish.new("dish", "1.35")
      expect(dish.add).to eq 1
      expect(dish.add).to eq 2
    end

    it "removes quantity" do
      dish = Dish.new("dish", "1.35")
      expect(dish.add).to eq 1
      expect(dish.remove).to eq 0
    end

    it "fails if the quanity is 0 when trying to remove a dish" do
      dish = Dish.new("dish", "1.35")
      expect(dish.add).to eq 1
      expect(dish.remove).to eq 0
      expect { dish.remove }.to raise_error "You have not ordered this dish"
    end
  end

  context "when adding the dish to the menu" do
    it "changes on_the_menu value to true" do
      dish = Dish.new("dish", "1.35")
      dish.on_the_menu
      expect(dish.menu?).to eq true
    end
  end

  context "when taking the dish off the menu" do
    it "changes on_the_menu value to false" do
      dish = Dish.new("dish", "1.35")
      dish.on_the_menu
      expect(dish.menu?).to eq true
      dish.off_the_menu
      expect(dish.menu?).to eq false
    end
  end
end
