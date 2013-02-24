package rs.zajac.skins;

/**
 * Interface that should be used for Panel skin.
 * @author Aleksandar Bogdanovic
 */
interface IPanelSkin implements ISkin {

	/**
	 * Skin class for vertical Scroll in panel.
	 * @return
	 */
	function getVScrollSkinClass(): Class<ISkin>;
	
	/**
	 * Skin class for horizontal Scroll in panel.
	 * @return
	 */
	function getHScrollSkinClass(): Class<ISkin>;
	
}