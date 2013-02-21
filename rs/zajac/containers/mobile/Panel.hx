package rs.zajac.containers.mobile;
import rs.zajac.core.ZajacCore;
import rs.zajac.skins.IPanelSkin;
import rs.zajac.skins.PanelSkin;
import rs.zajac.ui.Scroll;
import rs.zajac.ui.Slider;
import rs.zajac.ui.StyledComponent;
import rs.zajac.util.ComponentUtil;
import rs.zajac.util.PointUtil;
import nme.display.DisplayObject;
import nme.display.Sprite;
import nme.events.Event;
import nme.events.MouseEvent;
import nme.geom.Point;
import nme.geom.Rectangle;
import nme.Lib;

/**
 * Panel implementation for mobile application.
 * Scrolls are not responding on IO. User can drag content.
 * @author Aleksandar Bogdanovic
 */
class Panel extends StyledComponent {
	
	//******************************
	//		PUBLIC VARIABLES
	//******************************

	@style public var backgroundColor: Int = 0xe6e7e9;
	@style public var backgroundAlpha: Float = 1;
	@style public var borderColor: Null<Int> = 0xadaeb0;
	@style public var scrollSize(get_scrollSize, set_scrollSize): Float;
	
	public var verticalScroll(default, null): Scroll;
	public var horizontalScroll(default, null): Scroll;
	
	public var mouseWheelStep: Float = 10;	// used just on desktop
	
	public var contentRect(get_contentRect, null): Rectangle;
	
	//******************************
	//		PRIVATE VARIABLES
	//******************************
	
	private var _content: Sprite;
	private var _contentX: Float = 0;
	private var _contentY: Float = 0;
	
	private var _dirtyScroll: Bool = true;
	
	private var _dragPoint: Point;
	private var _dragDirection: Point;
	private var _dragging: Bool = false;
	
	//******************************
	//		PUBLIC METHODS
	//******************************
	
	public function new() {
		super();
		defaultWidth = defaultHeight = ZajacCore.getHeightUnit() * 5;
	}
	
	override public function validate(): Void {
		_validateScroll();
		super.validate();
	}
	
	override public function addChild(child: DisplayObject): DisplayObject {
		invalidScroll();
		return _content.addChild(child);
	}
	
	override public function addChildAt(child : DisplayObject, index : Int) : DisplayObject {
		invalidScroll();
		return _content.addChildAt(child, index);
	}
	
	override public function contains(child : DisplayObject) : Bool {
		return _content.contains(child);
	}
	
	override public function getChildAt(index : Int) : DisplayObject {
		return _content.getChildAt(index);
	}
	
	override public function getChildByName(name : String) : DisplayObject {
		return _content.getChildByName(name);
	}
	
	override public function getChildIndex(child : DisplayObject) : Int {
		return _content.getChildIndex(child);
	}
	
	override public function removeChild(child : DisplayObject) : DisplayObject {
		invalidScroll();
		return _content.removeChild(child);
	}
	
	override public function removeChildAt(index : Int) : DisplayObject {
		invalidScroll();
		return _content.removeChildAt(index);
	}
	
	override public function setChildIndex(child : DisplayObject, index : Int) : Void {
		_content.setChildIndex(child, index);
	}
	
	override public function swapChildren(child1 : DisplayObject, child2 : DisplayObject) : Void {
		_content.swapChildren(child1, child2);
	}
	
	override public function swapChildrenAt(index1 : Int, index2 : Int) : Void {
		_content.swapChildrenAt(index1, index2);
	}
	
