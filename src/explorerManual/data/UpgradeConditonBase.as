package explorerManual.data
{
   import explorerManual.data.model.ManualUpgradeInfo;
   
   public class UpgradeConditonBase
   {
       
      
      protected var _conditions:Array;
      
      public function UpgradeConditonBase()
      {
         super();
      }
      
      public function set conditions(param1:Array) : void
      {
         this._conditions = param1;
      }
      
      public function get materialCondition() : ManualUpgradeInfo
      {
         return null;
      }
      
      public function get upgradeCondition() : ManualUpgradeInfo
      {
         return null;
      }
      
      public function get targetCount() : int
      {
         return null;
      }
   }
}
