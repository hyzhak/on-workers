package org.hyzhak.onworkers.workers
{
	import flash.events.Event;
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
				
		public function buildBridge():BundleBridge
		{
			var bytes : ByteArray;
			var sharedPropertyWorker : Worker;
			if(toMainBundle)
			{
				channalCurrentToTarget = currentWorker.getSharedProperty(TARGET_TO_CURRENT);
				channalTargetToCurrent = currentWorker.getSharedProperty(CURRENT_TO_TARGET);
				
				bytes = new ByteArray();
				bytes.shareable = true;
				
				currentWorker.setSharedProperty("testbytes", bytes);
				if(bytes != null)
				{
					bytes.position = 0;
					bytes.writeObject("hello");
					channalCurrentToTarget.send("testbytes");
				}
				
				sharedPropertyWorker = currentWorker;
			}
			else
			{
				var channalTargetToCurrent : MessageChannel = targetWorker.createMessageChannel(currentWorker);
				var channalCurrentToTarget : MessageChannel = currentWorker.createMessageChannel(targetWorker);
				
				targetWorker.setSharedProperty(TARGET_TO_CURRENT, channalTargetToCurrent);
				targetWorker.setSharedProperty(CURRENT_TO_TARGET, channalCurrentToTarget);
				
				channalTargetToCurrent.addEventListener(Event.CHANNEL_MESSAGE, function(event : Event) : void {
					var localBytes : ByteArray = targetWorker.getSharedProperty("testbytes");
					localBytes.position = 0;
					trace("testbytes",localBytes.bytesAvailable);
					trace("bytes.shareable", localBytes.shareable);
					if(localBytes.bytesAvailable>0)
					{
						var object : Object = localBytes.readObject();
						trace("testbytes", object);
					}
				});
				
				if(startTargetWorker)
				{
					targetWorker.start();
				}
				
				sharedPropertyWorker = targetWorker;
			}
			
			return new WorkerBridge()
				.targetToSender(channalTargetToCurrent)
				.senderToTarget(channalCurrentToTarget)
				.setSharedPropertyWorker(sharedPropertyWorker);
		}		
		
		public function fromCurrent() : BundleBridgeBuilder
		{
			currentWorker = Worker.current;
			return this;
		}
		
		public function toMain() : BundleBridgeBuilder
		{
			toMainBundle = true;
			return this;
		}
		
		public function toNewBundleFromBytes(bytes : ByteArray) : BundleBridgeBuilder
		{
			targetWorker = WorkerDomain.current.createWorker(bytes);
			startTargetWorker = true;
			return this;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public.Methods
		//
		//--------------------------------------------------------------------------
		
		public function from(worker : Worker) : WorkerBridgeBuilder
		{
			currentWorker = worker;
			return this;
		}
		
		public function to(worker : Worker) : WorkerBridgeBuilder
		{
			targetWorker = worker;
			return this;
		}
	}
}