package org.hyzhak.onworkers.workers
{
	import org.hyzhak.onworkers.BundleResponse;
	
	public class WorkerRespose implements BundleResponse
	{
		private var values : Object;
		
		public function getParam(key:String):*
		{
			return values == null?null:values[key];
		}
		
		internal function setParams(values : Object) : WorkerRespose
		{
			this.values = values;
			return this;
		}
	}
}