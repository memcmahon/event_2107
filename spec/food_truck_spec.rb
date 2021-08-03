require './lib/item'
require './lib/food_truck'

RSpec.describe FoodTruck do
  before :each do
    @item1 = Item.new({name: 'Peach Pie (Slice)', price: "$3.76"})
    @item2 = Item.new({name: 'Apple Pie (Slice)', price: '$2.22'})
    @food_truck = FoodTruck.new("Rocky Mountain Pies")
  end

  it 'exists and has attributes' do
    expect(@food_truck).to be_a(FoodTruck)
    expect(@food_truck.name).to eq("Rocky Mountain Pies")
    expect(@food_truck.inventory).to eq({})
  end

  it 'stocks items' do
    @food_truck.stock(@item1, 30)

    expect(@food_truck.inventory).to eq({@item1 => 30})

    @food_truck.stock(@item1, 25)
    @food_truck.stock(@item2, 12)

    expect(@food_truck.inventory).to eq({@item1 => 55, @item2 => 12})
  end

  it 'can check stock' do
    expect(@food_truck.check_stock(@item1)).to eq(0)

    @food_truck.stock(@item1, 25)
    @food_truck.stock(@item2, 12)

    expect(@food_truck.check_stock(@item1)).to eq(25)
    expect(@food_truck.check_stock(@item2)).to eq(12)
  end

  it 'can determine potential_revenue' do
    @food_truck.stock(@item1, 25)
    @food_truck.stock(@item2, 12)

    expected = (@item1.price * @food_truck.check_stock(@item1)) + (@item2.price * 12)

    expect(@food_truck.potential_revenue).to eq(expected)
  end
end
