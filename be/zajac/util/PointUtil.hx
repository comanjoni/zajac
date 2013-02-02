package be.zajac.util;
import nme.geom.Point;

/**
 * ...
 * @author Aleksandar Bogdanovic
 */

class PointUtil {

	public function new() {}
	
	static public function distance(p1: Point, p2: Point): Float {
		var x: Float = p1.x - p2.x;
		var y: Float = p1.y - p2.y;
		return Math.sqrt(x * x + y * y);
	}
	
}