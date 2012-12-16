package be.zajac.containers.mobile.misc;
import be.zajac.containers.mobile.Panel;
import nme.events.Event;

/**
 * ...
 * @author Aleksandar Bogdanovic
 */

class PanelAnimator extends APanelAnimator {
	
	inline private static var ANIMTION_ACCELERATION: Float = -1;
	
	public function new(panel: Panel) {
		super(panel);
	}
	override private function _animate(e: Event): Void {
		var c_changed: Bool = false;
		
		if (_panel.verticalSlider.visible) {
			if (_direction.y < 0) {
				_panel.verticalSlider.value = Math.max(_panel.verticalSlider.value + _direction.y, _vMinValue);
				if (_panel.verticalSlider.value != _vMinValue) {
					_direction.y -= ANIMTION_ACCELERATION;
				} else {
					_direction.y = 0;
				}
				c_changed = true;
			} else if (_direction.y > 0) { 
				_panel.verticalSlider.value = Math.min(_panel.verticalSlider.value + _direction.y, _vMaxValue);
				if (_panel.verticalSlider.value != _vMaxValue) {
					_direction.y += ANIMTION_ACCELERATION;
				} else {
					_direction.y = 0;
				}
				c_changed = true;
			}
		}
		
		if (_panel.horizontalSlider.visible) {
			if (_direction.x < 0) {
				_panel.horizontalSlider.value = Math.max(_panel.horizontalSlider.value + _direction.x, _hMinValue);
				if (_panel.horizontalSlider.value != _hMinValue) {
					_direction.x -= ANIMTION_ACCELERATION;
				} else {
					_direction.x = 0;
				}
				c_changed = true;
			} else if (_direction.x > 0) { 
				_panel.horizontalSlider.value = Math.min(_panel.horizontalSlider.value + _direction.x, _hMaxValue);
				if (_panel.horizontalSlider.value != _hMaxValue) {
					_direction.x += ANIMTION_ACCELERATION;
				} else {
					_direction.x = 0;
				}
				c_changed = true;
			}
		}
		
		_panel.updateScrollRect();
		_panel.alphaAnimate();
		if (!c_changed) {
			stop();
		}
	}
}