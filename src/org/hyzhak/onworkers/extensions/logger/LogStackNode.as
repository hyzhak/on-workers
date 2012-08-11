package org.hyzhak.onworkers.extensions.logger
{
	[ExcludeClass]
	public class LogStackNode
	{
		private var logLevel : String;
		private var logMessage : String;

		public function getLevel():String
		{
			return logLevel;
		}

		public function setLevel(value:String):LogStackNode
		{
			logLevel = value;
			return this;
		}

		public function getMessage():String
		{
			return logMessage;
		}

		public function setMessage(value:String):LogStackNode
		{
			logMessage = value;
			return this;
		}

	}
}