package  
{
	/**
	 * ...
	 * @author umhr
	 */
	public dynamic class Vertices extends Array
	{
		public var rgb:uint;
		public function Vertices() 
		{
			
		}
		public function get center():Vertex {
			var result:Vertex = new Vertex();
			var n:int = this.length;
			for (var i:int = 0; i < n; i++) 
			{
				result.x += this[i].x / n;
				result.y += this[i].y / n;
				result.z += this[i].z / n;
			}
			return result;
		}
		public function distance(x:Number, y:Number, z:Number):Number {
			var cent:Vertex = this.center;
			var dx:Number = x - cent.x;
			var dy:Number = y - cent.y;
			var dz:Number = z - cent.z;
			
			return Math.sqrt(dx * dx + dy * dy + dz * dz);
			
		}
		
	}

}