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
	
	private static function _setModalBackground(window: DisplayObject): Void {
		if (_modalBackground == null) {
			_modalBackground = new Sprite();
		}
		_resizeModalBackground();
		var c_index: Int = Lib.current.stage.getChildIndex(window);
		// TODO: debug this. modal dialog is not positioned well on stage
		if (Lib.current.stage.contains(_modalBackground)) {
			Lib.current.stage.setChildIndex(_modalBackground, c_index - 1);
		} else {
			Lib.current.stage.addChildAt(_modalBackground, c_index);
		}
	}
	
	public static function addPopUp(window: DisplayObject, modal: Bool = false): Void {
		if (window == null) return;
		
		// ensure that window reference is unique in _popups list
		removePopUp(window);
		
		_popups.push(new PopUpDef(window, modal));
		
		Lib.current.stage.addChild(window);
		
		if (modal) {
			_setModalBackground(window);
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
		
		// set modal background to another modal popup
		var i: Int = _popups.length - 1;
		while (i >= 0) {
			c_popup = _popups[i];
			if (c_popup.modal) {
				_setModalBackground(c_popup.window);
				return;
			}
			i--;
		}
		
		// or remove modal background if no modal popup was found
		if (_modalBackground != null && Lib.current.stage.contains(_modalBackground)) {
			Lib.current.stage.removeChild(_modalBackground);
			_modalBackground = null;
		}
	}
	
}