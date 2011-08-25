package com.xoomcode.components
{
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	import mx.utils.StringUtil;
	
	public class SearchService
	{
		private var _httpService:HTTPService;
		private var _callback:Function;
		
		public function SearchService()
		{
			_httpService = new HTTPService();
			_httpService.showBusyCursor = false;
			_httpService.addEventListener(ResultEvent.RESULT, onResult, false, 0, true);
			_httpService.concurrency = "last";
		}
		
		public function suggest(text:String, callback:Function):void
		{
			var params:Object = new Object();
			params.
			
			_callback = callback;
			_httpService.resultFormat = HTTPService.RESULT_FORMAT_E4X;
			_httpService.url = "/transactions/suggest/" + StringUtil.trim(text);
			_httpService.send();
		}
		
		private function onResult(event:ResultEvent):void
		{
			event.result
			_callback(event.result);
		}
	}
}