package rs.zajac.util;

/**
 * Util functionality for Int.
 * @author Aleksandar Bogdanovic
 */
class IntUtil {

	private function new() { }
	
	/**
	 * Simbols used in hex number representation.
	 */
	static private inline var HEX_DIGITS: String = '0123456789abcdef';
	
	/**
	 * Converts hex string to integer value.
	 * @param	hex	Hexadecimal string that starts with "0x" or "#"
	 * @return		Int value of hex input.
	 */
	static public function hex2int(hex: String): Int {
		hex = hex.toLowerCase();
		if (hex.substr(0, 2) == '0x') {
			hex = hex.substr(2);
		} else if (hex.substr(0, 1) == '#') {
			hex = hex.substr(1);
		}
		var c_val: Int = 0;
		for (i in 0...hex.length) {
			c_val *= 16;
			c_val += HEX_DIGITS.indexOf(hex.charAt(i));
		}
		return c_val;
	}
	
}