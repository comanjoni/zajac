package rs.zajac.renderers;
import rs.zajac.core.ZajacCore;
import rs.zajac.ui.BaseComponent;
import nme.Assets;
import nme.display.DisplayObject;
import nme.display.Graphics;
import nme.display.Shape;
import nme.events.Event;
import nme.events.MouseEvent;
import nme.text.Font;
import nme.text.TextField;
import nme.text.TextFieldAutoSize;
import nme.text.TextFieldType;
import nme.text.TextFormat;

/**
 * Basic list item renderer.
 * Expected data is string.
 * @author Aleksandar Bogdanovic
 */
class ListItemRenderer extends AbstractListItemRenderer {
	
	//******************************
	//		PUBLIC VARIABLES
	//******************************

	/**
	 * Style property for text color. Can be set in css.
	 */
	@style public var color: Int = 0x333333;
	
	/**
	 * Style property for background color. Can be set in css.
	 */
	@style public var backgroundColor: Int = 0xffffff;
	
	/**
	 * Style property for spacer color (spacer is line between lit items).
	 * Can be set in css.
	 */
	@style public var spacerColor: Int = 0;
	
	/**
	 * Style property for spacer alpha (spacer is line between lit items).
	 * Can be set in css.
	 */
	@style public var spacerAlpha: Float = 0.1;
	
	/**
	 * Style property for text font name. Can be set in css.
	 */
	@style public var font: String = 'Arial';
	
	/**
	 * Reference to text field in list item.
	 */
	public var textField(default, null): TextField;
	
	//******************************
	//		PUBLIC METHODS
	//******************************
	
	public function new() {
		super();
	}
	
	/**
	 * Draw states for list item.
	 * @param	client
	 * @param	states
	 */
	override public function draw(client: BaseComponent, states:Hash<DisplayObject>): Void {
		var c_client: ListItemRenderer = cast(client);
		drawTextField(c_client);
		drawBackground(c_client);
		states.set(AbstractListItemRenderer.OVER, drawStateOVER(c_client, states.get(AbstractListItemRenderer.OVER)));
		states.set(AbstractListItemRenderer.SELECTED, drawStateSELECTED(c_client, states.get(AbstractListItemRenderer.SELECTED)));
	}
	
	//******************************
	//		PRIVATE METHODS
	//******************************
	
	override public function initialize(): Void {
		super.initialize();
		
		textField = new TextField();
		textField.type = TextFieldType.DYNAMIC;
		textField.autoSize = TextFieldAutoSize.LEFT;
		textField.wordWrap = false;
		textField.background = false;
		textField.border = false;
		textField.mouseEnabled = false;
		addChild(textField);
	}
	
	private function drawTextField(client: ListItemRenderer): Void {
		var c_textField: TextField = client.textField;
		var c_font: Font;
		var c_format: TextFormat;
		
		#if (cpp || neko)
		c_format = c_textField.defaultTextFormat;
		#else
		c_format = c_textField.getTextFormat();
		#end
		
		c_format.color = client.color;
		c_format.size = ZajacCore.getFontSize();

		c_font = Assets.getFont(client.font);
		if (c_font != null) {
			c_format.font = c_font.fontName;
			c_textField.embedFonts = true;
		}
		
		c_textField.defaultTextFormat = c_format;
		c_textField.setTextFormat(c_format);
		
		c_textField.width = client.Width;
		c_textField.text = client.data;
		
		c_textField.y = (client.Height - c_textField.height) / 2;
	}
	
	private function drawBackground(client: ListItemRenderer): Void {
		var c_gr: Graphics = client.graphics;
		
		c_gr.clear();
		c_gr.beginFill(client.backgroundColor);
		c_gr.drawRect(0, 0, client.Width, client.Height);
		c_gr.endFill();
		
		c_gr.lineStyle(1, client.spacerColor, client.spacerAlpha);
		c_gr.moveTo(0, client.Height - 0.5);
		c_gr.lineTo(client.Width, client.Height - 0.5);
	}
	
	private function drawStateOVER(client: ListItemRenderer, state: DisplayObject): DisplayObject {
		var c_shape: Shape;
		if (state == null) {
			c_shape = new Shape();
		} else  {
			c_shape = cast(state);
		}
		
		var c_gr: Graphics = c_shape.graphics;
		c_gr.clear();
		c_gr.beginFill(0xcbcbcb, 0.3);
		c_gr.drawRect(0, 0, client.Width, client.Height);
		c_gr.endFill();
		
		return c_shape;
	}
	
	private function drawStateSELECTED(client: ListItemRenderer, state: DisplayObject): DisplayObject {
		return drawStateOVER(client, state);
	}
	
}