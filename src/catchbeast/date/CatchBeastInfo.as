package catchbeast.date
{
   public class CatchBeastInfo
   {
       
      
      public var ChallengeNum:int;
      
      public var BuyBuffNum:int;
      
      public var DamageNum:int;
      
      public var PaidChallengeNum:int;
      
      public var BuffPrice:int;
      
      public var BoxState:Array;
      
      public function CatchBeastInfo()
      {
         this.BoxState = [];
         super();
      }
   }
}
