package rs.zajac.ui;
import rs.zajac.core.FWCore;
import rs.zajac.skins.ButtonCircleSkin;
import rs.zajac.skins.IScrollSkin;
import rs.zajac.skins.ScrollSkin;
import nme.events.Event;
import nme.events.MouseEvent;
import nme.geom.Point;

/**
 * ...
 * @author Aleksandar Bogdanovic
 */

class Scroll extends StyledComponent {

	inline public static var DIRECTION_HORIZONTAL:	String = 'horizontal';
	inline public static var DIRECTION_VERTICAL:	String = 'vertical';
	
	//******************************
	//		PUBLIC VARIABLES
	//******************************
	
	@style public var backgroundColor: Int = 0xdddddd;
	@style public var backgroundAlpha: Float = 0.7;
	@style public var borderColor: Null<Int> = null;
	@style public var roundness: Int = 0;
	@style public var buttonStyleName: String;
	
	public var button(default, null): Button;
	
	public var direction(default, set_direction): String = DIRECTION_HORIZONTAL;
	public var maxValue(default, set_maxValue): Float = 100;
	public var minValue(default, set_minValue): Float = 0;
	public var value(default, set_value): Float = 0;
	public var pageSize(default, set_pageSize): Float = 10;
	public var liveDragging: Bool = true;
	
	//******************************
	//		PRIVATE VARIABLES
	//******************************
	
	private var _dirtyScroll: Bool = true;
	private var _localBeginPoint: Point;
	
	//******************************
	//		PUBLIC METHODS
	//******************************
	
	public function new() {
		super();
	}
	
	override public function validate(): Void {
		super.validate();
		_validateScroll();
	}
	
	public function invalidScroll(): Void {
		if (_dirtyScroll) return;
		_dirtyScroll = true;
		invalid();
	}
	
	//******************************
	//		PRIVATE METHODS
	//******************************
	
	override private function initialize(): Void {
		button = new Button();
		addChild(button);
		
		button.addEventListener(MouseEvent.MOUSE_DOWN, _onBtnDown);
		addEventListener(MouseEvent.CLICK, _onClick);
		
		skinClass = ScrollSkin;
	}
	
	override private function _validateSkin(): Bool {
		if (super._validateSkin()) {
			if (Std.is(skin, IScrollSkin)) {
				var c_skin: IScrollSkin = cast(skin);
				if (c_skin.getButtonSkinClass != null) {
					button.skinClass = c_skin.getButtonSkinClass();
				}
			}
			return true;
		}
		return false;
	}
	
	private function _validateScroll(): Bool {
		if (_dirtyScroll) {
			button.styleName = buttonStyleName;
			
			switch (direction) {
				case DIRECTION_HORIZONTAL:
					button.Width = button.Height = Height;
					button.Width = Math.max(Height, Width * pageSize / (maxValue - minValue));
					button.x = (Width - button.Width) * (value - minValue) / (maxValue - minValue);
				case DIRECTION_VERTICAL:
					button.Height = button.Width = Width;
					button.Height = Math.max(Width, Height * pageSize / (maxValue - minValue));
					button.y = (Height - button.Height) * (value - minValue) / (maxValue - minValue);
			}
			
			button.validate();
			
			_dirtyScroll = false;
			
			return true;
		}
		return false;
	}
	
	private function _updateValue(stageX: Float, stageY: Float): Void {
		var c_btnPoint: Point = globalToLocal(new Point(stageX - _localBeginPoint.x, stageY - _localBeginPoint.y));
		switch (direction) {
			case DIRECTION_HORIZONTAL:
				value = minValue + (maxValue - minValue) * c_btnPoint.x / (Width - button.Width);
			case DIRECTION_VERTICAL:
				value = minValue + (maxValue - minValue) * c_btnPoint.y / (Height - button.Height);
		}
	}
	
	//******************************
	//		GETTERS AND SETTERS
	//******************************
	
	override private function set_Width(v: Float): Float {
		if (v != Width) {
			super.set_Width(v);
			invalidScroll();
		}
		return v;
	}
	
	override private function set_Height(v: Float): Float {
		if (v != Height) {
			super.set_Height(v);
			invalidScroll();
		}
		return v;
	}
	
	private function set_direction(v: String): String {
		if (direction != v) {
			direction = v;
			if (direction == DIRECTION_HORIZONTAL) {
				defaultWidth = FWCore.getHeightUnit() * 5;
				defaultHeight = FWCore.getHeightUnit();
			} else {
				defaultWidth = FWCore.getHeightUnit();
				defaultHeight = FWCore.getHeightUnit() * 5;
			}
			invalidScroll();
		}
		return v;
	}
	
	private function set_maxValue(v: Float): Float {
		if (maxValue != v) {
			maxValue = v;
			if (maxValue < value) {
				value = maxValue;
			}
			invalidScroll();
		}
		return v;
	}
	
	private function set_minValue(v: Float): Float {
		if (minValue != v) {
			minValue = v;
			if (minValue > value) {
				value = minValue;
			}
			invalidScroll();
		}
		return v;
	}
	
	private function set_value(v: Float): Float {
		v = Math.min(maxValue, Math.max(minValue, v));
		if (value != v) {
			value = v;
			invalidScroll();
		}
		return v;
	}
	
	private function set_pageSize(v: Float): Float {
		if (pageSize != v) {
			pageSize = v;
			invalidScroll();
		}
		return v;
	}
	
	//******************************
	//		EVENT LISTENERS
	//******************************
	
	private function _onClick(evt: MouseEvent): Void {
		if (evt.target == this) {
			var c_localPoint: Point = globalToLocal(new Point(evt.stageX, evt.stageY));
			switch (direction) {
				case DIRECTION_HORIZONTAL:
					if (c_localPoint.x > button.x) {
						value += pageSize;
					} else {
						value -= pageSize;
					}
				case DIRECTION_VERTICAL:
					if (c_localPoint.y > button.y) {
						value += pageSize;
					} else {
						value -= pageSize;
					}
			}
			dispatchEvent(new Event(Event.CHANGE));
		}
	}
	
	private function _onBtnDown(evt: MouseEvent): Void {
		_localBeginPoint = new Point(evt.localX, evt.localY);
		stage.addEventListener(MouseEvent.MOUSE_UP, _onBtnUp);
		stage.addEventListener(MouseEvent.MOUSE_MOVE, _onBtnMove);
	}
	
	private function _onBtnMove(evt: MouseEvent): Void {
		_updateValue(evt.stageX, evt.stageY);
		if (liveDragging) {
			dispatchEvent(new Event(Event.CHANGE));
		}
	}
	
	private function _onBtnUp(evt: MouseEvent): Void {
		stage.removeEventListener(MouseEvent.MOUSE_UP, _onBtnUp);
		stage.removeEventListener(MouseEvent.MOUSE_MOVE, _onBtnMove);
		_updateValue(evt.stageX, evt.stageY);
		_localBeginPoint = null;
		dispatchEvent(new Event(Event.CHANGE));
	}
	
}