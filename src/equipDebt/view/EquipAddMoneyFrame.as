package equipDebt.view
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import equipDebt.EquipDebtManager;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class EquipAddMoneyFrame extends BaseAlerFrame
   {
       
      
      private var _bg:Scale9CornerImage;
      
      private var _innerBg1:Bitmap;
      
      private var _innerBg:Bitmap;
      
      private var _commodityNumberText:FilterFrameText;
      
      private var _commodityPricesText1:FilterFrameText;
      
      private var _commodityPricesText2:FilterFrameText;
      
      private var _commodityPricesText3:FilterFrameText;
      
      private var _equipAddMoneyBt:BaseButton;
      
      private var _cartScroll:ScrollPanel;
      
      private var _cartList:VBox;
      
      public function EquipAddMoneyFrame()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         var _loc1_:AlertInfo = null;
         this._cartList = new VBox();
         _loc1_ = new AlertInfo(LanguageMgr.GetTranslation("ddt.vip.vipView.EquipRenewal"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false);
         _loc1_.moveEnable = false;
         info = _loc1_;
         this.escEnable = true;
         this._bg = ComponentFactory.Instance.creatComponentByStylename("EquipDebt.AddMoneyViewBg");
         this._innerBg1 = ComponentFactory.Instance.creatBitmap("asset.shop.CheckOutViewBg1");
         this._innerBg = ComponentFactory.Instance.creatBitmap("asset.shop.CheckOutViewBg");
         this._commodityNumberText = ComponentFactory.Instance.creatComponentByStylename("equipDebt.AddMoneyViewText0");
         this._commodityPricesText1 = ComponentFactory.Instance.creatComponentByStylename("equipDebt.AddMoneyViewText1");
         this._commodityPricesText2 = ComponentFactory.Instance.creatComponentByStylename("equipDebt.AddMoneyViewText2");
         this._commodityPricesText3 = ComponentFactory.Instance.creatComponentByStylename("equipDebt.AddMoneyViewText3");
         this._equipAddMoneyBt = ComponentFactory.Instance.creatComponentByStylename("equipDebt.AddMoneyViewBtn");
         this._equipAddMoneyBt.visible = true;
         this._cartScroll = ComponentFactory.Instance.creatComponentByStylename("equipDebt.AddMoneyViewScroll");
         this._cartScroll.setView(this._cartList);
         this._cartScroll.vScrollProxy = ScrollPanel.ON;
         this._cartList.spacing = 5;
         this._cartList.strictSize = 80;
         this._cartList.isReverAdd = true;
         addToContent(this._bg);
         addToContent(this._innerBg1);
         addToContent(this._innerBg);
         addToContent(this._cartScroll);
         addToContent(this._equipAddMoneyBt);
         addToContent(this._commodityNumberText);
         addToContent(this._commodityPricesText1);
         addToContent(this._commodityPricesText2);
         addToContent(this._commodityPricesText3);
         this.setEvent();
         this.updataText();
      }
      
      public function set Equiplist(param1:Array) : void
      {
         var _loc2_:EquipAddMoneyItem = null;
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_ = new EquipAddMoneyItem();
            _loc2_.info = param1[_loc3_];
            this._cartList.addChild(_loc2_);
            _loc2_.addEventListener(_loc2_.CLOSE,this.closeItem);
            _loc2_.addEventListener(_loc2_.CHANG,this.chageItem);
            _loc3_++;
         }
         this._cartScroll.invalidateViewport();
         this.updataText();
      }
      
      private function closeItem(param1:Event) : void
      {
         this._cartList.removeChild(EquipAddMoneyItem(param1.currentTarget));
         this.updataText();
      }
      
      private function chageItem(param1:Event) : void
      {
         this.updataText();
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.NONE_BLOCKGOUND);
      }
      
      private function updataText() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = this._cartList.numChildren;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         while(_loc9_ < this._cartList.numChildren)
         {
            _loc1_ = EquipAddMoneyItem(this._cartList.getChildAt(_loc9_)).shopID;
            _loc2_ = EquipAddMoneyItem(this._cartList.getChildAt(_loc9_)).getshopInfo(0).getItemPrice(_loc1_).moneyValue;
            _loc3_ = EquipAddMoneyItem(this._cartList.getChildAt(_loc9_)).getshopInfo(0).getItemPrice(_loc1_).giftValue;
            _loc4_ = EquipAddMoneyItem(this._cartList.getChildAt(_loc9_)).getshopInfo(0).getItemPrice(_loc1_).medalValue;
            _loc6_ += _loc2_;
            _loc7_ += _loc3_;
            _loc8_ += _loc4_;
            _loc9_++;
         }
         this._commodityNumberText.text = _loc5_.toString();
         this._commodityPricesText1.text = _loc6_.toString();
         this._commodityPricesText2.text = _loc7_.toString();
         this._commodityPricesText3.text = _loc8_.toString();
      }
      
      private function setEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.onFrameResponse);
         this._equipAddMoneyBt.addEventListener(MouseEvent.CLICK,this.clickAddMoneyBt);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.onFrameResponse);
         this._equipAddMoneyBt.removeEventListener(MouseEvent.CLICK,this.clickAddMoneyBt);
      }
      
      private function onFrameResponse(param1:FrameEvent) : void
      {
         EquipDebtManager.Instance.dispose();
      }
      
      private function clickAddMoneyBt(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc6_:Array = new Array();
         var _loc7_:int = 0;
         while(_loc7_ < this._cartList.numChildren)
         {
            _loc2_ = EquipAddMoneyItem(this._cartList.getChildAt(_loc7_)).info.BagType;
            _loc3_ = EquipAddMoneyItem(this._cartList.getChildAt(_loc7_)).info.Place;
            _loc4_ = EquipAddMoneyItem(this._cartList.getChildAt(_loc7_)).getshopInfo(0).GoodsID;
            _loc5_ = EquipAddMoneyItem(this._cartList.getChildAt(_loc7_)).shopID;
            _loc6_.push([_loc2_,_loc3_,_loc4_,_loc5_,false]);
            _loc7_++;
         }
         SocketManager.Instance.out.sendGoodsContinue(_loc6_);
         EquipDebtManager.Instance.dispose();
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         super.dispose();
         this._cartScroll.dispose();
      }
   }
}
