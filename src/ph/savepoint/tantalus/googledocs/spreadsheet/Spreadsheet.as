package ph.savepoint.tantalus.googledocs.spreadsheet
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.XMLLoader;
	
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import org.osflash.signals.Signal;
	
	import ph.savepoint.tantalus.Console;

	public class Spreadsheet
	{
		public static const FEED_TYPE_LIST:String = "list";
		public static const FEED_TYPE_CELLS:String = "cells";
		
		private static const REQUEST_TYPE_WORSHEET_CELLS:uint = 0;
		private static const REQUEST_TYPE_WORKSHEET_LIST:uint = 1;
		
		//https://spreadsheets.google.com/feeds/cells/0ApDFy_CfEYOPdDRLMDI3VHRzWlhEV1I4YTIzMEdKQ0E/od6/public/basic
		private static const URL:String = "https://spreadsheets.google.com/feeds/";
		private static const PROXY_URL:String = "http://project12.savepoint.ph/games/enclosure/GoogleSpreadsheetProxy.php";
		
		
		private static var _xmlLoader:XMLLoader;
		private static var _feedType:String = FEED_TYPE_CELLS;
		private static var _requestType:uint = REQUEST_TYPE_WORSHEET_CELLS;
		private static var _spreadsheetKey:String;
		private static var _worksheetID:String;
		
		private static var _xmlData:XML;
		
		//! Signals
		private static var _signalWorksheetListRequestComplete:Signal;
		private static var _signalWorksheetCellsRequestComplete:Signal;
		
		
		public static function init(p_spreadsheetKey:String = ""):void
		{
			_signalWorksheetListRequestComplete = new Signal();
			_signalWorksheetCellsRequestComplete = new Signal();
			
			_spreadsheetKey = p_spreadsheetKey;
		}
		
		/**
		 * Requests an RSS feed of the Spreadsheet containing the list of worksheets.
		 * The signal returns an array of worksheetIDs contained inside the spreadsheet. 
		 */		
		public static function requestFeedWorksheetList():void
		{
			_requestType = REQUEST_TYPE_WORKSHEET_LIST;
			
			//GET https://spreadsheets.google.com/feeds/worksheets/key/private/full
			var _url:String = URL +  "worksheets/" + _spreadsheetKey + "/public/basic?alt=rss";
			
			
			var variables:URLVariables = new URLVariables();
			variables["_url"] = _url;

			//call the proxy page passing all the variables above
			var request:URLRequest = new URLRequest( PROXY_URL );
			request.data = variables;
			request.method = URLRequestMethod.POST;
			
			
			//_xmlLoader = new XMLLoader(_url, {name:"SpreadsheetDataXML", onError:onProcessError, onComplete:onRequestComplete, autoDispose:true});
			_xmlLoader = new XMLLoader(request, {name:"SpreadsheetDataXML", onError:onProcessError, onComplete:onRequestComplete, autoDispose:true});
			_xmlLoader.load(true);
		}
		
		private static function onProcessError(p_event:LoaderEvent):void
		{
			Console.log("error occured: " + p_event.text);
		}
		
		
		public static function requestFeedWorksheetCells(p_worksheetID:String):void
		{
			_requestType = REQUEST_TYPE_WORSHEET_CELLS;
			
			//GET https://spreadsheets.google.com/feeds/cells/key/worksheetId/private/full
			var _url:String = URL +  "cells/" + _spreadsheetKey + "/" + p_worksheetID + "/public/basic?alt=rss";
			
			
			var variables:URLVariables = new URLVariables();
			variables["_url"] = _url;
			
			//call the proxy page passing all the variables above
			var request:URLRequest = new URLRequest( PROXY_URL );
			request.data = variables;
			request.method = URLRequestMethod.POST;
			
			
			
//			_xmlLoader = new XMLLoader(_url, {name:"SpreadsheetDataXML", onComplete:onRequestComplete, autoDispose:true});
			_xmlLoader = new XMLLoader(request, {name:"SpreadsheetDataXML", onComplete:onRequestComplete, autoDispose:true});
			_xmlLoader.load(true);
		}
		
		
		private static function onRequestProgress(p_event:LoaderEvent):void
		{
			trace("[GoogleSpreadsheet] LoadProgress: " + p_event.target.progress);
		}
		
		
		private static function onRequestComplete(p_event:LoaderEvent):void
		{
			
			_xmlData = new XML(_xmlLoader.content);
//			trace("DATA: " + _xmlData);
			
			switch(_requestType)
			{
				case REQUEST_TYPE_WORKSHEET_LIST:
					processRequestWorksheetList();		
					break;
				
				case REQUEST_TYPE_WORSHEET_CELLS:
					processRequestWorksheetCells();
					break;
				
				default:
					
					break;
			}
		}
		
		
		private static function processRequestWorksheetCells():void
		{
			// TODO Auto Generated method stub
			//trace(_xmlData.channel.item);
			
			var arrCells:Array = new Array();
			var tmpCell:Cell;
			
			var strTemp:String;
			var strRow:String;
			var strCol:String;
			
			var i:uint = 0;
			var nMax:int = _xmlData.channel.item.length();
			
			for(i = 0; i < nMax; i++)
			{
				strTemp = _xmlData.channel.item.guid[i];
				strTemp = strTemp.substr( strTemp.lastIndexOf("/") + 1 );
				
				strRow = strTemp.substr( 1, strTemp.lastIndexOf("C") - 1 );
				strCol = strTemp.substr( strTemp.lastIndexOf("C") + 1 );
				
				trace(strTemp + "Row: " + strRow + " Col: " + strCol);
				trace(_xmlData.channel.item.description[i]);
				
				tmpCell = new Cell( int(strRow), int(strCol), _xmlData.channel.item.description[i] );
				arrCells.push(tmpCell);
			}
			
			_signalWorksheetCellsRequestComplete.dispatch(arrCells);
		}		
		
		
		private static function processRequestWorksheetList():void
		{
			var _arrSpreadSheetIDs:Array = new Array();
			
			var i:uint = 0;
			var nMax:uint = _xmlData.channel.item.length();
			var strTemp:String;
			
			trace("ITEMS: " + _xmlData.channel.item);
			
			for(i = 0; i < nMax; i++)
			{
				strTemp = _xmlData.channel.item[i].guid;
				strTemp = strTemp.substr( strTemp.lastIndexOf("/") + 1 )
				
				_arrSpreadSheetIDs.push(strTemp);
			}
			
			_signalWorksheetListRequestComplete.dispatch(_arrSpreadSheetIDs);
		}

		public static function get signalWorksheetListRequestComplete():Signal
		{
			return _signalWorksheetListRequestComplete;
		}

		public static function get signalWorksheetCellsRequestComplete():Signal
		{
			return _signalWorksheetCellsRequestComplete;
		}


	}
}