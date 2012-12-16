package be.zajac.containers.mobile.misc;
import be.zajac.containers.mobile.Panel;
import nme.events.Event;

/**
 * ...
 * @author Aleksandar Bogdanovic
 */

class PanelElasticAnimator extends APanelAnimator {
	
	inline private static var ANIMTION_ELASTIC_ACCELERATION: Float = -4;
	inline private static var ANIMTION_ACCELERATION: Float = -1;
	
	override private function _animate(e: Event): Void {
		var c_changed: Bool = false;
		var c_value: Float;
		
		if (_panel.verticalSlider.visible) {
			c_value = _panel.verticalSlider.value + _direction.y;
			if (_panel.verticalSlider.minValue < _vMinValue) {
				_panel.verticalSlider.value = _panel.verticalSlider.minValue = Math.min(c_value, _vMinValue);
				if (_panel.verticalSlider.value != _vMinValue) {
					_direction.y -= ANIMTION_ELASTIC_ACCELERATION;
					c_changed = true;
				} else {
					_direction.y = 0;
				}
			} else if (_panel.verticalSlider.maxValue > _vMaxValue) {
				_panel.verticalSlider.value = _panel.verticalSlider.maxValue = Math.max(c_value, _vMaxValue);
				if (_panel.verticalSlider.value != _vMaxValue) {
					_direction.y += ANIMTION_ELASTIC_ACCELERATION;
					c_changed = true;
				} else {
					_direction.y = 0;
				}
			} else if (_direction.y < 0) {
				_panel.verticalSlider.minValue = Math.min(c_value, _vMinValue);
				_panel.verticalSlider.value = c_value;
				_direction.y -= ANIMTION_ACCELERATION;
				c_changed = true;
			} else if (_direction.y > 0) { 
				_panel.verticalSlider.maxValue = Math.max(c_value, _vMaxValue);
				_panel.verticalSlider.value = c_value;
				_direction.y += ANIMTION_ACCELERATION;
				c_changed = true;
			}
		}
		
		if (_panel.horizontalSlider.visible) {
			c_value = _panel.horizontalSlider.value + _direction.x;
			if (_panel.horizontalSlider.minValue < _hMinValue) {
				_panel.horizontalSlider.value = _panel.horizontalSlider.minValue = Math.min(c_value, _hMinValue);
				if (_panel.horizontalSlider.value != _hMinValue) {
					_direction.x -= ANIMTION_ELASTIC_ACCELERATION;
					c_changed = true;
				} else {
					_direction.x = 0;
				}
			} else if (_panel.horizontalSlider.maxValue > _hMaxValue) {
				_panel.horizontalSlider.value = _panel.horizontalSlider.maxValue = Math.max(c_value, _hMaxValue);
				if (_panel.horizontalSlider.value != _hMaxValue) {
					_direction.x += ANIMTION_ELASTIC_ACCELERATION;
					c_changed = true;
				} else {
					_direction.x = 0;
				}
			} else if (_direction.x < 0) {
				_panel.horizontalSlider.minValue = Math.min(c_value, _hMinValue);
				_panel.horizontalSlider.value = c_value;
				_direction.x -= ANIMTION_ACCELERATION;
				c_changed = true;
			} else if (_direction.x > 0) { 
				_panel.horizontalSlider.maxValue = Math.max(c_value, _hMaxValue);
				_panel.horizontalSlider.value = c_value;
				_direction.x += ANIMTION_ACCELERATION;
				c_changed = true;
			}
		}
		
		_panel.updateScrollRect();
		_panel.alphaAnimate();
		if (!c_changed) {
			stop();
		}
		
	}
	
	public function new(panel: Panel) {
		super(panel);
	}
}