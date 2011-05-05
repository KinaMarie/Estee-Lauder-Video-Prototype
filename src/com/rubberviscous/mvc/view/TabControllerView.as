package com.rubberviscous.mvc.view
{
	import flash.display.*;
	import com.rubberviscous.mvc.model.*;
	import com.rubberviscous.mvc.controller.*;
	import flash.events.*;
	import com.greensock.*;
	import com.greensock.easing.*;
	import com.rubberviscous.state.*;
	
	public class TabControllerView extends ComponentView
	{
		public function TabControllerView(aModel:IModel, aController:IController = null)
		{
			super(aModel, aController);
			this.model = aModel; 
			this.controller = aController;
			addEventListener(Event.ADDED_TO_STAGE, init)
			this.visible = false;
		}
		
		override public function update(event:Event = null):void 
		{
			if (model.getApplicationState() == model.TABVIEW) {
				transitionIn();
				controller.setVideoStatus(VideoState.PAUSED);
				controller.setApplicationState(model.VIDEO);
			} else{
			//	transitionOut();
			}
		}
		
		public function init(e:Event=null):void
		{
			this.mc_content.mcClose.addEventListener(MouseEvent.CLICK, closeHandler);
			this.mc_content.eyesBtn.addEventListener(MouseEvent.CLICK, showEyes);
			this.mc_content.faceBtn.addEventListener(MouseEvent.CLICK, showFace);
			this.x = stage.width;
			this.mc_content.mcClose.buttonMode = true;
			this.mc_content.eyesBtn.buttonMode = true;
			this.mc_content.faceBtn.buttonMode = true;
			
		}
		
		public function showEyes(e:MouseEvent):void
		{
			trace('show eye');
			this.mc_content.gotoAndStop('2');
		}
		
		public function showFace(e:MouseEvent):void
		{
			trace('show face');
			this.mc_content.gotoAndStop('1');
		}
		
		public function closeHandler(e:MouseEvent):void
		{
			TweenMax.to(this, .7, {x:stage.stageWidth, ease:Quad.easeInOut, onComplete: transitionOut});
		}
		
		public function transitionIn():void
		{
			trace('TABVIEW transitionIN');
			this.visible = true;
			
			TweenMax.to(this, .7, {x:stage.stageWidth-this.width, ease:Quad.easeInOut});
			
		}
		
		public function transitionOut():void
		{
			controller.setVideoStatus(VideoState.PLAYING);
			controller.setApplicationState(model.VIDEO);
			this.visible = false;
			this.x = stage.width;
			
		}
	}
}