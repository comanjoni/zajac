package rs.zajac.ui;
import rs.zajac.core.ZajacCore;
import rs.zajac.skins.ButtonCircleSkin;
import rs.zajac.skins.ISliderSkin;
import rs.zajac.skins.SliderSkin;
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
	
	//******************************
	//		PUBLIC VARIABLES
	//******************************
	
	/**
	 * Stlyed propery defining style name for Button used in Slider.
	 */
	@style public var buttonStyleName: String;

	/**
	 * Styled property defining background color.
	 */
	@style public var backgroundColor: Int = 0xffffff;

	/**
	 * Styled property defining border color.
	 */
	@style public var borderColor: Null<Int> = 0x7e8082;
	
	/**
	 * Backgroun bar size. If is null barSize will be height / 3 for horizontal
	 * and width / 3 for vertical direction.
	 */
	@style public var barSize: Null<Int> = null;

	/**
	 * Styled property defining background and border roundness.
	 */
	@style public var roundness: Int = 10;
	
	/**
	 * Reference to button.
	 */
	public var button: Button;
	
	/**
	 * Slider direction. Available values:
		 * Slider.DIRECTION_HORIZONTAL = 'horizontal'
		 * Slider.DIRECTION_VERTICAL = 'vertical'
	 */
	public var direction(default, set_direction): String = DIRECTION_HORIZONTAL;
	
	/**
	 * Maximum value of scroll.
	 */
	public var maxValue(default, set_maxValue): Float = 100;
	
	/**
	 * Minimum value of scroll.
	 */
	public var minValue(default, set_minValue): Float = 0;
	
	/**
	 * Scroll current value. It can be in range [minValue, maxValue].
	 */
	public var value(default, set_value): Float = 0;
	
	/**
	 * The number of items that can be viewed in display area.
	 */
	public var pageSize(default, set_pageSize): Float = 10;
	
	/**
	 * If live dragging is on then changes will be dispatched on mouse move.
	 */
	public var liveDragging: Bool = true;
	
	//******************************
	//		PRIVATE VARIABLES
	//******************************
	
	private var _dirtySlider: Bool = true;
	private var _localBeginPoint: Point;
	
	//******************************
	//		PUBLIC METHODS
	//******************************
	
	public function new() {
		super();
	}
	
	override public function validate(): Void {
		super.validate();
		_validateSlider();
	}
	
	public function invalidSlider(): Void {
		if (_dirtySlider) return;
		_dirtySlider = true;
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
		
		skinClass = SliderSkin;
	}
	
	override private function _validateSkin(): Bool {
		if (super._validateSkin()) {
			if (Std.is(skin, ISliderSkin)) {
				var c_skin: ISliderSkin = cast(skin);
				if (c_skin.getButtonSkinClass != null) {
					button.skinClass = c_skin.getButtonSkinClass();
				}
			}
			return true;
		}
		return false;
	}
	
	private function _validateSlider(): Bool {
		if (_dirtySlider) {
			button.styleName = buttonStyleName;
			
			switch (direction) {
				case DIRECTION_HORIZONTAL:
					button.Width = button.Height = Height;
					button.x = (Width - button.Width) * (value - minValue) / (maxValue - minValue);
				case DIRECTION_VERTICAL:
					button.Height = button.Width = Width;
					button.y = (Height - button.Height) * (value - minValue) / (maxValue - minValue);
			}
			
			button.validate();
			
			_dirtySlider = false;
			
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
	
	private function set_direction(v: String): String {
		if (direction != v) {
			direction = v;
			if (direction == DIRECTION_HORIZONTAL) {
				defaultWidth = ZajacCore.getHeightUnit() * 5;
				defaultHeight = ZajacCore.getHeightUnit();
			} else {
				defaultWidth = ZajacCore.getHeightUnit();
				defaultHeight = ZajacCore.getHeightUnit() * 5;
			}
			invalidSlider();
		}
		return v;
	}
	
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
	
	private function set_value(v: Float): Float {
		v = Math.min(maxValue, Math.max(minValue, v));
		if (value != v) {
			value = v;
			invalidSlider();
		}
		return v;
	}
	
	private function set_pageSize(v: Float): Float {
		if (pageSize != v) {
			pageSize = v;
			invalidSlider();
		}
		return v;
	}
	
	//******************************
	//		EVENT LISTENERS
	//******************************
	
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