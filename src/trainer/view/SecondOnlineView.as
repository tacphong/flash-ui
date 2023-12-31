package trainer.view
{
   import bagAndInfo.cell.BaseCell;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.ChatManager;
   import ddt.manager.ItemManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.geom.Point;
   
   public class SecondOnlineView extends BaseAlerFrame
   {
       
      
      private var _bmpBg:Bitmap;
      
      private var _bmpNpc:Bitmap;
      
      private var _tile:SimpleTileList;
      
      public function SecondOnlineView()
      {
         super();
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this.initView();
      }
      
      override public function dispose() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         ObjectUtils.disposeAllChildren(this);
         this._tile.dispose();
         this._bmpBg = null;
         this._bmpNpc = null;
         this._tile = null;
         super.dispose();
      }
      
      private function initView() : void
      {
         var _loc1_:Point = null;
         _loc1_ = null;
         var _loc2_:Bitmap = null;
         var _loc3_:Bitmap = null;
         var _loc4_:BaseCell = null;
         info = new AlertInfo();
         _info.showCancel = false;
         _info.moveEnable = false;
         _info.autoButtonGape = false;
         _info.customPos = ComponentFactory.Instance.creatCustomObject("trainer.second.posBtn");
         this._bmpBg = ComponentFactory.Instance.creatBitmap("asset.trainer.secondBg");
         addToContent(this._bmpBg);
         this._bmpNpc = ComponentFactory.Instance.creat("asset.trainer.welcome.girl");
         PositionUtils.setPos(this._bmpNpc,"trainer.second.posGirl");
         addToContent(this._bmpNpc);
         _loc1_ = ComponentFactory.Instance.creatCustomObject("trainer.posSecondTile");
         var _loc5_:Array = [9003,8003,112097,11998,11901,11233];
         this._tile = new SimpleTileList(3);
         this._tile.hSpace = 2;
         this._tile.vSpace = 2;
         this._tile.x = _loc1_.x;
         this._tile.y = _loc1_.y;
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_.length)
         {
            _loc2_ = ComponentFactory.Instance.creatBitmap("asset.trainer.secondOutBg");
            _loc3_ = ComponentFactory.Instance.creatBitmap("asset.trainer.secondOverBg");
            _loc4_ = new BaseCell(_loc2_,ItemManager.Instance.getTemplateById(_loc5_[_loc6_]),true,true);
            _loc4_.overBg = _loc3_;
            this._tile.addChild(_loc4_);
            _loc6_++;
         }
         addToContent(this._tile);
         ChatManager.Instance.releaseFocus();
      }
      
      private function __responseHandler(param1:FrameEvent) : void
      {
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK || param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
   }
}
