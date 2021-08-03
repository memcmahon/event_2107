class FoodTruck
  attr_reader :name, :inventory

  def initialize(name)
    @name = name
    #option 0/1
    # @inventory = {}

    #option 2
    @inventory = Hash.new(0)
  end

  def stock(item, amount)
    #option 0
    # if @inventory[item].nil?
    #   @inventory[item] = amount
    # else
    #   @inventory[item] += amount
    # end

    #option 1
    # @inventory[item] ||= 0 #check to see if that key exists, if not, set to 0
    # @inventory[item] += amount

    #option 2
    @inventory[item] += amount
  end

  def check_stock(item)
    @inventory[item]
  end

  def potential_revenue
    @inventory.sum do |item, qty|
      item.price * qty
    end
  end

  def sell(item, amount)
    @inventory[item] -= amount
  end
end
