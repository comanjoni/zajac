package be.zajac.skins;

interface IScrollSkin implements ISkin {

	function getButtonSkinClass(): Class<ISkin>;
	
}