package rs.zajac.core;
import flash.system.Capabilities;

/**
 * Framework core properties.
 * @author Aleksandar Bogdanovic
 */
class ZajacCore {
	
	private function new() {}
	
	/**
	 * Enable calculating different height unit based on device.
	 * Otherwise getHeightUnit will return value from staticHeightUnit.
	 */
	static public var componentAutoSize: Bool = true;
	
	/**
	 * If componentAutoSize is disabled or application is compiled for
	 * desktop this value will be returned as height unit.
	 */
	static public var staticHeightUnit: Float = 20;
	
	/**
	 * Screen DPI will be mutiplied with this value for unit height calculation.
	 */
	static public var heightUnitMultiplier: Float = 0.5;
	
	/**
	 * Get default height unit based on device type and screen DPI.
	 * If mobile devise is in use and componentAutoSize is enabled it
	 * will calculated height, otherwise it will return staticHeightUnit.
	 */
	static public function getHeightUnit(): Float {
		#if mobile
			if (componentAutoSize) {
				return Capabilities.screenDPI * heightUnitMultiplier;
			} else {
				return staticHeightUnit;
			}
		#else
			return staticHeightUnit;
		#end
	}
	
	/**
	 * Default height unit will be multiplied with this value for default font
	 * size calculation.
	 */
	static public var defaultFontMultiplier: Float = 0.6;
	
	static private var _fontMultipliers: Map<String,Float> = new Map<String,Float>();
	
	/**
	 * Adding multiplier for specific font.
	 * @param	font	Font name.
	 * @param	multiplier	Multiplying value for specified font.
	 */
	static public function addFontMultiplier(font: String, multiplier: Float): Void {
		_fontMultipliers.set(font, multiplier);
	}
	
	/**
	 * Get default font size for specific font. If font is not specified or 
	 * multiplier is not specified using addFontMultiplier it will return value
	 * calculated using defaultFontMultiplier.
	 * @param	?font	Font name or null.
	 * @return	default Font size.
	 */
	static public function getFontSize(?font: String): Int {
		var c_multiplier: Float = defaultFontMultiplier;
		if ((font != null) && _fontMultipliers.exists(font)) {
			c_multiplier = _fontMultipliers.get(font);
		}
		return Math.floor(getHeightUnit() * c_multiplier);
	}
	
}