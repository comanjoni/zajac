package be.zajac.ui;
import be.zajac.core.FWCore;
import be.zajac.skins.LabelSkin;
import nme.text.TextField;
import nme.text.TextFieldAutoSize;
import nme.text.TextFieldType;
import nme.text.TextFormatAlign;

/**
 * ...
 * @author Aleksandar Bogdanovic
 */

class Label extends StyledComponent {

	inline public static var ALIGN_LEFT: String = 'left';
	inline public static var ALIGN_CENTER: String = 'center';
	inline public static var ALIGN_RIGHT: String = 'right';
	
	//******************************
	//		PUBLIC VARIABLES
	//******************************
	
	@style public var color: Int = 0xffffff;
	@style public var font: String = 'Arial';
	@style public var align: String = ALIGN_LEFT;
	@style public var letterSpacing: Float = 0;
	@style public var textSize(get_textSize, default): Int;
	@style public var backgroundColor: Null<Int> = null;
	@style public var roundness: Int = 0;
	@style public var borderColor: Null<Int> = null;
	
	public var text(get_text, set_text): String = '';
	
	public var textField(default, null): TextField;
	
	//******************************
	//		PUBLIC METHODS
	//******************************
	
	public function new() {
		super();
		defaultHeight = FWCore.getHeightUnit();
	}
	
	override private function initialize(): Void {
		textField = new TextField();
		textField.background = false;
		textField.border = false;
		textField.mouseEnabled = false;
		textField.wordWrap = false;
		textField.multiline = false;
		textField.type = TextFieldType.DYNAMIC;
		addChild(textField);
		
		skinClass = LabelSkin;
	}
	
	//******************************
	//		GETTERS AND SETTERS
	//******************************
	
	private function get_textSize(): Int {
		return _getStyleProperty('textSize', FWCore.getFontSize(font));
	}
	private function get_text(): String {
		return text;
	}
	private function set_text(v: String): String {
		if (text != v) {
			text = v;
			invalidSkin();
		}
		return text;
	}
	
}