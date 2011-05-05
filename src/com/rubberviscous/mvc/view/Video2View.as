package com.rubberviscous.mvc.view
{
	import flash.display.*;
	import com.rubberviscous.mvc.model.*;
	import com.rubberviscous.mvc.controller.*;
	import com.rubberviscous.state.*;
	import flash.events.*;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.*;
	import com.greensock.*;
	import flash.geom.*;
	import com.greensock.easing.*;
	
	public class Video2View extends ComponentView
	{
		private var connection:NetConnection;
		private var ns:NetStream;
		private var videoURL:String;
		private var updatePlayheadTimer:Timer;
		private var videoDuration:Number;
		private var cuePointArray:Array;
		private var xml:XML;
		private var netStreamStatus:String;
		
		public function Video2View(aModel:IModel, aController:IController = null)
		{
			super(aModel, aController);
			this.model = aModel; 
			this.controller = aController;
			addEventListener(Event.ADDED_TO_STAGE, init)
			//init();
		}
		
		override public function update(event:Event = null):void 
		{
			//trace("Video2View : update()");
			if (model.getVideoView() == this.name) {
				this.visible = true;
				if (model.getApplicationState() == model.VIDEOHOTSPOT) {
					videoURL = model.getVideoURL();
					xml = model.getXML();
					ns.play(videoURL);
				} else if (model.getApplicationState() == model.VIDEO) {
					if (model.getVideoStatus() == VideoState.PLAYING) {
						controller.setVideoDuration(videoDuration);
						ns.resume();
						updatePlayheadTimer.start();
					} else if (model.getVideoStatus() == VideoState.PAUSED) {
						ns.pause();
						updatePlayheadTimer.stop();
					} else if (model.getVideoStatus() == VideoState.SEEK) {
						//ns.pause();
						ns.seek(model.getVideoTime());
					} 
					controller.setCuePoints(cuePointArray);
				}
			} else {
				ns.pause();
				updatePlayheadTimer.stop();
				this.visible = false;
			}
		}
		
		public function init(e:Event=null):void
		{
			this.name = "Video2View";
			//trace("VideoView : init()")
			connection = new NetConnection();
			/*connection.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
            connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);*/
            connection.connect(null);

			ns = new NetStream(connection);
			ns.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			
			//var customClient:Object = new Object();
			//customClient.onMetaData = metaDataHandler;
			
            ns.client = this;
            video.attachNetStream(ns);
			video.smoothing = true;

			updatePlayheadTimer = new Timer(30);
			updatePlayheadTimer.addEventListener(TimerEvent.TIMER, updatePlayheadHandler);
			
			cuePointArray = new Array();
            
		}
		
		private function updatePlayheadHandler(e:TimerEvent):void
		{
			controller.setVideoTime(ns.time);
			//trace(ns.time);
			/*if (Math.round(ns.time) == 4) {
				//trace("Cue point reached!")
			}*/
			//trace("updatePlayheadHandler running")
			/*for (var i:uint;i<xml.cuepoint.length();i++) {
				var timeStart:Number = Number(xml.cuepoint[i].@time_start);
				var timeEnd:Number = Number(xml.cuepoint[i].@time_end);
				//var duration:Number = Number(xml.cuepoint[i].@time_end) - Number(xml.cuepoint[i].@time_start);
				//trace(ns.time)
				//trace(duration);
				if (roundDec(ns.time, 1) == timeStart) {
					//trace(xml.cuepoint[i].@action);
					controller.setCuepointLabel(xml.cuepoint[i]);
					controller.setCuepointXY(new Point(Number(xml.cuepoint[i].@x), Number(xml.cuepoint[i].@y)));
					controller.setCuepointName(CuePoint.BEGIN);
					controller.setCuepointAction(xml.cuepoint[i].@action);
					controller.setApplicationState(model.HOTSPOT);
				}
				if (roundDec(ns.time, 1) == timeEnd) {
					controller.setCuepointName(CuePoint.END);
					controller.setApplicationState(model.HOTSPOT);
				}
			}*/
		}
		
		private function roundDec(numIn:Number, decimalPlaces:int):Number {
			var nExp:int = Math.pow(10,decimalPlaces) ; 
			var nRetVal:Number = Math.round(numIn * nExp) / nExp
			//trace(nRetVal);
			return nRetVal;
		}
		
		private function netStatusHandler(event:NetStatusEvent):void {
			trace("VideoView : netStatusHandler = "+event.info.code)
			netStreamStatus = event.info.code;
			switch (event.info.code) {
                case "NetStream.Play.StreamNotFound":
                    //trace("Stream not found: " + videoURL);
                    break;
				case "NetStream.Play.Start":
					//trace("playback has started");
					controller.setVideoStatus(VideoState.PLAYING);
					controller.setApplicationState(model.VIDEO);
					
					break;
				case "NetStream.Play.Stop":
					controller.setVideoStatus(VideoState.STOPPED);
					controller.setApplicationState(model.VIDEO);
					break;
				case "NetStream.Seek.Notify":
					model.setVideoStatus(VideoState.PLAYING);
					model.setApplicationState(model.VIDEO);
					break;
            }
        }

		/*private function metaDataHandler(infoObject:Object):void {
		    //trace("metadata: duration=" + infoObject.duration);
			controller.setVideoDuration(infoObject.duration);
		}*/
		public function onMetaData(info:Object):void { 
			
			trace("Video1View onMetaData fired");
			videoDuration = info.duration;
			controller.setVideoDuration(info.duration);
			
			/*var cuepoints = info.cuePoints;
			var all: String;
			
			for( all in cuepoints )
			{
				//trace( all + ' : ' + cuepoints[ all ].time +'\n')
				cuePointArray.push(cuepoints[ all ].time);
			}
			controller.setCuePoints(cuePointArray);*/
			/*for (var j:uint;j<xml.cuepoint.length();j++) {
				//trace(xml.cuepoint[j].@time_start);
				cuePointArray.push(Number(xml.cuepoint[j].@time_start));
			}
			controller.setCuePoints(cuePointArray);*/
			//trace("controller.setApplicationState(model.METADATARECEIVED);")
			controller.setApplicationState(model.REMOVECUEMARKERS);
        }
		
	/*	public function onCuePoint(info:Object):void {
			//trace("cuepoint: time=" + info.time + " name=" + info.name + " type=" + info.type);
			if (info.name == CuePoint.SEEPRODUCTBEGIN) {
				//trace(info.name);
				controller.setCuepointName(CuePoint.SEEPRODUCTBEGIN);
				controller.setApplicationState(model.HOTSPOT);
			} else if (info.name == CuePoint.SEEPRODUCTEND) {
				controller.setCuepointName(CuePoint.SEEPRODUCTEND);
				controller.setApplicationState(model.HOTSPOT);
			}
		}*/
		
		/*public function onXMPData(infoObject:Object):void 
		{ 
            trace("onXMPData Fired\n"); 
             //trace("raw XMP =\n"); 
             //trace(infoObject.data); 
            var cuePoints:Array = new Array(); 
            var cuePoint:Object; 
            var strFrameRate:String; 
            var nTracksFrameRate:Number; 
            var strTracks:String = ""; 
            var onXMPXML = new XML(infoObject.data); 
            // Set up namespaces to make referencing easier 
            var xmpDM:Namespace = new Namespace("http://ns.adobe.com/xmp/1.0/DynamicMedia/"); 
            var rdf:Namespace = new Namespace("http://www.w3.org/1999/02/22-rdf-syntax-ns#"); 
            for each (var it:XML in onXMPXML..xmpDM::Tracks) 
            { 
                 var strTrackName:String = it.rdf::Bag.rdf::li.rdf::Description.@xmpDM::trackName; 
                 var strFrameRateXML:String = it.rdf::Bag.rdf::li.rdf::Description.@xmpDM::frameRate; 
                 strFrameRate = strFrameRateXML.substr(1,strFrameRateXML.length); 

                 nTracksFrameRate = Number(strFrameRate);  

                 strTracks += it; 
            } 
            var onXMPTracksXML:XML = new XML(strTracks); 
            var strCuepoints:String = ""; 
            for each (var item:XML in onXMPTracksXML..xmpDM::markers) 
            { 
                strCuepoints += item; 
            } 
            trace("XMP cue point = "+strCuepoints); 
        }*/
		
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

/*class CustomClient {
    public function onMetaData(info:Object):void {
        trace("metadata: duration=" + info.duration + " width=" + info.width + " height=" + info.height + " framerate=" + info.framerate);
    }
    public function onCuePoint(info:Object):void {
        //trace("cuepoint: time=" + info.time + " name=" + info.name + " type=" + info.type);
    }
}*/