package com.xoomcode.components
{
	import com.xoomcode.components.SuggestList;
	import com.xoomcode.events.SuggestInputEvent;
	
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	
	import mx.controls.Alert;
	import mx.controls.TextInput;
	import mx.events.FlexEvent;
	import mx.events.FlexMouseEvent;
	import mx.managers.PopUpManager;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	[Event(name="searchChange", type="SuggestInputEvent")]
	
	public class SuggestInputCB extends TextInput
	{
		private var _suggestList:SuggestList;
		private var _view:SuggestInput = null;
		private var _timer:Timer;
		private var _cancel:Boolean = false;
		
		public var service:HTTPService;
		public var params:Object;
		
		[Bindable]
		public var minChars:int = 3;		
		[Bindable]
		public var searchDelay:int = 500;
		[Bindable]
		public var listAlpha:Number = 0.6;
		[Bindable]
		public var listColors:Array = [0xFFFFFF, 0xEEEEEE];
		
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
			
			this.addEventListener(KeyboardEvent.KEY_UP, onTextKeyUp, false, -100, true);
			
			_timer = new Timer(searchDelay, 1);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
			
			_suggestList = new SuggestList(this);
			_suggestList.alpha = this.listAlpha;
			_suggestList.setStyle('alternatingItemColors', this.listColors);
			
			_suggestList.addEventListener(SuggestInputEvent.LIST_CLOSE, onSuggestListClose);
			_suggestList.addEventListener(SuggestInputEvent.SEARCH_CHANGE, onSuggesListSearchChange);
		}
		
		private function onTextKeyUp(event:KeyboardEvent):void {
			
			if (event.keyCode == Keyboard.DOWN) { 
				if(_suggestList.isOpen)
					focusManager.setFocus(_suggestList);
				
			} else if (event.keyCode == Keyboard.ESCAPE) {
				_suggestList.close();
				
			} else if (event.keyCode == Keyboard.ENTER) {
				if (this.text.length >= 1) {
					dispatchSearchChangeEvent();
					_suggestList.close();
				}
				
			} else if (event.charCode != 0) {
				if (_timer.running) {
					_timer.stop();
				}
				_timer.start();
			}
		}
		
		private function onTimerComplete(e:TimerEvent):void
		{
			if(!_cancel && this.text != null && this.text.length >= minChars) {
				params.value = this.text;
				service.addEventListener(ResultEvent.RESULT, onSuggestResult);
				service.send(params);
			} else {
				_suggestList.close();
			}
			
			_cancel = false;
		}
		
		private function onSuggestResult(event:ResultEvent):void
		{
			var result:XMLList = XML(event.result).children();
			_suggestList.dataProvider = result;
			if(result.length() > 0) {
				_suggestList.open();	
			} else {
				_suggestList.close();
			}
		}
		
		private function onSuggestListClose(e:SuggestInputEvent):void
		{
			focusManager.setFocus(this);
		}
		
		private function onSuggesListSearchChange(e:SuggestInputEvent):void
		{
			dispatchSearchChangeEvent(e);
		}
		
		private function dispatchSearchChangeEvent(e:SuggestInputEvent = null):void
		{
			_cancel = true;
			
			var suggestEvent:SuggestInputEvent = new SuggestInputEvent(SuggestInputEvent.SEARCH_CHANGE);
			if (e)
				suggestEvent.selectedItem = e.selectedItem;
			
			suggestEvent.text = this.text;
			dispatchEvent(suggestEvent);
		}
	
	}
}