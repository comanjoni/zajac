package be.zajac.renderers;
import be.zajac.core.FWCore;
import be.zajac.skins.ISkin;
import be.zajac.ui.StyledComponent;
import be.zajac.ui.BaseComponent;
import nme.display.DisplayObject;
import nme.events.MouseEvent;
import nme.events.Event;
import nme.geom.Point;

/**
 * ...
 * @author Aleksandar Bogdanovic
 */

class AbstractListItemRenderer extends StyledComponent, implements ISkin {

	inline static public var OUT:		String = 'out';
	inline static public var OVER:		String = 'over';
	inline static public var SELECTED:	String = 'selected';
	
	//******************************
	//		PUBLIC VARIABLES
	//******************************
	
	public var data(default, set_data): Dynamic;
	public var selected(default, set_selected): Bool = false;
	
	//******************************
	//		PUBLIC METHODS
	//******************************
	
	public function new() {
		super();
		defaultWidth = FWCore.getHeightUnit() * 5;
		defaultHeight = FWCore.getHeightUnit();
	}
	
	public function draw(client: BaseComponent, states:Hash<DisplayObject>): Void { }
	
	//******************************
	//		PRIVATE METHODS
	//******************************
	
	override public function initialize(): Void {
		addEventListener(MouseEvent.CLICK, _onClick);
		#if !(android || ios)
		addEventListener(MouseEvent.ROLL_OVER, _onRollOver);
		addEventListener(MouseEvent.ROLL_OUT, _onRollOut);
		#end
		
		skin = this;
		state = OUT;
	}
	
	//******************************
	//		GETTERS AND SETTERS
	//******************************
	
	override private function get_state(): String {
		if (selected) return SELECTED;
		return state;
	}
	
	private function set_data(v: Dynamic): Dynamic {
		if (v != data) {
			data = v;
			invalidSkin();
		}
		return v;
	}
	
	private function set_selected(v: Bool): Bool {
		if (v != selected) {
			selected = v;
			invalidState();
		}
		return v;
	}
	
	//******************************
	//		EVENT LISTENERS
	//******************************
	
	private function _onClick(evt: MouseEvent): Void {
		if (!enabled) return;
		dispatchEvent(new Event(Event.SELECT));
	}
	
	private function _onRollOver(evt: MouseEvent): Void {
		if (!enabled) return;
		state = OVER;
	}
	
	private function _onRollOut(evt: MouseEvent): Void {
		if (!enabled) return;
		state = OUT;
	}
	
}