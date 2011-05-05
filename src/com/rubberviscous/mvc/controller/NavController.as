package com.rubberviscous.mvc.controller
{
	import com.rubberviscous.mvc.model.*;
	import flash.display.*;
	import flash.geom.*;
	
	public class NavController implements IController
	{
		private var model:Object;
		
		public function NavController(aModel:IModel) {
			this.model = aModel;
		}
		
		public function setApplicationState(aApplicationState:String):void
		{
			//trace("HomeController setApplicationState = "+aApplicationState);
			model.setApplicationState(aApplicationState);
		}
		
		public function setVideoURL(aURL:String):void
		{
			model.setVideoURL(aURL);
		}
		
		public function setVideoStatus(aStatus:String):void
		{
			model.setVideoStatus(aStatus);
		}
		
		public function setVideoDuration(aDuration:Number):void
		{
			model.setVideoDuration(aDuration);
		}
		
		public function setVideoTime(aTime:Number):void
		{
			model.setVideoTime(aTime);
		}
		
		public function setCuepointName(aName:String):void
		{
			model.setCuepointName(aName);
		}
		
		public function setVideoView(aView:String):void
		{
			model.setVideoView(aView);
		}
		
		public function setCuePoints(aCuePoints:Array):void
		{
			model.setCuePoints(aCuePoints);
			trace("NavController : setCuePoints")
		}
		
		public function setCuepointLabel(aLabel:String):void
		{
			model.setCuepointLabel(aLabel);
		}
		
		public function setCuepointXY(aPoint:Point):void
		{
			model.setCuepointXY(aPoint);
		}
		
		public function setCuepointAction(aLabel:String):void
		{
			trace("cuepoint action = "+aLabel);
			model.setCuepointAction(aLabel);
		}
	}
}