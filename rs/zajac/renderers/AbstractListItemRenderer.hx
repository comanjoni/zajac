package rs.zajac.renderers;
import rs.zajac.core.ZajacCore;
import rs.zajac.skins.ISkin;
import rs.zajac.ui.StyledComponent;
import rs.zajac.ui.BaseComponent;
import nme.display.DisplayObject;
import nme.events.MouseEvent;
import nme.events.Event;
import nme.geom.Point;

/**
 * Abstract class for renderers that should be used in List.
 * @author Aleksandar Bogdanovic
 */
class AbstractListItemRenderer extends StyledComponent, implements ISkin {

	/**
	 * List item state when mouse is out.
	 */
	inline static public var OUT:		String = 'out';
	
	/**
	 * List item state when mouse is over.
	 */
	inline static public var OVER:		String = 'over';
	
	/**
	 * List item state when mouse is selected.
	 */
	inline static public var SELECTED:	String = 'selected';
	
	//******************************
	//		PUBLIC VARIABLES
	//******************************
	
	/**
	 * Current data in list item.
	 */
	public var data(default, set_data): Dynamic;
	
	public var selected(default, set_selected): Bool = false;
	
	//******************************
	//		PUBLIC METHODS
	//******************************
	
	public function new() {
		super();
		defaultWidth = ZajacCore.getHeightUnit() * 5;
		defaultHeight = ZajacCore.getHeightUnit();
	}
	
	/**
	 * Renderer is its own skin.
	 * This method is empty. Should be filled in subclass.
	 * @param	client
	 * @param	states
	 */
	public function draw(client: BaseComponent, states:Hash<DisplayObject>): Void { }
	
	//******************************
	//		PRIVATE METHODS
	//******************************
	
	override public function initialize(): Void {
		addEventListener(MouseEvent.CLICK, _onClick);
		#if !mobile
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
	
	#if !mobile
	
	private function _onRollOver(evt: MouseEvent): Void {
		if (!enabled) return;
		state = OVER;
	}
	
	private function _onRollOut(evt: MouseEvent): Void {
		if (!enabled) return;
		state = OUT;
	}
	
	#end
	
}