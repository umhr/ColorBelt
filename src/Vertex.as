package  
{
	import flash.geom.Vector3D;
	/**
	 * ...
	 * @author umhr
	 */
	public class Vertex extends Vector3D
	{
		public var isCliped:Boolean;
		public var isCorner:Boolean;
		public function Vertex(x:Number = 0, y:Number = 0, z:Number = 0, w:Number = 0, isCliped:Boolean = false, isCorner:Boolean = false) 
		{
			super(x, y, z, w);
			this.isCliped = isCliped;
			this.isCorner = isCorner;
		}
		public function castByVector3D(vector3D:Vector3D):void {
			x = vector3D.x;
			y = vector3D.y;
			z = vector3D.z;
		}
		
	}

}