	public function updateScrollRect(): Void {
		var c_rect: Rectangle = contentRect;
		_content.x = c_rect.x;
		_content.y = c_rect.y;
		_content.scrollRect = new Rectangle(_contentX, _contentY, c_rect.width, c_rect.height);
		if (horizontalScroll.visible) {
			horizontalScroll.value = _contentX;
		}
		if (verticalScroll.visible) {
			verticalScroll.value = _contentY;
		}
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
		_content = new Sprite();
		_content.addEventListener(Event.RESIZE, _onContentResize);
		super.addChild(_content);
		
		verticalScroll = new Scroll();
		verticalScroll.direction = Scroll.DIRECTION_VERTICAL;
		verticalScroll.minValue = 0;
		verticalScroll.visible = false;
		verticalScroll.mouseChildren = false;
		verticalScroll.mouseEnabled = false;
		verticalScroll.alpha = 0;
		super.addChild(verticalScroll);
		
		horizontalScroll = new Scroll();
		horizontalScroll.direction = Scroll.DIRECTION_HORIZONTAL;
		horizontalScroll.minValue = 0;
		horizontalScroll.visible = false;
		horizontalScroll.mouseChildren = false;
		horizontalScroll.mouseEnabled = false;
		horizontalScroll.alpha = 0;
		super.addChild(horizontalScroll);
		
		addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
		
		skinClass = PanelSkin;
	}
	
	override private function _validateSkin(): Bool {
		if (super._validateSkin()) {
			if (Std.is(skin, IPanelSkin)) {
				var c_skin: IPanelSkin = cast(skin);
				if (c_skin.getHScrollSkinClass() != null) {
					horizontalScroll.skinClass = c_skin.getHScrollSkinClass();
				}
				if (c_skin.getVScrollSkinClass() != null) {
					verticalScroll.skinClass = c_skin.getVScrollSkinClass();
				}
			}
			return true;
		}
		return false;
	}
	
	private function _validateScroll(): Bool {
		if (_dirtyScroll) {
			var c_contentSize: Point = ComponentUtil.visibleContentSize(_content);
			var c_contentRect: Rectangle = contentRect;
			var c_width: Float;
			var c_height: Float;
			
			horizontalScroll.visible = c_contentSize.x > c_contentRect.width;
			verticalScroll.visible = c_contentSize.y > c_contentRect.height;
			
			if (horizontalScroll.visible) {
				horizontalScroll.Height = scrollSize;
				c_height = c_contentRect.height - scrollSize;
			} else {
				c_height = c_contentRect.height;
			}
			
			if (verticalScroll.visible) {
				verticalScroll.Width = scrollSize;
				c_width = c_contentRect.width - scrollSize;
			} else {
				c_width = c_contentRect.width;
			}
			
			if (verticalScroll.visible) {
				verticalScroll.x = c_width + c_contentRect.x;
				verticalScroll.y = c_contentRect.y;
				verticalScroll.Height = c_height;
				verticalScroll.maxValue = c_contentSize.y - c_height;
				verticalScroll.pageSize = verticalScroll.maxValue * c_height / c_contentSize.y;
			} else {
				verticalScroll.value = 0;
			}
			
			if (horizontalScroll.visible) {
				horizontalScroll.x = c_contentRect.x;
				horizontalScroll.y = c_height + c_contentRect.y;
				horizontalScroll.Width = c_width;
				horizontalScroll.maxValue = c_contentSize.x - c_width;
				horizontalScroll.pageSize = horizontalScroll.maxValue * c_width / c_contentSize.x;
			} else {
				horizontalScroll.value = 0;
			}
			
			updateScrollRect();
			_dirtyScroll = false;
			return true;
		}
		return false;
	}
	
	//******************************
	//		GETTERS AND SETTERS
	//******************************
	
	private function get_scrollSize(): Float {
		return _getStyleProperty('scrollSize', ZajacCore.getHeightUnit() / 5);
	}
	
	private function set_scrollSize(v: Float): Float {
		if (v != scrollSize) {
			invalidScroll();
		}
		return _setStyleProperty('scrollSize', v);
	}
	
	private function get_contentRect(): Rectangle {
		var c_rect: Rectangle = new Rectangle(0, 0, Width, Height);
		if (borderColor != null) {
			c_rect.x = 1;
			c_rect.y = 1;
			c_rect.width -= 2;
			c_rect.height -= 2;
		}
		return c_rect;
	}
	
