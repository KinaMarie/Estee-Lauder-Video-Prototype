package com.rubberviscous.rating 
{
	import flash.display.*;
	import flash.events.MouseEvent;
	
	public class FiveStarRating extends Sprite
	{
		public function FiveStarRating()
		{
			/*for (var i:Number = 1; i <= 5; i++) {
				var clip = getChildByName("star"+i);
				clip.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
				clip.index = i;
			}*/
			
			for (var i:uint=0;i<this.numChildren;i++) {
				var clip:MovieClip = MovieClip(this.getChildAt(i));
				//trace(clip);
			//	clip.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
				clip.buttonMode = true;
			}
		}
		
		private function rollOverHandler(e:MouseEvent):void
		{
			//trace(this.getChildIndex(DisplayObject(e.target)))
			var clip:DisplayObject;
			for (var j:uint = 0; j < this.numChildren; j++) {
				if (j > this.getChildIndex(DisplayObject(e.target))) {
					clip = this.getChildAt(j);
					clip.alpha = .25;
				} else {
					clip = this.getChildAt(j);
					clip.alpha = 1;
				}
			}
		}
	}
}