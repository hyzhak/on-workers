package org.hyzhak.onworkers.workers
{
	[ExcludeClass]
	public class WorkerUtil
	{
		public static function getSharedBytesName(bridgeId : String, messageId : String, key : String) : String
		{
			return bridgeId + "-" + messageId + "-" + key; 
		}
	}
}