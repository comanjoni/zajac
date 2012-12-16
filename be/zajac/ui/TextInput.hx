package be.zajac.ui;
import be.zajac.core.FWCore;
import be.zajac.skins.TextInputSkin;
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

	inline public static var FOCUSIN:		String = 'focusin';
	inline public static var FOCUSOUT:		String = 'focusout';
	inline public static var TOUCH:			String = 'touch';
	
	@style public var textColor: Int = 0;
	@style public var textSize: Int = 12;
	@style public var font: String = 'Arial';
	@style public var bold: Bool = false;
	@style public var italic: Bool = false;
	@style public var underline: Bool = false;
	@style public var leading: Float = 0;
	@style public var letterSpacing: Float = 0;
	
	@style public var backgroundColor: Int = 0xffffff;
	
	public var displayAsPassword(default, set_displayAsPassword): Bool;
	private function set_displayAsPassword(v: Bool): Bool {
		if (displayAsPassword != v) {
			displayAsPassword = v;
			invalidSkin();
		}
		return v;
	}
	
	public var maxChars(get_maxChars, set_maxChars): Int;
	private function get_maxChars(): Int {
		return textField.maxChars;
	}
	private function set_maxChars(v: Int): Int {
		textField.maxChars = v;
		return v;
	}
	
	public var text(get_text, set_text): String;
	private function get_text(): String {
		return textField.text;
	}
	private function set_text(v: String): String {
		textField.text = v;
		return v;
	}
	
	public var textField(default, null): TextField;
	
	public function new() {
		super();
		Width = FWCore.getHeightUnit() * 5;
		Height = FWCore.getHeightUnit();
	}
	
	override private function initialize(): Void {
		textField = new TextField();
		addChild(textField);
		textField.background = false;
		textField.border = false;
		textField.text = '';
		textField.wordWrap = false;
		textField.multiline = false;
		textField.type = TextFieldType.INPUT;
		textField.autoSize = TextFieldAutoSize.NONE;
		
		state = FOCUSOUT;
		
		textField.addEventListener(FocusEvent.FOCUS_IN, _onFocusIn);
		textField.addEventListener(FocusEvent.FOCUS_OUT, _onFocusOut);
		#if (android || ios)
		addEventListener(TouchEvent.TOUCH_BEGIN, _onTouchBegin);
		addEventListener(TouchEvent.TOUCH_END, _onTouchEnd);
		addEventListener(TouchEvent.TOUCH_OUT, _onTouchEnd);
		#end
		#if (!flash)
		textField.addEventListener(Event.CHANGE, _onTextChange);
		#end
		
		skinClass = TextInputSkin;
	}
	
	private function _onFocusIn(evt: FocusEvent): Void {
		if (state != TOUCH) {
			state = FOCUSIN;
		}
	}
	
	private function _onFocusOut(evt: FocusEvent): Void {
		state = FOCUSOUT;
	}
	
	#if (android || ios)
	private function _onTouchBegin(evt: TouchEvent): Void {
		state = TOUCH;
	}
	
	private function _onTouchEnd(evt: TouchEvent): Void {
		if (state == TOUCH) {
			state = FOCUSIN;
		}
	}
	#end
	
	#if (!flash)
	private function _onTextChange(evt: Event): Void {
		evt = evt.clone();
		evt.target = this;
		dispatchEvent(evt);
	}
	#end
	
}