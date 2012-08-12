package org.hyzhak.onworkers
{
	import flash.utils.ByteArray;

	public interface BundleInvoke
	{
		function param(key : String, value : *) : BundleInvoke;
		
		function shareBytes(bytes : ByteArray, key : String = "") : BundleInvoke;
		
		function then(fulfilledHandler : Function, errorHandler : Function = null, progressHandler : Function = null) : void;
	}
}