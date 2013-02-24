package rs.zajac.skins;

/**
 * Interface that should be used for Scroll skin.
 * @author Aleksandar Bogdanovic
 */
interface IScrollSkin implements ISkin {

	/**
	 * Skin class for Button in scroll.
	 * @return
	 */
	function getButtonSkinClass(): Class<ISkin>;
	
}