package rs.zajac.ui;
import rs.zajac.core.ZajacCore;
import rs.zajac.events.ListEvent;
import rs.zajac.managers.PopUpManager;
import rs.zajac.skins.ComboBoxSkin;
import rs.zajac.skins.IComboBoxSkin;
import rs.zajac.util.TextFieldUtil;
import flash.display.DisplayObjectContainer;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.TouchEvent;
import flash.geom.Point;
import flash.Lib;
import flash.text.TextField;
import flash.text.TextFieldType;

/**
 * @author Aleksandar Bogdanovic
 */
class ComboBox extends StyledComponent {
	
	inline public static var OUT:	String = 'out';
	inline public static var OVER:	String = 'over';
	inline public static var OPEN:	String = 'open';
	
	//******************************
	//		PUBLIC VARIABLES
	//******************************
	
	/**
	 * Stlyed propery defining style name for List used in ComboBox.
	 */
	@style public var listStyleName: String;

	/**
	 * Styled property defining text color.
	 */
	@style public var color: Int = 0;

	/**
	 * Styled property defining picker background color.
	 */
	@style public var backgroundColor: Int = 0xffffff;

	/**
	 * Styled property defining button arrow color.
	 */
	@style public var iconColor: Int = 0x666666;

	/**
	 * Styled property defining background and border roundness.
	 */
	@style public var roundness: Int = 0;

	/**
	 * Styled property defining picker border color.
	 */
	@style public var borderColor: Null<Int> = 0xbfc0c2;

	/**
	 * Styled property defining button size.
	 */
	@style public var buttonSize(get_buttonSize, default):Float;
	
	/**
	 * Array of items shown in list.
	 */
	public var items(get_items, set_items): Array<Dynamic>;
	
	/**
	 * Current selected item.
	 */
	public var selectedItem(get_selectedItem, set_selectedItem): Dynamic;
	
	/**
	 * Text shown if no item is selected.
	 */
	public var defaultText(default, set_defaultText): String = 'Please select';
	
	/**
	 * Reference to text field showing selected item.
	 */
	public var textField(default, null): TextField;
	
	/**
	 * Reference to list shown on click.
	 */
	public var list(default, null): List;
	
	/**
	 * Reference to component that will be used in PopupManager as parent for list.
	 */
	public var popupParent: DisplayObjectContainer = null;
	
	/**
	 * Read-only text to be printed in text field.
	 */
	public var text(get_text, null): String;
	
	//******************************
	//		PRIVATE VARIABLES
	//******************************
	
	private var _isOver: Bool = false;
	private var _listVisible: Bool = false;
	
	//******************************
	//		PUBLIC METHODS
	//******************************

	public function new() {
		super();
		defaultWidth = ZajacCore.getHeightUnit() * 5;
		defaultHeight = ZajacCore.getHeightUnit();
	}
	
	/**
	 * Add item to list.
	 * @param	item
	 * @return	Added item.
	 */
	public function addItem(item: Dynamic): Dynamic {
		list.addItem(item);
	}
	
	/**
	 * Add item to list at specific position.
	 * @param	item
	 * @param	index
	 */
	public function addItemAt(item: Dynamic, index: Int): Void {
		list.addItemAt(item, index);
	}
	
	/**
	 * Check does list contain specific item.
	 * @param	item
	 * @return	True if contains, otherwise False.
	 */
	public function hasItem(item: Dynamic): Bool {
		return list.hasItem(item);
	}
	
	/**
	 * Return index of item in list.
	 * @param	item
	 * @return	Item index.
	 */
	public function getItemIndex(item: Dynamic): Int {
		return list.getItemIndex(item);
	}
	
	/**
	 * Return item from list at specific lication.
	 * @param	index
	 * @return	Item.
	 */
	public function getItemAt(index: Int): Dynamic {
		return list.getItemAt(index);
	}
	
	/**
	 * Remove item from list.
	 * @param	item
	 * @return	Removed item.
	 */
	public function removeItem(item: Dynamic): Dynamic {
		return list.removeItem(item);
	}
	
	/**
	 * Remove item from list at specific location.
	 * @param	index
	 * @return	Removed item.
	 */
	public function removeItemAt(index: Int): Dynamic {
		return list.removeItemAt(index);
	}
	
	/**
	 * Remove all items from list.
	 */
	public function removeAllItems(): Void {
		list.removeAllItems();
	}
	
	//******************************
	//		PRIVATE METHODS
	//******************************
	
	override private function initialize(): Void {
		super.initialize();
		
		textField = new TextField();
		textField.background = false;
		textField.border = false;
		textField.mouseEnabled = false;
		textField.wordWrap = false;
		textField.multiline = false;
		textField.type = TextFieldType.DYNAMIC;
		TextFieldUtil.fillFieldFromObject(textField, { size: ZajacCore.getFontSize() } );
		addChild(textField);
		
		list = new List();
		list.defaultWidth = ZajacCore.getHeightUnit() * 5;
		list.addEventListener(ListEvent.SELECT, onListSelect);
		
		#if mobile
		addEventListener(TouchEvent.TOUCH_BEGIN,onTouchBegin);
		addEventListener(TouchEvent.TOUCH_END, 	onTouchEnd);
		addEventListener(TouchEvent.TOUCH_OVER,	onTouchOver);
		addEventListener(TouchEvent.TOUCH_OUT,	onTouchOut);
		#else
		addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		addEventListener(MouseEvent.MOUSE_UP, 	onMouseUp);
		addEventListener(MouseEvent.ROLL_OVER, 	onMouseOver);
		addEventListener(MouseEvent.ROLL_OUT, 	onMouseOut);
		buttonMode = useHandCursor = true;
		#end
		addEventListener(MouseEvent.CLICK, onClick);
		addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		
		state = OUT;
		
		skinClass = ComboBoxSkin;
	}
	
