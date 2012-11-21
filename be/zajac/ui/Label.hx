package be.zajac.ui;
import be.zajac.core.FWCore;
import be.zajac.skins.LabelSkin;
import nme.text.TextField;
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
	inline public static var ALIGN_JUSTIFY: String = 'justify';
	
	public static function convertAlign(align: String): Dynamic {
		switch (align) {
				case Label.ALIGN_CENTER:
					return TextFormatAlign.CENTER;
				case Label.ALIGN_JUSTIFY:
					return TextFormatAlign.JUSTIFY;
				case Label.ALIGN_RIGHT:
					return TextFormatAlign.RIGHT;
				case Label.ALIGN_LEFT:
					return TextFormatAlign.LEFT;
				default:
					return TextFormatAlign.LEFT;
		}
	}
	
	@style public var wordwrap: Bool = false;
	@style public var autosize: Bool = false;
	
	@style public var textColor: Int = 0xffffff;
	@style public var textSize: Int = 12;
	@style public var font: String = 'Arial';
	@style public var bold: Bool = false;
	@style public var italic: Bool = false;
	@style public var underline: Bool = false;
	@style public var align: String = ALIGN_LEFT;
	@style public var leading: Float = 0;
	@style public var letterSpacing: Float = 0;
	
	public var text(get_text, set_text): String;
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
	
	public var textField(default, null): TextField;
	
	public function new() {
		super();
		Width = FWCore.getHeightUnit() * 5;
		Height = FWCore.getHeightUnit();
		text = '';
	}
	
	override private function initialize(): Void {
		textField = new TextField();
		textField.wordWrap = true;
		textField.background = false;
		textField.border = false;
		textField.mouseEnabled = false;
		textField.type = TextFieldType.DYNAMIC;
		addChild(textField);
		
		skinClass = LabelSkin;
	}
	
}