package be.zajac.ui;
import be.zajac.core.FWCore;
import nme.display.Sprite;
import nme.display.DisplayObject;
import nme.events.Event;

private class BaseComonentUtil {
	
	static private var _componentUID: Int = 1;
	/**
	 * Unique identifier creator for BaseComponent.
	 * @return	String unique identifier.
	 */
	static public function nextComponentUID(): String {
		return StringTools.hex(_componentUID++);
	}
}

/**
 * Root ui component of framework. It supports states, skins an it is able to validate itself after changes.
 * @author Aleksandar Bogdanovic
 */
class BaseComponent extends Sprite {
	
	/**
	 * Unique component identiier in framework.
	 */
	public var componentUID(default, null): String;
	
	
	/**
	 * Hash map of skins for each state.
	 */
	public var states(_getStates, never): Hash<DisplayObject>;
	private var _states: Hash<DisplayObject>;
	private function _getStates(): Hash<DisplayObject> {
		return _states;
	}
	
	
	/**
	 * Current component state.
	 */
	public var state(_getState, _setState): String;
	private function _getState(): String {
		return state;
	}
	private function _setState(v: String): String {
		if (v != state) {
			state = v;
			invalidState();
		}
		return state;
	}
	
	
	/**
	 * Component that draws skins for all states.
	 */
	public var skin(_getSkin, _setSkin): ISkin;
	private function _getSkin(): ISkin {
		return skin;
	}
	private function _setSkin(v: ISkin): ISkin {
		if (v != skin) {
			skin = v;
			invalidSkin();
		}
		return skin;
	}
	
	
	private var _dirtySkin: Bool;
	private var _dirtyState: Bool;
	
	/**
	 * Add current component in validation list for validating on next enter frame.
	 */
	public function invalid(): Void {
		FWCore.invalidComponent(this);
	}
	
	/**
	 * Invalidate skin.
	 */
	public function invalidSkin(): Void {
		_dirtySkin = true;
		invalid();
	}
	
	/**
	 * Invalidate state.
	 */
	public function invalidState(): Void {
		_dirtyState = true;
		invalid();
	}
	
	/**
	 * Put component in valid state based on changes.
	 */
	public function validate(): Void {
		if (_dirtySkin && skin != null) {
			_states = skin.draw(this);
			_dirtySkin = false;
			_dirtyState = true;
		}
		if (_dirtyState && _states.exists(state)) {
			while (numChildren > 0) removeChildAt(0);
			addChild(_states.get(state));
			_dirtyState = false;
		}
	}
	
	
	/**
	 * Replacement for width that can not be overriden.
	 */
	public var Width(getWidth, setWidth): Float = 0;
	private function getWidth(): Float {
		return Width;
	}
	private function setWidth(v: Float): Float {
		if (v != Width) {
			Width = v;
			invalidSkin();
		}
		return Width;
	}
	
	
	/**
	 * Replacement for height that can not be overriden.
	 */
	public var Height(getHeight, setHeight): Float = 0;
	private function getHeight(): Float {
		return Height;
	}
	private function setHeight(v: Float): Float {
		if (v != Height) {
			Height = v;
			invalidSkin();
		}
		return Height;
	}
	
	/**
	 * Set Width and Height.
	 * @param	w	Width.
	 * @param	h	Height.
	 */
	public function setSize(w: Float, h: Float): Void {
		Width = w;
		Height = h;
	}
	
	
	public function new() {
		super();
		componentUID = BaseComonentUtil.nextComponentUID();
		_states = new Hash<DisplayObject>();
		_dirtySkin = true;
		_dirtyState = true;
		invalid();
	}
	
}