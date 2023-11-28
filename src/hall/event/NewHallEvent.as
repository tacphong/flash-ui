package hall.event
{
   import flash.events.Event;
   
   public class NewHallEvent extends Event
   {
      
      public static const SHOWBUFFCONTROL:String = "showbuffcontrol";
      
      public static const UPDATETITLE:String = "newhallupdatetitle";
      
      public static const BTNCLICK:String = "newhallbtnclick";
      
      public static const PLAYERSHOW:String = "newhallplayershow";
      
      public static const UPDATETIPSINFO:String = "newhallsetplayertippos";
      
      public static const CANCELEMAILSHINE:String = "cancelemailshine";
      
      public static const SETSELFPLAYERPOS:String = "setselfplayerpos";
      
      public static const SHOWPETS:String = "showPets";
       
      
      private var _data:Array;
      
      public function NewHallEvent(param1:String, param2:Array = null)
      {
         super(param1,bubbles,cancelable);
         this._data = param2;
      }
      
      public function get data() : Array
      {
         return this._data;
      }
   }
}
