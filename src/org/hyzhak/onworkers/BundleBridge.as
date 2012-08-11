package org.hyzhak.onworkers
{
	public interface BundleBridge
	{
		function invoke(name : String) : BundleInvoke;
		
		function onInvoke(name : String, handler : Function) : BundleBridge;
	}
}