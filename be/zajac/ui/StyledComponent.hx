package be.zajac.ui;

import be.zajac.core.StyleProperty;
import be.zajac.core.StyleManager;

/**
 * Root component that support styling.
 * Subclasses need to specially define properties that should by styleable.
 * Styleable means that property can be set from css.
 * Styleable property example:
 * @style public var property_name: property_type = property_default_value;
 * Where default value depends on proprty_type.
 * Dynamic getter and setter are important as they are dynamically added on class construction.
 * Property type can be: Int, Float, Bool and String
 * @author Aleksandar Bogdanovic
 */
@:autoBuild(be.zajac.macro.StyleMacro.build()) class StyledComponent extends BaseComponent {
	
	//******************************
	//		PUBLIC VARIABLES
	//******************************

	// Specific style from css files. In css file this style should start with ".".
	public var styleName(default, set_styleName): String;
	
	//******************************
	//		PRIVATE VARIABLES
	//******************************

	private var _style: Hash<StyleProperty>;
	
	//******************************
	//		PUBLIC METHODS
	//******************************
	
	// Constructor.
	public function new() {
		super();
		_style = StyleManager.getStyle(this);
	}
	
	//******************************
	//		PRIVATE METHODS
	//******************************
	
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
	
	// If developer want to override default getter, this method should be called from getter to get valid value.
	private function _getStyleProperty(key: String, ?defVal: Dynamic): Dynamic {
		return _style.exists(key) ? _style.get(key).value : defVal;
	}
	
	// If developer want to override default setter, this method should be called from setter to complete invalidation cycle.
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