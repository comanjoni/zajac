package rs.zajac.util;

/**
 * Util functionality for Map.
 * @author Aleksandar Bogdanovic
 */
class HashUtil {

	private function new() {}
	
	/**
	 * Updates destionation Map with source Map.
	 * @param	dst	Map that should be updated.
	 * @param	src	Map whith values that should be copied to dst.
	 * @return	Updated dst.
	 */
	static public function update(dst: Map<String,Dynamic>, src: Map<String,Dynamic>): Map<String,Dynamic> {
		if (src == null) return dst;
		if (dst == null) dst = new Map<String,Dynamic>();
		
		for (key in src.keys()) {
			dst.set(key, src.get(key));
		}
		
		return dst;
	}
	
	/**
	 * Creates copy of Map.
	 * @param	src	Map that should be copied
	 * @return	Copy of src.
	 */
	static public function copy(src: Map<String,Dynamic>): Map<String,Dynamic> {
		if (src == null) return null;
		
		var c_copy: Map<String,Dynamic> = new Map<String,Dynamic>();
		for (key in src.keys()) {
			c_copy.set(key, src.get(key));
		}
		
		return c_copy;
	}
	
}