require 'gilded_rose'

describe GildedRose do
  describe '#update_quality' do
    context 'legendary item' do
      it "doesn't change nor the quality neither the sell_in date" do
        sulfuras = Item.new('Sulfuras, Hand of Ragnaros', 14, 50)
        gilded_rose = GildedRose.new([sulfuras])

        sulfuras_updated = gilded_rose.update_quality[0]

        expect(sulfuras_updated.sell_in).to eq 14
        expect(sulfuras_updated.quality).to eq 50
      end
    end

    context 'normal item' do
      apple = Item.new('Apple', 1, 4)
      gilded_rose = GildedRose.new([apple])

      it "decrease the quality by 1 before sell by date" do
        apple_updated = gilded_rose.update_quality[0]

        expect(apple_updated.sell_in).to eq 0
        expect(apple_updated.quality).to eq 3
      end

      it "decrease the quality by 2 when sell by date is passed" do
        apple_updated = gilded_rose.update_quality[0]

        expect(apple_updated.sell_in).to eq -1
        expect(apple_updated.quality).to eq 1
      end
    end
  end
end