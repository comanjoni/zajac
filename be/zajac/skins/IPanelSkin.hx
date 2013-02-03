package be.zajac.skins;

/**
 * ...
 * @author Aleksandar Bogdanovic
 */

interface IPanelSkin implements ISkin {

	function getVScrollSkinClass(): Class<ISkin>;
	function getHScrollSkinClass(): Class<ISkin>;
	
}