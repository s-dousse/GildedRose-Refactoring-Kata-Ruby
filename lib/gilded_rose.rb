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
        if item.sell_in > 0 && updatable?(i)
          case item.name
            when 'Aged Brie'
              increase_quality(i)
            when 'Backstage passes to a TAFKAL80ETC concert'
              if item.sell_in < 6
                item.quality < 48 ? increase_quality(i, 3) : set_max_quality(i)
              elsif item.sell_in < 11
                item.quality < 49 ? increase_quality(i, 2) : set_max_quality(i)
              else
                increase_quality(i)
              end
            when 'Conjured Item'
              item.quality < 49 ? decrease_quality(i, 2) : lose_all_quality(i)
            else
              decrease_quality(i)
            end
          elsif updatable?(i)
            case item.name
              when 'Aged Brie'
                increase_quality(i, 2) if item.quality < 50
              when 'Backstage passes to a TAFKAL80ETC concert'
                lose_all_quality(i)
              when 'Conjured Item'
                item.quality > 4 ? decrease_quality(i, 4) : lose_all_quality(i)
              else
                item.quality < 49 ? decrease_quality(i, 2) : lose_all_quality(i)
            end
        end
        item.sell_in -= 1
      end
    end
  end

  def lose_all_quality(i)
    @items[i].quality = 0
  end

  def set_max_quality(i)
    @items[i].quality = 50
  end

  def increase_quality(index, num = 1)
    @items[index].quality += num
  end

  def decrease_quality(index, num = 1)
    @items[index].quality -= num
  end

  def updatable?(i)
    @items[i].quality > MIN_QUALITY && @items[i].quality < MAX_QUALITY
  end
end

