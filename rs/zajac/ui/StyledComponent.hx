package rs.zajac.ui;

import rs.zajac.core.StyleProperty;
import rs.zajac.managers.StyleManager;

/**
 * Root framework component that support styling.
 * Subclasses need to specially define properties that should by styleable.
 * Styleable means that property can be set using css.
 * Styleable property example:
	 * @style public var test: Int = 3;
 * In compile time this is translated to:
	 * @style public var test(get_test, set_test): Int;
	 * private function get_test(): Int {
	 *     return _getStyleProperty("test", 3);
	 * }
	 * private function set_test(v: Int): Int {
	 *     return _setStyleProperty("test", v);
	 * }
 * If specific functionality is requred in getter or setter developer can make manually getter or setter
 * but _getStylePoperty and _setStyleProperty must be used for value storage.
 * Setter example:
	 * @style public var (get_test, default): Int;
	 * private function get_test(): Int {
	 *     // some code
	 *     return _getStyleProperty("test", 3);		// Notie that default value is defined here and not in variable definition.
	 * }
 * Getter example:
	 * @style public var test(default, set_test): Int = 3;
	 * private function set_test(v: Int): Int {
	 *     // some code
	 *     return _setStyleProperty("test", v);
	 * }
 * @author Aleksandar Bogdanovic
 */
@:autoBuild(rs.zajac.macro.StyleMacro.build()) class StyledComponent extends BaseComponent {
	
	//******************************
	//		PUBLIC VARIABLES
	//******************************

	/**
	 * Specific style from css files. In css file this style must start with ".".
	 */
	public var styleName(default, set_styleName): String;
	
	//******************************
	//		PRIVATE VARIABLES
	//******************************

	/**
	 * Map of values for each style property.
	 * Key in this map is name of style propery.
	 */
	private var _style: Hash<StyleProperty>;
	
	//******************************
	//		PUBLIC METHODS
	//******************************
	
	public function new() {
		_style = StyleManager.getStyle(this);
		super();
	}
	
	//******************************
	//		PRIVATE METHODS
	//******************************
	
	/**
	 * Add style property values to component from specific style property map.
	 * Used for setting style from css.
	 * @param	style
	 */
	private function _mergeStyle(style: Hash<StyleProperty>): Void {
		if (style == null) return;
		
		var c_prop: StyleProperty;
		var c_changed: Bool = false;
		
		for (key in style.keys()) {
			c_prop = style.get(key);
			if (_style.exists(key)) {
				if (_style.get(key).priority <= c_prop.priority) {
					_style.set(key, c_prop);
					c_changed = true;
				}
			} else {
				_style.set(key, c_prop);
				c_changed = true;
			}
		}
		
		if (c_changed) invalidSkin();
	}
	
	/**
	 * If developer want to override default getter, this method should be called from getter to get valid value.
	 * @param	key	Stlye property name.
	 * @param	?defVal	Default value. If style propery is not set return this value.
	 * @return
	 */
	private function _getStyleProperty(key: String, ?defVal: Dynamic): Dynamic {
		return _style.exists(key) ? _style.get(key).value : defVal;
	}
	
	/**
	 * If developer want to override default setter, this method should be called from setter to complete invalidation cycle.
	 * @param	key	Style propery name.
	 * @param	value
	 * @return
	 */
	private function _setStyleProperty(key: String, value: Dynamic): Dynamic {
		var c_curProp: StyleProperty = _style.get(key);
		
		if ((c_curProp == null) || (c_curProp.value != value)) {
			_style.set(key, new StyleProperty(value, StyleProperty.PRIORITY_INSTANCE_PROPERTY));
			invalidSkin();
		} else if (c_curProp.priority < StyleProperty.PRIORITY_INSTANCE_PROPERTY) {
			_style.set(key, new StyleProperty(value, StyleProperty.PRIORITY_INSTANCE_PROPERTY));
		}
		
		return value;
	}
	
	//******************************
	//		GETTERS AND SETTERS
	//******************************
	
	private function set_styleName(v: String): String {
		if (v != styleName) {
			styleName = v;
			_mergeStyle(StyleManager.getStyleByName(this, styleName));
		}
		return styleName;
	}
	
}