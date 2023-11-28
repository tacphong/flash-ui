package com.pickgliss.utils
{
   public class ArrayUtils
   {
       
      
      public function ArrayUtils()
      {
         super();
      }
      
      public static function each(param1:Array, param2:Function) : void
      {
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            param2(param1[_loc3_]);
            _loc3_++;
         }
      }
      
      public static function setSize(param1:Array, param2:int) : void
      {
         if(param2 < 0)
         {
            param2 = 0;
         }
         if(param2 == param1.length)
         {
            return;
         }
         if(param2 > param1.length)
         {
            param1[param2 - 1] = undefined;
         }
         else
         {
            param1.splice(param2);
         }
      }
      
      public static function removeFromArray(param1:Array, param2:Object) : int
      {
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            if(param1[_loc3_] == param2)
            {
               param1.splice(_loc3_,1);
               return _loc3_;
            }
            _loc3_++;
         }
         return -1;
      }
      
      public static function removeAllFromArray(param1:Array, param2:Object) : void
      {
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            if(param1[_loc3_] == param2)
            {
               param1.splice(_loc3_,1);
               _loc3_--;
            }
            _loc3_++;
         }
      }
      
      public static function removeAllBehindSomeIndex(param1:Array, param2:int) : void
      {
         if(param2 <= 0)
         {
            param1.splice(0,param1.length);
            return;
         }
         var _loc3_:int = int(param1.length);
         var _loc4_:int = param2 + 1;
         while(_loc4_ < _loc3_)
         {
            param1.pop();
            _loc4_++;
         }
      }
      
      public static function indexInArray(param1:Array, param2:Object) : int
      {
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            if(param1[_loc3_] == param2)
            {
               return _loc3_;
            }
            _loc3_++;
         }
         return -1;
      }
      
      public static function cloneArray(param1:Array) : Array
      {
         return param1.concat();
      }
      
      public static function swapItems(param1:Array, param2:Object, param3:Object) : void
      {
         var _loc4_:Object = null;
         var _loc5_:int = param1.indexOf(param2);
         var _loc6_:int = param1.indexOf(param3);
         if(_loc5_ != -1 && _loc6_ != -1)
         {
            _loc4_ = param1[_loc6_];
            param1[_loc6_] = param1[_loc5_];
            param1[_loc5_] = _loc4_;
         }
      }
      
      public static function disorder(param1:Array) : void
      {
         var _loc2_:int = 0;
         var _loc3_:* = undefined;
         var _loc4_:int = 0;
         while(_loc4_ < param1.length)
         {
            _loc2_ = Math.random() * 10000 % param1.length;
            _loc3_ = param1[_loc4_];
            param1[_loc4_] = param1[_loc2_];
            param1[_loc2_] = _loc3_;
            _loc4_++;
         }
      }
   }
}
