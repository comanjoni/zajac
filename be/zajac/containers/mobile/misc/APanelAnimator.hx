package be.zajac.containers.mobile.misc;
import be.zajac.containers.mobile.Panel;
import nme.display.Sprite;
import nme.events.Event;
import nme.geom.Point;
import nme.Lib;

/**
 * ...
 * @author Aleksandar Bogdanovic
 */

class APanelAnimator {
	
	private var _panel: Panel;
	
	private var _animator: Sprite;
	private var _direction: Point;
	
	private var _width: Float = 0;
	private var _height: Float = 0;
	
	private var _vMinValue: Float = 0;
	private var _vMaxValue: Float = 0;
	private var _hMinValue: Float = 0;
	private var _hMaxValue: Float = 0;
	
	public function new(panel: Panel) {
		_panel = panel;
	}
	
	public function start(direction: Point): Void {
		_direction = direction;
		
		_width = _panel.Width - (_panel.verticalSlider.visible ? _panel.verticalSlider.Width : 0);
		_height = _panel.Height - (_panel.horizontalSlider.visible ? _panel.horizontalSlider.Height : 0);
		
		var c_contentSize: Point = _panel.getContentSize();
		_vMaxValue = c_contentSize.y - _height;
		_hMaxValue = c_contentSize.x - _width;
		
		if (_animator != null) return;
		_animator = new Sprite();
		_animator.addEventListener(Event.ENTER_FRAME, _animate);
		Lib.current.stage.addChild(_animator);
	}
	
	public function stop(): Void {
		if (_animator == null) return;
		_direction = null;
		_animator.removeEventListener(Event.ENTER_FRAME, _animate);
		Lib.current.stage.removeChild(_animator);
		_animator = null;
	}
	
	private function _animate(e: Event): Void {
		stop();
	}
	
}