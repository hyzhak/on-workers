package org.hyzhak.onworkers
{
	import org.hyzhak.onworkers.workers.WorkerBridgeBuilder;

	public class BundleBridges
	{
		public static function get isPrimordial() : Boolean
		{
			return WorkerBridgeBuilder.isPrimordial;
		}
		
		public static function onWorkers() : WorkerBridgeBuilder
		{
			return new WorkerBridgeBuilder();
		}
	}
}