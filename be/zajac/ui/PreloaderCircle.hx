package be.zajac.ui;
import be.zajac.core.FWCore;
import nme.events.Event;

/**
 * simple customizable circle preloader
 * @author Ilic S Stojan
 */

class PreloaderCircle extends StyledComponent{

	//******************************
	//		PUBLIC VARIABLES
	//******************************
	
	@style public var radius	: Int = 32;			//preloader radius
	@style public var segments	: Int = 12;		//how many circles
	@style public var color		: Int = 0xcbcbcb;
	@style public var margin	: Int = 1;
	@style public var linear	: Bool = true;
	
	private var _angle:Float = 0;
	
	//******************************
	//		PUBLIC METHODS
	//******************************
	
	public function new() {
		super();
		defaultWidth = FWCore.getHeightUnit();
		defaultHeight = FWCore.getHeightUnit();
		mouseChildren = false;
		mouseEnabled = false;
	}
	
	public function start():Void{
		if (!hasEventListener(Event.ENTER_FRAME) ) addEventListener(Event.ENTER_FRAME, onFrame);
	}
	
	public function stop():Void{
		removeEventListener(Event.ENTER_FRAME, onFrame);
	}
	
	private function onFrame(evt:Event):Void{
		rotation -= _angle;
	}

	//******************************
	//		PRIVATE METHODS
	//******************************
	
	override private function initialize(): Void {
		draw();
		start();
	}
	
	private function draw():Void{
		var i:Int;
		var c_x:Float;
		var c_y:Float;
		var c_angle:Float;
		var c_circRadius:Int;
		
		_angle = 360 / segments;
		
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