package org.hyzhak.onworkers.extensions.logger
{
	import mx.logging.Log;
	
	import org.hyzhak.onworkers.BridgeExtension;
	import org.hyzhak.onworkers.BundleBridge;
	import org.hyzhak.onworkers.BundleResponse;
	
	public class LogExtension implements BridgeExtension
	{
		private static const LOG : String = "log-special-method";
		
		private static const LEVEL : String = "level";
		
		private static const MESSAGE : String = "message";
		
		private var bundleBridge : BundleBridge;
		
		private var onLogHandler : Function;
		
		private var logStack : Array = [];
		
		//--------------------------------------------------------------------------
		//
		//  Dependencies
		//
		//--------------------------------------------------------------------------
		
		public function bridge(value:BundleBridge):BridgeExtension
		{
			if(bundleBridge == value)
			{
				return this;
			}
			
			bundleBridge = value;
			
			refreshOnLog();
			sendStackLogs();
			
			return this;
		}
		
		private function refreshOnLog():void
		{
			if(bundleBridge == null)
			{
				return;
			}
			
			bundleBridge.onInvoke(LOG, function(response : BundleResponse) : void {
				onLogHandler.call(null, response.getParam(LEVEL), response.getParam(MESSAGE));
			});
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public.Methods
		//
		//--------------------------------------------------------------------------
		
		public function error(message:String, ... rest):LogExtension
		{
			sendLog(LogLevel.ERROR, message + " " + rest.join(" "));
			
			return this;
		}
		
		public function info(message:String, ... rest):LogExtension
		{
			sendLog(LogLevel.INFO, message + " " + rest.join(" "));
			
			return this;
		}
		
		public function onLog(handler:Function):LogExtension
		{
			onLogHandler = handler;
			refreshOnLog();
			return this;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private.Methods
		//
		//--------------------------------------------------------------------------
		
		private function sendStackLogs() : void
		{
			if(bundleBridge == null)
			{
				return;
			}
			
			for each(var node : LogStackNode in logStack)
			{
				sendLog(node.getLevel(), node.getMessage());
			}
		}
		
		private function sendLog(level:String, message:String):void
		{
			if(bundleBridge == null)
			{
				logStack.push(new LogStackNode()
					.setLevel(level)
					.setMessage(message));
				return;
			}
			
			bundleBridge.invoke(LOG)
				.withParam(LEVEL, level)
				.withParam(MESSAGE, message);
		}
	}
}