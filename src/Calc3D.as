/*
 * フレーム9
 * 3Dfunctions
 * このフレームでは3D演算のための関数置き場
*/

package 
{
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import timeline.elements.Polygon;
	
	/**
	 * zsort, clipping, affine
	 * @author umhr
	 */
	public class Calc3D 
	{
		//public var control:Control;
		//Ｚソート用の配列を返す関数
		static public function fn_zsort(arg_data_array:Array):Array {
			var _length:int = arg_data_array.length;
			var _array:Array = [];
			for (var i:int = 0; i<_length; i++) {
				_array.push(Vector3D.distance(arg_data_array[i][0], new Vector3D(0, 0, -100000)));
				//_array.push(distance3d(arg_data_array[i][0]));
			}
			return _array.sort(Array.NUMERIC | Array.RETURNINDEXEDARRAY | Array.DESCENDING);
		}
		//二点間の距離を返す関数
		static public function distance3d(arg0_array:Vector3D):Number {
			var dz:Number = -100000 - arg0_array.z
			return arg0_array.x * arg0_array.x + arg0_array.y * arg0_array.y + dz * dz;
		}
		//座標情報コピーの関数
		//static public function fn_arraycopy(copy_array:Array):Array {
			//var n:int = copy_array.length;
			//var _array:Array = new Array();
			//for (var i:int= 0; i<n; i++) {
				//var polygon:Polygon = new Polygon();
				//var m:int = copy_array[i].length;
				//for (var j:int= 0; j<m; j++) {
					//polygon[j] = copy_array[i][j].clone();
				//}
				//_array[i] = polygon;
			//}
			//return _array;
		//}
		
		static public function cloneVertices(... rest):Array {
			var result:Array = new Array();
			var restLength:int = rest.length;
			for (var k:int = 0; k < restLength; k++) {
				//var metaList:Array/*Meta*/ = rest[k];
				//Array/*Meta*/またはVector.<Meta>
				var metaList:* = rest[k];
				var n:int = metaList.length;
				for (var i:int= 0; i<n; i++) {
					var polygon:Polygon = new Polygon();
					var m:int = metaList[i].vertices.length;
					for (var j:int= 0; j<m; j++) {
						polygon[j] = metaList[i].vertices[j].clone();
					}
					polygon.fieldID = metaList[i].fieldID;
					polygon.type = metaList[i].type;
					polygon.visibleManager = metaList[i].visibleManager;
					polygon.element = metaList[i].element;
					result[i] = polygon;
				}
			}
			return result;
		}
		
		//グローバル座標でのアフィン変換
		static public function fn_affine(data_array:Array, arg_array:Array):void {
			var n_cx:Number = Math.cos(arg_array[3]);
			var n_sx:Number = Math.sin(arg_array[3]);
			var n_cy:Number = Math.cos(arg_array[4]);
			var n_sy:Number = Math.sin(arg_array[4]);
			var n_cz:Number = Math.cos(arg_array[5]);
			var n_sz:Number = Math.sin(arg_array[5]);
			var d_x:Number = arg_array[0];//*global_scaleX;
			var d_y:Number = arg_array[1];
			var d_z:Number = arg_array[2];
			var af_xx:Number = n_cz*n_cy+n_sx*n_sy*n_sz;
			var af_xy:Number = n_sx*n_sy*n_cz-n_sz*n_cy;
			var af_xz:Number = n_sy*n_cx;
			var af_yx:Number = n_cx*n_sz;
			var af_yy:Number = n_cx*n_cz;
			var af_yz:Number = -n_sx;
			var af_zx:Number = n_cy*n_sx*n_sz-n_sy*n_cz;
			var af_zy:Number = n_sy*n_sz+n_cy*n_sx*n_cz;
			var af_zz:Number = n_cx*n_cy;
			var n:int = data_array.length;
			for (var i:int = 0; i< n ; i++) {
				var m:int = data_array[i].length;
				for (var j:int = 0; j< m ; j++) {
					var af_x:Number = data_array[i][j].x;
					var af_y:Number = data_array[i][j].y;
					var af_z:Number = data_array[i][j].z;
					data_array[i][j].x = af_x * af_xx + af_y * af_xy + af_z * af_xz + d_x;
					data_array[i][j].y = af_x * af_yx + af_y * af_yy + af_z * af_yz + d_y;
					data_array[i][j].z = af_x * af_zx + af_y * af_zy + af_z * af_zz + d_z;
				}
			}
		}
		//視点より手前の座標をクリップするための関数
		static public function fn_clipping(arg_data_array:Array):void {
			//var isClip:Boolean;
			var n:int = arg_data_array.length;
			for (var i:int = 0; i< n ; i++) {
				if(arg_data_array[i].type == "txt" || arg_data_array[i].type == "timescale" || arg_data_array[i].type == "sprite"  || arg_data_array[i].type == "layerselect"){
					if(arg_data_array[i][0].z < -3800){
						arg_data_array[i].visibleManager = false;
					}else{
						arg_data_array[i].visibleManager = true;
					}
				}else if(arg_data_array[i].type == "fill" || arg_data_array[i].type == "chart" || arg_data_array[i].type == "field"){
					var _array:Polygon = new Polygon();
					_array[0] = arg_data_array[i][0];
					_array.fieldID = arg_data_array[i].fieldID;
					_array.type = arg_data_array[i].type;
					_array.visibleManager = arg_data_array[i].visibleManager;
					_array.element = arg_data_array[i].element;
					
					var l:int = arg_data_array[i].length;
					for (var j:int = 1; j<l; j++) {
						var k:int = j % (arg_data_array[i].length - 1) + 1;
						var m:int = (j + arg_data_array[i].length + 1) % (arg_data_array[i].length - 1) + 1;
						var _w:Number;
						var new_x:Number;
						var new_y:Number;
						if(arg_data_array[i][j].z < -3800){
							if(arg_data_array[i][k].z > -3800){
								_w = ( -3800 - arg_data_array[i][j].z) / (arg_data_array[i][k].z - arg_data_array[i][j].z);
								new_x = (arg_data_array[i][k].x - arg_data_array[i][j].x) * _w + arg_data_array[i][j].x;
								new_y = (arg_data_array[i][k].y - arg_data_array[i][j].y) * _w + arg_data_array[i][j].y;
								_array.push(new Vector3D(new_x, new_y, -3800));
							}
							if(arg_data_array[i][m].z > -3800){
								_w = ( -3800 - arg_data_array[i][j].z) / (arg_data_array[i][m].z - arg_data_array[i][j].z);
								new_x = (arg_data_array[i][m].x - arg_data_array[i][j].x) * _w + arg_data_array[i][j].x;
								new_y = (arg_data_array[i][m].y - arg_data_array[i][j].y) * _w + arg_data_array[i][j].y;
								_array.push(new Vector3D(new_x, new_y, -3800));
							}
						}else{
							_array.push(arg_data_array[i][j]);
						}
					};
					if(_array.length < 4){
						arg_data_array[i].visibleManager = false;
					}else{
						arg_data_array[i].visibleManager = true;
					}
					arg_data_array[i] = _array;
				}
			}
		}
		
		//ペアトランスのための関数
		static public function fn_pertrans(arg_array:Array):void{
			var _length:int = arg_array.length;
			for (var i:int = 0; i<_length; i++) {
				var _i_length:int = arg_array[i].length;
				for (var j:int = 0; j<_i_length; j++) {
					var _per:Number = 4000/(4000 + arg_array[i][j].z);
					arg_array[i][j] = new Vector3D(arg_array[i][j].x * _per,     arg_array[i][j].y * _per,    _per);
				}
			}
		}
		//ステージより上下左右外れた座標をクリップするための関数
		static public function fn_clipping_xy(arg_data_array:Array):void{
			var stageWidth:int = Setting.stageWidth;
			var stageHeight:int = Setting.stageHeight;
			var n:int = arg_data_array.length
			for (var i:int = 0; i < n ; i++) {
				if(arg_data_array[i].type == "txt" || arg_data_array[i].type == "timescale" || arg_data_array[i].type == "sprite"  || arg_data_array[i].type == "layerselect"){
					if(arg_data_array[i][0].x < -(stageWidth/2+100) || arg_data_array[i][0].x > (stageWidth/2+100) || arg_data_array[i][0].y < -(stageHeight/2+50) || arg_data_array[i][0].y > (stageHeight/2+50)){
						arg_data_array[i].visibleManager = false;
					}
				}else if (arg_data_array[i].type == "fill" || arg_data_array[i].type == "chart" || arg_data_array[i].type == "field") {
					//continue;
					var _array:Polygon = new Polygon();
					_array[0] = arg_data_array[i][0];
					_array.fieldID = arg_data_array[i].fieldID;
					_array.type = arg_data_array[i].type;
					_array.visibleManager = arg_data_array[i].visibleManager;
					_array.element = arg_data_array[i].element;
					
					var l:int = arg_data_array[i].length;
					for (var j:int = 1; j < l ; j++) {
						var m:int = j % (arg_data_array[i].length - 1) + 1;
						var k:int = (j + arg_data_array[i].length + 1) % (arg_data_array[i].length - 1) + 1;
						var _w:Number;
						var new_x:Number;
						var new_y:Number;
						if(arg_data_array[i][j].x < -stageWidth/2){
							if(arg_data_array[i][k].x > -stageWidth/2){
								_w = (-stageWidth/2-arg_data_array[i][j].x)/(arg_data_array[i][k].x-arg_data_array[i][j].x);
								new_y = (arg_data_array[i][k].y-arg_data_array[i][j].y)*_w+arg_data_array[i][j].y;
								_array.push(new Vector3D(-stageWidth/2,new_y,arg_data_array[i][j].z));
							}
							if(arg_data_array[i][m].x > -stageWidth/2){
								_w = ( -stageWidth / 2 - arg_data_array[i][j].x) / (arg_data_array[i][m].x - arg_data_array[i][j].x);
								new_y = (arg_data_array[i][m].y - arg_data_array[i][j].y) * _w + arg_data_array[i][j].y;
								_array.push(new Vector3D( -stageWidth / 2, new_y, arg_data_array[i][j].z));
							}
						}else if(arg_data_array[i][j].x > stageWidth/2){
							if(arg_data_array[i][k].x < stageWidth/2){
								_w = (stageWidth / 2 - arg_data_array[i][j].x) / (arg_data_array[i][k].x - arg_data_array[i][j].x);
								new_y = (arg_data_array[i][k].y - arg_data_array[i][j].y) * _w + arg_data_array[i][j].y;
								_array.push(new Vector3D(stageWidth / 2, new_y, arg_data_array[i][j].z));
							}
							if(arg_data_array[i][m].x < stageWidth/2){
								_w = (stageWidth / 2 - arg_data_array[i][j].x) / (arg_data_array[i][m].x - arg_data_array[i][j].x);
								new_y = (arg_data_array[i][m].y - arg_data_array[i][j].y) * _w + arg_data_array[i][j].y;
								_array.push(new Vector3D(stageWidth / 2, new_y, arg_data_array[i][j].z));
							}
						}else{
							_array.push(arg_data_array[i][j]);
						}
					}
					if(_array.length < 4){
						arg_data_array[i].visibleManager = false;
					}else{
						arg_data_array[i].visibleManager = true;
					}
					arg_data_array[i] = _array;
				}
			}
		}
		
		//ローカルアフィン変換。現状座標移動用に最適化
		static public function fn_affinepartOptimized(data_array:Array, selecter_array:Array, global_scaleX:Number, global_scaleY:Number, global_scaleZ:Number):void {
			var arg_categoryLength:int = Setting.fieldNameList.length;
			var n:int = data_array.length;
			for (var i:int = 0; i < n ; i++) {
				var _n:Number = data_array[i].fieldID;
				//var _n:Number = meta_origin_array[i].fieldID;
				if(_n >= arg_categoryLength){
					_n = arg_categoryLength;
				}
				_n = selecter_array[_n];
				var d_y:Number = -_n*170+170;
				var m :int = data_array[i].length;
				for (var j:int = 0; j < m ; j++) {
					
					//重要！
					//はまってた箇所。origin_array:Array(Vector3D)書き換え作業時に data_array[i][j][0] を data_array[i][j].y にすると scale が反映されない。無視して続行すべきか、。
					//答え。timeObject_array  , Calc3D.arraycopy を　new Vector3D() に書き換える。他にもfn_clipping, fn_pertrans, fn_clipping_xy にも new Vector3D()の作業が必要だった。 @taka. 
					var af_y:Number = data_array[i][j].y*_n;// y
					data_array[i][j].x *= global_scaleX;
					data_array[i][j].y = af_y + d_y;
					data_array[i][j].z *= global_scaleZ;
					
					
				}
			}
		}
		
		
	}
	
}