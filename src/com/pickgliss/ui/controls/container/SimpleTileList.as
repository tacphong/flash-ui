package com.pickgliss.ui.controls.container
{
   import com.pickgliss.ui.controls.BaseButton;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class SimpleTileList extends BoxContainer
   {
       
      
      public var startPos:Point;
      
      protected var _column:int;
      
      protected var _arrangeType:int;
      
      protected var _hSpace:Number = 0;
      
      protected var _rowNum:int;
      
      protected var _vSpace:Number = 0;
      
      private var _selectedIndex:int;
      
      public function SimpleTileList(param1:int = 1, param2:int = 0)
      {
         this.startPos = new Point(0,0);
         super();
         this._column = param1;
         this._arrangeType = param2;
      }
      
      public function get selectedIndex() : int
      {
         return this._selectedIndex;
      }
      
      public function set selectedIndex(param1:int) : void
      {
         if(this._selectedIndex == param1)
         {
            return;
         }
         this._selectedIndex = param1;
      }
      
      public function get hSpace() : Number
      {
         return this._hSpace;
      }
      
      public function set hSpace(param1:Number) : void
      {
         this._hSpace = param1;
         onProppertiesUpdate();
      }
      
      public function get vSpace() : Number
      {
         return this._vSpace;
      }
      
      public function set vSpace(param1:Number) : void
      {
         this._vSpace = param1;
         onProppertiesUpdate();
      }
      
      override public function addChild(param1:DisplayObject) : DisplayObject
      {
         param1.addEventListener(MouseEvent.CLICK,this.__itemClick);
         super.addChild(param1);
         return param1;
      }
      
      private function __itemClick(param1:MouseEvent) : void
      {
         var _loc2_:DisplayObject = param1.currentTarget as DisplayObject;
         if(Boolean(_loc2_ as BaseButton))
         {
            return;
         }
         this._selectedIndex = getChildIndex(_loc2_);
      }
      
      override public function arrange() : void
      {
         this.caculateRows();
         if(this._arrangeType == 0)
         {
            this.horizontalArrange();
         }
         else
         {
            this.verticalArrange();
         }
      }
      
      private function horizontalArrange() : void
      {
         var _loc2_:DisplayObject = null;
         var _loc3_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc1_:int = 0;
         _loc2_ = null;
         _loc3_ = 0;
         var _loc4_:int = 0;
         _loc5_ = 0;
         _loc6_ = 0;
         _loc1_ = 0;
         var _loc7_:int = 0;
         _loc2_ = null;
         var _loc8_:int = 0;
         _loc3_ = this.startPos.x;
         _loc4_ = this.startPos.y;
         _loc5_ = 0;
         _loc6_ = 0;
         var _loc9_:int = 0;
         while(_loc9_ < this._rowNum)
         {
            _loc1_ = 0;
            _loc7_ = 0;
            while(_loc7_ < this._column)
            {
               _loc2_ = getChildAt(_loc8_++);
               _loc2_.x = _loc3_;
               _loc2_.y = _loc4_;
               _loc5_ = Math.max(_loc5_,_loc3_ + _loc2_.width);
               _loc6_ = Math.max(_loc6_,_loc4_ + _loc2_.height);
               _loc3_ += _loc2_.width + this._hSpace;
               if(_loc1_ < _loc2_.height)
               {
                  _loc1_ = _loc2_.height;
               }
               if(_loc8_ >= numChildren)
               {
                  this.changeSize(_loc5_,_loc6_);
                  return;
               }
               _loc7_++;
            }
            _loc3_ = this.startPos.x;
            _loc4_ += _loc1_ + this._vSpace;
            _loc9_++;
         }
         this.changeSize(_loc5_,_loc6_);
         dispatchEvent(new Event(Event.RESIZE));
      }
      
      private function verticalArrange() : void
      {
         var _loc2_:int = 0;
         var _loc1_:DisplayObject = null;
         _loc2_ = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc1_ = null;
         var _loc5_:int = 0;
         var _loc6_:int = this.startPos.x;
         var _loc7_:int = this.startPos.y;
         var _loc8_:int = 0;
         _loc2_ = 0;
         var _loc9_:int = 0;
         while(_loc9_ < this._rowNum)
         {
            _loc3_ = 0;
            _loc4_ = 0;
            while(_loc4_ < this._column)
            {
               _loc1_ = getChildAt(_loc5_++);
               _loc1_.x = _loc6_;
               _loc1_.y = _loc7_;
               _loc8_ = Math.max(_loc8_,_loc6_ + _loc1_.width);
               _loc2_ = Math.max(_loc2_,_loc7_ + _loc1_.height);
               _loc7_ += _loc1_.height + this._vSpace;
               if(_loc3_ < _loc1_.width)
               {
                  _loc3_ = _loc1_.width;
               }
               if(_loc5_ >= numChildren)
               {
                  this.changeSize(_loc8_,_loc2_);
                  return;
               }
               _loc4_++;
            }
            _loc6_ += _loc3_ + this._hSpace;
            _loc7_ = this.startPos.y;
            _loc9_++;
         }
         this.changeSize(_loc8_,_loc2_);
         dispatchEvent(new Event(Event.RESIZE));
      }
      
      private function changeSize(param1:int, param2:int) : void
      {
         if(param1 != _width || param2 != _height)
         {
            width = param1;
            height = param2;
         }
      }
      
      private function caculateRows() : void
      {
         this._rowNum = Math.ceil(numChildren / this._column);
      }
      
      override public function dispose() : void
      {
         var _loc1_:DisplayObject = null;
         var _loc2_:int = 0;
         while(_loc2_ < numChildren)
         {
            _loc1_ = getChildAt(_loc2_) as DisplayObject;
            _loc1_.removeEventListener(MouseEvent.CLICK,this.__itemClick);
            _loc2_++;
         }
         super.dispose();
      }
   }
}
