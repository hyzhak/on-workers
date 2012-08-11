package org.hyzhak.onworkers
{
	public interface BundleInvoke
	{
		function withParam(key : String, value : *) : BundleInvoke;
		
		function then(fulfilledHandler : Function, errorHandler : Function = null, progressHandler : Function = null) : void;
	}
}