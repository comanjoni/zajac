package rs.zajac.ui;
import rs.zajac.core.FWCore;
import rs.zajac.managers.PopUpManager;
import rs.zajac.skins.ColorPickerSkin;
import rs.zajac.skins.IColorPickerSkin;
import nme.display.Bitmap;
import nme.display.DisplayObjectContainer;
import nme.events.Event;
import nme.events.MouseEvent;
import nme.events.TouchEvent;
import nme.geom.ColorTransform;
import nme.geom.Point;
import nme.geom.Rectangle;
import nme.Lib;

/**
 * ...
 * @author Aleksandar Bogdanovic
 */

class ColorPicker extends StyledComponent {
	
	inline public static var OUT:	String = 'out';
	inline public static var OVER:	String = 'over';
	inline public static var OPEN:	String = 'open';

	//******************************
	//		PUBLIC VARIABLES
	//******************************
	
	@style public var paletteStyleName: String;
	
	@style public var backgroundColor: Int = 0xffffff;	//backgroundColor
	@style public var iconColor: Int = 0x666666;		//color of X of ok icon in the middle of the button box
	@style public var roundness: Int = 0;
	@style public var borderColor: Null<Int> = 0xbfc0c2;
	
	@style public var buttonSize(get_buttonSize, default):Float;//: Float = 20;		//size of checked icon in pixels
	
	public var popupParent: DisplayObjectContainer = null;
	
	public var palette(default, null): ColorPalette;
	public var colorBox(default, null): Bitmap;
	
	public var selectedColor(get_selectedColor, set_selectedColor): Int = 0;			//text color
	
	//******************************
	//		PRIVATE VARIABLES
	//******************************
	
	private var _isOver: Bool = false;
	private var _paletteVisible: Bool = false;
	private var _dirtyColor: Bool = true;
	
	//******************************
	//		PUBLIC METHODS
	//******************************
	
	public function new() {
		super();
		defaultWidth = FWCore.getHeightUnit() * 5;
		defaultHeight = FWCore.getHeightUnit();
	}
	
	override public function validate(): Void {
		super.validate();
		_validateColor();
	}
	
	public function invalidColor(): Void {
		if (_dirtyColor) return;
		_dirtyColor = true;
		invalid();
	}
	
	//******************************
	//		PRIVATE METHODS
	//******************************
	
	override private function initialize(): Void {
		super.initialize();
		
		palette = new ColorPalette();
		palette.defaultWidth = FWCore.getHeightUnit() * 5;
		palette.addEventListener(Event.CHANGE, onPaletteChange);
		
		colorBox = new Bitmap();
		addChild(colorBox);
		
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
		
		skinClass = ColorPickerSkin;
	}
	
	override private function _validateSkin(): Bool {
		if (super._validateSkin()) {
			if (Std.is(skin, IColorPickerSkin)) {
				var c_skin: IColorPickerSkin = cast(skin);
				if (c_skin.getPaletteSkinClass() != null) {
					palette.skinClass = c_skin.getPaletteSkinClass();
				}
			}
			palette.styleName = paletteStyleName;
			return true;
		}
		return false;
	}
	
	private function _validateColor(): Bool {
		if (_dirtyColor) {
			var c_transform: ColorTransform = new ColorTransform();
			c_transform.color = selectedColor;
			colorBox.transform.colorTransform = c_transform;
			_dirtyColor = false;
			return true;
		}
		return false;
	}
	
	private function _showPalette(): Void {
		if (_paletteVisible) return;
		#if mobile
		PopUpManager.addPopUp(popupParent, palette, true);
		PopUpManager.centerPopUp(palette);
		#else
		PopUpManager.addPopUp(popupParent, palette, false);
		var c_globalPoint = localToGlobal(new Point());
		palette.x = c_globalPoint.x;
		if (palette.Height + c_globalPoint.y + Height <= Lib.current.stage.stageHeight) {
			palette.y = c_globalPoint.y + Height;
		} else {
			palette.y = c_globalPoint.y - palette.Height;
		}
		#end
		_paletteVisible = true;
		Lib.current.stage.addEventListener(MouseEvent.CLICK, onStageClick);
	}
	
	private function _hidePalette(): Void {
		if (!_paletteVisible) return;
		PopUpManager.removePopUp(palette);
		_paletteVisible = false;
		Lib.current.stage.removeEventListener(MouseEvent.CLICK, onStageClick);
	}
	
	//******************************
	//		GETTERS AND SETTERS
	//******************************
	
	private function get_selectedColor(): Int {
		return palette.color;
	}
	
	private function set_selectedColor(v: Int): Int {
		palette.color = v;
		invalidColor();
		return v;
	}
	
	private function get_buttonSize(): Float {
		return Math.min(_getStyleProperty("buttonSize", FWCore.getHeightUnit()), Height);
	}
	
	//******************************
	//		EVENT LISTENERS
	//******************************
	
	private function onPaletteChange(e: Event): Void {
		invalidColor();
	}
	
	#if mobile
	
	private function onTouchBegin(e: TouchEvent): Void {
		if (!enabled) return;
		if (_paletteVisible) return;
		state = OPEN;
	}
	
	private function onTouchEnd(e: TouchEvent): Void {
		if (!enabled) return;
		if (_paletteVisible) return;
		state = OUT;
	}
	
	private function onTouchOver(e: TouchEvent): Void {
		if (!enabled) return;
		if (_paletteVisible) return;
		state = OPEN;
	}
	
	private function onTouchOut(e: TouchEvent): Void {
		if (!enabled) return;
		if (_paletteVisible) return;
		state = OUT;
	}
	
	#else
	
	private function onMouseDown(e:MouseEvent):Void {
		if (!enabled) return;
		if (_paletteVisible) return;
		state = OPEN;
	}
	
	private function onMouseUp(e:MouseEvent):Void {
		if (!enabled) return;
		if (_paletteVisible) return;
		state = _isOver ? OVER : OUT;
	}
	
	private function onMouseOver(e:MouseEvent):Void {
		if (!enabled) return;
		if (_paletteVisible) return;
		_isOver = true;
		state = OVER;
	}
	
	private function onMouseOut(e:MouseEvent):Void {
		if (!enabled) return;
		if (_paletteVisible) return;
		_isOver = false;
		state = OUT;
	}
	
	#end
	
	private function onClick(e: MouseEvent): Void {
		if (_paletteVisible) {
			_hidePalette();
			state = OVER;
		} else {
			_showPalette();
			state = OPEN;
		}
	}
	
	private function onStageClick(e: MouseEvent): Void {
		if (e.target == this) {
			return;
		}
		
		var c_listPosition: Point = palette.localToGlobal(new Point());
		if (e.stageX >= c_listPosition.x &&
			e.stageX <= c_listPosition.x + palette.Width &&
			e.stageY >= c_listPosition.y &&
			e.stageY <= c_listPosition.y + palette.Height) {
				return;
		}
		
		_hidePalette();
		state = OUT;
	}
	
	private function onRemovedFromStage(e: Event): Void {
		_hidePalette();
	}
	
}