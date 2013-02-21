package rs.zajac.ui;
import rs.zajac.core.ZajacCore;
import rs.zajac.events.ListEvent;
import rs.zajac.managers.PopUpManager;
import rs.zajac.skins.ComboBoxSkin;
import rs.zajac.skins.IComboBoxSkin;
import rs.zajac.util.TextFieldUtil;
import nme.display.DisplayObjectContainer;
import nme.events.Event;
import nme.events.MouseEvent;
import nme.events.TouchEvent;
import nme.geom.Point;
import nme.Lib;
import nme.text.TextField;
import nme.text.TextFieldType;

/**
 * ...
 * @author Aleksandar Bogdanovic
 */

class ComboBox extends StyledComponent {
	
	inline public static var OUT:	String = 'out';
	inline public static var OVER:	String = 'over';
	inline public static var OPEN:	String = 'open';
	
	//******************************
	//		PUBLIC VARIABLES
	//******************************
	
	@style public var listStyleName: String;
	
	@style public var color: Int = 0;			//text color
	@style public var backgroundColor: Int = 0xffffff;	//backgroundColor
	@style public var iconColor: Int = 0x666666;		//color of X of ok icon in the middle of the button box
	@style public var roundness: Int = 0;
	@style public var borderColor: Null<Int> = 0xbfc0c2;
	
	@style public var buttonSize(get_buttonSize, default):Float;//: Float = 20;		//size of checked icon in pixels
	
	public var items(get_items, set_items): Array<Dynamic>;
	public var selectedItem(get_selectedItem, set_selectedItem): Dynamic;
	
	public var defaultText(default, set_defaultText): String = 'Please select';
	
	public var textField(default, null): TextField;
	public var list(default, null): List;
	public var popupParent: DisplayObjectContainer = null;
	
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
	
	public function addItem(item: Dynamic): Dynamic {
		list.addItem(item);
	}
	
	public function addItemAt(item: Dynamic, index: Int): Void {
		list.addItemAt(item, index);
	}
	
	public function hasItem(item: Dynamic): Bool {
		return list.hasItem(item);
	}
	
	public function getItemIndex(item: Dynamic): Int {
		return list.getItemIndex(item);
	}
	
	public function getItemAt(index: Int): Dynamic {
		return list.getItemAt(index);
	}
	
	public function removeItem(item: Dynamic): Dynamic {
		return list.removeItem(item);
	}
	
	public function removeItemAt(index: Int): Dynamic {
		return list.removeItemAt(index);
	}
	
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