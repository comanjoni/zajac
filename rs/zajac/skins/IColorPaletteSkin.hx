package rs.zajac.skins;
import flash.display.DisplayObject;

/**
 * Interface that should be used for ColorPalette skin.
 * @author Aleksandar Bogdanovic
 */
interface IColorPaletteSkin extends ISkin {

	/**
	 * Skin for cursor pointing to selected color.
	 * @return
	 */
	function getCursor(): DisplayObject;
	
}