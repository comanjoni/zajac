package be.zajac.core;
import be.zajac.util.HashUtil;
import be.zajac.ui.StyledComponent;
import nme.Assets;
import haxe.rtti.Meta;
import nme.utils.ByteArray;

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
	 * Contains style properties for each styled component.
	 */
	static private var _classStyleProperties: Hash<Array<String>> = new Hash<Array<String>>();
	
	/**
	 * Adding style (css) resource that is embeded as asset.
	 * @usage		StyleManager.addResource("style.css");
	 * @param	res	The ID or asset path for the css file
	 */
	static public function addResource(res: String): Void {
		var c_css: String = null;
		#if js
			var c_bytes: ByteArray = Assets.getBytes(res);
			if (c_bytes != null) {
				c_css = Assets.getBytes(res).readUTF();
			}
		#else
			c_css = Assets.getText(res);
		#end
		if (c_css != null) {
			var c_styles: Hash<Hash<StyleProperty>> = StyleParser.parse(c_css);
			for (key in c_styles.keys()) {
				if (_styles.exists(key)) {
					HashUtil.update(_styles.get(key), c_styles.get(key));
				} else {
					_styles.set(key, c_styles.get(key));
				}
			}
		}
	}
	
	/**
	 * Returns predefined style for component instance.
	 * @param	target	Any subclass of StyledComponent.
	 * @return		Hash map with style properties that should be used or storing style property values in StyledComponent.
	 */
	static public function getStyle(target: StyledComponent): Hash<StyleProperty> {
		var c_targetClass: Class<StyledComponent> = Type.getClass(target);
		var c_targetClassName: String = Type.getClassName(c_targetClass);
		var c_styleCopy: Hash<StyleProperty> = new Hash<StyleProperty>();
		
		if (_styles.exists(c_targetClassName)) {
			var c_style: Hash<StyleProperty> = _styles.get(c_targetClassName);
			for (propName in getClassStyleProperties(c_targetClass)) {
				if (c_style.exists(propName)) {
					c_styleCopy.set(propName, c_style.get(propName));
				}
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
			for (propName in getStyleProperties(target)) {
				if (c_style.exists(propName)) {
					c_styleCopy.set(propName, c_style.get(propName));
				}
			}
		}
		
		return c_styleCopy;
	}
	
	/**
	 * Analyze StyleProperty subclass in order to resolve styleable fields and default values for them.
	 * @param	targetClass	Class of component that should be analyzed.
	 * @return		Hash map with default style property values of targetClass.
	 */
	static private function _processStyledComponent(targetClass: Class<StyledComponent>): Array<String> {
		var c_targetClassName: String = Type.getClassName(targetClass);
		
		if (_classStyleProperties.exists(c_targetClassName)) {
			return _classStyleProperties.get(c_targetClassName);
		}
		
		var c_properties: Array<String>;
		if (targetClass != StyledComponent) {
			c_properties = _processStyledComponent(cast(Type.getSuperClass(targetClass))).copy();
		} else {
			c_properties = new Array<String>();
		}
		
		var c_anotDict: Dynamic = Meta.getFields(targetClass);
		var c_fieldNames: Array<Dynamic> = Reflect.fields(c_anotDict);
		var c_anot: Dynamic;
		for (fieldName in c_fieldNames) {
			c_anot = Reflect.field(c_anotDict, fieldName);
			if (Reflect.hasField(c_anot, 'style')) {
				c_properties.push(fieldName);
			}
		}
		_classStyleProperties.set(c_targetClassName, c_properties);
		
		return c_properties;
	}
	
	/**
	 * Returns all field names that are styleable on targeted class.
	 * @param	targetClass
	 * @return		Iterator of field names.
	 */
	static public function getClassStyleProperties(targetClass: Class<StyledComponent>): Array<String> {
		return _processStyledComponent(targetClass);
	}
	
	/**
	 * Returns all field names that are styleable on targeted subclass of StyleComponent.
	 * @param	target
	 * @return
	 */
	static public function getStyleProperties(target: StyledComponent): Array<String> {
		return getClassStyleProperties(Type.getClass(target));
	}
	
}