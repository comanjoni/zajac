package be.zajac.util;

/**
 * ...
 * @author Aleksandar Bogdanovic
 */

class ColorUtil {

	private function new() { }
	
	//**************
	//		HSV		
	//**************
	
	static public function hsv2rgb(h: Float, s: Float, v: Float): Int {
		var i: Int = Math.floor(h * 6);
		var f: Float = h * 6 - i;
		v *= 0xff;
		
		switch (i % 6) {
			case 0:
				return 	Math.floor(v) * 0x10000 +
						Math.floor(v * (1 - (1 - f) * s)) * 0x100 +
						Math.floor(v * (1 - s));
			case 1:
				return	Math.floor(v * (1 - f * s)) * 0x10000 +
						Math.floor(v) * 0x100 +
						Math.floor(v * (1 - s));
			case 2:
				return 	Math.floor(v * (1 - s)) * 0x10000 + 
						Math.floor(v) * 0x100 +
						Math.floor(v * (1 - (1 - f) * s));
			case 3:
				return	Math.floor(v * (1 - s)) * 0x10000 +
						Math.floor(v * (1 - f * s)) * 0x100 +
						Math.floor(v);
			case 4:
				return 	Math.floor(v * (1 - (1 - f) * s)) * 0x10000 +
						Math.floor(v * (1 - s)) * 0x100 +
						Math.floor(v);
			case 5:
				return	Math.floor(v) * 0x10000 +
						Math.floor(v * (1 - s)) * 0x100 +
						Math.floor(v * (1 - f * s));
		}
		return 0;
	}
	
	static public function rgb2hsv(rgb: Int): Array<Float> {
		var r: Float = cast((rgb & 0xff0000) / 0x10000, Float) / 0xff;
		var g: Float = cast((rgb & 0x00ff00) / 0x100, Float) / 0xff;
		var b: Float = cast(rgb & 0x0000ff, Float) / 0xff;
		var max: Float = Math.max(Math.max(r, g), b);
		var min: Float = Math.min(Math.min(r, g), b);
		var d: Float = max - min;
		
		var h: Float = 0;
		var s: Float = (max == 0) ? 0 : d / max;
		var v: Float = max;
		if (max != min) {
			switch (max) {
				case r: h = (g - b) / d + (g < b ? 6 : 0);
				case g: h = (b - r) / 2 + 2;
				case b: h = (r - g) / d + 4;
			}
			h /= 6;
		}
		
		return [h, s, v];
	}
	
	//**************
	//		HSL		
	//**************
	
	static public function hsl2rgb(h: Float, s: Float, l: Float): Int {
		var r: Float = l;
		var g: Float = l;
		var b: Float = l;
		
		if (s != 0) {
			var q: Float = l < 0.5 ? l * (1 + s) : l + s - l * s;
			var p: Float = 2 * l - q;
			r = hue2rgb(p, q, h + 1 / 3);
			g = hue2rgb(p, q, h);
			b = hue2rgb(p, q, h - 1 / 3);
		}
		
		return Math.floor(r * 0xff) * 0x10000 + Math.floor(g * 0xff) * 0x100 + Math.floor(b * 0xff);
	}
	
	static public function rgb2hsl(rgb: Int): Array<Float> {
		var r: Float = cast((rgb & 0xff0000) / 0x10000, Float) / 0xff;
		var g: Float = cast((rgb & 0x00ff00) / 0x100, Float) / 0xff;
		var b: Float = cast(rgb & 0x0000ff, Float) / 0xff;
		var max: Float = Math.max(Math.max(r, g), b);
		var min: Float = Math.min(Math.min(r, g), b);
		var d: Float = max - min;
		
		var h: Float = 0;
		var s: Float = 0;
		var l: Float = (max + min) / 2;
		if (min != max) {
			s = l > 0.5 ? d / (2 - d) : d / (max + min);
			switch (max) {
				case r: h = (g - b) / d + (g < b ? 6 : 0);
				case g: h = (b - r) / 2 + 2;
				case b: h = (r - g) / d + 4;
			}
			h /= 6;
		}
		
		return [h, s, l];
	}
	
	//**************
	//		HELPER	
	//**************
	
	static public function hue2rgb(p: Float , q: Float, t: Float) {
		if (t < 0) t += 1;
		if (t > 1) t -= 1;
		if (t < 1 / 6) return p + (q - p) * 6 * t;
		if (t < 1 / 2) return q;
		if (t < 2 / 3) return p + (q - p) * (2 / 3 - t) * 6;
		return p;
	}
	
}