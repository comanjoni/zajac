package rs.zajac.util;
import nme.geom.Point;

/**
 * Util functionality for Point.
 * @author Aleksandar Bogdanovic
 */
class PointUtil {

	private function new() {}
	
	/**
	 * Distance between 2 points.
	 * @param	p1
	 * @param	p2
	 * @return
	 */
	static public function distance(p1: Point, p2: Point): Float {
		var x: Float = p1.x - p2.x;
		var y: Float = p1.y - p2.y;
		return Math.sqrt(x * x + y * y);
	}
	
}