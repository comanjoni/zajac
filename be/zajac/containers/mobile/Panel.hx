package be.zajac.containers.mobile;
import be.zajac.containers.mobile.misc.APanelAnimator;
import be.zajac.containers.mobile.misc.PanelAnimator;
import be.zajac.containers.mobile.misc.PanelElasticAnimator;
import be.zajac.core.FWCore;
import be.zajac.skins.PanelSkin;
import be.zajac.ui.Slider;
import be.zajac.ui.StyledComponent;
import nme.display.DisplayObject;
import nme.display.Sprite;
import nme.events.Event;
import nme.events.MouseEvent;
import nme.geom.Point;
import nme.geom.Rectangle;
import nme.Lib;

/**
 * ...
 * @author Aleksandar Bogdanovic
 */

class Panel extends StyledComponent {

	@style public var backgroundColor: Int = 0;
	@style public var backgroundAlpha: Float = 1;
	@style public var borderColor: Int = -1;
	
	// used just on desktop
	public var mouseWheelStep: Float = 10;
	
	public var elasticEdges(default, set_elasticEdges): Bool = true;
	private function set_elasticEdges(v: Bool): Bool {
		if (v != elasticEdges) {
			elasticEdges = v;
			_setAnimator();
		}
		return v;
	}
	
	public var content(default, null): Sprite;
	public var verticalSlider(default, null): Slider;
	public var horizontalSlider(default, null): Slider;
	
	private var _animator: APanelAnimator;
	private function _setAnimator(): Void {
		if (elasticEdges) {
			_animator = new PanelElasticAnimator(this);
		} else {
			_animator = new PanelAnimator(this);
		}
	}
	
	
	//TODO: check if child is moved
	private var _contentSize: Point;
	
	private function resetContentSize(): Void {
		_contentSize = null;
	}
	
	public function getContentSize(): Point {
		//TODO: calculate if x and y are < 0, Maca have implemented with bitmapData
		if (_contentSize != null) {
			_contentSize.x = Math.max(content.width, _contentSize.x);
			_contentSize.y = Math.max(content.height, _contentSize.y);
		} else {
			var c_do: Dynamic;
			_contentSize = new Point(content.width, content.height);
			for (index in 0...content.numChildren) {
				c_do = content.getChildAt(index);
				_contentSize.x = Math.max(_contentSize.x, c_do.x + c_do.Width);
				_contentSize.y = Math.max(_contentSize.y, c_do.y + c_do.Height);
			}
		}
		return _contentSize;
	}
	
	// animate slider alpha
	inline private static var ALPHA_STEP: Float = 0.03;
	
	private var _alphaAnimator: Sprite;
	
	public function alphaAnimate(): Void {
		horizontalSlider.alpha = verticalSlider.alpha = 1.0;
		if (_alphaAnimator != null) return;
		_alphaAnimator = new Sprite();
		Lib.current.stage.addChild(_alphaAnimator);
		_alphaAnimator.addEventListener(Event.ENTER_FRAME, _onAlphaAnimate);
	}
	
	private function _onAlphaAnimate(evt: Event): Void {
		horizontalSlider.alpha = verticalSlider.alpha = Math.max(horizontalSlider.alpha - ALPHA_STEP, 0);
		if (horizontalSlider.alpha == 0) {
			Lib.current.stage.removeChild(_alphaAnimator);
			_alphaAnimator.removeEventListener(Event.ENTER_FRAME, _onAlphaAnimate);
			_alphaAnimator = null;
		}
	}
	
	// scroll update methods
	public function updateScrollRect(): Void {
		content.scrollRect = new Rectangle(horizontalSlider.value, verticalSlider.value, Width, Height);
	}
	
	private var _dirtyScroll: Bool = true;
	
	public function invalidScroll(): Void {
		if (_dirtyScroll) return;
		_dirtyScroll = true;
		invalid();
	}
	
	private function _validateScroll(): Bool {
		if (_dirtyScroll) {
			var c_width: Float;
			var c_height: Float;
			var c_contentSize: Point = getContentSize();
			
			horizontalSlider.visible = c_contentSize.x > Width;
			verticalSlider.visible = c_contentSize.y > Height;
			
			if (horizontalSlider.visible) {
				c_height = Height - horizontalSlider.Height;
			} else {
				c_height = Height;
			}
			
			if (verticalSlider.visible) {
				c_width = Width - verticalSlider.Width;
			} else {
				c_width = Width;
			}
			
			if (verticalSlider.visible) {
				verticalSlider.x = c_width;
				verticalSlider.Height = c_height;
				verticalSlider.maxValue = c_contentSize.y - c_height;
				verticalSlider.pageSize = verticalSlider.maxValue * c_height / c_contentSize.y;
			} else {
				verticalSlider.value = 0;
			}
			
			if (horizontalSlider.visible) {
				horizontalSlider.y = c_height;
				horizontalSlider.Width = c_width;
				horizontalSlider.maxValue = c_contentSize.x - c_width;
				horizontalSlider.pageSize = horizontalSlider.maxValue * c_width / c_contentSize.x;
			} else {
				horizontalSlider.value = 0;
			}
			
			updateScrollRect();
			
			_dirtyScroll = false;
			
			return true;
		}
		return false;
	}
	// end scroll update methods
	
	
	override public function validate(): Void {
		_validateScroll();
		super.validate();
	}
	
	
	
