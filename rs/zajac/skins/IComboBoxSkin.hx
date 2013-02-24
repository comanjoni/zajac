package rs.zajac.skins;

/**
 * Interface that should be used for CmoboBox skin.
 * @author Aleksandar Bogdanovic
 */
interface IComboBoxSkin implements ISkin {

	/**
	 * Skin class for List in combo box.
	 * @return
	 */
	function getListSkinClass(): Class<ISkin>;
	
}