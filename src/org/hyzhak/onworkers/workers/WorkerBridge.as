package org.hyzhak.onworkers.workers
{
	import flash.events.Event;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	
	import org.hyzhak.onworkers.BundleBridge;
	import org.hyzhak.onworkers.BundleInvoke;
	import org.hyzhak.onworkers.BundleResponse;

	public class WorkerBridge implements BundleBridge
	{
		private var senderBridge:Worker;
		
		private var channelSenderToTarget : MessageChannel;
		private var channelTargetToSender : MessageChannel;
		
		private var isListenTarget:Boolean;
		
		private var handlers:Object = {};
		
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
				.invoke(name)
				.at(channelSenderToTarget)
				.listen(channelTargetToSender);
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
			return new WorkerCommand();
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
							.setParams(channelTargetToSender.receive() as Object));
				}
				catch(e : Error)
				{
					
				}
			}
		}
		
		private function buildResponce():WorkerRespose
		{
			return new WorkerRespose();
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