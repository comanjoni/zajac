package rs.zajac.ui;
import rs.zajac.core.ZajacCore;
import rs.zajac.skins.TextInputSkin;
import nme.events.Event;
import nme.events.FocusEvent;
import nme.events.TouchEvent;
import nme.text.TextField;
import nme.text.TextFieldAutoSize;
import nme.text.TextFieldType;

/**
 * ...
 * @author Aleksandar Bogdanovic
 */

class TextInput extends StyledComponent {

	inline public static var ALIGN_LEFT:	String = 'left';
	inline public static var ALIGN_CENTER:	String = 'center';
	inline public static var ALIGN_RIGHT:	String = 'right';

	inline public static var FOCUSIN:		String = 'focusin';
	inline public static var FOCUSOUT:		String = 'focusout';
	inline public static var TOUCH:			String = 'touch';
	
	//******************************
	//		PUBLIC VARIABLES
	//******************************
	
	/**
	 * Styled property defining text color.
	 */
	@style public var textColor: Int = 0;

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
	@style public var backgroundColor: Null<Int> = 0xffffff;

	/**
	 * Styled property defining background and border roundness.
	 */
	@style public var roundness: Int = 0;

	/**
	 * Styled property defining border color.
	 */
	@style public var borderColor: Null<Int> = 0xbfc0c2;

	/**
	 * Styled property defining border color when component is selected.
	 * On mobile application this color will be applied to background on touch down.
	 */
	@style public var focusColor: Null<Int> = 0xa4d4ff;
	
	/**
	 * Display text as password.
	 */
	public var displayAsPassword(default, set_displayAsPassword): Bool;
	
	/**
	 * Maximum number of characters that component will hold.
	 */
	public var maxChars(get_maxChars, set_maxChars): Int;
	
	/**
	 * Current text in text input.
	 */
	public var text(get_text, set_text): String;
	
	/**
	 * Reference to text field.
	 */
	public var textField(default, null): TextField;
	
	//******************************
	//		PUBLIC METHODS
	//******************************
	
	public function new() {
		super();
		defaultWidth = ZajacCore.getHeightUnit() * 5;
		defaultHeight = ZajacCore.getHeightUnit();
	}
	
	//******************************
	//		PRIVATE METHODS
	//******************************
	
	override private function initialize(): Void {
		textField = new TextField();
		addChild(textField);
		textField.background = false;
		textField.border = false;
		textField.wordWrap = false;
		textField.multiline = false;
		textField.type = TextFieldType.INPUT;
		textField.text = '';
		
		textField.addEventListener(FocusEvent.FOCUS_IN, _onFocusIn);
		textField.addEventListener(FocusEvent.FOCUS_OUT, _onFocusOut);
		#if mobile
		addEventListener(TouchEvent.TOUCH_BEGIN, _onTouchBegin);
		addEventListener(TouchEvent.TOUCH_END, _onTouchEnd);
		addEventListener(TouchEvent.TOUCH_OUT, _onTouchEnd);
		#end
		#if !flash
		textField.addEventListener(Event.CHANGE, _onTextChange);
		#end
		
		state = FOCUSOUT;
		
		skinClass = TextInputSkin;
	}
	
	//******************************
	//		GETTERS AND SETTERS
	//******************************
	
	private function get_textSize(): Int {
		return _getStyleProperty('textSize', ZajacCore.getFontSize(font));
	}
	private function set_displayAsPassword(v: Bool): Bool {
		if (displayAsPassword != v) {
			displayAsPassword = v;
			invalidSkin();
		}
		return v;
	}
	
	private function get_maxChars(): Int {
		return textField.maxChars;
	}
	
	private function set_maxChars(v: Int): Int {
		textField.maxChars = v;
		return v;
	}
	
	private function get_text(): String {
		return textField.text;
	}
	
	private function set_text(v: String): String {
		textField.text = v;
		return v;
	}
	
	//******************************
	//		EVENT LISTENERS
	//******************************
	
	private function _onFocusIn(evt: FocusEvent): Void {
		if (state != TOUCH) {
			state = FOCUSIN;
		}
	}
	
	private function _onFocusOut(evt: FocusEvent): Void {
		state = FOCUSOUT;
	}
	
	#if mobile
	private function _onTouchBegin(evt: TouchEvent): Void {
		state = TOUCH;
	}
	
	private function _onTouchEnd(evt: TouchEvent): Void {
		if (state == TOUCH) {
			state = FOCUSIN;
		}
	}
	#end
	
	#if !flash
	private function _onTextChange(evt: Event): Void {
		evt = evt.clone();
		evt.target = this;
		dispatchEvent(evt);
	}
	#end
	
}