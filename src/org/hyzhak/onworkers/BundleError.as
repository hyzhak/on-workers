package org.hyzhak.onworkers
{
	public class BundleError
	{
		private var errorId : int;
		private var errorMsg : String;
		
		public function get id() : int
		{
			return errorId;
		}
		
		public function get msg() : String
		{
			return errorMsg;
		}
	}
}