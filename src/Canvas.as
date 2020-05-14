package  
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	/**
	 * ...
	 * @author umhr
	 */
	public class Canvas extends Sprite
	{
		private var _axis:Sprite = new Sprite();
		private var _positionList:Vector.<Vertices> = new Vector.<Vertices>();
		
		private var _canvas:Sprite = new Sprite();
		
		public function Canvas() 
		{
			init();
		}
		private function init():void 
		{
			if (stage) onInit();
			else addEventListener(Event.ADDED_TO_STAGE, onInit);
		}
		
		private function onInit(event:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onInit);
			// entry point
			
			_canvas.x = stage.stageWidth * 0.5;
			_canvas.y = stage.stageHeight * 0.5;
			addChild(_canvas);
			
			var modelData:Vector.<Point> = new Vector.<Point>();
			
			var r:Number;
			var n:int = 24;
			for (var i:int = 0; i < n; i++) 
			{
				r = (i % 2) * 50 + 30 + i * 5;
				modelData.push(new Point( Math.cos(Math.PI * 4 * (i / n)) * r, Math.sin(Math.PI * 4 * (i / n)) * r));
			}
			vertices(modelData);
		}
		private function vertices(modelData:Vector.<Point>):void {
			
			var colorList:Vector.<uint> = new <uint>[0xCC3333,0x33CC33,0x3333CC,0xCCCC33,0x33CCCC,0xCC33CC];
			
			var dy:Number = 40;
			var ty:Number;
			var n:int = 5;
			for (var i:int = 0; i < n; i++) 
			{
				var verticesIn:Vertices = new Vertices();
				verticesIn.rgb = colorList[i];
				ty = i * dy - n * dy * 0.5;
				
				verticesIn.unshift(new Vertex(modelData[0].x, ty, modelData[0].y, NaN, false, true));
				verticesIn.unshift(new Vertex((modelData[0].x + modelData[1].x) * 0.5, ty, (modelData[0].y + modelData[1].y) * 0.5, NaN, false, true));
				verticesIn.push(new Vertex(modelData[0].x, ty + dy, modelData[0].y, NaN, false, true));
				verticesIn.push(new Vertex((modelData[0].x + modelData[1].x) * 0.5, ty + dy, (modelData[0].y + modelData[1].y) * 0.5, NaN, false, true));
				_positionList.push(verticesIn);
			}
			
			var m:int = modelData.length - 1;
			for (var j:int = 1; j < m; j++) 
			{
				for (i = 0; i < n; i++) 
				{
					ty = i * dy - n * dy * 0.5;
					var vertices:Vertices = new Vertices();
					vertices.rgb = colorList[i];
					vertices.unshift(new Vertex((modelData[j - 1].x + modelData[j].x) * 0.5, ty, (modelData[j - 1].y + modelData[j].y) * 0.5, 0, false, true));
					vertices.unshift(new Vertex(modelData[j].x, ty, modelData[j].y, NaN, false, false));
					vertices.unshift(new Vertex((modelData[j].x + modelData[j + 1].x) * 0.5, ty, (modelData[j].y + modelData[j + 1].y) * 0.5, 0, false, true));
					
					vertices.push(new Vertex((modelData[j - 1].x + modelData[j].x) * 0.5, ty + dy, (modelData[j - 1].y + modelData[j].y) * 0.5, 0, false, true));
					vertices.push(new Vertex(modelData[j].x, ty + dy, modelData[j].y, NaN, false, false));
					vertices.push(new Vertex((modelData[j].x + modelData[j + 1].x) * 0.5, ty + dy, (modelData[j].y + modelData[j + 1].y) * 0.5, 0, false, true));
					_positionList.push(vertices);
				}
			}
			for (i = 0; i < n; i++) 
			{
				ty = i * dy - n * dy * 0.5;
				var verticesOut:Vertices = new Vertices();
				verticesOut.rgb = colorList[i];
				verticesOut.unshift(new Vertex((modelData[m-1].x + modelData[m].x) * 0.5, ty, (modelData[m-1].y + modelData[m].y) * 0.5, NaN, false, true));
				verticesOut.unshift(new Vertex(modelData[m].x, ty, modelData[m].y, NaN, false, true));
				verticesOut.push(new Vertex((modelData[m-1].x + modelData[m].x) * 0.5, ty + dy, (modelData[m-1].y + modelData[m].y) * 0.5, NaN, false, true));
				verticesOut.push(new Vertex(modelData[m].x, ty + dy, modelData[m].y, NaN, false, true));
				_positionList.push(verticesOut);
			}
			
			animete();
		}
		
		private function animete():void {
			
			//_axis.graphics.beginFill(0xFF0000);
			//_axis.graphics.drawCircle(0, 0, 10);
			//_axis.graphics.endFill();
			//_axis.x = 0;
			//_axis.y = 0;
			//_axis.rotationZ = 25;
			_axis.z = -100;
			
			addChild(_axis);
			
			addEventListener(Event.ENTER_FRAME, onEnter);
		}
		
		private function onEnter(event:Event):void 
		{
			_axis.rotationX += (mouseX - stage.width * 0.5) * 0.0001;
			_axis.rotationZ += (mouseY - stage.height * 0.5) * 0.001;
			_axis.rotationY ++;
			
			var trancePosition:Vector.<Vertices> = new Vector.<Vertices>();
			
			var n:int = _positionList.length;
			for (var i:int = 0; i < n; i++) 
			{
				trancePosition[i] = new Vertices();
				trancePosition[i].rgb = _positionList[i].rgb;
				var m:int = _positionList[i].length;
				for (var j:int = 0; j < m; j++) 
				{
					var poz:Vertex = new Vertex();
					poz.castByVector3D(_axis.transform.matrix3D.transformVector(_positionList[i][j]));
					poz.isCorner = _positionList[i][j].isCorner;
					trancePosition[i].push(poz);
				}
			}
			
			
			//_canvas.graphics.lineStyle(1, 0xFF0000, 0.5);
			//graphics.moveTo(_dotList[0].x, _dotList[1].x);
			
			//draw(Calc.clipping(trancePosition));
			draw(Calc.pertrans(Calc.clipping(trancePosition)));
			//draw(trancePosition);
		}
		
		private function draw(trancePosition:Vector.<Vertices>):void {
			
			_canvas.graphics.clear();
			
			var n:int = trancePosition.length;
			
			var zArray:Array = [];
			for (var i:int = 0; i < n; i++) 
			{
				zArray.push(trancePosition[i].distance(0, 0, -100000));
			}
			var sortter:Array = zArray.sort(Array.NUMERIC | Array.RETURNINDEXEDARRAY);
			
			
			//for (var i:int = 0; i < n; i++) 
			//{
			for (var k:int = 0; k < n; k++) 
			{
				i = sortter[k];
				
				var m:int = trancePosition[i].length;
				//_canvas.graphics.beginFill(trancePosition[i].rgb, 0.5);
				_canvas.graphics.beginFill(trancePosition[i].rgb, 0.5);
				_canvas.graphics.lineStyle(1, trancePosition[i].rgb, 1);
				if (m == 0) {
					continue;
				}
				_canvas.graphics.moveTo(trancePosition[i][0].x, trancePosition[i][0].y);
				for (var j:int = 0; j < m; j++) 
				{
					//trace(trancePosition[i][j].isCorner)
					
					var i0:int = j;
					var i1:int = (j + 1) % m;
					var i2:int = (j + 2) % m;
					var v0:Vector3D = interpolate(trancePosition[i][i0], trancePosition[i][i1]);
					var v1:Vector3D = interpolate(trancePosition[i][i1], trancePosition[i][i2]);
					
					if(j == 0 && !trancePosition[i][j].isCorner){
						_canvas.graphics.moveTo(v0.x, v0.y);
					}
					if (trancePosition[i][i1].isCorner) {
						//_canvas.graphics.lineStyle(1, 0x00FF00, 0.5);
						_canvas.graphics.lineTo(trancePosition[i][i1].x, trancePosition[i][i1].y);
					}else if(trancePosition[i][i0].isCliped && trancePosition[i][i1].isCliped){
						_canvas.graphics.lineStyle(1, 0x00FFFF, 0.5);
						_canvas.graphics.lineTo(trancePosition[i][i1].x, trancePosition[i][i1].y);
						_canvas.graphics.lineTo(v1.x, v1.y);
					}else if (trancePosition[i][i1].isCliped && trancePosition[i][i2].isCliped) {
						_canvas.graphics.lineStyle(1, 0xFFFF00, 0.5);
						_canvas.graphics.lineTo(trancePosition[i][i1].x, trancePosition[i][i1].y);
						_canvas.graphics.lineTo(v1.x, v1.y);
					}else {
						//_canvas.graphics.lineStyle(3, 0x0000FF, 0.5);
						_canvas.graphics.lineTo(v0.x, v0.y);
						//_canvas.graphics.lineStyle(3, 0xFF00FF, 0.5);
						//_canvas.graphics.moveTo(v0.x, v0.y);
						_canvas.graphics.curveTo(trancePosition[i][i1].x, trancePosition[i][i1].y, v1.x, v1.y);
					}
					
					
				}
				_canvas.graphics.endFill();
			}
			//trace(poz);
			
			//stage.transform.concatenatedMatrix.deltaTransformPoint(_dot)
			//trace(stage.transform.concatenatedMatrix.deltaTransformPoint(new Point(_dot.x,_dot.y)))
			//_axis.transform.
			//trace(_axis.transform.concatenatedMatrix.deltaTransformPoint(new Point(_dot.x, _dot.y)));
		}
		
		private function interpolate(a:Vertex, b:Vertex):Vertex {
			return new Vertex(a.x + (b.x - a.x) * 0.5, a.y + (b.y - a.y) * 0.5, a.z + (b.z - a.z) * 0.5);
		}
		
	}

}