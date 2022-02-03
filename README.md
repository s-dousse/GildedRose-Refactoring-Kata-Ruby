# Gilded rose tech test

This is a well known kata developed by [Terry Hughes](http://iamnotmyself.com/2011/02/13/refactor-this-the-gilded-rose-kata/). This is commonly used as a tech test to assess a candidate's ability to read, refactor and extend legacy code.

Here is the text of the kata:

\*"Hi and welcome to team Gilded Rose. As you know, we are a small inn with a prime location in a prominent city run by a friendly innkeeper named Allison. We also buy and sell only the finest goods. Unfortunately, our goods are constantly degrading in quality as they approach their sell by date. We have a system in place that updates our inventory for us. It was developed by a no-nonsense type named Leeroy, who has moved on to new adventures. Your task is to add the new feature to our system so that we can begin selling a new category of items. First an introduction to our system:

All items have a `SellIn` value which denotes the number of days we have to sell the item. All items have a Quality value which denotes how valuable the item is. At the end of each day our system lowers both values for every item. Pretty simple, right? Well this is where it gets interesting:

- Once the sell by date has passed, Quality degrades twice as fast
- The Quality of an item is never negative
- “Aged Brie” actually increases in Quality the older it gets
- The Quality of an item is never more than 50
- “Sulfuras”, being a legendary item, never has to be sold or decreases in Quality
- “Backstage passes”, like aged brie, increases in Quality as it’s `SellIn` value approaches; Quality increases by 2 when there are 10 days or less and by 3 when there are 5 days or less but Quality drops to 0 after the concert

We have recently signed a supplier of conjured items. This requires an update to our system:

- “Conjured” items degrade in Quality twice as fast as normal items

Feel free to make any changes to the `UpdateQuality` method and add any new code as long as everything still works correctly. However, do not alter the Item class or Items property as those belong to the goblin in the corner who will insta-rage and one-shot you as he doesn’t believe in shared code ownership (you can make the `UpdateQuality` method and Items property static if you like, we’ll cover for you)."\*

## The brief:

Choose [legacy code](https://github.com/emilybache/GildedRose-Refactoring-Kata) (translated by Emily Bache) in the language of your choice. The aim is to practice good design in the language of your choice. Refactor the code in such a way that adding the new "conjured" functionality is easy.

You don't need to clone the repo if you don't want to. Feel free to copy [the ruby code](https://github.com/emilybache/GildedRose-Refactoring-Kata/blob/main/ruby/gilded_rose.rb) into a new folder and write your tests from scratch.

HINT: Test first FTW!

## Approach

I made a small feature test to see how items are updated:

- update the items twice to see exactly what happens when the sell by date is passed
- include a 'normal' item like an Apple to see how the #update_quality would deal with it.

```
___________________our items
Apple, 1, 30
Backstage passes to a TAFKAL80ETC concert, 1, 30
Sulfuras, Hand of Ragnaros, 1, 30
Aged Brie, 1, 20
___________________updated
Apple, 0, 29
Backstage passes to a TAFKAL80ETC concert, 0, 33
Sulfuras, Hand of Ragnaros, 1, 30
Aged Brie, 0, 21
___________________updated again
Apple, -1, 27
Backstage passes to a TAFKAL80ETC concert, -1, 0
Sulfuras, Hand of Ragnaros, 1, 30
Aged Brie, -1, 23
```

I then made a diagram based on my observations:

![Diagram: how do items update?](./img/Screenshot%202022-02-02%20at%2017.55.12.png)

This helps me figure out a pattern for the udated_quality

- **Sulfuras, Hand of Ragnaros**' attributes stay the same all the time
  add unless statement at the beginning

- if (item.quality > 0 && item.quality < 50)
  => check at the beginning

- **Aged Brie**
  `increase_quality(item.quality)`(method's default value is 1) before and on the sell by date
  `increase_quality(item.quality, 2)` after the sell by date

- **Apple/Normal Item**
  `decrease_quality(item.quality)`(method's default value is 1) before and on the sell by date
  `decrease_quality(item.quality, 2)` after the sell by date

- NEW **Conjured**
  `decrease_quality(item.quality, 2)` before and on the sell by date (double compared to normal items)
  `decrease_quality(item.quality, 4)` after the sell by date (double compared to normal items)

- **Backstage passes to a TAFKAL80ETC concert**

1. `increase_quality(item.quality)` if we are 11 days or more days away from the concert
2. `increase_quality(item.quality, 2)` if we are 10 days or less away from the concert
3. `increase_quality(item.quality, 3)` if we are 5 days or less away from the concert
   Once the concert has passed it `decrease_quality(item.quality, item.quality)`(too long? or `lose_all_quality`)

- there it a `decrease(item.sell_in)` after the quality is updated!

I will start by writing tests for different the scenarios for each type of items, then I will refactor the update_quality method and add some extra ones when needed.
