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
			_callback = callback;
			_httpService.resultFormat = HTTPService.RESULT_FORMAT_E4X;
			_httpService.url = "/locations/instant/" + StringUtil.trim(text);
			_httpService.send();
		}
		
		public function search(type:String, id:Number, callback:Function):void
		{
			_callback = callback;
			_httpService.resultFormat = HTTPService.RESULT_FORMAT_TEXT;
			_httpService.url = "/locations/search/" + type + "/" + id.toString();
			_httpService.send();
		}
		
		public function lucky_search(address:String, callback:Function):void
		{
			_callback = callback;
			_httpService.resultFormat = HTTPService.RESULT_FORMAT_TEXT;
			_httpService.url = "/locations/lucky/" + address;
			_httpService.send();
		}
		
		private function onResult(event:ResultEvent):void
		{
			event.result
			_callback(event.result);
		}
	}
}