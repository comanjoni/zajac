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
	
	//******************************
	//		PUBLIC VARIABLES
	//******************************

	@style public var itemStyleName: String;
	
	public var itemRenderer(default, set_itemRenderer): Class<AbstractListItemRenderer>;
	public var items(default, set_items): Array<Dynamic>;
	public var selectedItem(default, set_selectedItem): Dynamic;
	public var selectable(default, set_selectable): Bool = true;
	
	//******************************
	//		PRIVATE VARIABLES
	//******************************
	
	private var _dirtyItems: Bool = true;
	private var _dirtyItemsPosition: Bool = true;
	
	private var _itemComponents: Array<AbstractListItemRenderer>;
	
	//******************************
	//		PUBLIC METHODS
	//******************************
	
	public function new() {
		super();
	}
	
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
	
	override public function validate(): Void {
		_validateItems();
		_validateItemsPosition();
		super.validate();
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
		return getItemIndex(item) > -1;
	}
	
	public function getItemIndex(item: Dynamic): Int {
		if (items != null) {
			for (i in 0...items.length) {
				if (item == items[i]) return i;
			}
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
		if (items != null && items.remove(item)) {
			if (item == selectedItem) {
				selectedItem = null;
			}
			invalidItems();
			return item;
		}
		return null;
	}
	
	public function removeItemAt(index: Int): Dynamic {
		if (items == null) return null;
		if (index >= items.length) return null;
		if (index < 0) return null;
		
		var c_removed: Array<Dynamic> = items.splice(index, 1);
		if (c_removed.length != 0) {
			if (c_removed[0] == selectedItem) {
				selectedItem = null;
			}
			invalidItems();
			return c_removed[0];
		}
		
		return null;
	}
	
	public function removeAllItems(): Void {
		if (items == null) return;
		if (items.length == 0) return;
		items = null;
	}
	
	//******************************
	//		PRIVATE METHODS
	//******************************
	
	override private function initialize(): Void {
		super.initialize();
		itemRenderer = ListItemRenderer;
		addEventListener(Event.RESIZE, _onResize);
	}
	
	private function _clearItems(): Void {
		if (_itemComponents == null) return;
		for (itemComp in _itemComponents) {
			itemComp.removeEventListener(Event.SELECT, _onItemSelect);
			itemComp.removeEventListener(Event.RESIZE, _onItemResize);
			removeChild(itemComp);
		}
		_itemComponents = null;
	}
	
	private function _createItems(): Void {
		if (items == null) return;
		var itemComp: AbstractListItemRenderer;
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
	
	private function _updateItemsPosition(): Void {
		if (_itemComponents == null) return;
		var c_y: Float = 0;
		for (itemComp in _itemComponents) {
			itemComp.y = c_y;
			c_y += itemComp.Height;
		}
	}
	
	private function _validateItemsPosition(): Bool {
		if (_dirtyItemsPosition) {
			_updateItemsPosition();
			_dirtyItemsPosition = false;
			return true;
		}
		return false;
	}
	
	private function _validateItems(): Bool {
		if (_dirtyItems) {
			_clearItems();
			_createItems();
			_dirtyItemsPosition = true;
			_dirtyItems = false;
			return true;
		}
		return false;
	}
	
	//******************************
	//		GETTERS AND SETTERS
	//******************************
	
	private function set_itemRenderer(c: Class<AbstractListItemRenderer>): Class<AbstractListItemRenderer> {
		if (itemRenderer != c) {
			itemRenderer = c;
			invalidItems();
		}
		return c;
	}
	public function set_items(v: Array<Dynamic>): Array<Dynamic> {
		if (v != items) {
			items = v;
			invalidItems();
		}
		return v;
	}
	
	private function set_selectedItem(item: Dynamic): Dynamic {
		if (!selectable) return null;
		
		if (selectedItem != item) {
			var c_itemComp: AbstractListItemRenderer;
			var c_index: Int;
			
			if (selectedItem != null) {
				c_index = getItemIndex(selectedItem);
				if (_itemComponents != null && c_index >= 0 && c_index < _itemComponents.length) {
					_itemComponents[c_index].selected = false;
				}
			}
			
			selectedItem = item;
			
			if (selectedItem != null) {
				c_index = getItemIndex(selectedItem);
				if (_itemComponents != null && c_index >= 0 && c_index < _itemComponents.length) {
					_itemComponents[c_index].selected = true;
				}
			}
			dispatchEvent(new ListEvent(ListEvent.SELECT, false, false, selectedItem));
		}
		
		return item;
	}
	
	private function set_selectable(v: Bool): Bool {
		if (selectable == v) return v;
		if (!v) {
			selectedItem = null;
		}
		selectable = v;
		return v;
	}
	
	//******************************
	//		EVENT LISTENERS
	//******************************
	
	private function _onItemResize(evt: Event): Void {
		invalidItemsPosition();
	}
	
	private function _onItemSelect(e: Event): Void {
		if (selectable) {
			selectedItem = e.target.data;
		} else {
			dispatchEvent(new ListEvent(ListEvent.SELECT, false, false, e.target.data));
		}
	}
	
	private function _onResize(e: Event): Void {
		invalidItems();
	}
	
}