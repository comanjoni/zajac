package be.zajac.skins;

/**
 * ...
 * @author Aleksandar Bogdanovic
 */

interface IComboBoxSkin implements ISkin {

	function getListSkinClass(): Class<ISkin>;
	
}