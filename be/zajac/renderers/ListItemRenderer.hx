package be.zajac.renderers;
import be.zajac.core.FWCore;
import be.zajac.ui.BaseComponent;
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
 * ...
 * @author Aleksandar Bogdanovic
 */

class ListItemRenderer extends AbstractListItemRenderer {

	@style public var color: Int = 0x333333;				//renderer text color
	@style public var backgroundColor: Int = 0xffffff;		//backgroundColor
	@style public var spacerColor: Int = 0;					//spacer color between renderers
	@style public var spacerAlpha: Float = 0.1;				//spacer alpha
	
	public var textField(default, null): TextField;
	
	public function new() {
		super();
	}
	
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
	
	override public function draw(client: BaseComponent, states:Hash<DisplayObject>): Void {
		var c_client: ListItemRenderer = cast(client);
		var c_textField: TextField = c_client.textField;
		var c_gr: Graphics;
		var c_font: Font;
		var c_format: TextFormat;
		var c_shape: Shape;
		
		// update text field
		#if (cpp || neko)
			c_format = c_textField.defaultTextFormat;
		#else
			c_format = c_textField.getTextFormat();
		#end
		
		c_format.color = c_client.color;
		c_format.size = FWCore.getFontSize();

		c_font = Assets.getFont('Arial');
		if (c_font != null) {
			c_format.font = c_font.fontName;
			c_textField.embedFonts = true;
		}
		
		c_textField.defaultTextFormat = c_format;
		c_textField.width = c_client.Width;
		c_textField.text = c_client.data;
		
		c_textField.y = (c_client.Height - c_textField.height) / 2;
		
		// draw background
		c_gr = c_client.graphics;
		
		c_gr.clear();
		c_gr.beginFill(c_client.backgroundColor);
		c_gr.drawRect(0, 0, c_client.Width, c_client.Height);
		c_gr.endFill();
		
		c_gr.lineStyle(1, c_client.spacerColor, c_client.spacerAlpha);
		c_gr.moveTo(0, c_client.Height - 1);
		c_gr.lineTo(c_client.Width, c_client.Height - 1);
		
		// draw over state
		if (states.exists(AbstractListItemRenderer.OVER)) {
			c_shape = cast states.get(AbstractListItemRenderer.OVER);
		} else {
			c_shape = new Shape();
			states.set(AbstractListItemRenderer.OVER, c_shape);
		}
		c_gr = c_shape.graphics;
		c_gr.clear();
		c_gr.beginFill(0xcbcbcb, 0.3);
		c_gr.drawRect(0, 0, c_client.Width, c_client.Height);
		c_gr.endFill();
		
		// draw selected state
		if (states.exists(AbstractListItemRenderer.SELECTED)) {
			c_shape = cast states.get(AbstractListItemRenderer.SELECTED);
		} else {
			c_shape = new Shape();
			states.set(AbstractListItemRenderer.SELECTED, c_shape);
		}
		c_gr = c_shape.graphics;
		c_gr.clear();
		c_gr.beginFill(0xcbcbcb, 0.3);
		c_gr.drawRect(0, 0, c_client.Width, c_client.Height);
		c_gr.endFill();
		
	}
	
}