package org.hyzhak.onworkers.workers
{
	import flash.events.Event;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.utils.ByteArray;
	
	import org.hyzhak.onworkers.BridgeExtension;
	import org.hyzhak.onworkers.BundleBridge;
	import org.hyzhak.onworkers.BundleInvoke;
	import org.hyzhak.onworkers.BundleResponse;

	public class WorkerBridge implements BundleBridge
	{
		private var sharedPropertyWorker:Worker;
		
		private var channelSenderToTarget : MessageChannel;
		private var channelTargetToSender : MessageChannel;
		
		private var isListenTarget:Boolean;
		
		private var handlers:Object = {};
		
		private var sharedBytes:Object = {};
		
		//--------------------------------------------------------------------------
		//
		//  BundleBridge
		//
		//--------------------------------------------------------------------------
		
		public function invoke(name:String) : BundleInvoke
		{
			//FIXME : for test
			//startListen();
			
			trace("invoke", name);
			
			return buildCommand()
				.invoke(name);
		}
		
		public function onInvoke(name:String, handler : Function):BundleBridge
		{
			startListen();
			handlers[name] = handler;
			return this;
		}
		//--------------------------------------------------------------------------
		//
		//  Private.Methods
		//
		//--------------------------------------------------------------------------
		
		private function buildCommand():WorkerCommand
		{
			return new WorkerCommand()
				.at(channelSenderToTarget)
				.listen(channelTargetToSender)
				.setBridge(this);
		}
		
		private function startListen() : void
		{
			if(isListenTarget)
			{
				return;
			}
			isListenTarget = true;
			channelTargetToSender.addEventListener(Event.CHANNEL_MESSAGE, onChannelMessage);
			channelTargetToSender.addEventListener(Event.CHANNEL_STATE, onChangeChannelState);
		}
		
		protected function onChangeChannelState(event:Event):void
		{
			trace("channel change state", channelTargetToSender.state);
		}
		
		private function onChannelMessage(event:Event):void
		{
			//trace("onChannelMessage");
			if(!channelTargetToSender.messageAvailable)
			{
				//trace("stranget trigger event without messages");
				return;
			}
			
			while(channelTargetToSender.messageAvailable)
			{
				var msg : * = channelTargetToSender.receive();
				var handler : Function = handlers[msg];
				if(handler == null)
				{
					trace("got unhandled message", msg);
					//return;
					continue;
				}
				
				try
				{
					handler.call(null, 
						buildResponce()
							.setParams(channelTargetToSender.receive() as Object)
							.setMessage(msg)
							.setBridge(this)
					);
				}
				catch(e : Error)
				{
					return;
				}
			}
		}
		
		private function buildResponce():WorkerRespose
		{
			return new WorkerRespose();
		}
		
		internal function shareBytes(message : String, key : String, bytes : ByteArray) : void
		{
			var fullSharedKey : String = WorkerUtil.getSharedBytesName("", message, key);
			
			if(bytes == null || sharedBytes[fullSharedKey] != null)
			{
				return;
			}
			
			sharedBytes[fullSharedKey] = bytes;
			
			bytes.shareable = true;
			
			sharedPropertyWorker.setSharedProperty(fullSharedKey, bytes);
		}
		
		internal function getSharedBytes(message : String, key : String) : ByteArray
		{
			var fullSharedKey : String = WorkerUtil.getSharedBytesName("", message, key);
			
			if(sharedBytes[fullSharedKey] != null)
			{
				return sharedBytes[fullSharedKey];
			}
			
			var bytes : ByteArray = sharedPropertyWorker.getSharedProperty(fullSharedKey);
			
			sharedBytes[fullSharedKey] = bytes;
			
			return bytes;
		}
		
		internal function setSharedPropertyWorker(value : Worker) : WorkerBridge
		{
			sharedPropertyWorker = value;
			return this;
		}
		
		internal function senderToTarget(value : MessageChannel) : WorkerBridge
		{
			channelSenderToTarget = value;
			return this;
		}
		
		internal function targetToSender(value : MessageChannel) : WorkerBridge
		{
			channelTargetToSender = value;
			return this;
		}
	}
}