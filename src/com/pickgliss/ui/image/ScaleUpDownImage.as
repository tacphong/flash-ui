package com.pickgliss.ui.image
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   
   public class ScaleUpDownImage extends Image
   {
       
      
      private var _bitmaps:Vector.<Bitmap>;
      
      private var _imageLinks:Array;
      
      public function ScaleUpDownImage()
      {
         super();
      }
      
      override public function dispose() : void
      {
         this.removeImages();
         graphics.clear();
         this._bitmaps = null;
         super.dispose();
      }
      
      override protected function addChildren() : void
      {
         if(this._bitmaps == null)
         {
            return;
         }
         addChild(this._bitmaps[0]);
         addChild(this._bitmaps[2]);
      }
      
      override protected function resetDisplay() : void
      {
         this._imageLinks = ComponentFactory.parasArgs(_resourceLink);
         this.removeImages();
         this.creatImages();
      }
      
      override protected function updateSize() : void
      {
         if(Boolean(_changedPropeties[Component.P_width]) || Boolean(_changedPropeties[Component.P_height]))
         {
            this.drawImage();
         }
      }
      
      private function creatImages() : void
      {
         var _loc1_:Bitmap = null;
         this._bitmaps = new Vector.<Bitmap>();
         var _loc2_:int = 0;
         while(_loc2_ < this._imageLinks.length)
         {
            _loc1_ = ComponentFactory.Instance.creat(this._imageLinks[_loc2_]);
            this._bitmaps.push(_loc1_);
            _loc2_++;
         }
      }
      
      private function drawImage() : void
      {
         graphics.clear();
         graphics.beginBitmapFill(this._bitmaps[1].bitmapData);
         graphics.drawRect(0,this._bitmaps[0].height,_width,_height - this._bitmaps[0].height - this._bitmaps[2].height);
         graphics.endFill();
         this._bitmaps[2].y = _height - this._bitmaps[2].height;
      }
      
      private function removeImages() : void
      {
         if(this._bitmaps == null)
         {
            return;
         }
         var _loc1_:int = 0;
         while(_loc1_ < this._bitmaps.length)
         {
            ObjectUtils.disposeObject(this._bitmaps[_loc1_]);
            _loc1_++;
         }
      }
   }
}
