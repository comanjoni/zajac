package be.zajac.managers;
import flash.display.Graphics;
import nme.events.Event;
import nme.display.DisplayObject;
import nme.display.Sprite;
import nme.Lib;

/**
 * ...
 * @author Aleksandar Bogdanovic
 */

class PopUpDef {
	
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
	private static var _modalBackground: Sprite;
	private static var _popups: Array<PopUpDef> = new Array<PopUpDef>();
	
	private static function _initialize(): Void {
		if (_initialized) return;
		// TODO; research and debug this event. it is not firing!
		Lib.current.stage.addEventListener(Event.RESIZE, _resizeModalBackground);
		_initialized = true;
	}
	
	private static function _resizeModalBackground(evt: Event = null): Void {
		if (_modalBackground != null) {
			var g: Graphics = _modalBackground.graphics;
			g.clear();
			g.beginFill(0, 0.2);
			g.drawRect(0, 0, Lib.current.stage.stageWidth, Lib.current.stage.stageHeight);
			g.endFill();
		}
	}
	
	private static function _resetModalBackground(): Void {
		if (_modalBackground == null) {
			_modalBackground = new Sprite();
		}
		_resizeModalBackground();
		
		var c_isModal: Bool = false;
		var c_topIndex: Int = Lib.current.stage.numChildren - 1;
		
		for (_popup in _popups) {
			if (_popup.modal) {
				c_isModal = true;
				if (Lib.current.stage.contains(_modalBackground)) {
					Lib.current.stage.setChildIndex(_modalBackground, c_topIndex);
				} else {
					Lib.current.stage.addChild(_modalBackground);
					c_topIndex++;
				}
			}
			Lib.current.stage.setChildIndex(_popup.window, c_topIndex);
		}
		
		if (!c_isModal) {
			Lib.current.stage.removeChild(_modalBackground);
		}
	}
	
	private static function _removePopup(window: DisplayObject): PopUpDef {
		// find PupUp and remove it from list
		var c_popup: PopUpDef = null;
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
		if (Lib.current.stage.contains(window)) {
			Lib.current.stage.removeChild(window);
		}
		
		return c_popup;
	}
	
	public static function addPopUp(window: DisplayObject, modal: Bool = false): Void {
		if (window == null) return;
		
		// ensure that window reference is unique in _popups list
		var c_popup: PopUpDef = _removePopup(window);
		
		if (c_popup == null) {
			c_popup = new PopUpDef(window, modal);
		} else {
			c_popup.modal = modal;
		}
		_popups.push(c_popup);
		
		Lib.current.stage.addChild(window);
		
		if (c_popup.modal) {
			_resetModalBackground();
		}
	}
	
	public static function centerPopUp(window: DisplayObject): Void {
		if (window == null) return;
		if (!Lib.current.stage.contains(window)) return;
		
		window.x = (Lib.current.stage.stageWidth - window.width) / 2;
		window.y = (Lib.current.stage.stageHeight - window.height) / 2;
	}
	
	public static function removePopUp(window: DisplayObject): Void {
		if (window == null) return;
		
		var c_popup: PopUpDef = _removePopup(window);
		
		if (c_popup != null && c_popup.modal) {
			_resetModalBackground();
		}
	}
	
}