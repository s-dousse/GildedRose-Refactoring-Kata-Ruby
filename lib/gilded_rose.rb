class GildedRose
  attr_reader :name, :sell_in, :quality
  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |item|
      unless item.name == 'Sulfuras, Hand of Ragnaros'
          case item.name
            when 'Aged Brie'
              item.quality += 1 if (item.quality < 50)
            when 'Backstage passes to a TAFKAL80ETC concert'
              item.quality += 1 if (item.quality < 50)
              item.quality += 1 if item.sell_in < 11 && (item.quality < 50)
              item.quality += 1 if item.sell_in < 6 && (item.quality < 50)
            else # normal items
              item.quality -= 1 if item.quality > 0
          end
        # a day passes
        item.sell_in -= 1
        
        # if sell_by date is passed
        if item.sell_in < 0
          case item.name
            when 'Aged Brie'
              item.quality += 1 if (item.quality < 50)
              item.quality += 1 if (item.quality < 49)
            when 'Backstage passes to a TAFKAL80ETC concert'
              item.quality -= item.quality
            else # normal items
              item.quality -= 1 if item.quality > 0
          end
        end
        # end of if sell_by date is passed
      end
    end
  end
end
