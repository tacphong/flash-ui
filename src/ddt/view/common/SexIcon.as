package ddt.view.common
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import flash.display.Sprite;
   
   public class SexIcon extends Sprite implements Disposeable
   {
       
      
      private var _sexIcon:ScaleFrameImage;
      
      private var _sex:Boolean;
      
      public function SexIcon(param1:Boolean = true)
      {
         super();
         this._sexIcon = ComponentFactory.Instance.creat("sex_icon");
         this._sexIcon.setFrame(param1 ? int(1) : int(2));
         addChild(this._sexIcon);
      }
      
      public function setSex(param1:Boolean) : void
      {
         this._sexIcon.setFrame(param1 ? int(2) : int(1));
      }
      
      public function set size(param1:Number) : void
      {
         this._sexIcon.scaleX = this._sexIcon.scaleY = param1;
      }
      
      public function dispose() : void
      {
         if(Boolean(this._sexIcon))
         {
            this._sexIcon.dispose();
            this._sexIcon = null;
         }
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}
