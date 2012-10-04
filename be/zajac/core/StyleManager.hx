package be.zajac.core;
import be.zajac.util.HashUtil;
import be.zajac.ui.StyledComponent;
import nme.Assets;
import haxe.rtti.Meta;

/**
 * Provides functionality related to styles.
 * @author Aleksandar Bogdanovic
 */

class StyleManager {

	private function new() { }
	
	/**
	 * Contains all style definitions in system.
	 */
	static private var _styles: Hash<Hash<StyleProperty>> = new Hash<Hash<StyleProperty>>();
	
	/**
	 * Contains default styles for each styled component.
	 */
	static private var _defaultStyles: Hash<Hash<StyleProperty>> = new Hash<Hash<StyleProperty>>();
	
	/**
	 * Adding style (css) resource that is embeded as asset.
	 * @usage		StyleManager.addResource("style.css");
	 * @param	res	The ID or asset path for the css file
	 */
	static public function addResource(res: String): Void {
		var c_styles: Hash<Hash<StyleProperty>> = StyleParser.parse(Assets.getText(res));
		for (key in c_styles.keys()) {
			if (_styles.exists(key)) {
				HashUtil.update(_styles.get(key), c_styles.get(key));
			} else {
				_styles.set(key, c_styles.get(key));
			}
		}
	}
	
	/**
	 * Returns predefined style for component instance.
	 * @param	target	Any subclass of StyledComponent.
	 * @return		Hash map with style properties that should be used or storing style property values in StyledComponent.
	 */
	static public function getStyle(target: StyledComponent): Hash<StyleProperty> {
		var c_targetClass: Class<Dynamic> = Type.getClass(target);
		_processStyledComponent(c_targetClass);
		var c_targetClassName: String = Type.getClassName(c_targetClass);
		var c_styleCopy: Hash<StyleProperty> = new Hash<StyleProperty>();
		
		if (_styles.exists(c_targetClassName)) {
			var c_style: Hash<StyleProperty> = _styles.get(c_targetClassName);
			for (propName in getStyledProperties(target)) {
				c_styleCopy.set(propName, c_style.get(propName));
			}
		}
		
		return c_styleCopy;
	}
	
	/**
	 * 
	 * @param	target	Any subclass of StyledComponent.
	 * @param	name	Name of style in css asset (in css file it should start with ".")
	 * @return		Hash map with style properties that should be aplied to StyleComponent style.
	 */
	static public function getStyleByName(target: StyledComponent, name: String): Hash<StyleProperty> {
		if (name.charAt(0) != '.')
			name = '.' + name;
		
		var c_styleCopy: Hash<StyleProperty> = new Hash<StyleProperty>();
		
		if (_styles.exists(name)) {
			var c_style: Hash<StyleProperty> = _styles.get(name);
			for (propName in getStyledProperties(target)) {
				c_styleCopy.set(propName, c_style.get(propName));
			}
		}
		
		return c_styleCopy;
	}
	
	/**
	 * Analyze StyleProperty subclass in order to resolve styleable fields and default values for them.
	 * @param	targetClass	Class of component that should be analyzed.
	 * @return		Hash map with default style property values of targetClass.
	 */
	static private function _processStyledComponent(targetClass: Class<Dynamic>): Hash<StyleProperty> {
		var c_targetClassName: String = Type.getClassName(targetClass);
		
		if (_defaultStyles.exists(c_targetClassName)) {
			return _defaultStyles.get(c_targetClassName);
		}
		
		var c_defaultStyle: Hash<StyleProperty>;
		if (targetClass != StyledComponent) {
			c_defaultStyle = cast(HashUtil.copy(_processStyledComponent(Type.getSuperClass(targetClass))));
		} else {
			c_defaultStyle = new Hash<StyleProperty>();
		}
		
		var c_anotDict: Dynamic = Meta.getFields(targetClass);
		var c_anot: Dynamic;
		var c_fieldNames: Array<Dynamic> = Reflect.fields(c_anotDict);
		var c_defaultValue: Array<Dynamic>;
		for (fieldName in c_fieldNames) {
			// TODO: check is function
			c_anot = Reflect.field(c_anotDict, fieldName);
			if (Reflect.hasField(c_anot, 'style')) {
				c_defaultValue = Reflect.field(c_anot, 'style');
				if (c_defaultValue != null && c_defaultValue.length > 0) {
					c_defaultStyle.set(fieldName, new StyleProperty(c_defaultValue[0], StyleProperty.PRIORITY_DEFAULT));
				}
			}
		}
		_defaultStyles.set(c_targetClassName, c_defaultStyle);
		
		if (_styles.exists(c_targetClassName)) {
			var c_style: Hash<StyleProperty> = _styles.get(c_targetClassName);
			for (fieldName in c_defaultStyle.keys()) {
				if (!c_style.exists(fieldName)) {	// if exists that mean that its priority is greater then default
					c_style.set(fieldName, c_defaultStyle.get(fieldName));
				}
			}
		} else {
			_styles.set(c_targetClassName, cast(HashUtil.copy(c_defaultStyle)));
		}
		
		return c_defaultStyle;
	}
	
	/**
	 * Returns all field names that are styleable on targeted class.
	 * @param	targetClass
	 * @return		Iterator of field names.
	 */
	static public function getClassStyledProperties(targetClass: Class<Dynamic>): Iterator<String> {
		return _processStyledComponent(targetClass).keys();
	}
	
	/**
	 * Returns all field names that are styleable on targeted subclass of StyledComponent.
	 * @param	target
	 * @return
	 */
	static public function getStyledProperties(target: StyledComponent): Iterator<String> {
		return getClassStyledProperties(Type.getClass(target));
	}
	
}