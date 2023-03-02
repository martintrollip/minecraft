import 'package:get/get.dart';
import 'package:minecraft/resources/blocks.dart';
import 'package:minecraft/utils/constant.dart';

class InventoryManager {
  final List<InventorySlot> _items =
      List.generate(36, (index) => InventorySlot(index: index));

  Rx<int> currentSelection = 0.obs;

  Rx<bool> isOpen = false.obs;

  List<InventorySlot> get items => _items;

  bool addItem(Blocks item, {int count = 1, bool split = false}) {
    var index = _items.indexWhere((element) =>
        (element.block == item && element.count.value < stackSize));

    if (index != -1 && !split) {
      _items[index].count.value += count;
      return true;
    } else {
      index = _items.indexWhere((element) => element.block == null);
      if (index != -1) {
        _items[index].block = item;
        _items[index].count.value += count;
        return true;
      } else {
        return false;
      }
    }
  }

  void removeItem(InventorySlot item, {int count = 1}) {
    item.count.value -= count;
    if (item.count.value <= 0) {
      item.block = null;
    }
  }

  void toggle() {
    isOpen.value = !isOpen.value;
  }

  void close() {
    isOpen.value = false;
  }
}

class InventorySlot {
  InventorySlot({required this.index, this.block});

  Blocks? block;
  Rx<int> count = 0.obs;
  bool get isEmpty => count.value == 0;
  final int index;

  void emptySlot() {
    block = null;
    count.value = 0;
  }

  int freeSpace() {
    return stackSize - count.value;
  }
}
