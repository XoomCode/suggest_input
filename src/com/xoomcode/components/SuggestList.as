package com.xoomcode.components
{	
	import com.xoomcode.events.SuggestInputEvent;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	
	import mx.controls.Alert;
	import mx.controls.List;
	import mx.controls.TextInput;
	import mx.events.FlexMouseEvent;
	import mx.events.ListEvent;
	import mx.managers.PopUpManager;
	
	[Event(name="listClose", type="SuggestInputEvent")]
	[Event(name="searchChange", type="SuggestInputEvent")]
	
	public class SuggestList extends List
	{
		private var _suggestInput:TextInput;
		
		public var isOpen:Boolean;
		
		public function SuggestList(suggestInput:TextInput)
		{
			super();
			
			isOpen = false;
			doubleClickEnabled = true;
			
			_suggestInput = suggestInput;
			this.width = _suggestInput.width;
		}
		
		public function open():void
		{
			if (this.isOpen)
				return
				
			this.isOpen = true
			this.addEventListener(KeyboardEvent.KEY_UP, onListKeyUp);
			this.addEventListener(ListEvent.ITEM_DOUBLE_CLICK, onItemDoubleClick);
			this.addEventListener(FlexMouseEvent.MOUSE_DOWN_OUTSIDE, onListMouseDownOutside);
			
			var position:Point = _suggestInput.localToGlobal(new Point(_suggestInput.x, _suggestInput.y + _suggestInput.height + 3));
			PopUpManager.addPopUp(this, _suggestInput);
			PopUpManager.centerPopUp(this);
			this.move(position.x, position.y);
		}
		
		public function close():void
		{
			if (this.isOpen) {
				PopUpManager.removePopUp(this);
				
				this.removeEventListener(KeyboardEvent.KEY_UP, onListKeyUp);
				this.removeEventListener(ListEvent.ITEM_DOUBLE_CLICK, onItemDoubleClick);
				this.removeEventListener(FlexMouseEvent.MOUSE_DOWN_OUTSIDE, onListMouseDownOutside);
				
				this.isOpen = false;
				
				dispatchEvent(new SuggestInputEvent(SuggestInputEvent.LIST_CLOSE));
			}
		}
		
		private function onListKeyUp(event:KeyboardEvent):void
		{	
			if (event.keyCode == Keyboard.ENTER && this.selectedIndex != -1) {
				dispatchChangeEvent();			
			} else if ((event.keyCode == Keyboard.UP && this.selectedIndex == 0) ||
				event.keyCode == Keyboard.ESCAPE) {
				this.close();			
			}
			
		}
		
		private function onItemDoubleClick(event:ListEvent):void
		{
			if (this.selectedIndex != -1)
				dispatchChangeEvent();
		}
		
		private function onListMouseDownOutside(e:FlexMouseEvent):void
		{
			this.close();
		}
		
		private function dispatchChangeEvent():void
		{
			_suggestInput.text = selectedItem.value.toString();
			
			var event:SuggestInputEvent = new SuggestInputEvent(SuggestInputEvent.SEARCH_CHANGE, true);
			event.selectedItem = this.selectedItem;
			dispatchEvent(event);
			
			this.close();
		}
		
	}
}
