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
            else
              decrease_quality(i)
            end
          elsif updatable?(i)
            case item.name
              when 'Aged Brie'
                item.quality += 1
                item.quality += 1 if updatable?(i)
              when 'Backstage passes to a TAFKAL80ETC concert'
                item.quality -= item.quality
              else
                decrease_quality(i, 2)
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

