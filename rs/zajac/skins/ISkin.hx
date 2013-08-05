package rs.zajac.skins;
import rs.zajac.ui.BaseComponent;
import flash.display.DisplayObject;

/**
 * Interface for components that will draw skins for subclasses of BaseComponent.
 * @author Aleksandar Bogdanovic
 */
interface ISkin {

	/**
	 * Draw looks for all states of client component.
	 * @param	client	BaseComponent which skins should be created.
	 * @param	states	Map<String,DisplayObject> all current looks per state.
	 * @return		Map map with looks where keys are comonent states.
	 */
	function draw(client: BaseComponent, states:Map<String,DisplayObject>): Void;
	
}