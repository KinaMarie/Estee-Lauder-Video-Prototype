package {
	import flash.display.Sprite;
	import com.rubberviscous.mvc.model.*;
	import com.rubberviscous.mvc.view.*;
	import com.rubberviscous.mvc.controller.*;
	import flash.events.Event;
	
	public class Main extends Sprite
	{
		public var model:IModel;
		
		public function Main()
		{
			init();
		}
		
		public function init():void
		{
			 initializeMVC();
		}
		
		public function initializeMVC():void
		{
			model = new Model();
			
			// the controllers
			var navController:NavController = new NavController(model);
			
			// the views
			var shareView:ComponentView = new ShareView(model, navController);
			addChild(shareView);
			
			var commentView:ComponentView = new CommentView(model, navController);
			addChild(commentView);
			
			var shareTheLookView:ComponentView = new ShareTheLookView(model, navController);
			addChild(shareTheLookView);

			
			var playlistView:ComponentView = new PlaylistView(model, navController);
			addChild(playlistView);
			
			var mirrorView:ComponentView = new MirrorView(model, navController);
			addChild(mirrorView);
			
			var videoControllerView:CompositeView = new VideoControllerView(model, navController);
			addChild(videoControllerView);
			
			var video2View:ComponentView = new Video2View(model, navController);
			videoControllerView.addChild(video2View);
			videoControllerView.add(video2View);
			
			var video1View:ComponentView = new Video1View(model, navController);
			videoControllerView.addChild(video1View);
			videoControllerView.add(video1View);
			
			var tabView:ComponentView = new TabControllerView(model, navController);
			addChild(tabView);
			
			var hotSpotView:ComponentView = new HotSpotView(model, navController);
			videoControllerView.addChild(hotSpotView);
			videoControllerView.add(hotSpotView);
			
			var infoWindowView:ComponentView = new InfoWindowView(model, navController);
			addChild(infoWindowView);
			
			var productWindowView:ComponentView = new ProductWindowView(model, navController);
			addChild(productWindowView);
			
			var videoControlsView:ComponentView = new VideoControlsView(model, navController);
			addChild(videoControlsView);
			
			var borderView:ComponentView = new BorderView(model, navController);
			addChild(borderView);
			
			model.addEventListener(Event.CHANGE, shareView.update);
			model.addEventListener(Event.CHANGE, tabView.update);
			model.addEventListener(Event.CHANGE, commentView.update);
			model.addEventListener(Event.CHANGE, shareTheLookView.update);
			model.addEventListener(Event.CHANGE, playlistView.update);
			model.addEventListener(Event.CHANGE, mirrorView.update);
			model.addEventListener(Event.CHANGE, infoWindowView.update);
			model.addEventListener(Event.CHANGE, productWindowView.update);
			model.addEventListener(Event.CHANGE, videoControllerView.update);
			//model.addEventListener(Event.CHANGE, video1View.update);
			//model.addEventListener(Event.CHANGE, hotSpotView.update);
			model.addEventListener(Event.CHANGE, videoControlsView.update);
			model.addEventListener(Event.CHANGE, borderView.update);
			//model.addEventListener(Event.CHANGE, hotSpotView.update);
			
		}
	}
}