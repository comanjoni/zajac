package be.zajac.core;
import be.zajac.util.HashUtil;
import be.zajac.util.IntUtil;

/**
 * CSS parser.
 * @author Aleksandar Bogdanovic
 */

class StyleParser {
	
	private function new() {}

	// string definitions
	
	static private inline var R_DASH_REPLACE: String		= '-[a-z]';
	static private inline var R_WHITECPACE: String			= '(\\s)*';
	
	static private inline var R_SELECTOR_WORD: String		= '[A-Za-z]+[A-Za-z0-9_]*';
	static private inline var R_SELECTOR_COMP: String		= R_SELECTOR_WORD + '([.]' + R_SELECTOR_WORD + ')*';
	static private inline var R_SELECTOR_CLASS: String		= '[.]' + R_SELECTOR_WORD;
	static private inline var R_SELECTOR: String			= '(' + R_SELECTOR_COMP + '|' + R_SELECTOR_CLASS + ')';
	
	static private inline var R_PROPERTY: String			= '[A-Za-z]+(-[A-Za-z0-9_]+)*';
	
	static private inline var R_VALUE_INT: String			= '^(-)?[0-9]+$';
	static private inline var R_VALUE_HEX: String			= '^#[0-9a-fA-F]{1,6}$';
	static private inline var R_VALUE_FLOAT: String			= '^(-)?[0-9]+.[0-9]+$';
	static private inline var R_VALUE_BOOL: String			= '^(true|false)$';
	static private inline var R_VALUE_STR: String			= '^("(.)*"|\'(.)*\')$';
	static private inline var R_VALUE: String				= '(.)*';
	
	static private inline var R_DECLARATION: String			= R_PROPERTY + R_WHITECPACE + ':' + R_WHITECPACE + R_VALUE;
	static private inline var R_DECLARATION_BLOCK: String	= '{' + R_WHITECPACE + R_DECLARATION + '(;' + R_WHITECPACE + R_DECLARATION + ')*' + R_WHITECPACE + '(;' + R_WHITECPACE + ')?}';
	
	static private inline var R_RULE_SET: String			= R_SELECTOR + R_WHITECPACE + '(,' + R_WHITECPACE + R_SELECTOR + R_WHITECPACE + ')*' + R_DECLARATION_BLOCK;
	
	// regular expressions
	
	static private var DASH_REPLACE: EReg					= new EReg(R_DASH_REPLACE, '');
	
	static private var SELECTOR_COMP: EReg					= new EReg('^' + R_SELECTOR_COMP + '$', 'im');
	static private var SELECTOR_CLASS: EReg					= new EReg('^' + R_SELECTOR_CLASS + '$', 'im');
	static private var SELECTOR: EReg						= new EReg(R_SELECTOR, 'im');
	
	static private var PROPERTY: EReg						= new EReg(R_PROPERTY, 'im');
	
	static private var VALUE_INT: EReg						= new EReg(R_VALUE_INT, 'im');
	static private var VALUE_HEX: EReg						= new EReg(R_VALUE_HEX, 'im');
	static private var VALUE_FLOAT: EReg					= new EReg(R_VALUE_FLOAT, 'im');
	static private var VALUE_BOOL: EReg						= new EReg(R_VALUE_BOOL, 'im');
	static private var VALUE_STR: EReg						= new EReg(R_VALUE_STR, 'im');
	
	static private var DECLARATION: EReg					= new EReg(R_DECLARATION, 'im');
	static private var DECLARATION_BLOCK: EReg				= new EReg(R_DECLARATION_BLOCK, 'im');
	
	static private var RULE_SET: EReg						= new EReg(R_RULE_SET, 'im');
	
	// parsing methods
	
	static private function _replaceDash(r: EReg): String {
		return r.matched(0).substr(1).toUpperCase();
	}
	
	static private function _parseValue(input: String): Dynamic {
		if (VALUE_INT.match(input)) {
			return Std.parseInt(input);
		} else if (VALUE_HEX.match(input)) {
			return IntUtil.hex2int(input);
		} else if (VALUE_FLOAT.match(input)) {
			return Std.parseFloat(input);
		} else if (VALUE_BOOL.match(input)) {
			return input.toLowerCase() == 'true';
		} else if (VALUE_STR.match(input)) {
			return input.substring(1, input.length - 1);	// remove ' or " on begin and on end
		}
		return null;
	}
	
