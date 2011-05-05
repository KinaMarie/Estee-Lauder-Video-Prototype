package com.rubberviscous.mvc.model
{
	import flash.events.IEventDispatcher;
	
	public interface IModel extends IEventDispatcher
	{
		function getApplicationState():String
		function setApplicationState(aStatus:String):void
	}
}