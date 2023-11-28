package phy.maps
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.BlendMode;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class Tile extends Bitmap
   {
       
      
      private var _digable:Boolean;
      
      public function Tile(param1:BitmapData, param2:Boolean)
      {
         super(param1);
         this._digable = param2;
      }
      
      public function Dig(param1:Point, param2:Bitmap, param3:Bitmap = null) : void
      {
         var _loc4_:BitmapData = null;
         var _loc5_:Matrix = new Matrix(1,0,0,1,param1.x,param1.y);
         if(Boolean(param2) && this._digable)
         {
            _loc5_.tx -= param2.width / 2;
            _loc5_.ty -= param2.height / 2;
            bitmapData.draw(param2,_loc5_,null,BlendMode.ERASE);
         }
         if(Boolean(param3) && this._digable)
         {
            _loc4_ = param3.bitmapData.clone();
            _loc5_.tx = -param1.x + param3.width / 2;
            _loc5_.ty = -param1.y + param3.height / 2;
            _loc4_.draw(this,_loc5_,null,BlendMode.ALPHA);
            _loc5_.tx = param1.x - param3.width / 2;
            _loc5_.ty = param1.y - param3.height / 2;
            bitmapData.draw(_loc4_,_loc5_,null,param3.blendMode);
            _loc4_.dispose();
         }
      }
      
      public function DigFillRect(param1:Rectangle) : void
      {
         bitmapData.fillRect(param1,0);
      }
      
      public function GetAlpha(param1:int, param2:int) : uint
      {
         return bitmapData.getPixel32(param1,param2) >> 24 & 255;
      }
      
      public function dispose() : void
      {
         bitmapData.dispose();
      }
   }
}
