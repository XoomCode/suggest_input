package com.xoomcode.events
{
	import flash.events.Event;
	
	public class SuggestInputEvent extends Event
	{
		public static const SEARCH_CHANGE:String = "searchChange";
		public static const LIST_CLOSE:String = "listClose";
		
		public var selectedItem:Object;
		public var text:String;
		
		public function SuggestInputEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}

}
