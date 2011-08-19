package com.xoomcode.events
{
	import flash.events.Event;
	import flash.xml.XMLNode;
	
	public class SuggestListEvent extends Event
	{
		public static const ITEM_SELECTED:String = "itemSelected";
		
		public var selectedItem:Object;
		
		public function SuggestListEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}

}