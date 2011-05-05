package com.rubberviscous.mvc.view
{
	import flash.display.*;
	import com.rubberviscous.mvc.model.*;
	import com.rubberviscous.mvc.controller.*;
	import flash.events.*;
	import flash.geom.*;
	import com.greensock.*;
	import com.greensock.easing.*;
	import com.rubberviscous.state.*;
	
	public class VideoControllerView extends CompositeView
	{
		private var videoWidth:Number;
		private var videoHeight:Number;
		private var mcClickArea:MovieClip;
		
		public function VideoControllerView(aModel:IModel, aController:IController = null)
		{
			super(aModel, aController);
			this.model = aModel; 
			this.controller = aController;
			addEventListener(Event.ADDED_TO_STAGE, init)
		}
		
		override public function update(event:Event = null):void
		{
			if (model.getApplicationState() == model.XMLCOMPLETE)
			{
				mcClickArea = new ClickArea();
				addChild(mcClickArea);
				mcClickArea.addEventListener(MouseEvent.CLICK, fullSizeHandler);
				mcClickArea.visible = false;
				mcClickArea.alpha = 0;
				
			} else if (model.getApplicationState() == model.SHARE) {
				//removeDraggable();
				this.visible = true;
				TweenMax.to(this, .4, {scaleX:.4, scaleY:.4, x:15, y:15, ease:Quad.easeInOut});
				mcClickArea.visible = true;
				controller.setVideoStatus(VideoState.PAUSED);
				controller.setApplicationState(model.VIDEO);
			} else if (model.getApplicationState() == model.MIRROR) {
				//removeDraggable();
				//trace("VideoControllerView : mirror")
				this.visible = true;
				TweenMax.to(this, .4, {scaleX:.4, scaleY:.4, x:0, y:216, ease:Quad.easeInOut, onComplete:makeDraggable, onCompleteParams:[this]});
				mcClickArea.visible = true;
				
			} else if (model.getApplicationState() == model.VIDEOFULL) {
				this.visible = true;
				TweenMax.to(this, .4, {scaleX:1, scaleY:1, x:0, y:0, ease:Quad.easeInOut});
				mcClickArea.visible = false;
				controller.setVideoStatus(VideoState.PLAYING);
				controller.setApplicationState(model.VIDEO);
			} else 	if (model.getApplicationState() == model.COMMENT) {
				this.visible = true;
				//removeDraggable();
				/*var displayObject:Sprite = this as Sprite;
				trace("My object is = "+displayObject.scaleX);
				displayObject.scaleX = displayObject.scaleY = 2;*/
				TweenMax.to(this, .4, {scaleX:.4, scaleY:.4, x:15, y:15, ease:Quad.easeInOut});
				mcClickArea.visible = true;
				controller.setVideoStatus(VideoState.PAUSED);
				controller.setApplicationState(model.VIDEO);
			}else if (model.getApplicationState() == model.TABVIEW) {
				this.visible = false;
			//	TweenMax.to(this, .4, {scaleX:.9, scaleY:.4, x:15, y:15, ease:Quad.easeInOut});
			//	mcClickArea.visible = true;
			}
			else if (model.getApplicationState() == model.RATING) {
				TweenMax.to(this, .4, {scaleX:.4, scaleY:.4, x:15, y:15, ease:Quad.easeInOut});
				mcClickArea.visible = true;
				controller.setVideoStatus(VideoState.PAUSED);
				controller.setApplicationState(model.VIDEO);
			} else if (model.getApplicationState() == model.PLAYLIST) {
				this.visible = true;
				//removeDraggable();
				TweenMax.to(this, .4, {scaleX:.4, scaleY:.4, x:15, y:15, ease:Quad.easeInOut});
			//	mcClickArea.visible = true;
				controller.setVideoStatus(VideoState.PAUSED);
				controller.setApplicationState(model.VIDEO);
			} else if (model.getApplicationState() == model.SHARETHELOOK) {
				//removeDraggable();
				this.visible = false;
				//TweenMax.to(this, .4, {scaleX:.4, scaleY:.4, x:40, y:40, ease:Quad.easeInOut});
			}
			
			trace("VideoControllerView : update()")
			for each (var c:ComponentView in aChildren)
			{
				//trace(c);
				c.update(event);
				//trace(c);
			}
			
			if (model.getApplicationState() == model.TABVIEW) {
				this.visible = false;
				trace('video controller =- TABVIEW - merda')
			//	TweenMax.to(this, .4, {scaleX:.9, scaleY:.4, x:15, y:15, ease:Quad.easeInOut});
			//	mcClickArea.visible = true;
			}
		}
		
		private function makeDraggable(aDisplayObject:Sprite=null):void
		{
			aDisplayObject.addEventListener(MouseEvent.MOUSE_DOWN, startDragHandler);
			aDisplayObject.addEventListener(MouseEvent.MOUSE_UP, stopDragHandler);
			aDisplayObject.buttonMode = true;
		}
		
		private function removeDraggable(aDisplayObject:Sprite=null):void
		{
			aDisplayObject.removeEventListener(MouseEvent.MOUSE_DOWN, startDragHandler);
			aDisplayObject.removeEventListener(MouseEvent.MOUSE_UP, stopDragHandler);
			aDisplayObject.buttonMode = false;
		}
		
		private function startDragHandler(e:MouseEvent):void
		{
			trace("Mouse down")
			var rect:Rectangle = new Rectangle(0,0,videoWidth-this.width,videoHeight-this.height);
			this.startDrag(false, rect);
		}
		
		private function stopDragHandler(e:MouseEvent):void
		{
			this.stopDrag();
		}
		
		private function updatePosition(aDisplayObject:DisplayObject):void
		{
			trace(aDisplayObject.y)
			aDisplayObject.y = (videoHeight - aDisplayObject.height);
		}
		
		public function init(e:Event=null):void
		{
			
			//this.mouseEnabled = false;
			videoWidth = model.getVideoWidth();
			videoHeight = model.getVideoHeight();
			
			
		}
		
		public function fullSizeHandler(e:MouseEvent):void
		{
			//TweenMax.to(this, .4, {scaleX:1, scaleY:1, x:0, y:0, ease:Quad.easeInOut});
			controller.setApplicationState(model.VIDEOFULL);
			//removeDraggable();
		}
		
		public function transitionIn():void
		{
		}
		
		public function transitionOut():void
		{
		}
		
		
		public function controllerSetApplicationState(aApplicationState:String):void
		{
			controller.setApplicationState(aApplicationState);
		}
	}
}