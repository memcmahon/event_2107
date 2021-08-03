require 'date'

class Event
  attr_reader :name, :food_trucks, :date

  def initialize(name)
    @name = name
    @food_trucks = []
    @date = Date.today.strftime("%d/%m/%Y")
  end

  def add_food_truck(truck)
    @food_trucks << truck
  end

  def food_truck_names
    @food_trucks.map do |truck|
      truck.name
    end
  end

  def food_trucks_that_sell(item)
    @food_trucks.find_all do |truck|
      truck.check_stock(item) > 0
    end
  end

  def total_inventory
    total_inventory = {}
    #set up keys with values of 'TBD'
    @food_trucks.each do |truck|
      truck.inventory.each do |item, qty|
        total_inventory[item] ||= {
          quantity: 0,
          food_trucks: []
        }
        total_inventory[item][:quantity] += qty
        total_inventory[item][:food_trucks] << truck
      end
    end
    total_inventory

    # total_inventory = {}
    # all_items = @food_trucks.map do |truck|
    #   truck.inventory.keys
    # end.flatten.uniq
    #
    # all_items.each do |item|
    #   total_inventory[item] = {
    #     quantity: food_trucks_that_sell(item).sum { |truck| truck.check_stock(item) },
    #     food_trucks: food_trucks_that_sell(item)
    #   }
    # end
    # total_inventory
  end

  def overstocked_items
    overstocked_items = []
    total_inventory.each do |item, info|
      if info[:quantity] > 50 && info[:food_trucks].length > 1
        overstocked_items << item
      end
    end
    overstocked_items
  end

  def sorted_item_list
    sorted_items = total_inventory.keys.sort_by do |item|
      item.name
    end
    sorted_items.map do |item|
      item.name
    end
  end

  def sell(item, amount)
    return false if total_inventory[item].nil?
    return false if total_inventory[item][:quantity] < amount
    food_trucks_that_sell(item).each do |truck|
      if truck.check_stock(item) >= amount
        # binding.pry
        truck.sell(item, amount)
        amount -= amount
      else
        # binding.pry
        stock = truck.check_stock(item)
        truck.sell(item, stock)
        amount -= stock
      end
    end
    true
  end
end
