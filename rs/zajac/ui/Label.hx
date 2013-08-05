package rs.zajac.ui;
import rs.zajac.core.ZajacCore;
import rs.zajac.skins.LabelSkin;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFieldType;
import flash.text.TextFormatAlign;

/**
 * This component can only preview text.
 * @author Aleksandar Bogdanovic
 */
class Label extends StyledComponent {

	inline public static var ALIGN_LEFT: String = 'left';
	inline public static var ALIGN_CENTER: String = 'center';
	inline public static var ALIGN_RIGHT: String = 'right';
	
	//******************************
	//		PUBLIC VARIABLES
	//******************************
	
	/**
	 * Styled property defining text color.
	 */
	@style public var color: Int = 0;

	/**
	 * Styled property defining text font.
	 */
	@style public var font: String = 'Arial';

	/**
	 * Styled property defining text align.
	 */
	@style public var align: String = ALIGN_LEFT;

	/**
	 * Styled property defining text letter space.
	 */
	@style public var letterSpacing: Float = 0;

	/**
	 * Styled property defining font size.
	 */
	@style public var textSize(get_textSize, default): Int;

	/**
	 * Styled property defining background color.
	 */
	@style public var backgroundColor: Null<Int> = null;

	/**
	 * Styled property defining background and border roundness.
	 */
	@style public var roundness: Int = 0;

	/**
	 * Styled property defining border color.
	 */
	@style public var borderColor: Null<Int> = null;
	
	/**
	 * Current shown text in label.
	 */
	public var text(get_text, set_text): String = '';
	
	/**
	 * Reference to text field.
	 */
	public var textField(default, null): TextField;
	
	//******************************
	//		PUBLIC METHODS
	//******************************
	
	public function new() {
		super();
		defaultHeight = ZajacCore.getHeightUnit();
	}
	
	//******************************
	//		PRIVATE METHODS
	//******************************
	
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
		return _getStyleProperty('textSize', ZajacCore.getFontSize(font));
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