package academy.view
{
   import academy.AcademyController;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.utils.PositionUtils;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class AcademyView extends Sprite implements Disposeable
   {
       
      
      private var _memberLis:academy.view.AcademyMemberListView;
      
      private var _playerPanel:academy.view.AcademyPlayerPanel;
      
      private var _controller:AcademyController;
      
      private var _flowerPatternBg:MovieClip;
      
      public function AcademyView(param1:AcademyController)
      {
         super();
         this._controller = param1;
         this.init();
      }
      
      private function init() : void
      {
         this._flowerPatternBg = ClassUtils.CreatInstance("asset.academy.flowerPatternBg") as MovieClip;
         PositionUtils.setPos(this._flowerPatternBg,"academy.view.AcademyView.flowerPatternBgPOS");
         addChild(this._flowerPatternBg);
         this._memberLis = new academy.view.AcademyMemberListView(this._controller);
         PositionUtils.setPos(this._memberLis,"academy.view.AcademyMemberListViewPos");
         addChild(this._memberLis);
         this._playerPanel = new academy.view.AcademyPlayerPanel(this._controller);
         addChild(this._playerPanel);
      }
      
      public function dispose() : void
      {
         if(Boolean(this._memberLis))
         {
            this._memberLis.dispose();
            this._memberLis = null;
         }
         if(Boolean(this._playerPanel))
         {
            this._playerPanel.dispose();
            this._playerPanel = null;
         }
         if(Boolean(this._flowerPatternBg))
         {
            ObjectUtils.disposeObject(this._flowerPatternBg);
         }
         this._flowerPatternBg = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}
