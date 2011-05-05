package com.rubberviscous.mvc.view
{
	import flash.display.*;
	import com.rubberviscous.mvc.model.*;
	import com.rubberviscous.mvc.controller.*;
	import com.rubberviscous.state.*;
	import flash.events.*;
	import flash.text.*;
	import com.greensock.*;
	import com.greensock.easing.*;

	
	public class BorderView extends ComponentView
	{
		private var hotSpot:MovieClip;
		private var label:TextField;
		private var fontOptimaBold:Font;
		private var cuepointAction:String;
		
		public function BorderView(aModel:IModel, aController:IController = null)
		{
			super(aModel, aController);
			this.model = aModel; 
			this.controller = aController;
			init();
		}
		
		override public function update(event:Event = null):void 
		{	
			
		}
		
		public function init(e:Event=null):void
		{
			this.visible = true
		}
	}
}