package rs.zajac.ui;
import rs.zajac.core.ZajacCore;
import flash.events.Event;

/**
 * simple customizable circle preloader
 * @author Ilic S Stojan
 */

class PreloaderCircle extends StyledComponent{

	//******************************
	//		PUBLIC VARIABLES
	//******************************
	
	/**
	 * Styled property defining preloader radius.
	 */
	@style public var radius	: Int = 32;
	
	/**
	 * Styled property defining how manu circle segments preloader have.
	 */
	@style public var segments	: Int = 12;
	
	/**
	 * Styled property defining preloader circle color.
	 */
	@style public var color		: Int = 0xcbcbcb;
	
	/**
	 * Styled property defining margin between preloader circles in pixel.
	 */
	@style public var margin	: Int = 1;
	
	/**
	 * Styled property type. If linear is true, circles radius starts from 0 to max radius.
	 * If linear is false all preloader circles are the same radius
	 */
	@style public var linear	: Bool = true;
	
	private var _angle:Float = 0;
	private var _stableFrames:Int = 2;//how many frames to wait before next turn
	
	//******************************
	//		PUBLIC METHODS
	//******************************
	
	public function new() {
		super();
		defaultWidth = ZajacCore.getHeightUnit();
		defaultHeight = ZajacCore.getHeightUnit();
		mouseChildren = false;
		mouseEnabled = false;
	}
	
	/**
	 * start loader animation
	 */
	public function start():Void{
		if (!hasEventListener(Event.ENTER_FRAME) ) addEventListener(Event.ENTER_FRAME, onFrame);
	}
	
	/**
	 * stop loader animation
	 */
	public function stop():Void{
		removeEventListener(Event.ENTER_FRAME, onFrame);
	}
	
	private var _currentFrame:Int = 0;
	private function onFrame(evt:Event):Void {
		if (++_currentFrame >= _stableFrames) {
			rotation -= _angle;
			_currentFrame -= _stableFrames;
		}
	}

	//******************************
	//		PRIVATE METHODS
	//******************************
	
	override private function initialize(): Void {
		draw();
		start();
	}
	
	override public function validate():Void {
		super.validate();
		draw();
	}
	
	private function draw():Void{
		var i:Int;
		var c_x:Float;
		var c_y:Float;
		var c_angle:Float;
		var c_circRadius:Int;
		
		_angle = 360 / segments;
			//calculate how fast loader will be move
		if (stage != null) _stableFrames = Math.ceil( stage.frameRate / segments )
			else _stableFrames = Math.ceil( 30 / segments );
		_stableFrames = cast(Math.max(2, Math.min(_stableFrames, 5) ), Int);
			
		graphics.clear();
		graphics.beginFill(color);
		
		c_circRadius = Math.ceil(radius * Math.PI / segments) - margin;
		for (i in 0...segments){
			c_angle = Math.PI * 2 * i / segments;
			c_x = Math.cos(c_angle) * radius;
			c_y = Math.sin(c_angle) * radius;
			if (linear) graphics.drawCircle(c_x, c_y, c_circRadius * (segments - i)/segments);
				else graphics.drawCircle(c_x, c_y, c_circRadius);
		}
		
		graphics.endFill();
	}
	
	
	
}