	//******************************
	//		EVENT LISTENERS
	//******************************

	private function _onContentResize(evt: Event): Void {
		invalidScroll();
	}
	
	private function _onMouseDown(evt: MouseEvent): Void {
		if (!enabled) return;
		_stopAnimation();
		_dragPoint = new Point(evt.stageX, evt.stageY);
		stage.addEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove);
		stage.addEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
	}
	
	private function _onMouseMove(evt: MouseEvent): Void {
		if (!enabled) return;
		var c_point: Point = new Point(evt.stageX, evt.stageY);
		
		if (!_dragging && PointUtil.distance(_dragPoint, c_point) < 10) return;
		horizontalScroll.alpha = 1;
		verticalScroll.alpha = 1;
		_dragging = true;
		_content.mouseChildren = false;
		
		var c_contentSize: Point = ComponentUtil.visibleContentSize(_content);
		var c_contentRect: Rectangle = contentRect;
		_dragDirection = _dragPoint.subtract(c_point);
		
		_contentX = Math.max(0, Math.min(c_contentSize.x - c_contentRect.width, _contentX + _dragDirection.x));
		_contentY = Math.max(0, Math.min(c_contentSize.y - c_contentRect.height, _contentY + _dragDirection.y));
		
		_dragPoint = c_point;
		
		invalidScroll();
		
	}
	
	private function _onMouseUp(evt: MouseEvent): Void {
		if (!enabled) return;
		stage.removeEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove);
		stage.removeEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
		_content.mouseChildren = true;
		_dragging = false;
		_startAnimation();
	}
	
	//******************************
	//		ANIMATION
	//******************************
	
	private var _animator: Sprite;
	
	private function _startAnimation(): Void {
		if (_animator != null) return;
		_animator = new Sprite();
		_animator.addEventListener(Event.ENTER_FRAME, _updateAnimation);
		Lib.current.stage.addChild(_animator);
	}
	
	private function _stopAnimation(): Void {
		if (_animator == null) return;
		Lib.current.stage.removeChild(_animator);
		_animator.removeEventListener(Event.ENTER_FRAME, _updateAnimation);
		_animator = null;
	}
	
	private function _updateAnimation(evt: Event): Void {
		var c_change: Bool = false;
		var c_oldValue: Float;
		
		var c_contentSize: Point = ComponentUtil.visibleContentSize(_content);
		var c_contentRect: Rectangle = contentRect;
		
		if (_dragDirection != null) {
			if (horizontalScroll.visible && Math.abs(_dragDirection.x) >= 1) {
				c_oldValue = _contentX;
				_contentX = Math.max(0, Math.min(c_contentSize.x - c_contentRect.width, _contentX + _dragDirection.x));
				if (Math.abs(c_oldValue - _contentX) >= 1) {
					c_change = true;
					_dragDirection.x += _dragDirection.x > 0 ? -1 : 1;
				}
			}
			
			if (verticalScroll.visible && Math.abs(_dragDirection.y) >= 1) {
				c_oldValue = _contentY;
				_contentY = Math.max(0, Math.min(c_contentSize.y - c_contentRect.height, _contentY + _dragDirection.y));
				if (Math.abs(c_oldValue - _contentY) >= 1) {
					c_change = true;
					_dragDirection.y += _dragDirection.y > 0 ? -1 : 1;
				}
			}
			
			if (c_change) {
				updateScrollRect();
				return;
			}
		}
		
		if (horizontalScroll.visible && horizontalScroll.alpha > 0) {
			 horizontalScroll.alpha -= 0.1;
			 c_change = true;
		}
		
		if (verticalScroll.visible && verticalScroll.alpha > 0) {
			 verticalScroll.alpha -= 0.1;
			 c_change = true;
		}
		
		if (!c_change) {
			_stopAnimation();
		}
	}
	
}