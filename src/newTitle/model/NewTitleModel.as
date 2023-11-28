package newTitle.model
{
   import flash.display.Bitmap;
   
   public class NewTitleModel
   {
       
      
      public var id:int;
      
      public var Order:int;
      
      public var Show:String;
      
      public var Name:String;
      
      public var Pic:String;
      
      public var Att:String = "0";
      
      public var Def:String = "0";
      
      public var Agi:String = "0";
      
      public var Luck:String = "0";
      
      public var Desc:String = "无";
      
      public var Valid:int;
      
      public var Icon:Bitmap = null;
      
      public function NewTitleModel()
      {
         super();
      }
      
      public function set ID(param1:String) : void
      {
         this.id = int(param1);
      }
      
      public function set OrderNum(param1:String) : void
      {
         this.Order = int(param1);
      }
   }
}
