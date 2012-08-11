package org.hyzhak.onworkers
{
	import org.hyzhak.onworkers.workers.WorkerBridgeBuilder;
	import org.hyzhak.onworkers.workers.WorkerBridgesCore;

	public class BundleBridges
	{
		private static var _cores : Object = {};
		
		//--------------------------------------------------------------------------
		//
		//  Public.Methods
		//
		//--------------------------------------------------------------------------
		
		public static function onWorkers() : BundleBridgesCore
		{
			return getInstance(WorkerBridgesCore);
		}
		
		public static function onSharedEvents() : BundleBridgesCore
		{
			throw new Error("TODO : doesn't implement yet. ");
			return getInstance(null);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private.Methods
		//
		//--------------------------------------------------------------------------
		
		private static function getInstance(keyClass : Class) : BundleBridgesCore
		{
			if(_cores[keyClass] == null)
			{
				_cores[keyClass] = new keyClass;
			}
			
			return _cores[keyClass];
		}
	}
}