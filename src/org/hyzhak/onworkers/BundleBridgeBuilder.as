package org.hyzhak.onworkers
{
	import flash.utils.ByteArray;

	public interface BundleBridgeBuilder
	{
		function buildBridge() : BundleBridge;
		
		function fromCurrent() : BundleBridgeBuilder;
		
		function toMain() : BundleBridgeBuilder;
		
		function toNewBundleFromBytes(bytes : ByteArray) : BundleBridgeBuilder;		
	}
}