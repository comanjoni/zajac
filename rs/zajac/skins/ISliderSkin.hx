package rs.zajac.skins;

/**
 * Interface that should be used for Slider skin.
 * @author Ilic S Stojan
 */
interface ISliderSkin implements ISkin {

	/**
	 * Skin class for Button in slider.
	 * @return
	 */
	function getButtonSkinClass(): Class<ISkin>;
	
}