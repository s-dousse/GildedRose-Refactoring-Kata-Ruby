require 'gilded_rose'
require 'item'

describe GildedRose do
  describe '#update_quality - single item' do
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
      apple = Item.new('Apple', 1, 3)
      gilded_rose = GildedRose.new([apple])

      it 'decrease the quality by 1 before sell by date' do
        apple_updated = gilded_rose.update_quality[0]
        expect(apple_updated.sell_in).to eq 0
        expect(apple_updated.quality).to eq 2
      end

      it 'decrease the quality by 2 when sell by date is passed' do
        apple_updated = gilded_rose.update_quality[0]

        expect(apple_updated.sell_in).to eq -1
        expect(apple_updated.quality).to eq 0
      end

      it "quality can't be negative" do
        apple_updated = gilded_rose.update_quality[0]

        expect(apple_updated.sell_in).to eq -2
        expect(apple_updated.quality).to eq 0
      end
    end

    context 'Aged Brie' do
      brie = Item.new('Aged Brie', 1, 47)
      gilded_rose = GildedRose.new([brie])

      it 'increases the quality by 1 before sell by date' do
        brie_updated = gilded_rose.update_quality[0]

        expect(brie_updated.sell_in).to eq 0
        expect(brie_updated.quality).to eq 48
      end

      it 'increases the quality by 2 when sell by date is passed' do
        brie_updated = gilded_rose.update_quality[0]

        expect(brie_updated.sell_in).to eq -1
        expect(brie_updated.quality).to eq 50
      end

      it "it can't have a quality over 50" do
        brie_updated = gilded_rose.update_quality[0]

        expect(brie_updated.sell_in).to eq -2
        expect(brie_updated.quality).to eq 50
      end
    end

    context 'Backstage Passes, item.sell_in > 11' do
      passes = Item.new('Backstage passes to a TAFKAL80ETC concert', 14, 49)
      gilded_rose = GildedRose.new([passes])

      it 'increases the quality by 1' do
        passes_updated = gilded_rose.update_quality[0]

        expect(passes_updated.sell_in).to eq 13
        expect(passes_updated.quality).to eq 50
      end

      it "can't have a quality over 50" do

        passes_updated = gilded_rose.update_quality[0]

        expect(passes_updated.sell_in).to eq 12
        expect(passes_updated.quality).to eq 50
      end
    end

    context 'Backstage Passes, item.sell_in < 11' do
      passes = Item.new('Backstage passes to a TAFKAL80ETC concert', 10, 48)
      gilded_rose = GildedRose.new([passes])

      it 'increases the quality by 2' do
        passes = Item.new('Backstage passes to a TAFKAL80ETC concert', 10, 48)
        gilded_rose = GildedRose.new([passes])

        passes_updated = gilded_rose.update_quality[0]

        expect(passes_updated.sell_in).to eq 9
        expect(passes_updated.quality).to eq 50
      end

      it "can't have a quality over 50" do
        passes_updated = gilded_rose.update_quality[0]

        expect(passes_updated.sell_in).to eq 8
        expect(passes_updated.quality).to eq 50
      end
    end

    context 'Backstage Passes, item.sell_in < 6' do
      passes = Item.new('Backstage passes to a TAFKAL80ETC concert', 5, 45)
      gilded_rose = GildedRose.new([passes])

      it 'increases the quality by 3' do
        passes_updated = gilded_rose.update_quality[0]

        expect(passes_updated.sell_in).to eq 4
        expect(passes_updated.quality).to eq 48
      end

      it "can't have a quality over 50" do
        passes_updated = gilded_rose.update_quality[0]

        expect(passes_updated.sell_in).to eq 3
        expect(passes_updated.quality).to eq 50
      end
    end

    context 'Backstage Passes, item.sell_in <= 0' do
      passes = Item.new('Backstage passes to a TAFKAL80ETC concert', 1, 30)
      gilded_rose = GildedRose.new([passes])

      it "increases the quality by 3 on the day of the concert" do
        passes_updated = gilded_rose.update_quality[0]

        expect(passes_updated.sell_in).to eq 0
        expect(passes_updated.quality).to eq 33
      end
      
      it "loses all quality after the concert" do
        passes_updated = gilded_rose.update_quality[0]

        expect(passes_updated.sell_in).to eq -1
        expect(passes_updated.quality).to eq 0
      end

      it "can't have a quality over 50" do
        passes = Item.new('Backstage passes to a TAFKAL80ETC concert', 1, 48)
        gilded_rose = GildedRose.new([passes])

        passes_updated = gilded_rose.update_quality[0]

        expect(passes_updated.sell_in).to eq 0
        expect(passes_updated.quality).to eq 50
      end
    end

    describe '#update_quality - multiple items' do
      context 'all four types' do
        it "updates all items attributes" do
          sulfuras = Item.new('Sulfuras, Hand of Ragnaros', 4, 20)
          apple = Item.new('Apple', 4, 20)
          brie = Item.new('Aged Brie', 4, 20)
          passes = Item.new('Backstage passes to a TAFKAL80ETC concert', 4, 20)
          gilded_rose = GildedRose.new([sulfuras, apple, brie, passes])

          items_updated = gilded_rose.update_quality

          expect(items_updated[0].sell_in).to eq 4  # sulfuras - legendary item
          expect(items_updated[0].quality).to eq 20

          expect(items_updated[1].sell_in).to eq 3  # apple - normal item
          expect(items_updated[1].quality).to eq 19

          expect(items_updated[2].sell_in).to eq 3  # aged brie
          expect(items_updated[2].quality).to eq 21

          expect(items_updated[3].sell_in).to eq 3  # backstage passes
          expect(items_updated[3].quality).to eq 23
        end
      end
    end
  end

  describe 'edge cases #initialize' do
    context "doesn't accept items which quality isn't within the range 0..50" do
      xit "can't have a quality over 50 to start with" do
        apple = Item.new('Apple', 10, 60)

        expect { GildedRose.new([apple]) }.to raise_error "quality can't be over 50"
      end

      xit "can't have a quality over 50 to start with" do
        brie = Item.new('brie', 10, 60)

        expect { GildedRose.new([brie]) }.to raise_error "quality can't be over 50"
      end
    end

    context 'no item can be created with negative value for quality' do
      xit "can't have a quality over 50 to start with" do
        apple = Item.new('Apple', 10, -7)

        expect { GildedRose.new([apple]) }.to raise_error "quality can't be negative"
      end

      xit "it can't have a quality over 50 to start with" do
        brie = Item.new('brie', 10, -40)

        expect { GildedRose.new([brie]) }.to raise_error "quality can't be negative"
      end
    end
  end
end