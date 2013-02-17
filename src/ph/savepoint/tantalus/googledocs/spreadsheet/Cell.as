package ph.savepoint.tantalus.googledocs.spreadsheet
{
	public class Cell
	{
		private var _nCol:uint;
		private var _nRow:uint;
		private var _strData:String;
		
		public function Cell(p_row:uint = 0, p_col:uint = 0, p_data:String = "")
		{
			_nRow = p_row;
			_nCol = p_col;
			_strData = p_data;
		}

		public function get nCol():uint
		{
			return _nCol;
		}

		public function get nRow():uint
		{
			return _nRow;
		}

		public function get strData():String
		{
			return _strData;
		}


	}
}