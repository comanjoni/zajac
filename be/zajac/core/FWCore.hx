package be.zajac.core;
import nme.events.Event;
import nme.display.Sprite;
import nme.display.Stage;
import be.zajac.ui.BaseComponent;

/**
 * Framework initializer. Provides root functionality for components that rely on Stage.
 * @author Aleksandar Bogdanovic
 */

class FWCore {
	
	private function new() {}

	static private var _stage: Stage;
	static private var _inited: Bool = false;
	
	/**
	 * Public accessable Stage.
	 * @return		Stage.
	 */
	static public function getStage(): Stage {
		return _stage;
	}
	
	/**
	 * Initialize Framework.
	 * @param	stage	Stage instance.
	 */
	static public function init(stage: Stage): Void {
		if (_inited) return;
		_inited = true;
		_stage = stage;
	}
	
	static private var _invalidComponents: Hash<BaseComponent> = new Hash<BaseComponent>();
	static private var _validator: Sprite;
	
	static private function _validateComponents(evt: Event): Void {
		var c_invalidComponents: Hash<BaseComponent> = _invalidComponents;
		_invalidComponents = new Hash<BaseComponent>();
		for (c in c_invalidComponents.iterator()) {
			c.validate();
		}
		_destroyValidator();
	}
	
	static private function _createValidator(): Void {
		if (_validator != null) return;
		_validator = new Sprite();
		_validator.addEventListener(Event.ENTER_FRAME, _validateComponents);
		_stage.addChild(_validator);
	}
	
	static private function _destroyValidator(): Void {
		if (_validator == null) return;
		_validator.removeEventListener(Event.ENTER_FRAME, _validateComponents);
		_stage.removeChild(_validator);
		_validator = null;
	}
	
	/**
	 * Add component which changes should be validated on next enter frame event.
	 * @param	component	Invalid ui component.
	 */
	static public function invalidComponent(component: BaseComponent): Void {
		if (_invalidComponents.exists(component.componentUID)) return;
		_invalidComponents.set(component.componentUID, component);
		_createValidator();
	}
	
}