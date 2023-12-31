package latentEnergy
{
   import bagAndInfo.cell.BagCell;
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BagInfo;
   import ddt.data.UIModuleTypes;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.BagEvent;
   import ddt.events.CellEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import ddt.view.UIModuleSmallLoading;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class LatentEnergyMainView extends Sprite implements Disposeable
   {
       
      
      private var _bg:Bitmap;
      
      private var _openBtn:SimpleBitmapButton;
      
      private var _replaceBtn:SimpleBitmapButton;
      
      private var _bagList:latentEnergy.LatentEnergyBagListView;
      
      private var _proBagList:latentEnergy.LatentEnergyBagListView;
      
      private var _leftDrapSprite:latentEnergy.LatentEnergyLeftDragSprite;
      
      private var _rightDrapSprite:latentEnergy.LatentEnergyRightDragSprite;
      
      private var _itemPlace:int;
      
      private var _itemCell:latentEnergy.LatentEnergyItemCell;
      
      private var _equipCell:latentEnergy.LatentEnergyEquipCell;
      
      private var _moreLessIconMcList:Vector.<MovieClip>;
      
      private var _leftProTxtList:Vector.<FilterFrameText>;
      
      private var _rightProTxtList:Vector.<FilterFrameText>;
      
      private var _noProTxt:String;
      
      private var _delayIndex:int;
      
      private var _equipBagInfo:BagInfo;
      
      private var _isDispose:Boolean = false;
      
      public function LatentEnergyMainView()
      {
         super();
         this.mouseEnabled = false;
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.LATENT_ENERGY);
      }
      
      private function onUimoduleLoadProgress(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.LATENT_ENERGY)
         {
            UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
         }
      }
      
      private function loadCompleteHandler(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.LATENT_ENERGY)
         {
            UIModuleSmallLoading.Instance.hide();
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
            this.initThis();
         }
      }
      
      private function initThis() : void
      {
         this.initView();
         this.initEvent();
         this.createAcceptDragSprite();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.latentEnergyFrame.bg");
         this._openBtn = ComponentFactory.Instance.creatComponentByStylename("latentEnergyFrame.openBtn");
         this._openBtn.enable = false;
         this._replaceBtn = ComponentFactory.Instance.creatComponentByStylename("latentEnergyFrame.replaceBtn");
         this._replaceBtn.enable = false;
         this._bagList = new latentEnergy.LatentEnergyBagListView(BagInfo.EQUIPBAG,7,21);
         PositionUtils.setPos(this._bagList,"latentEnergyFrame.bagListPos");
         this.refreshBagList();
         this._proBagList = new latentEnergy.LatentEnergyBagListView(BagInfo.PROPBAG,7,21);
         PositionUtils.setPos(this._proBagList,"latentEnergyFrame.proBagListPos");
         this._proBagList.setData(LatentEnergyManager.instance.getLatentEnergyItemData());
         this._equipCell = new latentEnergy.LatentEnergyEquipCell(0,null,true,new Bitmap(new BitmapData(60,60,true,0)),false);
         this._equipCell.BGVisible = false;
         PositionUtils.setPos(this._equipCell,"latentEnergyFrame.equipCellPos");
         this._itemCell = new latentEnergy.LatentEnergyItemCell(this._itemPlace,null,true,new Bitmap(new BitmapData(60,60,true,0)),false);
         PositionUtils.setPos(this._itemCell,"latentEnergyFrame.itemCellPos");
         this._itemCell.BGVisible = false;
         this._bg.x = 30;
         addChild(this._bg);
         addChild(this._openBtn);
         addChild(this._replaceBtn);
         addChild(this._bagList);
         addChild(this._proBagList);
         addChild(this._equipCell);
         addChild(this._itemCell);
         this.createTxtView();
      }
      
      private function refreshBagList() : void
      {
         this._equipBagInfo = LatentEnergyManager.instance.getCanLatentEnergyData();
         this._bagList.setData(this._equipBagInfo);
      }
      
      private function createTxtView() : void
      {
         var _loc2_:FilterFrameText = null;
         var _loc4_:int = 0;
         var _loc1_:FilterFrameText = null;
         _loc1_ = null;
         _loc2_ = null;
         var _loc3_:MovieClip = null;
         this._noProTxt = LanguageMgr.GetTranslation("ddt.latentEnergy.oldProNoTxt");
         this._leftProTxtList = new Vector.<FilterFrameText>(4);
         this._rightProTxtList = new Vector.<FilterFrameText>(4);
         this._moreLessIconMcList = new Vector.<MovieClip>(4);
         _loc4_ = 1;
         while(_loc4_ <= 4)
         {
            _loc1_ = ComponentFactory.Instance.creatComponentByStylename("latentEnergyFrame.leftProTxt");
            PositionUtils.setPos(_loc1_,"latentEnergyFrame.leftProTxtPos" + _loc4_);
            _loc1_.visible = false;
            addChild(_loc1_);
            this._leftProTxtList[_loc4_ - 1] = _loc1_;
            _loc2_ = ComponentFactory.Instance.creatComponentByStylename("latentEnergyFrame.rightProTxt");
            PositionUtils.setPos(_loc2_,"latentEnergyFrame.rightProTxtPos" + _loc4_);
            _loc2_.visible = false;
            addChild(_loc2_);
            this._rightProTxtList[_loc4_ - 1] = _loc2_;
            _loc3_ = ComponentFactory.Instance.creat("asset.latentEnergyFrame.moreLessIcon");
            PositionUtils.setPos(_loc3_,"latentEnergyFrame.moreLessIconPos" + _loc4_);
            _loc3_.gotoAndStop(3);
            addChild(_loc3_);
            this._moreLessIconMcList[_loc4_ - 1] = _loc3_;
            _loc4_++;
         }
      }
      
      public function set itemPlace(param1:int) : void
      {
         this._itemPlace = param1;
         var _loc2_:InventoryItemInfo = PlayerManager.Instance.Self.PropBag.items[this._itemPlace] as InventoryItemInfo;
         this._itemCell = new latentEnergy.LatentEnergyItemCell(this._itemPlace,_loc2_,true,new Bitmap(new BitmapData(60,60,true,0)),false);
         PositionUtils.setPos(this._itemCell,"latentEnergyFrame.itemCellPos");
         this._itemCell.BGVisible = false;
         addChild(this._itemCell);
         this._equipCell.latentEnergyItemId = _loc2_.TemplateID;
      }
      
      private function createAcceptDragSprite() : void
      {
         this._leftDrapSprite = new latentEnergy.LatentEnergyLeftDragSprite();
         this._leftDrapSprite.mouseEnabled = false;
         this._leftDrapSprite.mouseChildren = false;
         this._leftDrapSprite.graphics.beginFill(0,0);
         this._leftDrapSprite.graphics.drawRect(0,0,347,404);
         this._leftDrapSprite.graphics.endFill();
         PositionUtils.setPos(this._leftDrapSprite,"latentEnergyFrame.leftDrapSpritePos");
         addChild(this._leftDrapSprite);
         this._rightDrapSprite = new latentEnergy.LatentEnergyRightDragSprite();
         this._rightDrapSprite.mouseEnabled = false;
         this._rightDrapSprite.mouseChildren = false;
         this._rightDrapSprite.graphics.beginFill(0,0);
         this._rightDrapSprite.graphics.drawRect(0,0,374,407);
         this._rightDrapSprite.graphics.endFill();
         PositionUtils.setPos(this._rightDrapSprite,"latentEnergyFrame.rightDrapSpritePos");
         addChild(this._rightDrapSprite);
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._openBtn.addEventListener(MouseEvent.CLICK,this.openHandler,false,0,true);
         this._replaceBtn.addEventListener(MouseEvent.CLICK,this.replaceHandler,false,0,true);
         this._bagList.addEventListener(CellEvent.ITEM_CLICK,this.cellClickHandler,false,0,true);
         this._bagList.addEventListener(CellEvent.DOUBLE_CLICK,this.__cellDoubleClick,false,0,true);
         this._equipCell.addEventListener(Event.CHANGE,this.equipChangeHandler,false,0,true);
         this._proBagList.addEventListener(CellEvent.ITEM_CLICK,this.cellClickHandler,false,0,true);
         this._proBagList.addEventListener(CellEvent.DOUBLE_CLICK,this.__cellDoubleClick,false,0,true);
         this._itemCell.addEventListener(Event.CHANGE,this.itemChangeHandler,false,0,true);
         PlayerManager.Instance.Self.PropBag.addEventListener(BagEvent.UPDATE,this.propInfoChangeHandler);
         PlayerManager.Instance.Self.Bag.addEventListener(BagEvent.UPDATE,this.bagInfoChangeHandler);
         LatentEnergyManager.instance.addEventListener(LatentEnergyManager.EQUIP_CHANGE,this.equipInfoChangeHandler);
      }
      
      private function bagInfoChangeHandler(param1:BagEvent) : void
      {
         var _loc2_:InventoryItemInfo = null;
         var _loc3_:InventoryItemInfo = null;
         var _loc4_:BagInfo = null;
         var _loc5_:Dictionary = param1.changedSlots;
         for each(_loc3_ in _loc5_)
         {
            _loc2_ = _loc3_;
         }
         if(Boolean(_loc2_) && !PlayerManager.Instance.Self.Bag.items[_loc2_.Place])
         {
            if(Boolean(this._equipCell.info) && (this._equipCell.info as InventoryItemInfo).Place == _loc2_.Place)
            {
               this._equipCell.info = null;
            }
            else
            {
               this.refreshBagList();
            }
         }
         else
         {
            _loc4_ = LatentEnergyManager.instance.getCanLatentEnergyData();
            if(_loc4_.items.length != this._equipBagInfo.items.length)
            {
               this._equipBagInfo = _loc4_;
               this._bagList.setData(this._equipBagInfo);
            }
         }
      }
      
      private function equipInfoChangeHandler(param1:Event) : void
      {
         this.refreshCurProView();
         this.refreshNewProView();
      }
      
      private function propInfoChangeHandler(param1:BagEvent) : void
      {
         var _loc2_:InventoryItemInfo = null;
         var _loc3_:InventoryItemInfo = null;
         var _loc4_:InventoryItemInfo = null;
         var _loc5_:Dictionary = param1.changedSlots;
         for each(_loc3_ in _loc5_)
         {
            _loc2_ = _loc3_;
         }
         if(Boolean(_loc2_) && !PlayerManager.Instance.Self.PropBag.items[_loc2_.Place])
         {
            if(Boolean(this._itemCell.info) && (this._itemCell.info as InventoryItemInfo).Place == _loc2_.Place)
            {
               this._itemCell.info = null;
            }
            else
            {
               this._proBagList.setData(LatentEnergyManager.instance.getLatentEnergyItemData());
            }
         }
         else
         {
            if(!this._itemCell || !this._itemCell.info)
            {
               return;
            }
            _loc4_ = this._itemCell.info as InventoryItemInfo;
            if(!PlayerManager.Instance.Self.PropBag.items[_loc4_.Place])
            {
               this._itemCell.info = null;
            }
            else
            {
               this._itemCell.setCount(_loc4_.Count);
            }
         }
      }
      
      private function openHandler(param1:MouseEvent) : void
      {
         var _loc2_:BaseAlerFrame = null;
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(!this._equipCell.info)
         {
            return;
         }
         if(!this._itemCell.info)
         {
            return;
         }
         if((this._itemCell.info as InventoryItemInfo).Count <= 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.latentEnergy.noEnoughItem"));
            return;
         }
         if(!(this._equipCell.info as InventoryItemInfo).IsBinds)
         {
            _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.latentEnergy.bindTipTxt"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.BLCAK_BLOCKGOUND);
            _loc2_.moveEnable = false;
            _loc2_.addEventListener(FrameEvent.RESPONSE,this.__confirm,false,0,true);
         }
         else
         {
            this.doOpenHandler();
         }
      }
      
      private function doOpenHandler() : void
      {
         var _loc1_:InventoryItemInfo = this._equipCell.info as InventoryItemInfo;
         var _loc2_:InventoryItemInfo = this._itemCell.info as InventoryItemInfo;
         SocketManager.Instance.out.sendLatentEnergy(1,_loc1_.BagType,_loc1_.Place,_loc2_.BagType,_loc2_.Place);
         this._openBtn.enable = false;
         this._delayIndex = setTimeout(this.openBtnEnableHandler,1000);
      }
      
      private function __confirm(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__confirm);
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK || param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            this.doOpenHandler();
         }
      }
      
      private function openBtnEnableHandler() : void
      {
         if(this._equipCell && this._openBtn && Boolean(this._itemCell))
         {
            if(Boolean(this._equipCell.info) && Boolean(this._itemCell.info))
            {
               this._openBtn.enable = true;
            }
            else
            {
               this._openBtn.enable = false;
            }
         }
      }
      
      private function replaceHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(!this._equipCell.info)
         {
            return;
         }
         if(!(this._equipCell.info as InventoryItemInfo).isHasLatenetEnergyNew)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.latentEnergy.noNewProperty"));
            this._replaceBtn.enable = false;
            return;
         }
         var _loc2_:InventoryItemInfo = this._equipCell.info as InventoryItemInfo;
         SocketManager.Instance.out.sendLatentEnergy(2,_loc2_.BagType,_loc2_.Place);
      }
      
      private function itemChangeHandler(param1:Event) : void
      {
         if(Boolean(this._itemCell.info))
         {
            this._equipCell.latentEnergyItemId = this._itemCell.info.TemplateID;
         }
         else
         {
            this._equipCell.latentEnergyItemId = 0;
         }
         this.equipChangeHandler(null);
      }
      
      private function equipChangeHandler(param1:Event) : void
      {
         var _loc2_:int = 0;
         if(Boolean(this._equipCell.info))
         {
            this.refreshCurProView();
            this.refreshNewProView();
         }
         else
         {
            this._replaceBtn.enable = false;
            _loc2_ = 0;
            while(_loc2_ < 4)
            {
               this._leftProTxtList[_loc2_].visible = false;
               this._rightProTxtList[_loc2_].visible = false;
               this._moreLessIconMcList[_loc2_].gotoAndStop(3);
               _loc2_++;
            }
         }
         if(Boolean(this._equipCell.info) && Boolean(this._itemCell.info))
         {
            this._openBtn.enable = true;
         }
         else
         {
            this._openBtn.enable = false;
         }
      }
      
      private function refreshCurProView() : void
      {
         var _loc1_:Array = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(!this._equipCell.info)
         {
            return;
         }
         var _loc4_:InventoryItemInfo = this._equipCell.info as InventoryItemInfo;
         if(_loc4_.isHasLatentEnergy)
         {
            _loc1_ = _loc4_.latentEnergyCurList;
            _loc2_ = 0;
            while(_loc2_ < 4)
            {
               this._leftProTxtList[_loc2_].text = _loc1_[_loc2_];
               this._leftProTxtList[_loc2_].visible = true;
               _loc2_++;
            }
         }
         else
         {
            _loc3_ = 0;
            while(_loc3_ < 4)
            {
               this._leftProTxtList[_loc3_].text = this._noProTxt;
               this._leftProTxtList[_loc3_].visible = true;
               _loc3_++;
            }
         }
      }
      
      private function refreshNewProView() : void
      {
         var _loc1_:Array = null;
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(!this._equipCell.info)
         {
            return;
         }
         var _loc5_:InventoryItemInfo = this._equipCell.info as InventoryItemInfo;
         if(_loc5_.isHasLatenetEnergyNew)
         {
            this._replaceBtn.enable = true;
            _loc1_ = _loc5_.latentEnergyNewList;
            _loc2_ = _loc5_.latentEnergyCurList;
            _loc3_ = 0;
            while(_loc3_ < 4)
            {
               this._rightProTxtList[_loc3_].text = _loc1_[_loc3_];
               this._rightProTxtList[_loc3_].visible = true;
               if(int(_loc1_[_loc3_]) > int(_loc2_[_loc3_]))
               {
                  this._moreLessIconMcList[_loc3_].gotoAndStop(1);
               }
               else if(int(_loc1_[_loc3_]) == int(_loc2_[_loc3_]))
               {
                  this._moreLessIconMcList[_loc3_].gotoAndStop(3);
               }
               else if(int(_loc1_[_loc3_]) < int(_loc2_[_loc3_]))
               {
                  this._moreLessIconMcList[_loc3_].gotoAndStop(2);
               }
               _loc3_++;
            }
         }
         else
         {
            this._replaceBtn.enable = false;
            _loc4_ = 0;
            while(_loc4_ < 4)
            {
               this._rightProTxtList[_loc4_].visible = false;
               this._moreLessIconMcList[_loc4_].gotoAndStop(3);
               _loc4_++;
            }
         }
      }
      
      protected function __cellDoubleClick(param1:CellEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc2_:String = "";
         if(param1.target == this._proBagList)
         {
            _loc2_ = LatentEnergyManager.ITEM_MOVE;
         }
         else
         {
            _loc2_ = LatentEnergyManager.EQUIP_MOVE;
         }
         var _loc3_:LatentEnergyEvent = new LatentEnergyEvent(_loc2_);
         var _loc4_:BagCell = param1.data as BagCell;
         _loc3_.info = _loc4_.info as InventoryItemInfo;
         _loc3_.moveType = 1;
         LatentEnergyManager.instance.dispatchEvent(_loc3_);
      }
      
      private function cellClickHandler(param1:CellEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:BagCell = param1.data as BagCell;
         _loc2_.dragStart();
      }
      
      override public function set visible(param1:Boolean) : void
      {
         super.visible = param1;
         if(param1)
         {
            if(!this._isDispose)
            {
               this.refreshListData();
               PlayerManager.Instance.Self.PropBag.addEventListener(BagEvent.UPDATE,this.propInfoChangeHandler);
               PlayerManager.Instance.Self.Bag.addEventListener(BagEvent.UPDATE,this.bagInfoChangeHandler);
            }
         }
         else
         {
            this.clearCellInfo();
            PlayerManager.Instance.Self.PropBag.removeEventListener(BagEvent.UPDATE,this.propInfoChangeHandler);
            PlayerManager.Instance.Self.Bag.removeEventListener(BagEvent.UPDATE,this.bagInfoChangeHandler);
         }
      }
      
      public function clearCellInfo() : void
      {
         if(Boolean(this._equipCell))
         {
            this._equipCell.clearInfo();
         }
         if(Boolean(this._itemCell))
         {
            this._itemCell.clearInfo();
         }
      }
      
      public function refreshListData() : void
      {
         if(Boolean(this._bagList))
         {
            this.refreshBagList();
         }
         if(Boolean(this._proBagList))
         {
            this._proBagList.setData(LatentEnergyManager.instance.getLatentEnergyItemData());
         }
      }
      
      private function __responseHandler(param1:FrameEvent) : void
      {
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            this.dispose();
         }
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._openBtn.removeEventListener(MouseEvent.CLICK,this.openHandler);
         this._replaceBtn.removeEventListener(MouseEvent.CLICK,this.replaceHandler);
         this._bagList.removeEventListener(CellEvent.ITEM_CLICK,this.cellClickHandler);
         this._bagList.removeEventListener(CellEvent.DOUBLE_CLICK,this.__cellDoubleClick);
         this._equipCell.removeEventListener(Event.CHANGE,this.equipChangeHandler);
         this._proBagList.removeEventListener(CellEvent.ITEM_CLICK,this.cellClickHandler);
         this._proBagList.removeEventListener(CellEvent.DOUBLE_CLICK,this.__cellDoubleClick);
         this._itemCell.removeEventListener(Event.CHANGE,this.itemChangeHandler);
         PlayerManager.Instance.Self.PropBag.removeEventListener(BagEvent.UPDATE,this.propInfoChangeHandler);
         PlayerManager.Instance.Self.Bag.removeEventListener(BagEvent.UPDATE,this.bagInfoChangeHandler);
         LatentEnergyManager.instance.removeEventListener(LatentEnergyManager.EQUIP_CHANGE,this.equipInfoChangeHandler);
      }
      
      public function dispose() : void
      {
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
         this.removeEvent();
         clearTimeout(this._delayIndex);
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         this._openBtn = null;
         this._replaceBtn = null;
         this._bagList = null;
         this._proBagList = null;
         this._leftDrapSprite = null;
         this._rightDrapSprite = null;
         this._itemCell = null;
         this._equipCell = null;
         this._moreLessIconMcList = null;
         this._leftProTxtList = null;
         this._rightProTxtList = null;
         this._noProTxt = null;
         this._equipBagInfo = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
         this._isDispose = true;
      }
   }
}
