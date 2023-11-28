package littleGame.view
{
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Sprite;
   
   public class LittleGameOptionView extends Sprite implements Disposeable
   {
       
      
      private var _leftView:littleGame.view.OptionLeftView;
      
      private var _rightView:littleGame.view.OptionRightView;
      
      public function LittleGameOptionView()
      {
         super();
         this.initView();
         this.addEvent();
      }
      
      private function initView() : void
      {
         this._leftView = new littleGame.view.OptionLeftView();
         addChild(this._leftView);
         this._rightView = new littleGame.view.OptionRightView();
         addChild(this._rightView);
      }
      
      private function addEvent() : void
      {
      }
      
      public function dispose() : void
      {
         if(Boolean(this._leftView))
         {
            ObjectUtils.disposeObject(this._leftView);
         }
         this._leftView = null;
         if(Boolean(this._rightView))
         {
            ObjectUtils.disposeObject(this._rightView);
         }
         this._rightView = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}
