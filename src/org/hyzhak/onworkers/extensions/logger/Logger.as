package org.hyzhak.onworkers.extensions.logger
{
	public interface Logger
	{
		function error(message:String, ... rest):void;
		
		function info(message:String, ... rest):void;
	}
}