	public function new() {
		super();
		setSize(FWCore.getHeightUnit() * 5, FWCore.getHeightUnit() * 5);
	}
	
	override private function initialize(): Void {
		content = new Sprite();
		content.addEventListener(Event.RESIZE, _onContentSize);
		super.addChild(content);
		
		verticalSlider = new Slider();
		verticalSlider.direction = Slider.DIRECTION_VERTICAL;
		verticalSlider.minValue = 0;
		verticalSlider.x = 0;
		verticalSlider.Width = FWCore.getHeightUnit() / 4;
		verticalSlider.visible = false;
		verticalSlider.alpha = 0.0;
		super.addChild(verticalSlider);
		
		horizontalSlider = new Slider();
		horizontalSlider.direction = Slider.DIRECTION_HORIZONTAL;
		horizontalSlider.minValue = 0;
		horizontalSlider.y = 0;
		horizontalSlider.Height = FWCore.getHeightUnit() / 4;
		horizontalSlider.visible = false;
		horizontalSlider.alpha = 0.0;
		super.addChild(horizontalSlider);
		
		horizontalSlider.mouseChildren = false;
		horizontalSlider.mouseEnabled = false;
		verticalSlider.mouseChildren = false;
		verticalSlider.mouseEnabled = false;
		addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
		
		_setAnimator();
		
		skinClass = PanelSkin;
	}
	
	

	private function _onContentSize(evt: Event): Void {
		invalidScroll();
	}
	
	
	// mobile scroll methods
	private var _lastGlobalPoint: Point;
	private var _globalPoint: Point;
	
	private function _onMouseDown(evt: MouseEvent): Void {
		_animator.stop();
		
		_globalPoint = new Point(evt.stageX, evt.stageY);
		
		stage.addEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove);
		stage.addEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
	}
	
	private function _onMouseMove(evt: MouseEvent): Void {
		var c_point: Point = new Point(evt.stageX, evt.stageY);
		var c_value: Float, c_oldValue: Float;
		var c_changed: Bool = false;
		
		if (verticalSlider.visible) {
			c_value = verticalSlider.value - c_point.y + _globalPoint.y;
			if (elasticEdges) {
				if (c_value < verticalSlider.minValue) {
					verticalSlider.minValue = c_value;
				} else if (c_value > verticalSlider.maxValue) {
					verticalSlider.maxValue = c_value;
				}
			}
			c_oldValue = verticalSlider.value;
			verticalSlider.value = c_value;
			c_changed = (c_oldValue != verticalSlider.value);
		}
		
		if (horizontalSlider.visible) {
			c_value = horizontalSlider.value - c_point.x + _globalPoint.x;
			if (elasticEdges) {
				if (c_value < horizontalSlider.minValue) {
					horizontalSlider.minValue = c_value;
				} else if (c_value > horizontalSlider.maxValue) {
					horizontalSlider.maxValue = c_value;
				}
			}
			c_oldValue = horizontalSlider.value;
			horizontalSlider.value = c_value;
			c_changed = c_changed || (c_oldValue != horizontalSlider.value);
		}
		
		if (c_changed) {
			updateScrollRect();
			alphaAnimate();
		}
		
		_lastGlobalPoint = _globalPoint;
		_globalPoint = c_point;
	}
	
	private function _onMouseUp(evt: MouseEvent): Void {
		stage.removeEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove);
		stage.removeEventListener(MouseEvent.MOUSE_UP, _onMouseUp);

		if (_lastGlobalPoint != null && _globalPoint != null) {
			_animator.start(new Point(_lastGlobalPoint.x - _globalPoint.x, _lastGlobalPoint.y - _globalPoint.y));
		}
		
		_lastGlobalPoint = null;
		_globalPoint = null;
	}
	// end mobile scroll methods
	
	
	// forwaring DisplayObject children to content
	override public function addChild(child: DisplayObject): DisplayObject {
		resetContentSize();
		invalidScroll();
		return content.addChild(child);
	}
	
	override public function addChildAt(child : DisplayObject, index : Int) : DisplayObject {
		resetContentSize();
		invalidScroll();
		return content.addChildAt(child, index);
	}
	
	override public function contains(child : DisplayObject) : Bool {
		return content.contains(child);
	}
	
	override public function getChildAt(index : Int) : DisplayObject {
		return content.getChildAt(index);
	}
	
	override public function getChildByName(name : String) : DisplayObject {
		return content.getChildByName(name);
	}
	
	override public function getChildIndex(child : DisplayObject) : Int {
		return content.getChildIndex(child);
	}
	
	override public function removeChild(child : DisplayObject) : DisplayObject {
		resetContentSize();
		invalidScroll();
		return content.removeChild(child);
	}
	
	override public function removeChildAt(index : Int) : DisplayObject {
		resetContentSize();
		invalidScroll();
		return content.removeChildAt(index);
	}
	
	override public function setChildIndex(child : DisplayObject, index : Int) : Void {
		content.setChildIndex(child, index);
	}
	
	override public function swapChildren(child1 : DisplayObject, child2 : DisplayObject) : Void {
		content.swapChildren(child1, child2);
	}
	
	override public function swapChildrenAt(index1 : Int, index2 : Int) : Void {
		content.swapChildrenAt(index1, index2);
	}
	
}