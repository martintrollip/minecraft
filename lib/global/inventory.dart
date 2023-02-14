import 'package:minecraft/resources/blocks.dart';
import 'package:minecraft/utils/constant.dart';

class InventoryManager {
  final List<InventorySlot> _items = List.generate(
    5,
    (index) => InventorySlot(index: index),
  );

  List<InventorySlot> get items => _items;

  bool addItem(Blocks item) {
    var index = _items.indexWhere(
        (element) => (element.block == item && element.count < stackSize));
    if (index != -1) {
      _items[index].count++;
      return true;
    } else {
      index = _items.indexWhere((element) => element.block == null);
      if (index != -1) {
        _items[index].block = item;
        _items[index].count++;
        return true;
      } else {
        return false;
      }
    }
  }

  void removeItem(InventorySlot item) {
    if (item.count > 1) {
      item.count--;
    } else {
      item.block = null;
      item.count = 0;
    }
  }
}

class InventorySlot {
  InventorySlot({required this.index, this.block, this.count = 0});

  Blocks? block;
  int count;

  final int index;
}
