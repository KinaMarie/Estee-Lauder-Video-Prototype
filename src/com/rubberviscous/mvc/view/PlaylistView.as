package com.rubberviscous.mvc.view
{
	import flash.display.*;
	import com.rubberviscous.mvc.model.*;
	import com.rubberviscous.mvc.controller.*;
	import flash.events.*;
	import com.greensock.*;
	import com.greensock.easing.*;
	import com.rubberviscous.state.*;
	
	public class PlaylistView extends ComponentView
	{
		public function PlaylistView(aModel:IModel, aController:IController = null)
		{
			super(aModel, aController);
			this.model = aModel; 
			this.controller = aController;
			addEventListener(Event.ADDED_TO_STAGE, init)
			this.visible = false;
		}
		
		override public function update(event:Event = null):void 
		{
			if (model.getApplicationState() == model.PLAYLIST) {
				transitionIn();
			} else if (model.getApplicationState() == model.COMMENT) {
				transitionOut();
			} else if (model.getApplicationState() == model.SHARE) {
				transitionOut();
			} else if (model.getApplicationState() == model.SHARETHELOOK) {
				transitionOut();
			}
			else if (model.getApplicationState() == model.TABVIEW) {
				transitionOut();
			}
		}
		
		public function init(e:Event=null):void
		{
			mcClose.addEventListener(MouseEvent.CLICK, closeHandler);
			mcClose.buttonMode = true;
			
			for (var i:uint=1;i<=3;i++) {
				var clip:MovieClip = MovieClip(getChildByName("video"+i));
				clip.addEventListener(MouseEvent.ROLL_OVER, mouseHandler);
				clip.addEventListener(MouseEvent.ROLL_OUT, mouseHandler);
				clip.buttonMode = true;
				clip.mouseChildren = false;
			}
		}
		
		private function mouseHandler(e:MouseEvent):void
		{
			switch (e.type) {
				case MouseEvent.ROLL_OVER:
					TweenMax.to(e.target, .3, {scaleX:1.1, scaleY:1.1, ease:Quad.easeOut});
				//	TweenMax.to(e.target.icon.mcPlay, .3, {alpha:1, ease:Quad.easeOut});
					break;
				case MouseEvent.ROLL_OUT:
					TweenMax.to(e.target, .3, {scaleX:1, scaleY:1, ease:Quad.easeOut});
					//TweenMax.to(e.target.icon.mcPlay, .3, {alpha:0, ease:Quad.easeOut});
					break;
			}
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