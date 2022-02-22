class GildedRose
  attr_reader :name, :sell_in, :quality

  MIN_QUALITY = 0;
  MAX_QUALITY = 50;

  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each_with_index do |item, i|
      unless item.name == 'Sulfuras, Hand of Ragnaros'
        if updatable?(i)
          case item.name
            when 'Aged Brie'
              item.quality += 1
            when 'Backstage passes to a TAFKAL80ETC concert'
              item.quality += 1
              item.quality += 1 if item.sell_in < 11 && updatable?(i)
              item.quality += 1 if item.sell_in < 6  && updatable?(i)
            else
              item.quality -= 1
            end
        end
          
        item.sell_in -= 1

          if item.sell_in < 0 && updatable?(i)
            case item.name
              when 'Aged Brie'
                item.quality += 1
                item.quality += 1 if updatable?(i)
              when 'Backstage passes to a TAFKAL80ETC concert'
                item.quality -= item.quality
              else
                item.quality -= 1
            end
          end

      end
    end
  end

  def updatable?(i)
    @items[i].quality > MIN_QUALITY && @items[i].quality < MAX_QUALITY
  end
end

