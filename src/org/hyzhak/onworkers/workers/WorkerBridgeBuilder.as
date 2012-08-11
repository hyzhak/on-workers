package org.hyzhak.onworkers.workers
{
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.system.WorkerDomain;
	import flash.utils.ByteArray;
	
	import org.hyzhak.onworkers.BundleBridge;
	import org.hyzhak.onworkers.BundleBridgeBuilder;
	
	public class WorkerBridgeBuilder implements BundleBridgeBuilder
	{
		private static const CURRENT_TO_TARGET : String = "currentToTarget";
		private static const TARGET_TO_CURRENT : String = "targetToCurrent";
		
		private var currentWorker : Worker;
		private var targetWorker : Worker;
		private var toMainBundle:Boolean;
		private var startTargetWorker:Boolean;
		
		public static function get isPrimordial() : Boolean
		{
			return Worker.current.isPrimordial;
		}
		
		public function buildBridge():BundleBridge
		{
			if(toMainBundle)
			{
				channalCurrentToTarget = currentWorker.getSharedProperty(TARGET_TO_CURRENT);
				channalTargetToCurrent = currentWorker.getSharedProperty(CURRENT_TO_TARGET);
			}
			else
			{
				var channalTargetToCurrent : MessageChannel = targetWorker.createMessageChannel(currentWorker);
				var channalCurrentToTarget : MessageChannel = currentWorker.createMessageChannel(targetWorker);
				
				targetWorker.setSharedProperty(TARGET_TO_CURRENT, channalTargetToCurrent);
				targetWorker.setSharedProperty(CURRENT_TO_TARGET, channalCurrentToTarget);
				
				if(startTargetWorker)
				{
					targetWorker.start();
				}
			}
			
			return new WorkerBridge()
				.targetToSender(channalTargetToCurrent)
				.senderToTarget(channalCurrentToTarget);
		}
		
		public function from(worker : Worker) : WorkerBridgeBuilder
		{
			currentWorker = worker;
			return this;
		}
		
		public function fromCurrent() : WorkerBridgeBuilder
		{
			currentWorker = Worker.current;
			return this;
		}
		
		public function to(worker : Worker) : WorkerBridgeBuilder
		{
			targetWorker = worker;
			return this;
		}
		
		public function toMain() : WorkerBridgeBuilder
		{
			toMainBundle = true;
			return this;
		}
		
		public function toNewBundleFromBytes(bytes : ByteArray) : WorkerBridgeBuilder
		{
			targetWorker = WorkerDomain.current.createWorker(bytes);
			startTargetWorker = true;
			return this;
		}
	}
}