	static private function _parseDeclarationBlock(input: String): Hash<StyleProperty> {
		var c_decBlock: Hash<StyleProperty> =  new Hash <StyleProperty>();
		var c_dec: String;
		var c_scIndex: Int;
		var c_property: String;
		var c_propertyChunks: String;
		var c_valueStr: String;
		var c_value: Dynamic;
		
		while (DECLARATION.match(input)) {
			input = DECLARATION.matchedRight();
			
			c_dec = StringTools.trim(DECLARATION.matched(0));
			if (c_dec.lastIndexOf(';') == c_dec.length - 1) {
				c_dec = c_dec.substring(0, c_dec.length - 1);
			}
			
			c_scIndex = c_dec.indexOf(':');
			c_property = StringTools.trim(c_dec.substring(0, c_scIndex));
			c_property = DASH_REPLACE.customReplace(c_property, _replaceDash);
			if (PROPERTY.match(c_property)) {
				c_valueStr = StringTools.trim(c_dec.substr(c_scIndex + 1));
				c_value = _parseValue(c_valueStr);
				if (c_value != null) {
					c_decBlock.set(c_property, new StyleProperty(c_value));
				}
			}
		}
		
		return c_decBlock;
	}
	
	static private function _parseRuleSet(input: String): Hash<Hash<StyleProperty>> {
		if (!DECLARATION_BLOCK.match(input)) return null;
		
		var c_ruleSets: Hash<Hash<StyleProperty>>  = new Hash<Hash<StyleProperty>>();
		var c_decBlock: Hash<StyleProperty> = _parseDeclarationBlock(DECLARATION_BLOCK.matched(0));
		var c_decBlockCopy: Hash<StyleProperty>;
		
		var c_selectors: String = DECLARATION_BLOCK.matchedLeft();
		var c_selector: String;
		var c_priority: Int = 0;
		while (SELECTOR.match(c_selectors)) {
			c_selectors = SELECTOR.matchedRight();
			c_selector = StringTools.trim(SELECTOR.matched(0));
			c_decBlockCopy = cast(HashUtil.copy(c_decBlock));
			
			if (SELECTOR_CLASS.match(c_selector)) {
				c_priority = StyleProperty.PRIORITY_STYLE_NAME; // 3
			} else if (SELECTOR_COMP.match(c_selector)) {
				c_priority = StyleProperty.PRIORITY_COMPONENT; // 2
			}
				
			if (c_priority > 0) {
				for (c_prop in c_decBlockCopy.iterator()) {
					c_prop.priority = c_priority;
				}
			}
			c_ruleSets.set(c_selector, c_decBlockCopy);
		}
		
		return c_ruleSets;
	}
	
	static public function _removeCommented(input: String): String {
		var c_chunks: Array<String> = input.split('/*');
		var c_chunk: String;
		var c_index: Int;
		input = '';
		
		for (c_chunk in c_chunks.iterator()) {
			c_index = c_chunk.indexOf('*/');
			if (c_index == -1) {
				input += c_chunk;
			} else {
				input += c_chunk.substr(c_index + 2);
			}
		}
		
		return input;
	}
	
	static public function parse(input: String): Hash<Hash<StyleProperty>> {
		input = _removeCommented(input);
		
		var c_style: Hash<Hash<StyleProperty>> = new Hash<Hash<StyleProperty>>();
		var c_ruleSets: Hash<Hash<StyleProperty>>;
		
		while (RULE_SET.match(input)) {
			input = RULE_SET.matchedRight();
			
			c_ruleSets = _parseRuleSet(RULE_SET.matched(0));
			if (c_ruleSets != null) {
				for (key in c_ruleSets.keys()) {
					if (c_style.exists(key)) {
						HashUtil.update(c_style.get(key), c_ruleSets.get(key));
					} else {
						c_style.set(key, c_ruleSets.get(key)); 
					}
				}
			}
		}
		
		return c_style;
	}
	
}