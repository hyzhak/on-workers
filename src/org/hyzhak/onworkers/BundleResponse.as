package org.hyzhak.onworkers
{
	import flash.utils.ByteArray;

	public interface BundleResponse
	{
		function getParam(key : String) : *;
		
		function getSharedBytes(key : String = "") : ByteArray;
	}
}