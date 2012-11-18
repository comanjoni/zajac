package be.zajac.ui;
import be.zajac.containers.Panel;
import be.zajac.renderers.AbstractListItemRenderer;
import nme.display.DisplayObject;
import nme.events.Event;
import be.zajac.renderers.ListItemRenderer;

/**
 * ...
 * @author Aleksandar Bogdanovic
 */

class List extends Panel {

	private var _dirtyItems: Bool = true;
	
	public function invalidItems(): Void {
		if (_dirtyItems) return;
		_dirtyItems = true;
		invalidScroll();
	}
	
	private var _itemComponents: Array<Dynamic>;
	
	private function _validateItems(): Bool {
		if (_dirtyItems) {
			var itemComp: Dynamic;
			var c_y: Float;
			
			if (_itemComponents != null) {
				for (itemComp in _itemComponents) {
					itemComp.removeEventListener(Event.SELECT, _onItemSelect);
					removeChild(itemComp);
				}
				_itemComponents = null;
			}
			
			if (items != null) {
				_itemComponents = new Array<Dynamic>();
				c_y = 0;
				for (item in items) {
					itemComp = Type.createInstance(itemRenderer, []);
					itemComp.data = item;
					if (selectable && item == selectedItem) {
						itemComp.selected = true;
					}
					itemComp.Width = Width;
					itemComp.y = c_y;
					_itemComponents.push(itemComp);
					addChild(itemComp);
					c_y += itemComp.Height;
					itemComp.addEventListener(Event.SELECT, _onItemSelect);
				}
			}
			
			_dirtyItems = false;
			
			return true;
		}
		return false;
	}
	
	override public function validate(): Void {
		_validateItems();
		super.validate();
	}
	
	public var itemRenderer(default, set_itemRenderer): Class<AbstractListItemRenderer>;
	private function set_itemRenderer(c: Class<AbstractListItemRenderer>): Class<AbstractListItemRenderer> {
		if (itemRenderer != c) {
			itemRenderer = c;
			invalidItems();
		}
		return c;
	}
	
	public var items(default, set_items): Array<Dynamic>;
	public function set_items(v: Array<Dynamic>): Array<Dynamic> {
		if (v != items) {
			items = v;
			invalidItems();
		}
		return v;
	}
	
	public function addItem(item: Dynamic): Dynamic {
		if (items == null) {
			items = new Array<Dynamic>();
		}
		items.push(item);
		invalidItems();
	}
	
	public function addItemAt(item: Dynamic, index: Int): Dynamic {
		if (items == null) {
			items = new Array<Dynamic>();
		}
		items.insert(index, item);
		invalidItems();
	}
	
	public function hasItem(item: Dynamic): Bool {
		var c_index: Int = getItemIndex(item);
		return c_index > -1;
	}
	
	public function getItemIndex(item: Dynamic): Int {
		if (items == null) return -1;
		var i: Int = 0;
		for (c_item in items) {
			if (c_item == item) {
				return i;
			}
			i++;
		}
		return -1;
	}
	
	public function getItemAt(index: Int): Dynamic {
		if (items == null) return null;
		if (index >= items.length) return null;
		if (index < 0) return null;
		return items[index];
	}
	
	public function removeItem(item: Dynamic): Dynamic {
		if (items == null) return null;
		if (items.remove(item)) {
			invalidItems();
			return item;
		} else {
			return null;
		}
	}
	
	public function removeItemAt(index: Int): Dynamic {
		if (items == null) return null;
		if (index >= items.length) return null;
		if (index < 0) return null;
		var c_removed: Array<Dynamic> = items.splice(index, 1);
		if (c_removed.length != 0) {
			invalidItems();
			return c_removed[0];
		}
		return null;
	}
	
	public function removeAllItems(): Void {
		if (items == null) return;
		if (items.length == 0) return;
		items = null;
		invalidItems();
	}
	
	
	public var selectedItem(default, set_selectedItem): Dynamic;
	private function set_selectedItem(item: Dynamic): Dynamic {
		if (!selectable) return null;
		if (selectedItem != item) {
			var c_itemComp: BaseComponent;
			var c_index: Int;
			if (selectedItem != null) {
				c_index = getItemIndex(selectedItem);
				if (_itemComponents != null && c_index > 0 && _itemComponents.length > c_index) {
					_itemComponents[c_index].selected = false;
				}
			}
			selectedItem = item;
			if (selectedItem != null) {
				c_index = getItemIndex(selectedItem);
				if (_itemComponents != null && c_index > 0 && _itemComponents.length > c_index) {
					_itemComponents[c_index].selected = true;
				}
			}
			dispatchEvent(new Event(Event.SELECT));
		}
		return item;
	}
	
	private function _onItemSelect(e: Event): Void {
		selectedItem = e.target.data;
	}
	
	public var selectable: Bool = true;
	
	public function new() {
		super();
	}
	
	override private function initialize(): Void {
		super.initialize();
		itemRenderer = ListItemRenderer;
	}
	
}