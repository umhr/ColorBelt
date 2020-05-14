package  
{
	import flash.geom.Vector3D;
	/**
	 * ...
	 * @author umhr
	 */
	public class Calc
	{
		
		public function Calc() 
		{
			
		}
		//視点より手前の座標をクリップするための関数
		static public function clipping(trancePosition:Vector.<Vertices>):Vector.<Vertices> {
			var result:Vector.<Vertices> = new Vector.<Vertices>();
			var n:int = trancePosition.length;
			for (var i:int = 0; i < n; i++) {
				result[i] = new Vertices();
				result[i].rgb = trancePosition[i].rgb;
				var m:int = trancePosition[i].length;
				var d:int = -500;
				for (var j:int = 0; j < m; j++) {
					var prev:int = (j + m - 1) % m;
					var next:int = (j + m + 1) % m;
					var w:Number;
					var x:Number;
					var y:Number;
					if (trancePosition[i][j].z < d) {
						if(trancePosition[i][prev].z > d){
							w = ( d - trancePosition[i][j].z) / (trancePosition[i][prev].z - trancePosition[i][j].z);
							x = (trancePosition[i][prev].x - trancePosition[i][j].x) * w + trancePosition[i][j].x;
							y = (trancePosition[i][prev].y - trancePosition[i][j].y) * w + trancePosition[i][j].y;
							result[i].push(new Vertex(x, y, d, 0, true, trancePosition[i][j].isCorner));
						}
						if(trancePosition[i][next].z > d){
							w = ( d - trancePosition[i][j].z) / (trancePosition[i][next].z - trancePosition[i][j].z);
							x = (trancePosition[i][next].x - trancePosition[i][j].x) * w + trancePosition[i][j].x;
							y = (trancePosition[i][next].y - trancePosition[i][j].y) * w + trancePosition[i][j].y;
							result[i].push(new Vertex(x, y, d, 0, true, trancePosition[i][j].isCorner));
						}
					}else{
						result[i].push(trancePosition[i][j]);
					}
				};
			}
			return result;
			
		}
		//ペアトランスのための関数
		static public function pertrans(trancePosition:Vector.<Vertices>):Vector.<Vertices> {
			var result:Vector.<Vertices> = new Vector.<Vertices>();
			var n:int = trancePosition.length;
			for (var i:int = 0; i < n; i++) {
				result[i] = new Vertices();
				result[i].rgb = trancePosition[i].rgb;
				var m:int = trancePosition[i].length;
				for (var j:int = 0; j < m; j++) {
					var per:Number = 400/(400 + trancePosition[i][j].z);
					result[i][j] = new Vertex(trancePosition[i][j].x * per, trancePosition[i][j].y * per, per, 0, false, trancePosition[i][j].isCorner);
				}
			}
			return result;
		}
		
	}

}