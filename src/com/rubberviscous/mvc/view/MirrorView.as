package com.rubberviscous.mvc.view
{
	import flash.display.*;
	import com.rubberviscous.mvc.model.*;
	import com.rubberviscous.mvc.controller.*;
	import flash.events.*;
	import flash.media.*;
	import flash.geom.*;
	import com.greensock.*;
	import com.greensock.easing.*;

	public class MirrorView extends ComponentView
	{
		private var video:Video;
		private var _cam:Camera;
		private var _bmpd:BitmapData;
		private var videoWidth:Number = 640;
		private var videoHeight:Number = 480;
		private var bCamera:Boolean = false;
		private var shareLook:MovieClip;
		private var closeButton:MovieClip
		
		public function MirrorView(aModel:IModel, aController:IController = null)
		{
			super(aModel, aController);
			this.model = aModel; 
			this.controller = aController;
			this.visible = false;
			init();
		}
		
		override public function update(event:Event = null):void 
		{
			//trace("MirrorView : update()")
			if (model.getApplicationState() == model.MIRROR) {
				//shareLook.visible = true;
				closeButton.visible = true;
				transitionIn();
			} else if (model.getApplicationState() == model.SHARE) {
				transitionOut();
			} else if (model.getApplicationState() == model.COMMENT) {
				transitionOut();
				} else if (model.getApplicationState() == model.TABVIEW) {
					transitionOut();
			} else if (model.getApplicationState() == model.VIDEOFULL) {
				transitionOut();
			} else if (model.getApplicationState() == model.SHARETHELOOK) {
				TweenMax.to(this, .4, {scaleX:.4, scaleY:.4, x:15, y:15, ease:Quad.easeInOut});
				shareLook.visible = false;
				closeButton.visible = false;
			} else if (model.getApplicationState() == model.PLAYLIST) {
				transitionOut();
			}
		}
		
		public function init():void
		{
			videoWidth = 640//model.getVideoWidth();
			videoHeight = 480//model.getVideoHeight();
			
			_bmpd = new BitmapData(videoWidth, videoHeight, false);
			var _bm = new Bitmap(_bmpd)
			addChild(_bm);
			
			video = new Video();
			video.name = "video";
			video.width = videoWidth;
			video.height= videoHeight;
			addChild(video);
			
			closeButton = new CloseButton();
			addChild(closeButton);
			closeButton.x = 561;
			closeButton.y = 32.5;
			closeButton.addEventListener(MouseEvent.CLICK, closeHandler);
			closeButton.buttonMode = true;
			
			shareLook = new ShareTheLook();
			shareLook.addEventListener(MouseEvent.CLICK, shareTheLookHandler);
			shareLook.buttonMode = true;
			addChild(shareLook);
			shareLook.x = 0;
			shareLook.y = 195;
			shareLook.visible = false;
			shareLook.alpha = 0;
		}
		
		public function closeHandler(e:MouseEvent):void
		{
			controller.setApplicationState(model.VIDEOFULL);
			transitionOut();
		}
		
		public function shareTheLookHandler(e:MouseEvent):void
		{
			controller.setApplicationState(model.SHARETHELOOK);
		}
		
		private function enterFrameHandler(event:Event):void
		{
			var matrix:Matrix = new Matrix(-1,0,0,1,_bmpd.width, 0);
			_bmpd.draw(video, matrix);
		}
		
		public function transitionIn():void
		{
			this.visible = true;
			if (bCamera == false) {
				_cam = Camera.getCamera();
				_cam.setMode(videoWidth, videoHeight, 15);
				video.attachCamera(_cam);
				bCamera = true;
			}
			TweenMax.to(this, .4, {scaleX:1, scaleY:1, x:0, y:0, ease:Quad.easeInOut, onComplete:function() {
				TweenMax.to(shareLook, .4, {alpha:1, ease:Quad.easeInOut})
				shareLook.visible = true;
			}});
			
			/*if (getChildByName("video") == null) {
				addChild(video);
			}*/
			
			//_vid.attachCamera(_cam);
			
			//addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		public function transitionOut():void
		{
			this.visible = false;
			//video.attachCamera(null);
			/*if (getChildByName("video") != null) {
				removeChild(video);
			}*/
			//removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
	}
}