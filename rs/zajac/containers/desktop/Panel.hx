package rs.zajac.containers.desktop;
import rs.zajac.core.FWCore;
import rs.zajac.skins.IPanelSkin;
import rs.zajac.skins.PanelSkin;
import rs.zajac.ui.Scroll;
import rs.zajac.ui.StyledComponent;
import rs.zajac.util.ComponentUtil;
import nme.display.DisplayObject;
import nme.display.Sprite;
import nme.events.Event;
import nme.events.MouseEvent;
import nme.geom.Point;
import nme.geom.Rectangle;

/**
 * ...
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
	
	public var mouseWheelStep: Float = 10;
	
	public var contentRect(get_contentRect, null): Rectangle;
	
	//******************************
	//		PRIVATE VARIABLES
	//******************************
	
	private var _content: Sprite;
	
	private var _dirtyScroll: Bool = true;
	
	//******************************
	//		PUBLIC METHODS
	//******************************
	
	public function new() {
		super();
		defaultWidth = defaultHeight = FWCore.getHeightUnit() * 5;
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
		_content.scrollRect = new Rectangle(horizontalScroll.value, verticalScroll.value, c_rect.width, c_rect.height);
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
		verticalScroll.addEventListener(Event.CHANGE, _onVerticalScroll);
		super.addChild(verticalScroll);
		
		horizontalScroll = new Scroll();
		horizontalScroll.direction = Scroll.DIRECTION_HORIZONTAL;
		horizontalScroll.minValue = 0;
		horizontalScroll.visible = false;
		horizontalScroll.addEventListener(Event.CHANGE, _onHorizontalScroll);
		super.addChild(horizontalScroll);
		
		addEventListener(MouseEvent.MOUSE_WHEEL, _onMouseWheel);
		
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
		return _getStyleProperty('scrollSize', FWCore.getHeightUnit() / 2);
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
	
	private function _onVerticalScroll(evt: Event): Void {
		updateScrollRect();
	}
	
	private function _onHorizontalScroll(evt: Event): Void {
		updateScrollRect();
	}
	
	private function _onMouseWheel(evt: MouseEvent): Void {
		if (!enabled) return;
		if (!evt.ctrlKey && verticalScroll.visible) {
			verticalScroll.value += mouseWheelStep * ((evt.delta < 0) ? 1 : -1);
			updateScrollRect();
		}
		if (evt.ctrlKey && horizontalScroll.visible) {
			horizontalScroll.value += mouseWheelStep * ((evt.delta < 0) ? 1 : -1);
			updateScrollRect();
		}
	}
	
}