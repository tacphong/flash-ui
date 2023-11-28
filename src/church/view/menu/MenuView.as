package church.view.menu
{
   import ddt.data.player.PlayerInfo;
   
   public class MenuView
   {
      
      private static var _menu:church.view.menu.MenuPanel;
       
      
      public function MenuView()
      {
         super();
      }
      
      public static function show(param1:PlayerInfo) : void
      {
         if(param1 == null)
         {
            return;
         }
         if(_menu == null)
         {
            _menu = new church.view.menu.MenuPanel();
         }
         _menu.playerInfo = param1;
         _menu.show();
      }
      
      public static function hide() : void
      {
         if(Boolean(_menu))
         {
            _menu.hide();
         }
      }
      
      public function dispose() : void
      {
         if(Boolean(_menu) && Boolean(_menu.parent))
         {
            _menu.parent.removeChild(_menu);
         }
         if(Boolean(_menu))
         {
            _menu.dispose();
         }
         _menu = null;
      }
   }
}
