package be.zajac.ui;
import be.zajac.core.FWCore;
import be.zajac.skins.SliderSkin;
import nme.events.Event;
import nme.events.MouseEvent;
import nme.geom.Point;

/**
 * ...
 * @author Aleksandar Bogdanovic
 */

class Slider extends StyledComponent {

	inline public static var DIRECTION_HORIZONTAL:	String = 'horizontal';
	inline public static var DIRECTION_VERTICAL:	String = 'vertical';
	
	@style public var backgroundColor: Int = 0;
	@style public var roundness: Int = 0;
	@style public var buttonBackgroundColor: Int = 0xffffff;
	@style public var buttonBorderColor: Int = -1;
	
	private var _dirtySlider: Bool = true;
	
	public function invalidSlider(): Void {
		if (_dirtySlider) return;
		_dirtySlider = true;
		invalid();
	}
	
	private function _validateSlider(): Bool {
		if (_dirtySlider) {
			button.roundness = roundness;
			button.backgroundColor = buttonBackgroundColor;
			button.borderColor = buttonBorderColor;
			
			switch (direction) {
				case DIRECTION_HORIZONTAL:
					button.Height = Height;
					button.Width = Math.max(Height, Width * pageSize / (maxValue - minValue));
					button.x = (Width - button.Width) * (value - minValue) / (maxValue - minValue);
				case DIRECTION_VERTICAL:
					button.Width = Width;
					button.Height = Math.max(Width, Height * pageSize / (maxValue - minValue));
					button.y = (Height - button.Height) * (value - minValue) / (maxValue - minValue);
			}
			
			button.validate();
			
			_dirtySlider = false;
			
			return true;
		}
		return false;
	}
	
	override public function validate(): Void {
		super.validate();
		_validateSlider();
	}
	
	public var direction(default, set_direction): String;
	private function set_direction(v: String): String {
		if (direction != v) {
			direction = v;
			invalidSlider();
		}
		return v;
	}
	
	public var maxValue(default, set_maxValue): Float;
	private function set_maxValue(v: Float): Float {
		if (maxValue != v) {
			maxValue = v;
			if (maxValue < value) {
				value = maxValue;
			}
			invalidSlider();
		}
		return v;
	}
	
	public var minValue(default, set_minValue): Float;
	private function set_minValue(v: Float): Float {
		if (minValue != v) {
			minValue = v;
			if (minValue > value) {
				value = minValue;
			}
			invalidSlider();
		}
		return v;
	}
	
	public var value(default, set_value): Float;
	private function set_value(v: Float): Float {
		v = Math.min(maxValue, Math.max(minValue, v));
		if (value != v) {
			value = v;
			invalidSlider();
		}
		return v;
	}
	
	public var pageSize(default, set_pageSize): Float;
	private function set_pageSize(v: Float): Float {
		if (pageSize != v) {
			pageSize = v;
			invalidSlider();
		}
		return v;
	}
	
	public var liveDragging: Bool = true;
	
	public var button: Button;
	
	public function new() {
		super();
		Width = FWCore.getHeightUnit() * 5;
		Height = FWCore.getHeightUnit();
		
		direction = DIRECTION_HORIZONTAL;
		maxValue = 100;
		minValue = 0;
		pageSize = 10;
		value = 0;
	}
	
	override private function initialize(): Void {
		button = new Button();
		addChild(button);
		
		button.addEventListener(MouseEvent.MOUSE_DOWN, _onBtnDown);
		addEventListener(MouseEvent.CLICK, _onClick);
		
		skinClass = SliderSkin;
	}
	
	override private function set_Width(v: Float): Float {
		if (v != Width) {
			super.set_Width(v);
			invalidSlider();
		}
		return v;
	}
	
	override private function set_Height(v: Float): Float {
		if (v != Height) {
			super.set_Height(v);
			invalidSlider();
		}
		return v;
	}
	
	
	private var _localBeginPoint: Point;
	
	private function _updateValue(stageX: Float, stageY: Float): Void {
		var c_btnPoint: Point = globalToLocal(new Point(stageX - _localBeginPoint.x, stageY - _localBeginPoint.y));
		switch (direction) {
			case DIRECTION_HORIZONTAL:
				value = minValue + (maxValue - minValue) * c_btnPoint.x / (Width - button.Width);
			case DIRECTION_VERTICAL:
				value = minValue + (maxValue - minValue) * c_btnPoint.y / (Height - button.Height);
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
	
}