package newTitle.event
{
   import flash.events.Event;
   
   public class NewTitleEvent extends Event
   {
      
      public static const NEWTITLE_OPENVIEW:String = "newTitleOpenView";
      
      public static const NEWTITLE_HIDEVIEW:String = "newTitleHideView";
      
      public static const TITLE_ITEM_CLICK:String = "titleItemClick";
      
      public static const SELECT_TITLE:String = "selectTitle";
      
      public static const SET_SELECT_TITLE:String = "setSelectTitle";
       
      
      public var data:Array;
      
      public function NewTitleEvent(param1:String, param2:Array = null)
      {
         super(param1,bubbles,cancelable);
         this.data = param2;
      }
   }
}
