package org.bytearray.display
{
   import com.pickgliss.ui.core.Disposeable;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   
   public class ScaleBitmap extends Bitmap implements Disposeable
   {
       
      
      protected var _originalBitmap:BitmapData;
      
      protected var _scale9Grid:Rectangle = null;
      
      public function ScaleBitmap(param1:BitmapData = null, param2:String = "auto", param3:Boolean = false)
      {
         super(param1,param2,param3);
         this._originalBitmap = param1.clone();
      }
      
      override public function set bitmapData(param1:BitmapData) : void
      {
         if(Boolean(this._originalBitmap))
         {
            this._originalBitmap.dispose();
         }
         this._originalBitmap = param1.clone();
         if(this._scale9Grid != null)
         {
            if(!this.validGrid(this._scale9Grid))
            {
               this._scale9Grid = null;
            }
            this.setSize(param1.width,param1.height);
         }
         else
         {
            this.assignBitmapData(this._originalBitmap.clone());
         }
      }
      
      public function dispose() : void
      {
         if(Boolean(this._originalBitmap))
         {
            this._originalBitmap.dispose();
         }
         this._originalBitmap = null;
         bitmapData.dispose();
         if(Boolean(this._scale9Grid))
         {
            this._scale9Grid = null;
         }
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      public function getOriginalBitmapData() : BitmapData
      {
         return this._originalBitmap;
      }
      
      override public function set height(param1:Number) : void
      {
         if(param1 != height)
         {
            this.setSize(width,param1);
         }
      }
      
      override public function get scale9Grid() : Rectangle
      {
         return this._scale9Grid;
      }
      
      override public function set scale9Grid(param1:Rectangle) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(this._scale9Grid == null && param1 != null || this._scale9Grid != null && !this._scale9Grid.equals(param1))
         {
            if(param1 == null)
            {
               _loc2_ = width;
               _loc3_ = height;
               this._scale9Grid = null;
               this.assignBitmapData(this._originalBitmap.clone());
               this.setSize(_loc2_,_loc3_);
            }
            else
            {
               if(!this.validGrid(param1))
               {
                  throw new Error("#001 - The _scale9Grid does not match the original BitmapData");
               }
               this._scale9Grid = param1.clone();
               this.resizeBitmap(width,height);
               scaleX = 1;
               scaleY = 1;
            }
         }
      }
      
      public function setSize(param1:Number, param2:Number) : void
      {
         if(this._scale9Grid == null)
         {
            super.width = param1;
            super.height = param2;
         }
         else
         {
            param1 = Math.max(param1,this._originalBitmap.width - this._scale9Grid.width);
            param2 = Math.max(param2,this._originalBitmap.height - this._scale9Grid.height);
            this.resizeBitmap(param1,param2);
         }
      }
      
      override public function set width(param1:Number) : void
      {
         if(param1 != width)
         {
            this.setSize(param1,height);
         }
      }
      
      protected function resizeBitmap(param1:Number, param2:Number) : void
      {
         var _loc3_:Rectangle = null;
         var _loc4_:Rectangle = null;
         var _loc5_:int = 0;
         var _loc6_:BitmapData = new BitmapData(param1,param2,true,0);
         var _loc7_:Array = [0,this._scale9Grid.top,this._scale9Grid.bottom,this._originalBitmap.height];
         var _loc8_:Array = [0,this._scale9Grid.left,this._scale9Grid.right,this._originalBitmap.width];
         var _loc9_:Array = [0,this._scale9Grid.top,param2 - (this._originalBitmap.height - this._scale9Grid.bottom),param2];
         var _loc10_:Array = [0,this._scale9Grid.left,param1 - (this._originalBitmap.width - this._scale9Grid.right),param1];
         var _loc11_:Matrix = new Matrix();
         var _loc12_:int = 0;
         while(_loc12_ < 3)
         {
            _loc5_ = 0;
            while(_loc5_ < 3)
            {
               _loc3_ = new Rectangle(_loc8_[_loc12_],_loc7_[_loc5_],_loc8_[_loc12_ + 1] - _loc8_[_loc12_],_loc7_[_loc5_ + 1] - _loc7_[_loc5_]);
               _loc4_ = new Rectangle(_loc10_[_loc12_],_loc9_[_loc5_],_loc10_[_loc12_ + 1] - _loc10_[_loc12_],_loc9_[_loc5_ + 1] - _loc9_[_loc5_]);
               _loc11_.identity();
               _loc11_.a = _loc4_.width / _loc3_.width;
               _loc11_.d = _loc4_.height / _loc3_.height;
               _loc11_.tx = _loc4_.x - _loc3_.x * _loc11_.a;
               _loc11_.ty = _loc4_.y - _loc3_.y * _loc11_.d;
               _loc6_.draw(this._originalBitmap,_loc11_,null,null,_loc4_,smoothing);
               _loc5_++;
            }
            _loc12_++;
         }
         this.assignBitmapData(_loc6_);
      }
      
      private function assignBitmapData(param1:BitmapData) : void
      {
         super.bitmapData.dispose();
         super.bitmapData = param1;
      }
      
      private function validGrid(param1:Rectangle) : Boolean
      {
         return param1.right <= this._originalBitmap.width && param1.bottom <= this._originalBitmap.height;
      }
   }
}
