package be.zajac.core;

/**
 * This class is used for storing values of styled properties in StyledComponent.
 * @author Aleksandar Bogdanovic
 */

class StyleProperty {

	static public inline var PRIORITY_DEFAULT				= 1;
	static public inline var PRIORITY_COMPONENT				= 2;
	static public inline var PRIORITY_STYLE_NAME			= 3;
	static public inline var PRIORITY_INSTANCE_PROPERTY		= 4;
	
	/**
	 * Value of property.
	 */
	public var value(default, null): Dynamic;
	
	/**
	 * Priority of property based on its origin.
	 */
	public var priority: Int;
	
	/**
	 * @param	pvalue	Property value.
	 * @param	ppriority	Property priority.
	 */
	public function new(pvalue: Dynamic, ppriority: Int = PRIORITY_DEFAULT) {
		value = pvalue;
		priority = ppriority;
	}
	
	public function toString(): String {
		return '[StyleProperty value="' + value + '" priority="' + priority + '"]';
	}
	
}