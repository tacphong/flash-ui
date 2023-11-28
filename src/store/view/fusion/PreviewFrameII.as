package store.view.fusion
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.bagStore.BagStore;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import store.data.PreviewInfoII;
   
   public class PreviewFrameII extends Frame
   {
       
      
      private var _list:VBox;
      
      private var _okBtn:TextButton;
      
      public function PreviewFrameII()
      {
         super();
         this.initII();
         this.initEvents();
      }
      
      private function initII() : void
      {
         titleText = LanguageMgr.GetTranslation("store.view.fusion.PreviewFrame.preview");
         var _loc1_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.store.PreviewFrameBG");
         addToContent(_loc1_);
         this._list = new VBox();
         addToContent(this._list);
         this._okBtn = ComponentFactory.Instance.creatComponentByStylename("store.PreviewFrameEnter");
         this._okBtn.text = LanguageMgr.GetTranslation("ok");
         addToContent(this._okBtn);
         escEnable = true;
         enterEnable = true;
      }
      
      private function initEvents() : void
      {
         this._okBtn.addEventListener(MouseEvent.CLICK,this._okClick);
         addEventListener(Event.REMOVED_FROM_STAGE,this.removeFromStageHandler);
         addEventListener(FrameEvent.RESPONSE,this._response);
      }
      
      private function removeEvents() : void
      {
         this._okBtn.removeEventListener(MouseEvent.CLICK,this._okClick);
         removeEventListener(Event.REMOVED_FROM_STAGE,this.removeFromStageHandler);
         removeEventListener(FrameEvent.RESPONSE,this._response);
      }
      
      private function _okClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.hide();
      }
      
      private function _response(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         this.hide();
      }
      
      public function set items(param1:Array) : void
      {
         var _loc2_:PreviewItem = null;
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_ = new PreviewItem();
            _loc2_.info = param1[_loc3_] as PreviewInfoII;
            this._list.addChild(_loc2_);
            _loc3_++;
         }
      }
      
      public function clearList() : void
      {
         this._list.disposeAllChildren();
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_TOP_LAYER,true);
      }
      
      public function hide() : void
      {
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      override public function dispose() : void
      {
         this.removeEvents();
         this.clearList();
         if(Boolean(this._list))
         {
            ObjectUtils.disposeObject(this._list);
         }
         this._list = null;
         if(Boolean(this._okBtn))
         {
            ObjectUtils.disposeObject(this._okBtn);
         }
         this._okBtn = null;
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
      
      private function removeFromStageHandler(param1:Event) : void
      {
         BagStore.instance.reduceTipPanelNumber();
      }
   }
}
