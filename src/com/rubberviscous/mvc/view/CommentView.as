package com.rubberviscous.mvc.view
{
	import flash.display.*;
	import com.rubberviscous.mvc.model.*;
	import com.rubberviscous.mvc.controller.*;
	import flash.events.*;
	import com.greensock.*;
	import com.greensock.easing.*;
	import com.rubberviscous.state.*;
	
	public class CommentView extends ComponentView
	{
		public function CommentView(aModel:IModel, aController:IController = null)
		{
			super(aModel, aController);
			this.model = aModel; 
			this.controller = aController;
			addEventListener(Event.ADDED_TO_STAGE, init)
			this.visible = false;
		}
		
		override public function update(event:Event = null):void 
		{
			if (model.getApplicationState() == model.COMMENT) {
				transitionIn();
				mcScreen.gotoAndStop(1);
			} else if (model.getApplicationState() == model.RATING) {
				transitionIn();
				mcScreen.gotoAndStop(2);
			} else if (model.getApplicationState() == model.SHARE) {
				transitionOut();
			} else if (model.getApplicationState() == model.PLAYLIST) {
				transitionOut();
			} else if (model.getApplicationState() == model.VIDEOFULL) {
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
			transitionOut();
			controller.setApplicationState(model.VIDEOFULL);
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