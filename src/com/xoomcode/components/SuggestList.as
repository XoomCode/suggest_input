package com.xoomcode.components
{	
	import com.xoomcode.events.SuggestListEvent;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import mx.controls.List;
	import mx.controls.TextInput;
	import mx.events.FlexMouseEvent;
	import mx.managers.PopUpManager;
	
	[Event(name="itemSelected", type="SuggestListEvent")]

	public class SuggestList extends List
	{
		private const SAFE_ROW_COUNT:int = 15;
		public var isOpen:Boolean;
		
		public function SuggestList()
		{
			super();
			setStyle('alternatingItemColors', [0xFFFFFF,0xEEEEEE]);
			alpha = 0.6;
			isOpen = false;
		}
		
		public function open(suggestInput:TextInput):void
		{
			if (this.isOpen)
				return
				
			this.isOpen = true
			this.addEventListener(KeyboardEvent.KEY_UP, onListKeyUp);
			this.addEventListener(MouseEvent.MOUSE_UP, onListMouseUp);
			this.addEventListener(FlexMouseEvent.MOUSE_DOWN_OUTSIDE, close);
			
			PopUpManager.addPopUp(this, suggestInput);
			PopUpManager.centerPopUp(this);
			this.move(this.x, suggestInput.y + suggestInput.height);
		}
		
		public function close():void
		{
			if (this.isOpen) {
				PopUpManager.removePopUp(this);
				
				this.removeEventListener(KeyboardEvent.KEY_UP, onListKeyUp);
				this.removeEventListener(MouseEvent.MOUSE_UP, onListMouseUp);
				this.removeEventListener(FlexMouseEvent.MOUSE_DOWN_OUTSIDE, close);
				
				this.isOpen = false;
			}
		}
		
		private function onListKeyUp(event:KeyboardEvent):void
		{	
			if (event.keyCode == Keyboard.ENTER && this.selectedIndex != -1) {
				dispatchItemSelectedEvent();
				//focusManager.setFocus(
				this.close();
				
			} else if (event.keyCode == Keyboard.UP && this.selectedIndex == 0 ||
				event.keyCode == Keyboard.ESCAPE) {
				//focusManager.setFocus(
				this.close();			
			}
			
		}
		
		private function onListMouseUp(event:MouseEvent):void
		{
			if (this.selectedIndex != -1) {
				dispatchItemSelectedEvent();
				//focusManager.setFocus(
				this.close();
			}
		}
		
		private function dispatchItemSelectedEvent():void
		{
			var suggestEvent:SuggestListEvent = new SuggestListEvent(SuggestListEvent.ITEM_SELECTED);
			suggestEvent.selectedItem = this.selectedItem;
			dispatchEvent(suggestEvent);
		}
		
		private function getMatchFieldLabel(matchField:String):String 
		{
			if (matchField == "address") {
				return "Dirección";
			} else if (matchField == "description") {
				return "Descripción";
			} else {
				return "Reporte";
			}
		}
		
		override protected function drawRowBackground(s:Sprite, rowIndex:int, y:Number, height:Number, color:uint, dataIndex:int):void
		{
			if (dataProvider != null) {
				var item:Object;
				
				if (dataIndex < dataProvider.length) {
					item = dataProvider[dataIndex];
				}
				
				if (item) {
					color = colorFunction(item, rowIndex, dataIndex, color);
				}
			}
			
			super.drawRowBackground(s, rowIndex, y, height, color, dataIndex);
		}
		
		override public function set dataProvider(value:Object):void
		{
			if (value) {
				if (value is Array) {
					var count:int = (value as Array).length;
					if (count > SAFE_ROW_COUNT) {
						count = SAFE_ROW_COUNT;
					}
					rowCount = count;
				}
			}
			
			super.dataProvider = value;
		}
		
		/**
		 * Colorize keywordList rows based on filter type
		 */ 
		private function colorFunction(item:Object, rowIndex:int, dataIndex:int, color:uint):uint
		{
			if (item.match_field == "description") {
				return 0xE8FFE6;
			} else if (item.match_field == "address") {
				return 0xE6EEFF;
			} else {
				return color;
			}
		}
	}
}
