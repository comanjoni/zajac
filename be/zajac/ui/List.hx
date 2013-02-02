package be.zajac.ui;
import be.zajac.containers.Panel;
import be.zajac.events.ListEvent;
import be.zajac.renderers.AbstractListItemRenderer;
import nme.display.DisplayObject;
import nme.events.Event;
import be.zajac.renderers.ListItemRenderer;

/**
 * ...
 * @author Aleksandar Bogdanovic
 */

class List extends Panel {

	@style public var itemStyleName: String;
	
	private var _dirtyItems: Bool = true;
	private var _dirtyItemsPosition: Bool = true;
	
	public function invalidItems(): Void {
		if (_dirtyItems) return;
		_dirtyItems = true;
		invalidScroll();
	}
	
	public function invalidItemsPosition(): Void {
		if (_dirtyItemsPosition) return;
		_dirtyItemsPosition = true;
		invalidScroll();
	}
	
	private var _itemComponents: Array<AbstractListItemRenderer>;
	
	private function _validateItemsPosition(): Bool {
		if (_dirtyItemsPosition) {
			if (_itemComponents != null) {
				var c_y: Float = 0;
				for (itemComp in _itemComponents) {
					itemComp.y = c_y;
					c_y += itemComp.Height;
				}
			}
			
			_dirtyItemsPosition = false;
			
			return true;
		}
		return false;
	}
	
	private function _validateItems(): Bool {
		if (_dirtyItems) {
			var itemComp: AbstractListItemRenderer;
			
			if (_itemComponents != null) {
				for (itemComp in _itemComponents) {
					itemComp.removeEventListener(Event.SELECT, _onItemSelect);
					itemComp.removeEventListener(Event.RESIZE, _onItemResize);
					removeChild(itemComp);
				}
				_itemComponents = null;
			}
			
			if (items != null) {
				_itemComponents = new Array<AbstractListItemRenderer>();
				for (item in items) {
					itemComp = Type.createInstance(itemRenderer, []);
					itemComp.styleName = itemStyleName;
					itemComp.data = item;
					if (selectable && item == selectedItem) {
						itemComp.selected = true;
					}
					itemComp.Width = Width;
					_itemComponents.push(itemComp);
					addChild(itemComp);
					itemComp.addEventListener(Event.SELECT, _onItemSelect);
					itemComp.addEventListener(Event.RESIZE, _onItemResize);
				}
			}
			
			_dirtyItems = false;
			_dirtyItemsPosition = true;
			
			return true;
		}
		return false;
	}
	
	override public function validate(): Void {
		_validateItems();
		_validateItemsPosition();
		super.validate();
	}
	
	private function _onItemResize(evt: Event): Void {
		invalidItemsPosition();
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
			if (item == selectedItem) {
				selectedItem = null;
			}
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
			if (c_removed[0] == selectedItem) {
				selectedItem = null;
			}
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
			var c_itemComp: AbstractListItemRenderer;
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
				dispatchEvent(new ListEvent(ListEvent.SELECT, false, false, selectedItem));
			}
			
		}
		
		return item;
	}
	
	private function _onItemSelect(e: Event): Void {
		if (selectable) {
			selectedItem = e.target.data;
		} else {
			dispatchEvent(new ListEvent(ListEvent.SELECT, false, false, e.target.data));
		}
	}
	
	public var selectable(default, set_selectable): Bool = true;
	private function set_selectable(v: Bool): Bool {
		if (selectable == v) return v;
		if (!v) {
			selectedItem = null;
		}
		selectable = v;
		return v;
	}
	
	public function new() {
		super();
	}
	
	override private function initialize(): Void {
		super.initialize();
		itemRenderer = ListItemRenderer;
		addEventListener(Event.RESIZE, _onResize);
	}
	
	private function _onResize(e: Event): Void {
		invalidItems();
	}
	
}