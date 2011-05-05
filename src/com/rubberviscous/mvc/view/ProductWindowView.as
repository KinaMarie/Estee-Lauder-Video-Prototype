package com.rubberviscous.mvc.view
{
	import flash.display.*;
	import com.rubberviscous.mvc.model.*;
	import com.rubberviscous.mvc.controller.*;
	import flash.events.*;
	import com.greensock.*;
	import com.greensock.easing.*;
	import com.rubberviscous.state.*;
	
	public class ProductWindowView extends ComponentView
	{
		public function ProductWindowView(aModel:IModel, aController:IController = null)
		{
			super(aModel, aController);
			this.model = aModel; 
			this.controller = aController;
			addEventListener(Event.ADDED_TO_STAGE, init)
		}
		
		override public function update(event:Event = null):void 
		{
			if (model.getApplicationState()==model.PRODUCTHOTSPOT) {
				transitionIn();
				controller.setVideoStatus(VideoState.PAUSED);
				controller.setApplicationState(model.VIDEO);
			}
		}
		
		public function init(e:Event=null):void
		{
			this.visible = false;
			this.x = stage.stageWidth;
			mcClose.addEventListener(MouseEvent.CLICK, closeWindowHandler);
			mcClose.buttonMode = true;
		}
		
		public function closeWindowHandler(e:MouseEvent):void
		{
			TweenMax.to(this, .4, {x:stage.stageWidth, ease:Quad.easeInOut, visible:false});
			controller.setVideoStatus(VideoState.PLAYING);
			controller.setApplicationState(model.VIDEO);
		}
		
		public function transitionIn():void
		{
			this.visible = true;
			trace("InfoWindow transition in")
			TweenMax.to(this, .4, {x:stage.stageWidth-307, ease:Quad.easeInOut});
		}
		
		public function transitionOut():void
		{
		}
	}
}