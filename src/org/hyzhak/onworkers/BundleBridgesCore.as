package org.hyzhak.onworkers
{
	import org.hyzhak.onworkers.workers.WorkerBridgeBuilder;

	public interface BundleBridgesCore
	{
		function get isPrimordial() : Boolean;
		
		function newBundleBridgeBuilder() : BundleBridgeBuilder;
	}
}