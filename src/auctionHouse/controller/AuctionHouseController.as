package auctionHouse.controller
{
   import auctionHouse.AuctionState;
   import auctionHouse.IAuctionHouse;
   import auctionHouse.analyze.AuctionAnalyzer;
   import auctionHouse.model.AuctionHouseModel;
   import auctionHouse.view.AuctionHouseView;
   import auctionHouse.view.AuctionRightView;
   import auctionHouse.view.SimpleLoading;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.LoaderManager;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.utils.MD5;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.auctionHouse.AuctionGoodsInfo;
   import ddt.data.goods.CateCoryInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TaskManager;
   import ddt.states.BaseStateView;
   import ddt.states.StateType;
   import ddt.utils.RequestVairableCreater;
   import ddt.view.MainToolBar;
   import flash.net.URLVariables;
   import trainer.data.Step;
   
   public class AuctionHouseController extends BaseStateView
   {
       
      
      private var _model:AuctionHouseModel;
      
      private var _view:IAuctionHouse;
      
      private var _rightView:AuctionRightView;
      
      public function AuctionHouseController()
      {
         super();
      }
      
      override public function enter(param1:BaseStateView, param2:Object = null) : void
      {
         super.enter(param1,param2);
         this._model = new AuctionHouseModel();
         this._view = new AuctionHouseView(this,this._model);
         this._view.show();
         AuctionState.CURRENTSTATE = "browse";
         this._model.category = ItemManager.Instance.categorys;
         MainToolBar.Instance.show();
         MainToolBar.Instance.setAuctionHouseState();
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.AUCTION_REFRESH,this.__updateAuction);
         if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.VISIT_AUCTION) && Boolean(TaskManager.getQuestDataByID(466)))
         {
            SocketManager.Instance.out.sendQuestCheck(466,1,0);
            SocketManager.Instance.out.syncWeakStep(Step.VISIT_AUCTION);
         }
      }
      
      public function set model(param1:AuctionHouseModel) : void
      {
         this._model = param1;
      }
      
      public function get model() : AuctionHouseModel
      {
         return this._model;
      }
      
      override public function leaving(param1:BaseStateView) : void
      {
         super.leaving(param1);
         this.dispose();
         MainToolBar.Instance.hide();
         PlayerManager.Instance.Self.unlockAllBag();
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.AUCTION_REFRESH,this.__updateAuction);
      }
      
      override public function getBackType() : String
      {
         return StateType.MAIN;
      }
      
      override public function getType() : String
      {
         return StateType.AUCTION;
      }
      
      public function setState(param1:String) : void
      {
         this._model.state = param1;
         AuctionState.CURRENTSTATE = param1;
      }
      
      public function browseTypeChange(param1:CateCoryInfo, param2:int = -1) : void
      {
         var _loc3_:CateCoryInfo = null;
         if(param1 == null)
         {
            _loc3_ = this._model.getCatecoryById(param2);
         }
         else
         {
            _loc3_ = param1;
         }
         this._model.currentBrowseGoodInfo = _loc3_;
      }
      
      public function browseTypeChangeNull() : void
      {
         this._model.currentBrowseGoodInfo = null;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(Boolean(this._view))
         {
            this._view.hide();
         }
         this._view = null;
         if(Boolean(this._model))
         {
            this._model.dispose();
         }
         this._model = null;
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
      
      public function searchAuctionList(param1:int, param2:String, param3:int, param4:int, param5:int, param6:int, param7:uint = 0, param8:String = "false", param9:String = "") : void
      {
         if(AuctionHouseModel.searchType == 1)
         {
            param2 = "";
         }
         this.startLoadAuctionInfo(param1,param2,param3,param4,param5,param6,param7,param8,param9);
         (this._view as AuctionHouseView).forbidChangeState();
      }
      
      private function startLoadAuctionInfo(param1:int, param2:String, param3:int, param4:int, param5:int, param6:int, param7:uint = 0, param8:String = "false", param9:String = "") : void
      {
         var _loc10_:URLVariables = RequestVairableCreater.creatWidthKey(true);
         _loc10_["page"] = param1;
         _loc10_["name"] = param2;
         _loc10_["type"] = param3;
         _loc10_["pay"] = param4;
         _loc10_["userID"] = param5;
         _loc10_["buyID"] = param6;
         _loc10_["order"] = param7;
         _loc10_["sort"] = param8;
         _loc10_["Auctions"] = param9;
         _loc10_["selfid"] = PlayerManager.Instance.Self.ID;
         _loc10_["key"] = MD5.hash(PlayerManager.Instance.Account.Password);
         _loc10_["rnd"] = Math.random();
         var _loc11_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("AuctionPageList.ashx"),BaseLoader.REQUEST_LOADER,_loc10_);
         _loc11_.loadErrorMessage = LanguageMgr.GetTranslation("tank.auctionHouse.controller.AuctionHouseListError");
         _loc11_.analyzer = new AuctionAnalyzer(this.__searchResult);
         LoaderManager.Instance.startLoad(_loc11_);
         _loc11_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         mouseChildren = false;
         mouseEnabled = false;
         if(AuctionHouseModel._dimBooble == false)
         {
            SimpleLoading.instance.show();
         }
      }
      
      private function __searchResult(param1:AuctionAnalyzer) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         mouseChildren = true;
         mouseEnabled = true;
         if(!this._view)
         {
            return;
         }
         SimpleLoading.instance.hide();
         var _loc6_:Vector.<AuctionGoodsInfo> = param1.list;
         if(this._model.state == AuctionState.SELL)
         {
            this._model.clearMyAuction();
            _loc2_ = 0;
            while(_loc2_ < _loc6_.length)
            {
               this._model.addMyAuction(_loc6_[_loc2_]);
               _loc2_++;
            }
            this._model.sellTotal = param1.total;
         }
         else if(this._model.state == AuctionState.BROWSE)
         {
            this._model.clearBrowseAuctionData();
            if(_loc6_.length == 0 && AuctionHouseModel.searchType != 3)
            {
               if(AuctionHouseModel._dimBooble == false)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.auctionHouse.controller.AuctionHouseController"));
               }
            }
            _loc3_ = 0;
            while(_loc3_ < _loc6_.length)
            {
               this._model.addBrowseAuctionData(_loc6_[_loc3_]);
               _loc3_++;
            }
            this._model.browseTotal = param1.total;
         }
         else if(this._model.state == AuctionState.BUY)
         {
            _loc4_ = new Array();
            this._model.clearBuyAuctionData();
            _loc5_ = 0;
            while(_loc5_ < _loc6_.length)
            {
               this._model.addBuyAuctionData(_loc6_[_loc5_]);
               _loc4_.push(_loc6_[_loc5_].AuctionID);
               _loc5_++;
            }
            this._model.buyTotal = param1.total;
            SharedManager.Instance.AuctionIDs[PlayerManager.Instance.Self.ID] = _loc4_;
            SharedManager.Instance.save();
         }
         (this._view as AuctionHouseView).allowChangeState();
      }
      
      private function __onLoadError(param1:LoaderEvent) : void
      {
         var _loc2_:String = param1.loader.loadErrorMessage;
         if(Boolean(param1.loader.analyzer))
         {
            _loc2_ = param1.loader.loadErrorMessage + "\n" + param1.loader.analyzer.message;
         }
         var _loc3_:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("alert"),param1.loader.loadErrorMessage,LanguageMgr.GetTranslation("tank.view.bagII.baglocked.sure"));
         _loc3_.addEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
      }
      
      private function __onAlertResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         param1.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
         ObjectUtils.disposeObject(param1.currentTarget);
      }
      
      private function __updateAuction(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:InventoryItemInfo = null;
         param1.pkg.deCompress();
         var _loc4_:AuctionGoodsInfo = new AuctionGoodsInfo();
         _loc4_.AuctionID = param1.pkg.readInt();
         var _loc5_:Boolean = param1.pkg.readBoolean();
         if(_loc5_)
         {
            _loc4_.AuctioneerID = param1.pkg.readInt();
            _loc4_.AuctioneerName = param1.pkg.readUTF();
            _loc4_.beginDateObj = param1.pkg.readDate();
            _loc4_.BuyerID = param1.pkg.readInt();
            _loc4_.BuyerName = param1.pkg.readUTF();
            _loc4_.ItemID = param1.pkg.readInt();
            _loc4_.Mouthful = param1.pkg.readInt();
            _loc4_.PayType = param1.pkg.readInt();
            _loc4_.Price = param1.pkg.readInt();
            _loc4_.Rise = param1.pkg.readInt();
            _loc4_.ValidDate = param1.pkg.readInt();
            _loc2_ = param1.pkg.readBoolean();
            if(_loc2_)
            {
               _loc3_ = new InventoryItemInfo();
               _loc3_.Count = param1.pkg.readInt();
               _loc3_.TemplateID = param1.pkg.readInt();
               _loc3_.AttackCompose = param1.pkg.readInt();
               _loc3_.DefendCompose = param1.pkg.readInt();
               _loc3_.AgilityCompose = param1.pkg.readInt();
               _loc3_.LuckCompose = param1.pkg.readInt();
               _loc3_.StrengthenLevel = param1.pkg.readInt();
               _loc3_.IsBinds = param1.pkg.readBoolean();
               _loc3_.IsJudge = param1.pkg.readBoolean();
               _loc3_.BeginDate = param1.pkg.readDateString();
               _loc3_.ValidDate = param1.pkg.readInt();
               _loc3_.Color = param1.pkg.readUTF();
               _loc3_.Skin = param1.pkg.readUTF();
               _loc3_.IsUsed = param1.pkg.readBoolean();
               _loc3_.Hole1 = param1.pkg.readInt();
               _loc3_.Hole2 = param1.pkg.readInt();
               _loc3_.Hole3 = param1.pkg.readInt();
               _loc3_.Hole4 = param1.pkg.readInt();
               _loc3_.Hole5 = param1.pkg.readInt();
               _loc3_.Hole6 = param1.pkg.readInt();
               _loc3_.Pic = param1.pkg.readUTF();
               _loc3_.RefineryLevel = param1.pkg.readInt();
               _loc3_.DiscolorValidDate = param1.pkg.readDateString();
               _loc3_.Hole5Level = param1.pkg.readByte();
               _loc3_.Hole5Exp = param1.pkg.readInt();
               _loc3_.Hole6Level = param1.pkg.readByte();
               _loc3_.Hole6Exp = param1.pkg.readInt();
               ItemManager.fill(_loc3_);
               _loc4_.BagItemInfo = _loc3_;
               this._model.sellTotal += 1;
            }
            this._model.addMyAuction(_loc4_);
         }
         else
         {
            this._model.removeMyAuction(_loc4_);
         }
      }
      
      public function visibleHelp(param1:AuctionRightView, param2:int) : void
      {
         this._rightView = param1;
      }
   }
}
