package shop.view
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemPrice;
   import ddt.data.goods.ShopCarItemInfo;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class ShopRechargeEquipView extends Sprite implements Disposeable
   {
       
      
      private var price:ItemPrice;
      
      private var _bg:Bitmap;
      
      private var _frame:BaseAlerFrame;
      
      private var _chargeBtn:SimpleBitmapButton;
      
      private var _itemContainer:VBox;
      
      private var _scrollPanel:ScrollPanel;
      
      private var _equipList:Array;
      
      private var _costMoneyTxt:FilterFrameText;
      
      private var _costGiftTxt:FilterFrameText;
      
      private var _playerMoneyTxt:FilterFrameText;
      
      private var _playerGiftTxt:FilterFrameText;
      
      private var _currentCountTxt:FilterFrameText;
      
      private var _affirmContinuBt:SimpleBitmapButton;
      
      public function ShopRechargeEquipView()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this._frame = ComponentFactory.Instance.creatComponentByStylename("shop.RechargeViewFrame");
         this._bg = ComponentFactory.Instance.creatBitmap("asset.shop.ShopRechargeGoodsBg");
         this._chargeBtn = ComponentFactory.Instance.creatComponentByStylename("shop.RechargeViewChargeBtn");
         this._scrollPanel = ComponentFactory.Instance.creatComponentByStylename("shop.RechargeViewItemList");
         this._itemContainer = ComponentFactory.Instance.creatComponentByStylename("shop.CartItemContainer");
         this._costMoneyTxt = ComponentFactory.Instance.creatComponentByStylename("shop.RechargeViewCostMoney");
         this._costGiftTxt = ComponentFactory.Instance.creatComponentByStylename("shop.RechargeViewCostGift");
         this._playerMoneyTxt = ComponentFactory.Instance.creatComponentByStylename("shop.RechargeViewPlayerMoney");
         this._playerGiftTxt = ComponentFactory.Instance.creatComponentByStylename("shop.RechargeViewPlayerGift");
         this._currentCountTxt = ComponentFactory.Instance.creatComponentByStylename("shop.RechargeViewCurrentCount");
         this._affirmContinuBt = ComponentFactory.Instance.creatComponentByStylename("shop.affirmContinuBt");
         var _loc1_:AlertInfo = new AlertInfo(LanguageMgr.GetTranslation("tank.view.continuation.contiuationTitle"),LanguageMgr.GetTranslation("tank.view.common.AddPricePanel.xu"),LanguageMgr.GetTranslation("cancel"),false,false);
         this._frame.info = _loc1_;
         this._equipList = PlayerManager.Instance.Self.OvertimeListByBody;
         this._scrollPanel.vScrollProxy = ScrollPanel.ON;
         this._scrollPanel.setView(this._itemContainer);
         this._itemContainer.spacing = 5;
         this._itemContainer.strictSize = 80;
         this._scrollPanel.invalidateViewport();
         this._frame.moveEnable = false;
         this._frame.addToContent(this._bg);
         this._frame.addToContent(this._chargeBtn);
         this._frame.addToContent(this._scrollPanel);
         this._frame.addToContent(this._costMoneyTxt);
         this._frame.addToContent(this._costGiftTxt);
         this._frame.addToContent(this._playerMoneyTxt);
         this._frame.addToContent(this._playerGiftTxt);
         this._frame.addToContent(this._currentCountTxt);
         this._frame.addToContent(this._affirmContinuBt);
         this.setList();
         this.__onPlayerPropertyChange();
         this._chargeBtn.addEventListener(MouseEvent.CLICK,this.__onChargeClick);
         this._frame.addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._affirmContinuBt.addEventListener(MouseEvent.CLICK,this._clickContinuBt);
         addChild(this._frame);
      }
      
      private function __frameEventHandler(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
               if(PlayerManager.Instance.Self.bagLocked)
               {
                  BaglockedManager.Instance.show();
               }
               else
               {
                  this.payAll();
               }
               break;
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               InventoryItemInfo.startTimer();
               this.dispose();
         }
      }
      
      private function _clickContinuBt(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
         }
         else
         {
            this.payAll();
         }
      }
      
      private function __onChargeClick(param1:Event) : void
      {
         LeavePageManager.leaveToFillPath();
      }
      
      private function payAll() : void
      {
         var _loc1_:Array = null;
         var _loc2_:Array = null;
         var _loc3_:Array = null;
         var _loc4_:ShopCarItemInfo = null;
         var _loc5_:ShopRechargeEquipViewItem = null;
         var _loc6_:int = 0;
         var _loc7_:uint = 0;
         var _loc8_:ShopRechargeEquipViewItem = null;
         var _loc9_:Boolean = false;
         var _loc10_:Array = this.shopInfoList;
         var _loc11_:Array = ShopManager.Instance.buyIt(this.shopInfoListWithOutDelete);
         if(_loc11_.length > 0)
         {
            _loc1_ = new Array();
            _loc2_ = new Array();
            _loc3_ = new Array();
            for each(_loc4_ in _loc11_)
            {
               _loc7_ = uint(_loc10_.indexOf(_loc4_));
               _loc8_ = this._itemContainer.getChildAt(_loc7_) as ShopRechargeEquipViewItem;
               _loc2_.push(_loc8_.info);
               _loc3_.push(_loc8_);
            }
            for each(_loc5_ in _loc3_)
            {
               this._itemContainer.removeChild(_loc5_);
            }
            this._scrollPanel.invalidateViewport();
            _loc6_ = 0;
            while(_loc6_ < _loc11_.length)
            {
               _loc9_ = _loc2_[_loc6_].Place <= 30;
               _loc1_.push([_loc2_[_loc6_].BagType,_loc2_[_loc6_].Place,_loc11_[_loc6_].GoodsID,_loc11_[_loc6_].currentBuyType,_loc9_]);
               _loc6_++;
            }
            this.updateTxt();
            SocketManager.Instance.out.sendGoodsContinue(_loc1_);
            if(this._itemContainer.numChildren <= 0)
            {
               this.dispose();
            }
            else if(this.shopInfoListWithOutDelete.length > 0)
            {
               this.showAlert();
            }
         }
         else if(this.shopInfoListWithOutDelete.length != 0)
         {
            this.showAlert();
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.continuation.contiuationFailed"));
         }
      }
      
      private function setList() : void
      {
         var i:InventoryItemInfo = null;
         var item:ShopRechargeEquipViewItem = null;
         this._equipList.sort(function(param1:InventoryItemInfo, param2:InventoryItemInfo):Number
         {
            var _loc3_:Array = [7,5,1,17,8,9,14,6,13,15,3,4,2];
            var _loc4_:uint = uint(_loc3_.indexOf(param1.CategoryID));
            var _loc5_:uint = uint(_loc3_.indexOf(param2.CategoryID));
            if(_loc4_ < _loc5_)
            {
               return -1;
            }
            if(_loc4_ == _loc5_)
            {
               return 0;
            }
            return 1;
         });
         for each(i in this._equipList)
         {
            if(ShopManager.Instance.canAddPrice(i.TemplateID))
            {
               item = new ShopRechargeEquipViewItem();
               item.itemInfo = i;
               item.setColor(i.Color);
               item.addEventListener(ShopCartItem.DELETE_ITEM,this.__onItemDelete);
               item.addEventListener(ShopCartItem.CONDITION_CHANGE,this.__onItemChange);
               this._itemContainer.addChild(item);
            }
         }
         this._scrollPanel.invalidateViewport();
         this.updateTxt();
      }
      
      private function __onItemDelete(param1:Event) : void
      {
      }
      
      private function __onItemChange(param1:Event) : void
      {
         this.updateTxt();
      }
      
      private function get shopInfoListWithOutDelete() : Array
      {
         var _loc1_:ShopRechargeEquipViewItem = null;
         var _loc2_:Array = new Array();
         var _loc3_:uint = 0;
         while(_loc3_ < this._itemContainer.numChildren)
         {
            _loc1_ = this._itemContainer.getChildAt(_loc3_) as ShopRechargeEquipViewItem;
            if(Boolean(_loc1_) && !_loc1_.isDelete)
            {
               _loc2_.push(_loc1_.shopItemInfo);
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      private function get shopInfoList() : Array
      {
         var _loc1_:ShopRechargeEquipViewItem = null;
         var _loc2_:Array = new Array();
         var _loc3_:uint = 0;
         while(_loc3_ < this._itemContainer.numChildren)
         {
            _loc1_ = this._itemContainer.getChildAt(_loc3_) as ShopRechargeEquipViewItem;
            _loc2_.push(_loc1_.shopItemInfo);
            _loc3_++;
         }
         return _loc2_;
      }
      
      private function updateTxt() : void
      {
         var _loc1_:ShopCarItemInfo = null;
         var _loc2_:Array = this.shopInfoListWithOutDelete;
         var _loc3_:uint = _loc2_.length;
         this._currentCountTxt.text = String(_loc3_);
         if(_loc3_ == 0)
         {
            this._affirmContinuBt.enable = false;
         }
         else
         {
            this._affirmContinuBt.enable = true;
         }
         this._frame.submitButtonEnable = _loc3_ <= 0 ? Boolean(false) : Boolean(true);
         this.price = new ItemPrice(null,null,null);
         for each(_loc1_ in _loc2_)
         {
            this.price.addItemPrice(_loc1_.getCurrentPrice());
         }
         this._costMoneyTxt.text = String(this.price.moneyValue);
         this._costGiftTxt.text = String(this.price.giftValue);
         this.updataTextColor();
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__onPlayerPropertyChange,false,0,true);
      }
      
      private function __onPlayerPropertyChange(param1:Event = null) : void
      {
         this._playerMoneyTxt.text = String(PlayerManager.Instance.Self.Money);
         this._playerGiftTxt.text = String(PlayerManager.Instance.Self.Gift);
         this.updataTextColor();
      }
      
      private function updataTextColor() : void
      {
         if(Boolean(this.price))
         {
            if(this.price.moneyValue > PlayerManager.Instance.Self.Money)
            {
               this._costMoneyTxt.setTextFormat(ComponentFactory.Instance.model.getSet("shop.DigitWarningTF"));
            }
            else
            {
               this._costMoneyTxt.setTextFormat(ComponentFactory.Instance.model.getSet("shop.DigitTF"));
            }
            if(this.price.giftValue > PlayerManager.Instance.Self.Gift)
            {
               this._costGiftTxt.setTextFormat(ComponentFactory.Instance.model.getSet("shop.DigitWarningTF"));
            }
            else
            {
               this._costGiftTxt.setTextFormat(ComponentFactory.Instance.model.getSet("shop.DigitTF"));
            }
         }
      }
      
      private function showAlert() : void
      {
         var _loc1_:BaseAlerFrame = null;
         if(this.price.moneyValue > PlayerManager.Instance.Self.Money)
         {
            _loc1_ = LeavePageManager.showFillFrame();
         }
         else if(this.price.giftValue > PlayerManager.Instance.Self.Gift)
         {
            _loc1_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("store.view.transfer.StoreIITransferBG.lijinbuzu"),LanguageMgr.GetTranslation("ok"),"",true,false,false,LayerManager.ALPHA_BLOCKGOUND);
         }
         _loc1_.moveEnable = false;
      }
      
      public function dispose() : void
      {
         InventoryItemInfo.startTimer();
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__onPlayerPropertyChange);
         this._frame.removeEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._chargeBtn.removeEventListener(MouseEvent.CLICK,this.__onChargeClick);
         this._affirmContinuBt.removeEventListener(MouseEvent.CLICK,this._clickContinuBt);
         this._frame.dispose();
         this._frame = null;
         this.price = null;
         this._bg = null;
         this._chargeBtn = null;
         this._itemContainer = null;
         this._scrollPanel = null;
         this._equipList = null;
         this._costMoneyTxt = null;
         this._costGiftTxt = null;
         this._playerMoneyTxt = null;
         this._playerGiftTxt = null;
         this._currentCountTxt = null;
         this._affirmContinuBt = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}
