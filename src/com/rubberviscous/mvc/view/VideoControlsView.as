package com.rubberviscous.mvc.view
{
	import flash.display.*;
	import com.rubberviscous.mvc.model.*;
	import com.rubberviscous.mvc.controller.*;
	import com.rubberviscous.state.*;
	import flash.events.*;
	import flash.utils.*;
	import flash.text.*;
	import flash.geom.*;
	import com.greensock.*;
	import com.greensock.easing.*;
	import com.abrahamyan.liquid.ToolTip;
	
	public class VideoControlsView extends ComponentView
	{
		private var videoDuration:Number;
		private var updatePlayheadTimer:Timer;
		private var videoTime:Number;
		private var scrubber:MovieClip;
		private var bar:MovieClip;
		private var tooltip:ToolTip;
		private var toolTipTimer:Timer;
		private var cuePointArray:Array;
		private var xml:XML;
		private var label:TextField;
		private var fontOptimaBold:Font;
		
		public function VideoControlsView(aModel:IModel, aController:IController = null)
		{
			super(aModel, aController);
			this.model = aModel; 
			this.controller = aController;
			addEventListener(Event.ADDED_TO_STAGE, init)
		}
		
		override public function update(event:Event = null):void 
		{
			trace("VideoControlsView : update()")
			trace(model.getApplicationState())
			if (model.getApplicationState() == model.XMLCOMPLETE) {
				xml = model.getXML();
			} else if (model.getApplicationState() == model.REMOVECUEMARKERS) {
				//removeCuePointMarkers();
			} else if (model.getApplicationState() == model.METADATARECEIVED) {
				trace("VideoControlsView : Applictation State = "+model.METADATARECEIVED);
				
				cuePointArray = new Array();
				for (var j:uint;j<xml.cuepoint.length();j++) {
					//trace(xml.cuepoint[j].@time_start);
					cuePointArray.push({startTime:Number(xml.cuepoint[j].@time_start), endTime:Number(xml.cuepoint[j].@time_end)});
				}
				
				createCuePointMarkers();
				setVideoLabel(xml.@name)
			} else if (model.getApplicationState() == model.VIDEO) {
				if (model.getVideoStatus() == VideoState.PLAYING) {
				
					mcPause.visible = true;
					mcPlay.visible = false;
					updatePlayheadTimer.start();
					//createCuePointMarkers();
				
				} else if (model.getVideoStatus() == VideoState.STOPPED) {
					mcPause.visible = false;
					mcPlay.visible = true;
					updatePlayheadTimer.stop();
				} else if (model.getVideoStatus() == VideoState.PAUSED) {
				
					//trace("VideoControlsView : VideoState.PAUSED")
					mcPause.visible = false;
					mcPlay.visible = true;
					updatePlayheadTimer.stop();
				} 
			} else if (model.getApplicationState() == model.MIRROR) {
				//TweenMax.to(mcMirror, .5, {delay:.5, y:mcMirror.height, ease:Quad.easeInOut})
			} else if (model.getApplicationState() == model.VIDEOFULL) {
				//TweenMax.to(mcMirror, .5, {delay:.5, y:0, ease:Quad.easeInOut})
			} else if (model.getApplicationState() == model.COMMENT) {
				//TweenMax.to(mcMirror, .5, {delay:.5, y:0, ease:Quad.easeInOut})
			} else if (model.getApplicationState() == model.SHARE) {
				//TweenMax.to(mcMirror, .5, {delay:.5, y:0, ease:Quad.easeInOut})
			} else if (model.getApplicationState() == model.PLAYLIST) {
				//TweenMax.to(mcMirror, .5, {delay:.5, y:0, ease:Quad.easeInOut})
			}
		}
		
		public function init(e:Event=null):void
		{
			this.y = 361.5//stage.stageHeight-this.height;
			trace("control view = "+this.y)
			mcPause.addEventListener(MouseEvent.MOUSE_DOWN, pauseHandler);
			mcPause.buttonMode = true;
			mcPause.visible = false;
			mcPlay.addEventListener(MouseEvent.MOUSE_DOWN, playHandler);
			mcPlay.buttonMode = true;
			
			updatePlayheadTimer = new Timer(30);
			updatePlayheadTimer.addEventListener(TimerEvent.TIMER, updatePlayheadHandler);
			
			toolTipTimer = new Timer(30);
			toolTipTimer.addEventListener(TimerEvent.TIMER, toolTipTimerHandler);
			
			scrubber = mcSeekBar.mcScrubber;
			scrubber.mouseChildren = false;
			scrubber.addEventListener(MouseEvent.MOUSE_DOWN, startDragHandler);
			scrubber.addEventListener(MouseEvent.MOUSE_UP, stopDragHandler);
			scrubber.addEventListener(MouseEvent.MOUSE_OVER, onOver, false, 0, true);
			scrubber.addEventListener(MouseEvent.MOUSE_OUT, onOut, false, 0, true);
			
			scrubber.buttonMode = true;
			bar = mcSeekBar.mcBar;
			
			mcShare.addEventListener(MouseEvent.CLICK, shareHandler);
			mcShare.buttonMode = true;
			
			mcComment.addEventListener(MouseEvent.CLICK, commentHandler);
			mcComment.buttonMode = true;
			
			mcMirror.addEventListener(MouseEvent.CLICK, mirrorHandler);
			mcMirror.buttonMode = true;
			
			mcPlaylist.addEventListener(MouseEvent.CLICK, playlistHandler);
			mcPlaylist.buttonMode = true;
			
			bar.addEventListener(MouseEvent.CLICK, barSeekHandler);
			
			tooltip=ToolTip.getInstance();
			addChild(tooltip);
			
			mcShare.addEventListener(MouseEvent.MOUSE_OVER,onOver,false,0,true);
			mcComment.addEventListener(MouseEvent.MOUSE_OVER,onOver,false,0,true);
			mcPlaylist.addEventListener(MouseEvent.MOUSE_OVER,onOver,false,0,true);
			mcMirror.addEventListener(MouseEvent.MOUSE_OVER,onOver,false,0,true);
			
			mcShare.mouseChildren = false;
			mcComment.mouseChildren = false;
			mcPlaylist.mouseChildren = false;
			
			
			mcShare.addEventListener(MouseEvent.MOUSE_OUT,onOut,false,0,true);
			mcComment.addEventListener(MouseEvent.MOUSE_OUT,onOut,false,0,true);
			mcPlaylist.addEventListener(MouseEvent.MOUSE_OUT,onOut,false,0,true);
			mcMirror.addEventListener(MouseEvent.MOUSE_OUT,onOut,false,0,true);
			
			fontOptimaBold = new OptimaBold();
			
			label = new TextField();
			label.autoSize = TextFieldAutoSize.LEFT;
			label.embedFonts = true;
			label.selectable = false;
			label.multiline = true;
			label.antiAliasType = AntiAliasType.ADVANCED;

            var format:TextFormat = new TextFormat();
            format.font = fontOptimaBold.fontName;
            format.color = 0xFFFFFF;
            format.size = 10;
            
			addChild(label);
			
			label.x = 28;
			label.y = 24;

            label.defaultTextFormat = format;

			/*mcMirror.y = mcMirror.height;
			TweenMax.to(mcMirror, .5, {delay:1, y:0, ease:Quad.easeInOut})*/
			
			mcMirror.addEventListener(MouseEvent.MOUSE_OVER, mirrorHandler);
			mcMirror.mouseChildren = false;
		}
		
		private function mirrorHandler(e:MouseEvent):void
		{
			switch (e.type) {
				case MouseEvent.MOUSE_OVER:
					e.target.gotoAndPlay(2);
					break;
				case MouseEvent.CLICK:
					controller.setApplicationState(model.MIRROR);
					break;
			}
		}
		
		private function setVideoLabel(aLabel:String):void
		{
			label.text = aLabel.toUpperCase();//xml.@name;
			mcRating.alpha = 1;
			mcRating.x = label.x+label.textWidth+10;
		}
		
		private function onOver(e:MouseEvent):void
		{
			trace(e.target.name)
			switch(e.target.name)
			{
				case "mcShare":
					//mcShare.mc_rollOverState.alpha = 0.5;
				
					tooltip.followMouse=true;
					
					//tooltip.labelColor=0xff0000;
					tooltip.multiLine=false;
					//tooltip.arrowMargin=50;
					tooltip.show("Share");
					
					//trace("mcShare showing tooltip")
					break;
				case "mcComment":
					//mcComment.mc_rollOverState.alpha = 0.5;
				
					tooltip.followMouse=true;
					tooltip.multiLine=false;
					//tooltip.labelColor=0x555555;
					tooltip.show("Comment");
					
					break;
				case "mcPlaylist":
					//mcPlaylist.mc_rollOverState.alpha = 0.5;
				
					tooltip.followMouse=true;
					tooltip.multiLine=false;
					//tooltip.arrowMargin=10;
					tooltip.show("Playlist");
					break;
				case "mcMirror":
					tooltip.followMouse=true;
					tooltip.multiLine=false;
					tooltip.show("Mirror");
					break;
				case "mcScrubber":
					tooltip.followMouse=true;
					tooltip.multiLine=false;
					tooltip.show(convertTime(videoTime));
					toolTipTimer.start();
					break;
			}
		}
		
		function onOut(e:MouseEvent):void
		{
			tooltip.hide();
			toolTipTimer.stop();
			/*mcPlaylist.mc_rollOverState.alpha = 0;
			mcShare.mc_rollOverState.alpha = 0;
			mcComment.mc_rollOverState.alpha = 0;*/
			

		}
		
		private function barSeekHandler(e:MouseEvent):void
		{
			var per:Number = e.target.mouseX/bar.width;
			trace("mouseX = "+e.target.mouseX);
			trace("bar.width = "+bar.width)
			controller.setVideoTime(per*videoDuration);
			controller.setVideoStatus(VideoState.SEEK);
			controller.setApplicationState(model.VIDEO);
		}
		
		private function startDragHandler(e:MouseEvent):void
		{
			var rect:Rectangle = new Rectangle(0, 0, bar.width, 0);
			scrubber.startDrag(true, rect)
			updatePlayheadTimer.stop();
			toolTipTimer.start();
			//stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
		}
		
		private function shareHandler(e:MouseEvent):void
		{
			controller.setApplicationState(model.SHARE);
		}
		
		private function commentHandler(e:MouseEvent):void
		{
			controller.setApplicationState(model.COMMENT);
		}
		
		/*private function mirrorHandler(e:MouseEvent):void
		{
			controller.setApplicationState(model.MIRROR);
		}*/
		
		private function playlistHandler(e:MouseEvent):void
		{
			controller.setApplicationState(model.PLAYLIST);
		}
		
		private function stopDragHandler(e:MouseEvent):void
		{
			scrubber.stopDrag();
			//stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			//controller.setVideoStatus(VideoState.PLAYING);
			var per:Number = scrubber.x/bar.width;
			controller.setVideoTime(per*videoDuration);
			controller.setVideoStatus(VideoState.SEEK);
			controller.setApplicationState(model.VIDEO);
			updatePlayheadTimer.start();
			toolTipTimer.stop();
		}
		
		/*private function mouseMoveHandler(e:MouseEvent):void
		{
			var per:Number = scrubber.x/bar.width;
			controller.setVideoTime(per*videoDuration);
			controller.setVideoStatus(VideoState.SEEK);
		}*/
		
		private function updatePlayheadHandler(e:TimerEvent):void
		{
			
			videoTime = model.getVideoTime();
			//trace(videoTime);
			//playerTime();
			//trace("VideoControlsView : videoTime = "+videoTime)
			videoDuration = model.getVideoDuration();
			time_txt.text = convertTime(videoTime)+" / "+convertTime(videoDuration);
			//trace(videoTime);
			var per:Number = videoTime/videoDuration;
			//trace(per);
			scrubber.x = per*bar.width
			mcSeekBar.mcBar_progress.width = scrubber.x;
		}
		
		private function toolTipTimerHandler(e:TimerEvent):void
		{
			var per:Number = scrubber.x/bar.width;
			var newTime = per*videoDuration;
			//videoTime = model.getVideoTime();
			tooltip.setLabel(convertTime(newTime));
			//trace(convertTime(newTime));
		}
		
		public static function roundDecimal(num:Number, precision:int):Number{

			var decimal:Number = Math.pow(10, precision);

			return Math.round(decimal* num) / decimal;

		}
		
		private function convertTime(aSeconds:Number):String
		{
			var ratio:Number = aSeconds/60;
			var secs:Number;
			var mins:Number;
			if (ratio<1) {
				secs = Math.round(ratio*60);
				if (secs<10) {
					//trace("time = 0:0"+secs);
					return "0:0"+secs;
				} else {
					//trace("time = 0:"+secs);
					return "0:"+secs;
				}
			} else {
				mins = Math.floor(ratio);
				secs = Math.round((ratio-mins)*60);
				if (secs<10) {
					//trace("time = "+mins+":0"+secs);
					return mins+":0"+secs;
				} else {
					//trace("time = "+mins+":"+secs);
					return mins+":"+secs;
				}
				//trace("time = "+mins+":"+secs);
				
			}
		}
		
		private function pauseHandler(e:MouseEvent):void
		{
			controller.setVideoStatus(VideoState.PAUSED);
			controller.setApplicationState(model.VIDEO);
		}
		
	/*	public function pauseHandler(e:MouseEvent):void
		{
			controller.setVideoStatus(VideoState.PAUSED);
			controller.setApplicationState(model.VIDEO);
		}*/
		
		private function playHandler(e:MouseEvent):void
		{
			controller.setVideoStatus(VideoState.PLAYING);
			controller.setApplicationState(model.VIDEO);
		}
		
		private function createCuePointMarkers():void
		{
			//cuePointArray = model.getCuePoints();
			//trace("createCuePointMarkers()")
			//cuePointArray = new Array();
			//trace("XML ======= "+xml)

			trace("cuePointArray = "+cuePointArray)
			var marker:MovieClip;
			// remove existing markers if ones exist
			//trace("REMOVING MARKERS = "+mcSeekBar.mcCuePointHolder.numChildren)
			for (var k:uint=0;k<mcSeekBar.mcCuePointHolder.numChildren;k++) {
				marker = mcSeekBar.mcCuePointHolder.getChildAt(k);
				mcSeekBar.mcCuePointHolder.removeChild(marker);
				//trace(marker);
			}
			
			for (var i:uint=0;i<cuePointArray.length;i++) {
				marker = new CuePointMarker();
				mcSeekBar.mcCuePointHolder.addChild(marker);
				videoDuration = model.getVideoDuration();
				var positionStart:Number = (cuePointArray[i].startTime/videoDuration)*bar.width;
				var positionEnd:Number = (cuePointArray[i].endTime/videoDuration)*bar.width;
				//trace("CuePointMarker x = "+typeof(cuePointArray[i]));
				marker.x = positionStart;
				marker.y = -marker.height
				marker.width = positionEnd-positionStart;
				marker.name = "marker"+i;
				trace(marker.name)
				marker.addEventListener(MouseEvent.MOUSE_OVER, markerHandler, false, 0, true);
				marker.addEventListener(MouseEvent.MOUSE_OUT, markerHandler, false, 0, true);
				marker.addEventListener(MouseEvent.CLICK, markerHandler);
				marker.buttonMode = true;
				marker.mouseChildren = false;
			}
		}
		
		private function removeCuePointMarkers():void
		{
			var marker:MovieClip;
			// remove existing markers if ones exist
			//trace("REMOVING MARKERS = "+mcSeekBar.mcCuePointHolder.numChildren)
			for (var k:uint=0;k<mcSeekBar.mcCuePointHolder.numChildren;k++) {
				marker = mcSeekBar.mcCuePointHolder.getChildAt(k);
				mcSeekBar.mcCuePointHolder.removeChild(marker);
				//trace(marker);
			}
		}
		
		private function markerHandler(e:MouseEvent):void
		{
			
			//tooltip.labelMargin = 2;
			//tooltip.show(xml.cuepoint[0]);
			switch (e.type) {
				case MouseEvent.MOUSE_OVER:
					for (var i:uint=0;i<cuePointArray.length;i++) {
						//var marker:String = MovieClip(mcSeekBar.mcCuePointHolder.getChildByName("marker"+i));
						trace(e.target.name)
						if (e.target.name == "marker"+i) {
							tooltip.followMouse=true;
							tooltip.fixedWidth = 250;
							tooltip.multiLine=true;
							tooltip.show(xml.cuepoint[i].@tooltip);
						}
					}
					break;
				case MouseEvent.MOUSE_OUT:
					tooltip.hide();
					break;
				case MouseEvent.CLICK:
					var per:Number = e.target.x/bar.width;
					/*trace("mouseX = "+e.target.mouseX);
					trace("bar.width = "+bar.width)*/
					controller.setVideoTime(per*videoDuration);
					controller.setVideoStatus(VideoState.SEEK);
					controller.setApplicationState(model.VIDEO);
					break;
			}
			
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