	override private function _validateSkin(): Bool {
		if (super._validateSkin()) {
			if (Std.is(skin, IComboBoxSkin)) {
				var c_skin: IComboBoxSkin = cast(skin);
				if (c_skin.getListSkinClass() != null) {
					list.skinClass = c_skin.getListSkinClass();
				}
			}
			list.styleName = listStyleName;
			return true;
		}
		return false;
	}
	
	private function _showList(): Void {
		if (_listVisible) return;
		#if mobile
		PopUpManager.addPopUp(popupParent, list, true);
		PopUpManager.centerPopUp(list);
		#else
		PopUpManager.addPopUp(popupParent, list, false);
		var c_globalPoint = localToGlobal(new Point());
		list.x = c_globalPoint.x;
		if (list.Height + c_globalPoint.y + Height <= Lib.current.stage.stageHeight) {
			list.y = c_globalPoint.y + Height;
		} else {
			list.y = c_globalPoint.y - list.Height;
		}
		#end
		_listVisible = true;
		Lib.current.stage.addEventListener(MouseEvent.CLICK, onStageClick);
	}
	
	private function _hideList(): Void {
		if (!_listVisible) return;
		PopUpManager.removePopUp(list);
		_listVisible = false;
		Lib.current.stage.removeEventListener(MouseEvent.CLICK, onStageClick);
	}
	
	//******************************
	//		GETTERS AND SETTERS
	//******************************
	
	private function get_items(): Array<Dynamic> {
		return list.items;
	}
	
	private function set_items(v: Array<Dynamic>): Array<Dynamic> {
		list.items = v;
		return v;
	}
	
	private function get_selectedItem(): Dynamic {
		return list.selectedItem;
	}
	
	private function set_selectedItem(v: Dynamic): Dynamic {
		list.selectedItem = v;
		return v;
	}
	
	private function set_defaultText(v: String): String {
		if (v != defaultText) {
			defaultText = v;
			if (selectedItem == null) {
				invalidSkin();
			}
		}
		return v;
	}
	
	private function get_buttonSize(): Float {
		return Math.min(_getStyleProperty("buttonSize", ZajacCore.getHeightUnit()), Height);
	}
	
	private function get_text(): String {
		if (selectedItem != null) {
			return selectedItem;
		}
		return defaultText;
	}
	
	//******************************
	//		EVENT LISTENERS
	//******************************
	
	private function onListSelect(e: ListEvent): Void {
		invalidSkin();
		_hideList();
		state = OUT;
	}
	
	#if mobile
	
	private function onTouchBegin(e: TouchEvent): Void {
		if (!enabled) return;
		if (_listVisible) return;
		state = OPEN;
	}
	
	private function onTouchEnd(e: TouchEvent): Void {
		if (!enabled) return;
		if (_listVisible) return;
		state = OUT;
	}
	
	private function onTouchOver(e: TouchEvent): Void {
		if (!enabled) return;
		if (_listVisible) return;
		state = OPEN;
	}
	
	private function onTouchOut(e: TouchEvent): Void {
		if (!enabled) return;
		if (_listVisible) return;
		state = OUT;
	}
	
	#else
	
	private function onMouseDown(e:MouseEvent):Void {
		if (!enabled) return;
		if (_listVisible) return;
		state = OPEN;
	}
	
	private function onMouseUp(e:MouseEvent):Void {
		if (!enabled) return;
		if (_listVisible) return;
		state = _isOver ? OVER : OUT;
	}
	
	private function onMouseOver(e:MouseEvent):Void {
		if (!enabled) return;
		if (_listVisible) return;
		_isOver = true;
		state = OVER;
	}
	
	private function onMouseOut(e:MouseEvent):Void {
		if (!enabled) return;
		if (_listVisible) return;
		_isOver = false;
		state = OUT;
	}
	
	#end
	
	private function onClick(e: MouseEvent): Void {
		if (_listVisible) {
			_hideList();
			state = OVER;
		} else {
			_showList();
			state = OPEN;
		}
	}
	
	private function onStageClick(e: MouseEvent): Void {
		if (e.target == this) {
			return;
		}
		
		var c_listPosition: Point = list.localToGlobal(new Point());
		if (e.stageX >= c_listPosition.x &&
			e.stageX <= c_listPosition.x + list.Width &&
			e.stageY >= c_listPosition.y &&
			e.stageY <= c_listPosition.y + list.Height) {
				return;
		}
		
		_hideList();
		state = OUT;
	}
	
	private function onRemovedFromStage(e: Event): Void {
		_hideList();
	}
	
}