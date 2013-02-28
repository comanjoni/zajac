package rs.zajac.util;

/**
 * Util functionality for Hash.
 * @author Aleksandar Bogdanovic
 */
class HashUtil {

	private function new() {}
	
	/**
	 * Updates destionation Hash with source Hash.
	 * @param	dst	Hash that should be updated.
	 * @param	src	Hash whith values that should be copied to dst.
	 * @return	Updated dst.
	 */
	static public function update(dst: Hash<Dynamic>, src: Hash<Dynamic>): Hash<Dynamic> {
		if (src == null) return dst;
		if (dst == null) dst = new Hash<Dynamic>();
		
		for (key in src.keys()) {
			dst.set(key, src.get(key));
		}
		
		return dst;
	}
	
	/**
	 * Creates copy of Hash.
	 * @param	src	Hash that should be copied
	 * @return	Copy of src.
	 */
	static public function copy(src: Hash<Dynamic>): Hash<Dynamic> {
		if (src == null) return null;
		
		var c_copy: Hash<Dynamic> = new Hash<Dynamic>();
		for (key in src.keys()) {
			c_copy.set(key, src.get(key));
		}
		
		return c_copy;
	}
	
}