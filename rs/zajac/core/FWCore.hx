package rs.zajac.core;
import nme.system.Capabilities;

/**
 * Framework initializer.
 * @author Aleksandar Bogdanovic
 */

class FWCore {
	
	private function new() {}
	
	/**
	 * Calculate different height unit based on device.
	 * Otherwise getHeightUnit will return value from staticHeightUnit.
	 */
	static public var componentAutoSize: Bool = true;
	
	/**
	 * If componentAutoSize is false or application is compiled for
	 * desktop this value will be returned as height unit.
	 */
	static public var staticHeightUnit: Float = 20;
	
	/**
	 * Screen DPI will be mutiplied with this value for unit height calculation.
	 */
	static public var heightUnitMultiplier: Float = 0.5;
	
	/**
	 * Get default height unit based on device and dpi.
	 * If mobile devise is in use and componentAutoSize is true it
	 * will calculated height, otherwise it will return staticHeightUnit.
	 */
	static public function getHeightUnit(): Float {
		#if (iphone || android)
			if (componentAutoSize) {
				return Capabilities.screenDPI * heightUnitMultiplier;
			} else {
				return staticHeightUnit;
			}
		#else
			return staticHeightUnit;
		#end
	}
	
	static public var defaultFontMultiplier: Float = 0.6;
	static private var _fontMultipliers: Hash<Float> = new Hash<Float>();
	
	static public function addFontMultiplier(font: String, multiplier: Float): Void {
		_fontMultipliers.set(font, multiplier);
	}
	
	static public function getFontSize(?font: String): Int {
		var c_multiplier: Float = defaultFontMultiplier;
		if ((font != null) && _fontMultipliers.exists(font)) {
			c_multiplier = _fontMultipliers.get(font);
		}
		return Math.floor(getHeightUnit() * c_multiplier);
	}
	
}