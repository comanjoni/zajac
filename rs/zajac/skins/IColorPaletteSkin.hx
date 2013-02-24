package rs.zajac.skins;
import nme.display.DisplayObject;

/**
 * Interface that should be used for ColorPalette skin.
 * @author Aleksandar Bogdanovic
 */
interface IColorPaletteSkin implements ISkin {

	/**
	 * Skin for cursor pointing to selected color.
	 * @return
	 */
	function getCursor(): DisplayObject;
	
}