package be.zajac.ui;
import be.zajac.skins.LabelSkin;
import nme.text.TextField;
import nme.text.TextFieldType;
import nme.text.TextFormatAlign;

/**
 * ...
 * @author Aleksandar Bogdanovic
 */

class Label extends StyledComponent {

	inline public static var ALIGN_LEFT: String = 'LEFT';
	inline public static var ALIGN_CENTER: String = 'CENTER';
	inline public static var ALIGN_RIGHT: String = 'RIGHT';
	inline public static var ALIGN_JUSTIFY: String = 'JUSTIFY';
	
	@style(0xffffff)				public var textColor(dynamic, dynamic): Dynamic;
	@style(12)						public var textSize(dynamic, dynamic): Dynamic;
	@style('Arial')					public var font(dynamic, dynamic): Dynamic;
	@style(false)					public var bold(dynamic, dynamic): Dynamic;
	@style(false)					public var italic(dynamic, dynamic): Dynamic;
	@style(false)					public var underline(dynamic, dynamic): Dynamic;
	@style('LEFT')					public var align(dynamic, dynamic): Dynamic;
	@style(0)						public var leading(dynamic, dynamic): Dynamic;
	@style(0)						public var letterSpacing(dynamic, dynamic): Dynamic;
	
	public var text(get_text, set_text): String;
	public function get_text(): String {
		return textField.text;
	}
	public function set_text(v: String): String {
		textField.text = v;
		return v;
	}
	
	public var selectable(get_selectable, set_selectable): Bool;
	public function get_selectable(): Bool {
		return textField.selectable;
	}
	public function set_selectable(v: Bool): Bool {
		textField.selectable = v;
		return v;
	}
	
	public var multiline(get_multiline, set_multiline): Bool;
	public function get_multiline(): Bool {
		return textField.multiline;
	}
	public function set_multiline(v: Bool): Bool {
		textField.multiline = v;
		return v;
	}
	
	public var textField(default, null): TextField;
	
	public function new() {
		super();
		textField = new TextField();
		
		textField.wordWrap = true;
		textField.background = false;
		textField.border = false;
		textField.mouseEnabled = false;
		#if flash
			textField.mouseWheelEnabled = false;
			textField.tabEnabled = false;
		#end
		textField.type = TextFieldType.DYNAMIC;
		
		addChild(textField);
		
		skin = new LabelSkin();
	}
	
}