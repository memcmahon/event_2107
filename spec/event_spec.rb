require './lib/item'
require './lib/food_truck'
require './lib/event'
require 'pry'

RSpec.describe Event do
  before :each do
    allow(Date).to receive(:today).and_return(Date.new(2020, 01, 24))
    @event = Event.new("South Pearl Street Farmers Market")
    @food_truck1 = FoodTruck.new("Rocky Mountain Pies")
    @food_truck2 = FoodTruck.new("Ba-Nom-a-Nom")
    @food_truck3 = FoodTruck.new("Palisade Peach Shack")
    @item1 = Item.new({name: 'Peach Pie (Slice)', price: "$3.75"})
    @item2 = Item.new({name: 'Apple Pie (Slice)', price: '$2.50'})
    @item3 = Item.new({name: "Peach-Raspberry Nice Cream", price: "$5.30"})
    @item4 = Item.new({name: "Banana Nice Cream", price: "$4.25"})
  end

  it 'exists and has attributes' do
    expect(@event).to be_a(Event)
    expect(@event.name).to eq("South Pearl Street Farmers Market")
    expect(@event.food_trucks).to eq([])
    expect(@event.date).to eq('24/01/2020')
  end

  it 'can add food_trucks' do
    @event.add_food_truck(@food_truck1)
    @event.add_food_truck(@food_truck2)
    @event.add_food_truck(@food_truck3)

    expect(@event.food_trucks).to eq([@food_truck1, @food_truck2, @food_truck3])
  end

  context 'with food trucks (with items) added' do
    before :each do
      @event.add_food_truck(@food_truck1)
      @event.add_food_truck(@food_truck2)
      @event.add_food_truck(@food_truck3)
      @food_truck1.stock(@item1, 35)
      @food_truck1.stock(@item2, 7)
      @food_truck2.stock(@item4, 55)
      @food_truck2.stock(@item3, 25)
      @food_truck3.stock(@item1, 65)
    end

    it 'can list food truck names' do
      expect(@event.food_truck_names).to eq(["Rocky Mountain Pies", "Ba-Nom-a-Nom", "Palisade Peach Shack"])
    end

    it 'can list food trucks that stock specific items' do
      expect(@event.food_trucks_that_sell(@item1)).to eq([@food_truck1, @food_truck3])
      expect(@event.food_trucks_that_sell(@item4)).to eq([@food_truck2])
    end

    it 'can report total inventory' do
      expected = {
        @item1 => {
          quantity: @event.food_trucks.sum { |truck| truck.check_stock(@item1) },
          food_trucks: @event.food_trucks_that_sell(@item1)
        },
        @item2 => {
          quantity: @event.food_trucks.sum { |truck| truck.check_stock(@item2) },
          food_trucks: @event.food_trucks_that_sell(@item2)
        },
        @item3 => {
          quantity: @event.food_trucks.sum { |truck| truck.check_stock(@item3) },
          food_trucks: @event.food_trucks_that_sell(@item3)
        },
        @item4 => {
          quantity: @event.food_trucks.sum { |truck| truck.check_stock(@item4) },
          food_trucks: @event.food_trucks_that_sell(@item4)
        },
      }
      # binding.pry
      expect(@event.total_inventory).to eq(expected)
    end

    it 'can report overstocked items' do
      expect(@event.overstocked_items).to eq([@item1])
    end

    it 'can get item names sorted ascending' do
      expect(@event.sorted_item_list).to eq(["Apple Pie (Slice)", "Banana Nice Cream", "Peach Pie (Slice)", "Peach-Raspberry Nice Cream"])
    end
  end

  context 'selling items' do
    before :each do
      @item1 = Item.new({name: 'Peach Pie (Slice)', price: "$3.75"})
      @item2 = Item.new({name: 'Apple Pie (Slice)', price: '$2.50'})
      @item3 = Item.new({name: "Peach-Raspberry Nice Cream", price: "$5.30"})
      @item4 = Item.new({name: "Banana Nice Cream", price: "$4.25"})
      @item5 = Item.new({name: 'Onion Pie', price: '$25.00'})
      @event = Event.new("South Pearl Street Farmers Market")
      @food_truck1 = FoodTruck.new("Rocky Mountain Pies")
      @food_truck2 = FoodTruck.new("Ba-Nom-a-Nom")
      @food_truck3 = FoodTruck.new("Palisade Peach Shack")
      @food_truck1.stock(@item1, 35)
      @food_truck1.stock(@item2, 7)
      @food_truck2.stock(@item4, 50)
      @food_truck2.stock(@item3, 25)
      @food_truck2.stock(@item1, 25)
      @food_truck3.stock(@item1, 65)
      @event.add_food_truck(@food_truck1)
      @event.add_food_truck(@food_truck2)
      @event.add_food_truck(@food_truck3)
    end

    it 'can not sell an item if not enough total inventory' do
      expect(@event.sell(@item1, 200)).to eq(false)
    end

    it 'can not sell an item that is not in stock at any truck' do
      expect(@event.sell(@item5, 1)).to eq(false)
    end

    it 'can sell an item that is in stock in enough quantity from one truck' do
      expect(@event.sell(@item4, 5)).to eq(true)
      expect(@food_truck2.check_stock(@item4)).to eq(45)
    end

    it 'can sell an item that is in stock in enough quantity from multiple trucks' do
      expect(@event.sell(@item1, 40)).to eq(true)
      expect(@food_truck1.check_stock(@item1)).to eq(0)
      expect(@food_truck2.check_stock(@item1)).to eq(20)
      expect(@food_truck3.check_stock(@item1)).to eq(65)
    end
  end
end
