class GildedRose
  attr_reader :name, :sell_in, :quality
  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |item|
      unless item.name == 'Sulfuras, Hand of Ragnaros'
    # if normal item decrese quality by 1 
        if item.name != 'Aged Brie' and item.name != 'Backstage passes to a TAFKAL80ETC concert'
          # normal item if quality < 0 no change
          item.quality = item.quality - 1 if item.quality > 0
        elsif item.quality < 50
          # aged brie and backstage passes +1
          item.quality = item.quality + 1
          if item.name == 'Backstage passes to a TAFKAL80ETC concert'
            # backstage passes + 1 if sell_in <
            item.quality = item.quality + 1 if item.sell_in < 11 && (item.quality < 50)
            # backstage passes + 1 if sell_in <
            item.quality = item.quality + 1 if item.sell_in < 6 && (item.quality < 50)
          end
        end
    # end of normal item decrese quality by 1 

        # a day passes
        item.sell_in = item.sell_in - 1
        
    # if sell_by date is passed
        if item.sell_in < 0
          if item.name != 'Aged Brie'
            if item.name != 'Backstage passes to a TAFKAL80ETC concert'
              # if normal item decrese quality by 1
              item.quality = item.quality - 1 if item.quality > 0
            else
              # if backstage passes  quality == 0
              item.quality = item.quality - item.quality
            end
          elsif item.quality < 50
            item.quality = item.quality + 1
          end
        end
    # end of if sell_by date is passed
      end
    end
  end
end
