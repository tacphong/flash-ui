package email.view
{
   import baglocked.BagLockedController;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.core.ITipedDisplay;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.LanguageMgr;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class DiamondOfWriting extends DiamondBase implements ITipedDisplay
   {
       
      
      private var _cellGoodsID:int;
      
      private var _annex:ItemTemplateInfo;
      
      private var _bagLocked:BagLockedController;
      
      private var _tipStyle:String;
      
      private var _tipData:Object;
      
      private var _tipDirctions:String;
      
      private var _tipGapV:int;
      
      private var _tipGapH:int;
      
      public function DiamondOfWriting()
      {
         super();
         this.tipStyle = "ddt.view.tips.OneLineTip";
         this.tipDirctions = "0";
         this.tipGapV = 5;
         this.tipData = LanguageMgr.GetTranslation("tank.view.emailII.WritingView.annex.tip");
         ShowTipManager.Instance.addTip(this);
      }
      
      public function get annex() : ItemTemplateInfo
      {
         return this._annex;
      }
      
      public function set annex(param1:ItemTemplateInfo) : void
      {
         this._annex = param1;
      }
      
      override protected function initView() : void
      {
         super.initView();
         mouseEnabled = true;
         mouseChildren = true;
         buttonMode = true;
         _cell.visible = true;
         _cell.allowDrag = true;
      }
      
      override protected function update() : void
      {
         if(this._annex == null)
         {
            centerMC.setFrame(1);
            centerMC.visible = true;
         }
         _cell.info = this._annex;
      }
      
      override protected function addEvent() : void
      {
         _cell.addEventListener(Event.CHANGE,this.__dragInBag);
         addEventListener(MouseEvent.CLICK,this.__click);
      }
      
      override protected function removeEvent() : void
      {
         _cell.removeEventListener(Event.CHANGE,this.__dragInBag);
         removeEventListener(MouseEvent.CLICK,this.__click);
      }
      
      public function setBagUnlock() : void
      {
         _cell.clearLinkCell();
      }
      
      private function __click(param1:MouseEvent) : void
      {
         dispatchEvent(new EmailEvent(EmailEvent.SHOW_BAGFRAME));
         if(Boolean(this._annex))
         {
            _cell.dragStart();
         }
      }
      
      private function __dragInBag(param1:Event) : void
      {
         this.annex = _cell.info;
         if(Boolean(this.annex))
         {
            dispatchEvent(new EmailEvent(EmailEvent.DRAGIN_ANNIEX));
         }
         else
         {
            dispatchEvent(new EmailEvent(EmailEvent.DRAGOUT_ANNIEX));
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this._annex = null;
         this._bagLocked;
         ShowTipManager.Instance.removeTip(this);
      }
      
      public function get tipStyle() : String
      {
         return this._tipStyle;
      }
      
      public function get tipData() : Object
      {
         return this._tipData;
      }
      
      public function get tipDirctions() : String
      {
         return this._tipDirctions;
      }
      
      public function get tipGapV() : int
      {
         return this._tipGapV;
      }
      
      public function get tipGapH() : int
      {
         return this._tipGapH;
      }
      
      public function set tipStyle(param1:String) : void
      {
         if(this._tipStyle == param1)
         {
            return;
         }
         this._tipStyle = param1;
      }
      
      public function set tipData(param1:Object) : void
      {
         if(this._tipData == param1)
         {
            return;
         }
         this._tipData = param1;
      }
      
      public function set tipDirctions(param1:String) : void
      {
         if(this._tipDirctions == param1)
         {
            return;
         }
         this._tipDirctions = param1;
      }
      
      public function set tipGapV(param1:int) : void
      {
         if(this._tipGapV == param1)
         {
            return;
         }
         this._tipGapV = param1;
      }
      
      public function set tipGapH(param1:int) : void
      {
         if(this._tipGapH == param1)
         {
            return;
         }
         this._tipGapH = param1;
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
   }
}
