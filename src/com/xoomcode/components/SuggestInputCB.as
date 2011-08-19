package com.xoomcode.components
{
	import com.xoomcode.components.SuggestList;
	import com.xoomcode.events.SuggestListEvent;
	
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	
	import mx.controls.TextInput;
	import mx.events.FlexEvent;
	import mx.events.FlexMouseEvent;
	import mx.managers.PopUpManager;
	
	public class SuggestInputCB extends TextInput
	{
		private const MIN_CHARS:int = 3;
		private const SEARCH_DELAY:int = 200;
		
		private var _suggestList:SuggestList;
		private var _view:SuggestInput = null;
		private var _timer:Timer;		
		private var _searchService:SearchService;
		
		public function SuggestInputCB()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, setup, false, 0, true);
		}
		
		public function get labelField():String {
			return _suggestList.labelField;
		}
		
		public function set labelField(value:String):void {
			_suggestList.labelField = value;
		}
		
		public function get labelFunction():Function {
			return _suggestList.labelFunction;
		}
		
		public function set labelFunction(value:Function):void {
			_suggestList.labelFunction = value;
		}
		
		protected function setup(e:FlexEvent):void
		{
			_view = new SuggestInput();
			_searchService = new SearchService();
			
			this.addEventListener(KeyboardEvent.KEY_UP, onTextKeyUp, false, -100, true);
			
			_timer = new Timer(SEARCH_DELAY, 1);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
			
			_suggestList = new SuggestList();
			_suggestList.width = this.width;
			_suggestList.addEventListener(SuggestListEvent.ITEM_SELECTED, onItemSelected);
		}
		
		private function onTextKeyUp(event:KeyboardEvent):void {
			
			if (event.keyCode == Keyboard.DOWN) { 
				if(_suggestList.isOpen)
					focusManager.setFocus(_suggestList);
				
			} else if (event.keyCode == Keyboard.ESCAPE) {
				_suggestList.close();
				focusManager.setFocus(this);
				
			} else if (event.keyCode == Keyboard.ENTER) {
				if (this.text.length >= MIN_CHARS)
					_searchService.lucky_search(this.text, onSearchCallback);
				
			} else if (event.charCode != 0) {
				if (_timer.running) {
					_timer.stop();
				}
				_timer.start();
			}
		}
		
		private function onTimerComplete(e:TimerEvent):void
		{
			if(this.text != null && this.text.length >= MIN_CHARS){
				_searchService.suggest(this.text, onSuggestCallback);
			}
		}
		
		
		private function onSuggestCallback():void
		{
			
		}
		
		private function onItemSelected():void
		{
				
		}
		
		private function onSearchCallback():void
		{
			
		}
	}
}