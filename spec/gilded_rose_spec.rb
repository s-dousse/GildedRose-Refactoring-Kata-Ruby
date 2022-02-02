require 'gilded_rose'

describe GildedRose do
  describe '#update_quality' do
    context 'legendary item' do
      it "doesn't change nor the quality neither the sell_in date" do
        sulfuras = double('legendary_item')
        allow(sulfuras).to receive(:name).and_return('Sulfuras, Hand of Ragnaros')
        allow(sulfuras).to receive(:quality).and_return(50)
        allow(sulfuras).to receive(:sell_in).and_return(14)
        gilded_rose = GildedRose.new([sulfuras])

        gilded_rose.update_quality

        expect(sulfuras.quality).to eq 50
        expect(sulfuras.sell_in).to eq 14
      end
    end
  end
end