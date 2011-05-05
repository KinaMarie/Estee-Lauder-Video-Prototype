package com.rubberviscous.mvc.view
{
	import flash.display.*;
	import com.rubberviscous.mvc.model.*;
	import com.rubberviscous.mvc.controller.*;
	import flash.events.*;
	import com.greensock.*;
	import com.greensock.easing.*;
	import com.rubberviscous.state.*;
	
	public class ShareTheLookView extends ComponentView
	{
		public function ShareTheLookView(aModel:IModel, aController:IController = null)
		{
			super(aModel, aController);
			this.model = aModel; 
			this.controller = aController;
			addEventListener(Event.ADDED_TO_STAGE, init)
			this.visible = false;
		}
		
		override public function update(event:Event = null):void 
		{
			if (model.getApplicationState() == model.SHARETHELOOK) {
				transitionIn();
			} else if (model.getApplicationState() == model.COMMENT) {
				transitionOut();
			} else if (model.getApplicationState() == model.SHARE) {
				transitionOut();
			} else if (model.getApplicationState() == model.PLAYLIST) {
				transitionOut();
			} else if (model.getApplicationState() == model.MIRROR) {
				transitionOut();
			}
		}
		
		public function init(e:Event=null):void
		{
			mcClose.addEventListener(MouseEvent.CLICK, closeHandler);
			mcClose.buttonMode = true;
		}
		
		public function closeHandler(e:MouseEvent):void
		{
			controller.setApplicationState(model.MIRROR);
			transitionOut();
		}
		
		public function transitionIn():void
		{
			this.visible = true;
		}
		
		public function transitionOut():void
		{
			this.visible = false;
		}
	}
}