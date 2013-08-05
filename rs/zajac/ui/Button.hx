package rs.zajac.ui;
import rs.zajac.core.ZajacCore;
import rs.zajac.skins.ButtonSkin;
import rs.zajac.util.TextFieldUtil;
import flash.events.MouseEvent;
import flash.events.TouchEvent;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormatAlign;

/**
 * ...
 * @author Ilic S Stojan
 */

class Button extends StyledComponent {

	inline public static var UP:	String = 'up';
	inline public static var OVER:	String = 'over';
	inline public static var DOWN:	String = 'down';
	
	//******************************
	//		PUBLIC VARIABLES
	//******************************
	
	/**
	 * Styled property defining text color.
	 */
	@style public var color: Int = 0;
	
	/**
	 * Styled property defining background color.
	 */
	@style public var backgroundColor: Int = 0xffffff;
	
	/**
	 * Styled property defining button roundness.
	 */
	@style public var roundness: Int = 0;
	
	/**
	 * Styled property defining border color.
	 */
	@style public var borderColor: Null<Int> = 0xbfc0c2;
	
	/**
	 * Reference to label field.
	 */
	public var labelField(default, null): TextField;
	
	/**
	 * Button label text.
	 */
	public var label(default, set_label): String = '';
	
	//******************************
	//		PRIVATE VARIABLES
	//******************************
	
	private var _isOver:Bool;
	
	//******************************
	//		PUBLIC METHODS
	//******************************
	
	public function new() {
		super();
		defaultWidth = ZajacCore.getHeightUnit();
		defaultHeight = ZajacCore.getHeightUnit();
		mouseChildren = false;
	}
	
	//******************************
	//		PRIVATE METHODS
	//******************************
	
	override private function initialize(): Void {
		labelField = new TextField();
		labelField.autoSize = TextFieldAutoSize.LEFT;
		labelField.multiline = false;
		labelField.selectable = false;
		labelField.mouseEnabled = false;
		TextFieldUtil.fillFieldFromObject(labelField, { align: TextFormatAlign.LEFT, size: ZajacCore.getFontSize() } );
		addChild(labelField);
		
		#if mobile
		addEventListener(TouchEvent.TOUCH_BEGIN,onTouchBegin);
		addEventListener(TouchEvent.TOUCH_END, 	onTouchEnd);
		addEventListener(TouchEvent.TOUCH_OVER,	onTouchOver);
		addEventListener(TouchEvent.TOUCH_OUT,	onTouchOut);
		#else
		addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		addEventListener(MouseEvent.MOUSE_UP, 	onMouseUp);
		addEventListener(MouseEvent.ROLL_OVER, 	onMouseOver);
		addEventListener(MouseEvent.ROLL_OUT, 	onMouseOut);
		buttonMode = useHandCursor = true;
		#end
		
		skinClass = ButtonSkin;
		state = UP;
	}
	
	//******************************
	//		GETTERS AND SETTERS
	//******************************
	
	private function set_label(value: String): String {
		if (value != label) {
			label = value;
			labelField.text = label;
			defaultWidth = labelField.width + ZajacCore.getHeightUnit();
			invalidSkin();
		}
		return value;
	}
	
	//******************************
	//		EVENT LISTENERS
	//******************************
	
	#if mobile
	
	private function onTouchBegin(e: TouchEvent): Void {
		if (!enabled) return;
		state = DOWN;
	}
	
	private function onTouchEnd(e: TouchEvent): Void {
		if (!enabled) return;
		state = UP;
	}
	
	private function onTouchOver(e: TouchEvent): Void {
		if (!enabled) return;
		state = DOWN;
	}
	
	private function onTouchOut(e: TouchEvent): Void {
		if (!enabled) return;
		state = UP;
	}
	
	#else
	
	private function onMouseDown(e:MouseEvent):Void {
		if (!enabled) return;
		state = DOWN;
	}
	
	private function onMouseUp(e:MouseEvent):Void {
		if (!enabled) return;
		state = _isOver ? OVER : UP;
	}
	
	private function onMouseOver(e:MouseEvent):Void {
		if (!enabled) return;
		_isOver = true;
		state = OVER;
	}
	
	private function onMouseOut(e:MouseEvent):Void {
		if (!enabled) return;
		_isOver = false;
		state = UP;
	}
	
	#end
	
}