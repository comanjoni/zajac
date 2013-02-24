package rs.zajac.skins;
import rs.zajac.ui.BaseComponent;
import nme.display.DisplayObject;

/**
 * Interface for components that will draw skins for subclasses of BaseComponent.
 * @author Aleksandar Bogdanovic
 */
interface ISkin {

	/**
	 * Draw looks for all states of client component.
	 * @param	client	BaseComponent which skins should be created.
	 * @param	states	Hash<DisplayObject> all current looks per state.
	 * @return		Hash map with looks where keys are comonent states.
	 */
	function draw(client: BaseComponent, states:Hash<DisplayObject>): Void;
	
}