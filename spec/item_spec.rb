require './lib/item'

RSpec.describe Item do
  before :each do
    @item = Item.new({name: 'Peach Pie (Slice)', price: "$3.75"})
  end

  it 'exists and has attributes' do
    expect(@item).to be_a(Item)
    expect(@item.name).to eq('Peach Pie (Slice)')
    expect(@item.price).to eq(3.75)
  end
end
