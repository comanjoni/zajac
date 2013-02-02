package be.zajac.managers;
import be.zajac.ui.BaseComponent;
import be.zajac.util.ComponentUtil;
import flash.display.Graphics;
import nme.display.DisplayObjectContainer;
import nme.display.Stage;
import nme.events.Event;
import nme.display.DisplayObject;
import nme.display.Sprite;
import nme.geom.Point;
import nme.Lib;

/**
 * ...
 * @author Aleksandar Bogdanovic
 */

class _PopUpDef {
	
	public var window: DisplayObject;
	public var modal: Bool;
	
	public function new(window: DisplayObject, modal: Bool) {
		this.window = window;
		this.modal = modal;
	}
}

class PopUpManager {

	private function new() { }
	
	private static var _initialized: Bool = false;
	private static var _popups: Array<_PopUpDef> = new Array<_PopUpDef>();
	private static var _modalBackgrounds: Array<Sprite> = new Array<Sprite>();
	
	private static function _initialize(): Void {
		if (_initialized) return;
		// TODO: research and debug this event. it is not firing!
		Lib.current.stage.addEventListener(Event.RESIZE, _resizeModalBackgrounds);
		_initialized = true;
	}
	
	private static function _resizeModalBackground(modalBackground: Sprite): Void {
		var c_dimensions: Point = ComponentUtil.size(modalBackground.parent);
		var g: Graphics = modalBackground.graphics;
		g.clear();
		g.beginFill(0, 0.2);
		g.drawRect(0, 0, c_dimensions.x, c_dimensions.y);
		g.endFill();
	}
	
	private static function _resizeModalBackgrounds(evt: Event = null): Void {
		for (_modalBackground in _modalBackgrounds) {
			_resizeModalBackground(_modalBackground);
		}
	}
	
	private static function _reorderPopups(parent: DisplayObjectContainer): Void {
		var c_topModal: DisplayObject = null;
		var c_modalBackground: Sprite = null;
		
		for (_popup in _popups) {
			if (_popup.window.parent == parent) {
				parent.removeChild(_popup.window);
				parent.addChild(_popup.window);
				if (_popup.modal) {
					c_topModal = _popup.window;
				}
			}
		}
		
		for (_modalBackground in _modalBackgrounds) {
			if (_modalBackground.parent == parent) {
				c_modalBackground = _modalBackground;
			}
		}
		if (c_topModal == null) {
			if (c_modalBackground != null) {
				parent.removeChild(c_modalBackground);
				_modalBackgrounds.remove(c_modalBackground);
			}
		} else {
			var c_childIndex: Int = parent.getChildIndex(c_topModal);
			if (c_modalBackground == null) {
				c_modalBackground = new Sprite();
				parent.addChildAt(c_modalBackground, c_childIndex);
				_modalBackgrounds.push(c_modalBackground);
			} else {
				parent.setChildIndex(c_modalBackground, c_childIndex - 1);
			}
			_resizeModalBackground(c_modalBackground);
		}
	}
	
	private static function _removePopup(window: DisplayObject): _PopUpDef {
		// find PupUp and remove it from list
		var c_popup: _PopUpDef = null;
		for (_popup in _popups) {
			if (_popup.window == window) {
				c_popup = _popup;
				break;
			}
		}
		if (c_popup != null) {
			_popups.remove(c_popup);
		}
		
		// remove window from stage
		if (window.parent != null) {
			window.parent.removeChild(window);
		}
		
		return c_popup;
	}
	
	private static function _onAdded(evt: Event): Void {
		if (evt.target.parent == evt.currentTarget) {
			_removeEvents();
			_reorderPopups(evt.currentTarget);
			_addEvents();
		}
	}
	
	private static function _addEvents(): Void {
		var c_parents: Array<DisplayObjectContainer> = new Array<DisplayObjectContainer>();
		var c_parent: DisplayObjectContainer;
		
		for (_popup in _popups) {
			c_parent = _popup.window.parent;
			for (_parent in c_parents) {
				if (c_parent == _parent) {
					c_parent.addEventListener(Event.ADDED, _onAdded);
					c_parents.push(c_parent);
					break;
				}
			}
		}
	}
	
	private static function _removeEvents(): Void {
		for (_popup in _popups) {
			if (_popup.window.parent != null) {
				_popup.window.parent.removeEventListener(Event.ADDED, _onAdded);
			}
		}
	}
	
	public static function addPopUp(parent: DisplayObjectContainer, window: DisplayObject, modal: Bool = false): Void {
		if (window == null) return;
		if (parent == null) {
			parent = Lib.current.stage;
		}
		
		_initialize();
		_removeEvents();
		
		// ensure that window reference is unique in _popups list
		var c_popup: _PopUpDef = _removePopup(window);
		
		if (c_popup == null) {
			c_popup = new _PopUpDef(window, modal);
		} else {
			c_popup.modal = modal;
		}
		_popups.push(c_popup);
		
		parent.addChild(window);
		
		_reorderPopups(parent);
		
		_addEvents();
	}
	
	public static function centerPopUp(window: DisplayObject): Void {
		if (window == null) return;
		if (window.parent == null) return;
		
		var c_parentDimension: Point = ComponentUtil.size(window.parent);
		var c_windowDimension: Point = ComponentUtil.size(window);
		
		window.x = (c_parentDimension.x - c_windowDimension.x) / 2;
		window.y = (c_parentDimension.y - c_windowDimension.y) / 2;
	}
	
	public static function removePopUp(window: DisplayObject): Void {
		if (window == null) return;
		
		_removeEvents();
		
		var c_parent: DisplayObjectContainer = window.parent;
		var c_popup: _PopUpDef = _removePopup(window);
		if (c_parent != null) {
			_reorderPopups(c_parent);
		}
		
		_addEvents();
	}
	
}