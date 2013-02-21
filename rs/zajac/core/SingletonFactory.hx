package rs.zajac.core;

/**
 * SingletonFactory provides one instance per class.
 * @author Aleksandar Bogdanovic
 */
class SingletonFactory {

	private function new() { }
	
	private static var _instances: Hash<Dynamic> = new Hash<Dynamic>();
	
	/**
	 * Creating only one instance per class.
	 * @param	c	class that should be instanced
	 * @return	class instance
	 */
	static public function getInstance(c: Class<Dynamic>): Dynamic {
		var c_className: String = Type.getClassName(c);
		if (!_instances.exists(c_className)) {
			_instances.set(c_className, Type.createInstance(c, []));
		}
		return _instances.get(c_className);
	}
	
}