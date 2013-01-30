package be.zajac.renderers;
import be.zajac.core.FWCore;
import be.zajac.skins.ISkin;
import be.zajac.ui.BaseComponent;
import nme.display.DisplayObject;
import nme.events.MouseEvent;
import nme.events.Event;

/**
 * ...
 * @author Aleksandar Bogdanovic
 */

class AbstractListItemRenderer extends BaseComponent, implements ISkin {

	public function new() {
		super();
		defaultWidth = FWCore.getHeightUnit() * 5;
		defaultHeight = FWCore.getHeightUnit();
	}
	
	override public function initialize(): Void {
		#if (android || ios)
			addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
		#else
			addEventListener(MouseEvent.CLICK, _onClick);
		#end
		skin = this;
	}
	
	// ios and android
	private var _pressTimestamp: Float;
	
	private function _onMouseDown(evt: MouseEvent): Void {
		_pressTimestamp = Date.now().getTime();
		addEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove);
		addEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
	}
	
	private function _onMouseMove(evt: MouseEvent): Void {
		_pressTimestamp = -1;
		removeEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove);
		removeEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
	}
	
	private function _onMouseUp(evt: MouseEvent): Void {
		if (_pressTimestamp > 0 && (Date.now().getTime() - _pressTimestamp) < 1000) {
			dispatchEvent(new Event(Event.SELECT));
		}
		_onMouseMove(evt);
	}
	// end ios and android
	
	// desktop
	private function _onClick(evt: MouseEvent): Void {
		dispatchEvent(new Event(Event.SELECT));
	}
	// end desktop
	
	public var data(default, set_data): Dynamic;
	private function set_data(v: Dynamic): Dynamic {
		if (v != data) {
			data = v;
			invalidSkin();
		}
		return v;
	}
	
	public var selected(default, set_selected): Bool = false;
	private function set_selected(v: Bool): Bool {
		if (v != selected) {
			selected = v;
			invalidState();
		}
		return v;
	}
	
	public function draw(client: BaseComponent, states:Hash<DisplayObject>): Void { }
	
}