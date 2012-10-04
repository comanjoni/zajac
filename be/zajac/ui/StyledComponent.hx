package be.zajac.ui;

import be.zajac.core.StyleProperty;
import be.zajac.core.StyleManager;

/**
 * Root component that support styling.
 * Subclasses need to specially define properties that should by styleable.
 * Styleable means that property can be set from css.
 * Styleable property example:
 * @Styled(default_value) public var property_name(dynamic, dynamic): property_type;
 * Where default value depends on proprty_type.
 * Dynamic getter and setter are important as they are dynamically added on class construction.
 * Property type can be: Int, Float, Bool and String
 * @author Aleksandar Bogdanovic
 */
class StyledComponent extends BaseComponent, implements Dynamic {

	private var _style: Hash<StyleProperty>;
	
	private function _mergeStyle(style: Hash<StyleProperty>): Void {
		if (style == null) return;
		
		var c_changed: Bool = false;
		var c_prop: StyleProperty;
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
	 * Specific style from css files. In css file this style should start with ".".
	 */
	public var styleName(_getStyleName, _setStyleName): String;
	private function _getStyleName(): String {
		return styleName;
	}
	private function _setStyleName(v: String): String {
		if (v != styleName) {
			styleName = v;
			_mergeStyle(StyleManager.getStyleByName(this, styleName));
		}
		return styleName;
	}
	
	
	public function new() {
		super();
		_style = StyleManager.getStyle(this);
		
		var c_styledProperties: Iterator<String> = StyleManager.getStyledProperties(this);
		for (propName in c_styledProperties) {
			var c_getter = function() {
				if (_style.exists(propName)) {
					return _style.get(propName).value;
				}
				return null;
			}
			var c_setter = function(v) {
				_style.set(propName, new StyleProperty(v, StyleProperty.PRIORITY_INSTANCE_PROPERTY));
				invalidSkin();
				return v;
			}
			Reflect.setField(this, "get_" + propName, c_getter);
			Reflect.setField(this, "set_" + propName, c_setter);
		}
	}
	
}