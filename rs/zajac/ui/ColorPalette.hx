package rs.zajac.ui;
import rs.zajac.core.ZajacCore;
import rs.zajac.skins.ColorPaletteSkin;
import rs.zajac.skins.IColorPaletteSkin;
import rs.zajac.util.ColorUtil;
import flash.display.Bitmap;
import flash.display.DisplayObject;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.Lib;

/**
 * HSV color palette.
 * @author Aleksandar Bogdanovic
 */
class ColorPalette extends StyledComponent {

	//******************************
	//		PUBLIC VARIABLES
	//******************************

	/**
	 * Styled property defining palette background color.
	 */
	@style public var backgroundColor: Int = 0xe6e7e9;

	/**
	 * Styled property defining palette border color.
	 */
	@style public var borderColor: Null<Int> = 0xadaeb0;
	
	/**
	 * Selected color.
	 */
	public var color(get_color, set_color): Int;
	
	/**
	 * Reference to palette visual component.
	 */
	public var palette(default, null): Bitmap;
	
	/**
	 * Refenrece to cursor component.
	 */
	public var cursor(default, null): DisplayObject;
	
	//******************************
	//		PRIVATE VARIABLES
	//******************************
	
	private var _color: Int = 0;
	private var _cursorMask: Sprite;
	
	//******************************
	//		PUBLIC METHODS
	//******************************
	
	public function new() {
		super();
		defaultHeight = defaultWidth = ZajacCore.getHeightUnit() * 5;
	}
	
	//******************************
	//		PRIVATE METHODS
	//******************************
	
	override private function initialize(): Void {
		palette = new Bitmap();
		addChild(palette);
		
		_cursorMask = new Sprite();
		_cursorMask.graphics.beginFill(0);
		_cursorMask.graphics.drawRect(0, 0, 10, 10);
		_cursorMask.graphics.endFill();
		
		addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
		
		skinClass = ColorPaletteSkin;
	}
	
	override private function _validateSkin(): Bool {
		if (super._validateSkin()) {
			if (Std.is(skin, IColorPaletteSkin)) {
				if (cursor != null) {
					removeChild(cursor);
					if (contains(_cursorMask)) {
						removeChild(_cursorMask);
					}
				}
				cursor = cast(skin, IColorPaletteSkin).getCursor();
				if (cursor != null) {
					addChild(cursor);
					addChild(_cursorMask);
					cursor.mask = _cursorMask;
					_cursorMask.width = palette.width;
					_cursorMask.height = palette.height;
					_cursorMask.x = palette.x;
					_cursorMask.y = palette.y;
					_updateCursor();
				}
			}
			return true;
		}
		return false;
	}
	
	private function _updateCursor(): Void {
		if (cursor != null) {
			var hsl: Array<Float> = ColorUtil.rgb2hsl(_color);
			cursor.x = Math.round(palette.x + palette.width * hsl[0]);
			cursor.y = Math.round(palette.y + palette.height * (1 - hsl[2]));
		}
	}
	
	private function _moveCursor(pos: Point): Void {
		pos.x = Math.round(Math.min(palette.x + palette.width, Math.max(palette.x, pos.x)));
		pos.y = Math.round(Math.min(palette.y + palette.height, Math.max(palette.y, pos.y)));
		if (cursor != null) {
			cursor.x = pos.x;
			cursor.y = pos.y;
		}
		_color = ColorUtil.hsl2rgb((pos.x - palette.x) / palette.width, 1, 1 - (pos.y - palette.y) / palette.height);
		dispatchEvent(new Event(Event.CHANGE));
	}
	
	//******************************
	//		GETTERS AND SETTERS
	//******************************
	private function get_color(): Int {
		return _color;
	}
	
	private function set_color(v: Int): Int {
		if (_color != v) {
			_color = v;
			_updateCursor();
		}
		return v;
	}
	
	//******************************
	//		EVENT LISTENERS
	//******************************
	
	private function _onMouseDown(e: MouseEvent): Void {
		if (e.localX < palette.x || e.localX > palette.x + palette.width ||
			e.localY < palette.y || e.localY > palette.y + palette.height) {
				return;
		}
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove);
	}
	
	private function _onMouseUp(e: MouseEvent): Void {
		Lib.current.stage.removeEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
		Lib.current.stage.removeEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove);
		_moveCursor(globalToLocal(new Point(e.stageX, e.stageY)));
	}
	
	private function _onMouseMove(e: MouseEvent): Void {
		_moveCursor(globalToLocal(new Point(e.stageX, e.stageY)));
	}
	
}