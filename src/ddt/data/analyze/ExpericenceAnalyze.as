package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   
   public class ExpericenceAnalyze extends DataAnalyzer
   {
       
      
      public var expericence:Array;
      
      public var HP:Array;
      
      public function ExpericenceAnalyze(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:XMLList = null;
         var _loc3_:int = 0;
         var _loc4_:XML = new XML(param1);
         this.expericence = [];
         this.HP = [];
         if(_loc4_.@value == "true")
         {
            _loc2_ = _loc4_..Item;
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length())
            {
               this.expericence.push(int(_loc2_[_loc3_].@GP));
               this.HP.push(int(_loc2_[_loc3_].@Blood));
               _loc3_++;
            }
            onAnalyzeComplete();
         }
         else
         {
            message = _loc4_.@message;
            onAnalyzeError();
            onAnalyzeComplete();
         }
      }
   }
}
