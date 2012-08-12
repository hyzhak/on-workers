package org.hyzhak.onworkers.workers
{
	import flash.system.WorkerDomain;
	import flash.utils.ByteArray;
	
	import org.hyzhak.onworkers.BundleResponse;
	
	public class WorkerRespose implements BundleResponse
	{
		private var values : Object;
		private var bridge:WorkerBridge;		
		private var message : String;
		
		public function getParam(key:String):*
		{
			return values == null?null:values[key];
		}
		
		public function getSharedBytes(key:String=""):ByteArray
		{
			return bridge.getSharedBytes(message, key);
		}
		
		internal function setParams(values : Object) : WorkerRespose
		{
			this.values = values;
			return this;
		}
		
		internal function setBridge(value : WorkerBridge) : WorkerRespose
		{
			bridge = value;
			return this;
		}
		
		internal function setMessage(value : String) : WorkerRespose
		{
			message = value;
			return this;
		}
	}
}