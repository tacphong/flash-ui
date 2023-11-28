package org.aswing
{
   import flash.utils.Dictionary;
   
   public class KeyMap
   {
       
      
      private var map:Dictionary;
      
      public function KeyMap()
      {
         super();
         this.map = new Dictionary();
      }
      
      public static function getCodec(param1:KeyType) : String
      {
         return getCodecWithKeySequence(param1.getCodeSequence());
      }
      
      public static function getCodecWithKeySequence(param1:Array) : String
      {
         return param1.join("|");
      }
      
      public function registerKeyAction(param1:KeyType, param2:Function) : void
      {
         var _loc3_:String = getCodec(param1);
         var _loc4_:Array = this.map[_loc3_];
         if(_loc4_ == null)
         {
            _loc4_ = new Array();
         }
         _loc4_.push(new KeyAction(param1,param2));
         this.map[_loc3_] = _loc4_;
      }
      
      public function unregisterKeyAction(param1:KeyType, param2:Function) : void
      {
         var _loc3_:int = 0;
         var _loc4_:KeyAction = null;
         var _loc5_:String = getCodec(param1);
         var _loc6_:Array = this.map[_loc5_];
         if(Boolean(_loc6_))
         {
            _loc3_ = 0;
            while(_loc3_ < _loc6_.length)
            {
               _loc4_ = _loc6_[_loc3_];
               if(_loc4_.action == param2)
               {
                  _loc6_.splice(_loc3_,1);
                  _loc3_--;
               }
               _loc3_++;
            }
         }
      }
      
      public function getKeyAction(param1:KeyType) : Function
      {
         return this.getKeyActionWithCodec(getCodec(param1));
      }
      
      private function getKeyActionWithCodec(param1:String) : Function
      {
         var _loc2_:Array = this.map[param1];
         if(_loc2_ != null && _loc2_.length > 0)
         {
            return _loc2_[_loc2_.length - 1].action;
         }
         return null;
      }
      
      public function fireKeyAction(param1:Array) : Boolean
      {
         var _loc2_:String = getCodecWithKeySequence(param1);
         var _loc3_:Function = this.getKeyActionWithCodec(_loc2_);
         if(_loc3_ != null)
         {
            _loc3_();
            return true;
         }
         return false;
      }
      
      public function containsKey(param1:KeyType) : Boolean
      {
         return this.map[getCodec(param1)] != null;
      }
   }
}

import org.aswing.KeyType;

class KeyAction
{
    
   
   private var key:KeyType;
   
   internal var action:Function;
   
   public function KeyAction(param1:KeyType, param2:Function)
   {
      super();
      this.key = param1;
      this.action = param2;
   }
}
