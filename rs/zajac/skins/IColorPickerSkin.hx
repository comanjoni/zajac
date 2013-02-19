package rs.zajac.skins;

/**
 * ...
 * @author Aleksandar Bogdanovic
 */

interface IColorPickerSkin implements ISkin {

	function getPaletteSkinClass(): Class<ISkin>;
	
}