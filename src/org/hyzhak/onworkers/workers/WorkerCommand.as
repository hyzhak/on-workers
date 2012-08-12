package org.hyzhak.onworkers.workers
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.system.MessageChannel;
	import flash.system.MessageChannelState;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	import mx.binding.utils.ChangeWatcher;
	
	import org.hyzhak.onworkers.BundleInvoke;
	
	public class WorkerCommand implements BundleInvoke
	{
		private var message : String;
		private var toChannel : MessageChannel;
		private var fromChannel : MessageChannel;
		private var args : Object = {};
		private var isLazyRun:Boolean = false;
		
		private var timer:Timer;
		
		private var bridge : WorkerBridge;
		
		//--------------------------------------------------------------------------
		//
		//  BundleInvoke
		//
		//--------------------------------------------------------------------------
		
		public function then(fulfilledHandler:Function, errorHandler:Function=null, progressHandler:Function=null):void
		{
			// TODO Auto Generated method stub
		}
		
		public function param(key : String, value:*):BundleInvoke
		{
			args[key] = value;
			return this;
		}
		
		public function shareBytes(bytes:ByteArray, key : String = ""):BundleInvoke
		{
			bridge.shareBytes(message, key, bytes);
			return this;
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Private.Methods
		//
		//--------------------------------------------------------------------------
		
		private function lazyRun():void
		{
			if(isLazyRun)
			{
				return;
			}
			
			isLazyRun = true;
			
			timer = new Timer(0, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimer);
			timer.start();
		}
		
		protected function onTimer(event:TimerEvent):void
		{
			timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimer);
			run();
		}
		
		private function run():void
		{
			trace("run", toChannel.state);
			if(toChannel.state != MessageChannelState.OPEN)
			{
				return;
			}
			
			toChannel.send(message);
			toChannel.send(args);
		}
		
		internal function invoke(message : String) : WorkerCommand
		{
			this.message = message; 
			lazyRun();
			return this;
		}
		
		internal function at(channel : MessageChannel) : WorkerCommand
		{
			toChannel = channel;
			return this;
		}
		
		internal function listen(channel : MessageChannel) : WorkerCommand
		{
			//TODO : wait response from recivers
			fromChannel = channel;
			return this;
		}
		
		internal function setBridge(value : WorkerBridge) : WorkerCommand
		{
			bridge = value;
			return this;
		}
	}
}