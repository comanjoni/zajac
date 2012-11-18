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
		Height = FWCore.getHeightUnit();
		Width = FWCore.getHeightUnit() * 5;
	}
	
	override public function initialize(): Void {
		addEventListener(MouseEvent.CLICK, _onClick);
		skin = this;
	}
	
	private function _onClick(evt: MouseEvent): Void {
		dispatchEvent(new Event(Event.SELECT));
	}
	
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
	
	public function draw(client: BaseComponent, states:Hash<DisplayObject>): Void {
		
	}
	
}