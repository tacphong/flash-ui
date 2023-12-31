package deng.utils
{
   import flash.utils.ByteArray;
   
   public class ChecksumUtil
   {
      
      private static var crcTable:Array = makeCRCTable();
       
      
      public function ChecksumUtil()
      {
         super();
      }
      
      private static function makeCRCTable() : Array
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:Array = [];
         _loc1_ = 0;
         while(_loc1_ < 256)
         {
            _loc3_ = _loc1_;
            _loc2_ = 0;
            while(_loc2_ < 8)
            {
               if(Boolean(_loc3_ & 1))
               {
                  _loc3_ = uint(3988292384 ^ _loc3_ >>> 1);
               }
               else
               {
                  _loc3_ >>>= 1;
               }
               _loc2_++;
            }
            _loc4_.push(_loc3_);
            _loc1_++;
         }
         return _loc4_;
      }
      
      public static function CRC32(param1:ByteArray, param2:uint = 0, param3:uint = 0) : uint
      {
         var _loc4_:uint = 0;
         if(param2 >= param1.length)
         {
            param2 = param1.length;
         }
         if(param3 == 0)
         {
            param3 = uint(param1.length - param2);
         }
         if(param3 + param2 > param1.length)
         {
            param3 = uint(param1.length - param2);
         }
         var _loc5_:uint = 4294967295;
         _loc4_ = param2;
         while(_loc4_ < param3)
         {
            _loc5_ = uint(uint(crcTable[(_loc5_ ^ param1[_loc4_]) & 255]) ^ _loc5_ >>> 8);
            _loc4_++;
         }
         return _loc5_ ^ 4294967295;
      }
      
      public static function Adler32(param1:ByteArray, param2:uint = 0, param3:uint = 0) : uint
      {
         if(param2 >= param1.length)
         {
            param2 = param1.length;
         }
         if(param3 == 0)
         {
            param3 = uint(param1.length - param2);
         }
         if(param3 + param2 > param1.length)
         {
            param3 = uint(param1.length - param2);
         }
         var _loc4_:uint = param2;
         var _loc5_:uint = 1;
         var _loc6_:uint = 0;
         while(_loc4_ < param2 + param3)
         {
            _loc5_ = (_loc5_ + param1[_loc4_]) % 65521;
            _loc6_ = (_loc5_ + _loc6_) % 65521;
            _loc4_++;
         }
         return _loc6_ << 16 | _loc5_;
      }
   }
}
