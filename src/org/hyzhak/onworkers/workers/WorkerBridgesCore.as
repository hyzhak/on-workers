package org.hyzhak.onworkers.workers
{
	import flash.system.Worker;
	
	import org.hyzhak.onworkers.BridgeExtension;
	import org.hyzhak.onworkers.BundleBridgeBuilder;
	import org.hyzhak.onworkers.BundleBridgesCore;
	
	public class WorkerBridgesCore implements BundleBridgesCore
	{
		public function get isPrimordial():Boolean
		{
			return Worker.current.isPrimordial;
		}
		
		public function newBundleBridgeBuilder():BundleBridgeBuilder
		{
			return new WorkerBridgeBuilder();
		}
		
		public function registrateExtension(extension:BridgeExtension):BundleBridgesCore
		{
			//TODO
			//extension.bridge();
			return this;
		}
	}
}