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
	
	@style(0)			public var backgroundColor(dynamic, dynamic): Dynamic;
	@style(0)			public var roundness(dynamic, dynamic): Dynamic;
	@style(0xffffff) 	public var buttonBackgroundColor(dynamic, dynamic): Dynamic;
	@style( -1)			public var buttonBorderColor(dynamic, dynamic): Dynamic;
	
	public var direction(default, set_direction): String;
	private function set_direction(v: String): String {
		if (direction != v) {
			direction = v;
			invalidSkin();
		}
		return v;
	}
	
	public var maxValue(default, set_maxValue): Float;
	private function set_maxValue(v: Float): Float {
		if (maxValue != v) {
			maxValue = v;
			invalidSkin();
		}
		return v;
	}
	
	public var minValue(default, set_minValue): Float;
	private function set_minValue(v: Float): Float {
		if (minValue != v) {
			minValue = v;
			invalidSkin();
		}
		return v;
	}
	
	public var value(default, set_value): Float;
	private function set_value(v: Float): Float {
		v = Math.min(maxValue, Math.max(minValue, v));
		if (value != v) {
			value = v;
			switch (direction) {
				case DIRECTION_HORIZONTAL:
					button.x = (Width - button.Width) * (value - minValue) / (maxValue - minValue);
				case DIRECTION_VERTICAL:
					button.y = (Height - button.Height) * (value - minValue) / (maxValue - minValue);
			}
		}
		return v;
	}
	
	public var pageSize(default, set_pageSize): Float;
	private function set_pageSize(v: Float): Float {
		if (pageSize != v) {
			pageSize = v;
			invalidSkin();
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
	
	private var _localBeginPoint: Point;
	
	private function _updateBtnPos(stageX: Float, stageY: Float): Void {
		var c_btnPoint: Point = globalToLocal(new Point(stageX - _localBeginPoint.x, stageY - _localBeginPoint.y));
		switch (direction) {
			case DIRECTION_HORIZONTAL:
				button.x = Math.min(Width - button.Width, Math.max(0, c_btnPoint.x));
			case DIRECTION_VERTICAL:
				button.y = Math.min(Height - button.Height, Math.max(0, c_btnPoint.y));
		}
	}
	
	private function _updateValue(): Void {
		switch (direction) {
			case DIRECTION_HORIZONTAL:
				value = minValue + (maxValue - minValue) * button.x / (Width - button.Width);
			case DIRECTION_VERTICAL:
				value = minValue + (maxValue - minValue) * button.y / (Height - button.Height);
		}
		dispatchEvent(new Event(Event.CHANGE));
	}
	
	private function _onBtnDown(evt: MouseEvent): Void {
		_localBeginPoint = new Point(evt.localX, evt.localY);
		stage.addEventListener(MouseEvent.MOUSE_UP, _onBtnUp);
		stage.addEventListener(MouseEvent.MOUSE_MOVE, _onBtnMove);
	}
	
	private function _onBtnMove(evt: MouseEvent): Void {
		_updateBtnPos(evt.stageX, evt.stageY);
		if (liveDragging) {
			_updateValue();
		}
	}
	
	private function _onBtnUp(evt: MouseEvent): Void {
		stage.removeEventListener(MouseEvent.MOUSE_UP, _onBtnUp);
		stage.removeEventListener(MouseEvent.MOUSE_MOVE, _onBtnMove);
		_updateBtnPos(evt.stageX, evt.stageY);
		_updateValue();
		_localBeginPoint = null;
	}
	
	private function _onClick(evt: MouseEvent): Void {
		if (evt.target == this) {
			var c_localPoint: Point = globalToLocal(new Point(evt.stageX, evt.stageY));
			switch (direction) {
				case DIRECTION_HORIZONTAL:
					if (c_localPoint.x > button.x) {
						value = value + pageSize;
					} else {
						value = value - pageSize;
					}
				case DIRECTION_VERTICAL:
					if (c_localPoint.y > button.y) {
						value = value + pageSize;
					} else {
						value = value - pageSize;
					}
			}
			dispatchEvent(new Event(Event.CHANGE));
		}
	}
	
}