package ddt.view.tips
{
   import AvatarCollection.AvatarCollectionManager;
   import GodSyah.SyahManager;
   import GodSyah.SyahTip;
   import bagAndInfo.BagAndInfoManager;
   import bagAndInfo.bag.ring.RingSystemTip;
   import bagAndInfo.info.PlayerInfoViewControl;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.tip.BaseTip;
   import com.pickgliss.ui.tip.ITip;
   import ddt.bagStore.BagStore;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.goods.QualityType;
   import ddt.data.goods.ShopItemInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.data.store.FineSuitVo;
   import ddt.manager.FineSuitManager;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.TimeManager;
   import ddt.utils.PositionUtils;
   import ddt.utils.StaticFormula;
   import ddt.view.SimpleItem;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.text.TextFormat;
   import gemstone.GemstoneManager;
   import gemstone.items.GemstonTipItem;
   import latentEnergy.LatentEnergyTipItem;
   import road7th.utils.DateUtils;
   import road7th.utils.StringHelper;
   import store.data.StoreEquipExperience;
   import store.equipGhost.EquipGhostManager;
   import store.equipGhost.data.GhostPropertyData;
   
   public class GoodTip extends BaseTip implements Disposeable, ITip
   {
      
      public static const BOUND:uint = 1;
      
      public static const UNBOUND:uint = 2;
      
      public static const ITEM_NORMAL_COLOR:uint = 16777215;
      
      public static const ITEM_BADGE_COLOR:uint = 65280;
      
      public static const ITEM_PROPERTIES_COLOR:uint = 16750899;
      
      public static const ITEM_HOLES_COLOR:uint = 16777215;
      
      public static const ITEM_HOLE_RESERVE_COLOR:uint = 16776960;
      
      public static const ITEM_HOLE_GREY_COLOR:uint = 6710886;
      
      public static const ITEM_FIGHT_PROP_CONSUME_COLOR:uint = 14520832;
      
      public static const ITEM_NEED_LEVEL_COLOR:uint = 13421772;
      
      public static const ITEM_NEED_LEVEL_FAILED_COLOR:uint = 16711680;
      
      public static const ITEM_UPGRADE_TYPE_COLOR:uint = 10092339;
      
      public static const ITEM_NEED_SEX_COLOR:uint = 10092339;
      
      public static const ITEM_NEED_SEX_FAILED_COLOR:uint = 16711680;
      
      public static const ITEM_ETERNAL_COLOR:uint = 16776960;
      
      public static const ITEM_PAST_DUE_COLOR:uint = 16711680;
      
      private static const PET_SPECIAL_FOOD:int = 334100;
      
      public static const ITEM_NECKLACE_COLOR:uint = 16750899;
       
      
      private var _strengthenLevelImage:MovieImage;
      
      private var _fusionLevelImage:MovieImage;
      
      private var _boundImage:ScaleFrameImage;
      
      private var _nameTxt:FilterFrameText;
      
      private var _qualityItem:SimpleItem;
      
      private var _typeItem:SimpleItem;
      
      private var _expItem:SimpleItem;
      
      private var _mainPropertyItem:SimpleItem;
      
      private var _armAngleItem:SimpleItem;
      
      private var _otherHp:SimpleItem;
      
      private var _necklaceItem:FilterFrameText;
      
      private var _attackTxt:FilterFrameText;
      
      private var _defenseTxt:FilterFrameText;
      
      private var _agilityTxt:FilterFrameText;
      
      private var _luckTxt:FilterFrameText;
      
      private var _needLevelTxt:FilterFrameText;
      
      private var _needSexTxt:FilterFrameText;
      
      private var _holes:Vector.<FilterFrameText>;
      
      private var _upgradeType:FilterFrameText;
      
      private var _descriptionTxt:FilterFrameText;
      
      private var _bindTypeTxt:FilterFrameText;
      
      private var _remainTimeTxt:FilterFrameText;
      
      private var _goldRemainTimeTxt:FilterFrameText;
      
      private var _fightPropConsumeTxt:FilterFrameText;
      
      private var _boxTimeTxt:FilterFrameText;
      
      private var _info:ItemTemplateInfo;
      
      private var _bindImageOriginalPos:Point;
      
      private var _maxWidth:int;
      
      private var _minWidth:int = 196;
      
      private var _isArmed:Boolean;
      
      private var _displayList:Vector.<DisplayObject>;
      
      private var _displayIdx:int;
      
      private var _lines:Vector.<Image>;
      
      private var _lineIdx:int;
      
      private var _isReAdd:Boolean;
      
      private var _remainTimeBg:Bitmap;
      
      private var _gp:FilterFrameText;
      
      private var _maxGP:FilterFrameText;
      
      private var _levelTxt:FilterFrameText;
      
      private var _laterEquipmentView:ddt.view.tips.LaterEquipmentGoodView;
      
      protected var syahTip:SyahTip;
      
      private var _addition:RingSystemTip;
      
      private var _suitIcon:ScaleFrameImage;
      
      private var _nameContent:Sprite;
      
      private var _exp:int;
      
      private var _UpExp:int;
      
      private var _autoGhostWidth:int;
      
      private var _ghostPropertyData:GhostPropertyData;
      
      private var _ghostStartsContainer:ddt.view.tips.GhostStarContainer = null;
      
      private var _avatarTxt:FilterFrameText;
      
      public function GoodTip()
      {
         this._holes = new Vector.<FilterFrameText>();
         super();
      }
      
      override protected function init() : void
      {
         this._lines = new Vector.<Image>();
         this._displayList = new Vector.<DisplayObject>();
         _tipbackgound = ComponentFactory.Instance.creat("core.GoodsTipBg");
         this._strengthenLevelImage = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemNameMc");
         this._fusionLevelImage = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTrinketLevelMc");
         this._boundImage = ComponentFactory.Instance.creatComponentByStylename("core.goodTip.BoundImage");
         this._bindImageOriginalPos = new Point(this._boundImage.x,this._boundImage.y);
         this._nameContent = new Sprite();
         this._suitIcon = ComponentFactory.Instance.creatComponentByStylename("fineSuit.tips.image");
         this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemNameTxt");
         this._qualityItem = ComponentFactory.Instance.creatComponentByStylename("core.goodTip.QualityItem");
         this._typeItem = ComponentFactory.Instance.creatComponentByStylename("core.goodTip.TypeItem");
         this._expItem = ComponentFactory.Instance.creatComponentByStylename("core.goodTip.EXPItem");
         this._mainPropertyItem = ComponentFactory.Instance.creatComponentByStylename("core.goodTip.MainPropertyItem");
         this._armAngleItem = ComponentFactory.Instance.creatComponentByStylename("core.goodTip.armAngleItem");
         this._otherHp = ComponentFactory.Instance.creatComponentByStylename("core.goodTip.otherHp");
         this._necklaceItem = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
         this._attackTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
         this._defenseTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
         this._agilityTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
         this._luckTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
         this._levelTxt = ComponentFactory.Instance.creatComponentByStylename("core.goodTip.LimitGradeTxt");
         this._gp = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
         this._maxGP = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
         this._holes = new Vector.<FilterFrameText>();
         var _loc1_:int = 0;
         while(_loc1_ < 6)
         {
            this._holes.push(ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt"));
            _loc1_++;
         }
         this._needLevelTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
         this._needSexTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
         this._upgradeType = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
         this._descriptionTxt = ComponentFactory.Instance.creatComponentByStylename("core.goodTip.DescriptionTxt");
         this._bindTypeTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
         this._remainTimeTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemDateTxt");
         this._goldRemainTimeTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipGoldItemDateTxt");
         this._remainTimeBg = ComponentFactory.Instance.creatBitmap("asset.core.tip.restTime");
         this._fightPropConsumeTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
         this._boxTimeTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
         this._laterEquipmentView = new ddt.view.tips.LaterEquipmentGoodView();
         this._laterEquipmentView.visible = false;
         this._avatarTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTip.avatarItemTxt");
      }
      
      override public function get tipData() : Object
      {
         return _tipData;
      }
      
      override public function set tipData(param1:Object) : void
      {
         var _loc2_:ItemTemplateInfo = null;
         if(Boolean(param1))
         {
            if(param1 is GoodTipInfo)
            {
               _tipData = param1 as GoodTipInfo;
				if(EquipType.canBringUp(_tipData.itemInfo))
			   {
				   setJewelryExp(_tipData.itemInfo);
			   }		   
               this.showTip(_tipData.itemInfo,_tipData.typeIsSecond);
               if(PathManager.suitEnable)
               {
                  this.showSuitTip(_tipData.itemInfo);
               }
               else
               {
                  this._laterEquipmentView.visible = false;
               }
               if(SyahManager.Instance.isOpen)
               {
                  this.showSyahTip();
               }
            }
            else if(param1 is ShopItemInfo)
            {
               _tipData = param1 as ShopItemInfo;
				if(EquipType.canBringUp(_tipData.TemplateInfo))
			   {
				   setJewelryExp(_tipData.TemplateInfo);
			   }		   
               this.showTip(_tipData.TemplateInfo);
               this._laterEquipmentView.visible = false;
            }
            visible = true;
         }
         else
         {
            _tipData = null;
            visible = false;
            this._laterEquipmentView.visible = false;
         }
      }
      
      private function showSyahTip() : void
      {
         var _loc1_:* = null;
         if(Boolean(SyahManager.Instance.getSyahModeByInfo(_tipData.itemInfo)))
         {
            this.syahTip = new SyahTip();
            this.syahTip.setTipInfo(_tipData.itemInfo);
            if(this._laterEquipmentView.visible)
            {
               this.syahTip.setBGWidth(this._laterEquipmentView.getBGWidth());
               this.syahTip.x = this._laterEquipmentView.x;
               this.syahTip.y = this._laterEquipmentView.y - this.syahTip.displayHeight;
               if(this.syahTip.y + this.y < 5)
               {
                  this.syahTip.y = 0;
                  this._laterEquipmentView.y = this.syahTip.displayHeight;
               }
            }
            else
            {
               this.syahTip.setBGWidth(228);
               _loc1_ = localToGlobal(new Point(_tipbackgound.x,_tipbackgound.y));
               if(_loc1_.x + _tipbackgound.width + this.syahTip.displayWidth < StageReferance.stageWidth)
               {
                  this.syahTip.x = _width + 5;
               }
               else
               {
                  this.syahTip.x = -250;
               }
               this.syahTip.y = _tipbackgound.height - this.syahTip.displayHeight;
            }
            addChild(this.syahTip);
         }
      }
      
      public function showTip(param1:ItemTemplateInfo, param2:Boolean = false) : void
      {
         this._displayIdx = 0;
         this._displayList = new Vector.<DisplayObject>();
         this._lineIdx = 0;
         this._isReAdd = false;
         this._maxWidth = 0;
         this._autoGhostWidth = 0;
         this._info = param1;
         this._ghostPropertyData = this.getGhostPropertyData();
         this.updateView();
      }
      
      public function showSuitTip(param1:ItemTemplateInfo) : void
      {
         param1 = _tipData.itemInfo;
         if(param1 is InventoryItemInfo)
         {
            if(param1.SuitId != 0)
            {
               this._laterEquipmentView.visible = true;
               if(param1["Place"] < 20 && param1["Place"] > -1)
               {
                  if(BagStore.instance._isStoreOpen)
                  {
                     this._laterEquipmentView.x = -250;
                  }
                  else
                  {
                     this._laterEquipmentView.x = _width + 5;
                  }
               }
               else
               {
                  this._laterEquipmentView.x = -250;
               }
               this.laterEquipment(param1);
            }
            else
            {
               this._laterEquipmentView.visible = false;
            }
         }
         else
         {
            this._laterEquipmentView.visible = false;
         }
         this._laterEquipmentView.y = _tipbackgound.height - this._laterEquipmentView.height;
      }
      
      private function updateView() : void
      {
         if(this._info == null)
         {
            return;
         }
         this.clear();
         this._isArmed = false;
         this.createItemName();
         this.createQualityItem();
         this.createCategoryItem();
		 this.careteEXP();
         this.createMainProperty();
         this.seperateLine();
         this.createAvatarState();
         this.seperateLine();
         this.createNecklaceItem();
         this.createProperties();
         this.creatLevel();
         this.seperateLine();
         this.creatGemstone();
         this.seperateLine();
         this.createLatentEnergy();
         this.seperateLine();
         this.createHoleItem();
         this.createOperationItem();
         this.seperateLine();
         this.createDescript();
         this.createBindType();
         this.createRemainTime();
         this.createGoldRemainTime();
         this.createFightPropConsume();
         this.createBoxTimeItem();
         this.addChildren();
         this.createStrenthLevel();
         this.createRingAddition();
      }
      
      private function createAvatarState() : void
      {
//         var _loc1_:* = null;
//         if(this._info != null)
//         {
//            if(AvatarCollectionManager.instance.isCollectionGoodsByTemplateID(this._info.TemplateID))
//            {
//               _loc1_ = LanguageMgr.GetTranslation("ddt.goodsTip.avatarState").split(",");
//               if(this.isAvatarActivated(this._info.TemplateID))
//               {
//                  this._avatarTxt.htmlText = _loc1_[0];
//               }
//               else
//               {
//                  this._avatarTxt.htmlText = _loc1_[1];
//               }
//               var _loc2_:* = this._displayIdx++;
//               this._displayList[_loc2_] = this._avatarTxt;
//            }
//         }
      }
      
      public function isAvatarActivated(param1:int) : Boolean
      {
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc2_:Array = AvatarCollectionManager.instance.maleUnitList;
         var _loc3_:Array = AvatarCollectionManager.instance.femaleUnitList;
         var _loc4_:Array = AvatarCollectionManager.instance.weaponUnitList;
         for each(_loc5_ in _loc2_)
         {
            for each(_loc8_ in _loc5_.totalItemList)
            {
               if(_loc8_.itemInfo.TemplateID == param1)
               {
                  return _loc8_.isActivity;
               }
            }
         }
         for each(_loc6_ in _loc3_)
         {
            for each(_loc9_ in _loc6_.totalItemList)
            {
               if(_loc9_.itemInfo.TemplateID == param1)
               {
                  return _loc9_.isActivity;
               }
            }
         }
         for each(_loc7_ in _loc4_)
         {
            for each(_loc10_ in _loc7_.totalItemList)
            {
               if(_loc10_.itemInfo.TemplateID == param1)
               {
                  return _loc10_.isActivity;
               }
            }
         }
         return false;
      }
      
      private function createRingAddition() : void
      {
         var _loc1_:* = null;
         if(this._info is InventoryItemInfo && EquipType.isWeddingRing(this._info))
         {
            _loc1_ = BagAndInfoManager.Instance.getRingData(InventoryItemInfo(this._info).RingExp);
            if(PlayerManager.Instance.Self.ID == InventoryItemInfo(this._info).UserID)
            {
               _loc1_ = BagAndInfoManager.Instance.getRingData(PlayerManager.Instance.Self.RingExp);
            }
            this._addition = new RingSystemTip();
            this._addition.setAdditiontext([this._info.Attack * _loc1_.Attack,this._info.Defence * _loc1_.Defence,this._info.Agility * _loc1_.Agility,this._info.Luck * _loc1_.Luck]);
            this._addition.x = this._attackTxt.x + 130;
            this._addition.y = this._attackTxt.y + 3;
            addChild(this._addition);
         }
      }
      
      private function createLatentEnergy() : void
      {
         var _loc5_:* = undefined;
         var _loc1_:InventoryItemInfo = null;
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:LatentEnergyTipItem = null;
         if(this._info is InventoryItemInfo)
         {
            _loc1_ = this._info as InventoryItemInfo;
            if(_loc1_.isHasLatentEnergy)
            {
               _loc2_ = _loc1_.latentEnergyCurList;
               _loc3_ = 0;
               while(_loc3_ < 4)
               {
                  _loc4_ = new LatentEnergyTipItem();
                  _loc4_.setView(_loc3_,_loc2_[_loc3_]);
                  _loc5_ = this._displayIdx++;
                  this._displayList[_loc5_] = _loc4_;
                  _loc3_++;
               }
            }
         }
      }
      
      private function laterEquipment(param1:ItemTemplateInfo) : void
      {
         if(!this._laterEquipmentView)
         {
            this._laterEquipmentView = new ddt.view.tips.LaterEquipmentGoodView();
         }
         this._laterEquipmentView.tipData = param1;
      }
      
      private function clear() : void
      {
         var _loc1_:DisplayObject = null;
         while(numChildren > 0)
         {
            _loc1_ = getChildAt(0) as DisplayObject;
            if(Boolean(_loc1_.parent))
            {
               _loc1_.parent.removeChild(_loc1_);
            }
         }
      }
      
      override protected function addChildren() : void
      {
         var _loc1_:DisplayObject = null;
         var _loc2_:int = int(this._displayList.length);
         var _loc3_:Point = new Point(4,4);
         var _loc4_:int = 6;
         var _loc5_:int = this._maxWidth;
         var _loc6_:int = 0;
         while(_loc6_ < _loc2_)
         {
            _loc1_ = this._displayList[_loc6_] as DisplayObject;
            if(this._lines.indexOf(_loc1_) < 0 && _loc1_ != this._descriptionTxt)
            {
               _loc5_ = Math.max(_loc1_.width,_loc5_);
            }
            PositionUtils.setPos(_loc1_,_loc3_);
            addChild(_loc1_);
            _loc3_.y = _loc1_.y + _loc1_.height + _loc4_;
            _loc6_++;
         }
         this._maxWidth = Math.max(this._minWidth,_loc5_);
         if(this._descriptionTxt.width != this._maxWidth)
         {
            this._descriptionTxt.width = this._maxWidth;
            this._descriptionTxt.height = this._descriptionTxt.textHeight + 10;
            this.addChildren();
            return;
         }
         if(!this._isReAdd)
         {
            _loc6_ = 0;
            while(_loc6_ < this._lines.length)
            {
               this._lines[_loc6_].width = this._maxWidth;
               if(_loc6_ + 1 < this._lines.length && this._lines[_loc6_ + 1].parent != null && Math.abs(this._lines[_loc6_ + 1].y - this._lines[_loc6_].y) <= 10)
               {
                  this._displayList.splice(this._displayList.indexOf(this._lines[_loc6_ + 1]),1);
                  this._lines[_loc6_ + 1].parent.removeChild(this._lines[_loc6_ + 1]);
                  this._isReAdd = true;
               }
               _loc6_++;
            }
            if(this._isReAdd)
            {
               this.addChildren();
               return;
            }
         }
         if(_loc2_ > 0)
         {
            _width = _tipbackgound.width = this._maxWidth + 8;
            _height = _tipbackgound.height = _loc1_.y + _loc1_.height + 8;
         }
         if(Boolean(_tipbackgound))
         {
            addChildAt(_tipbackgound,0);
         }
         if(Boolean(this._remainTimeBg.parent))
         {
            this._remainTimeBg.x = this._remainTimeTxt.x + 2;
            this._remainTimeBg.y = this._remainTimeTxt.y + 2;
            this._remainTimeBg.parent.addChildAt(this._remainTimeBg,1);
         }
         if(Boolean(this._remainTimeBg.parent))
         {
            this._goldRemainTimeTxt.x = this._remainTimeTxt.x + 2;
            this._goldRemainTimeTxt.y = this._remainTimeTxt.y + 22;
            this._remainTimeBg.parent.addChildAt(this._goldRemainTimeTxt,1);
         }
         addChild(this._laterEquipmentView);
      }
      
      private function createItemName() : void
      {
         var _loc1_:GoodTipInfo = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:FineSuitVo = null;
         var _loc5_:int = 0;
         var _loc6_:Array = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:TextFormat = null;
         this._nameTxt.text = String(this._info.Name);
         var _loc10_:InventoryItemInfo = this._info as InventoryItemInfo;
         if(Boolean(_loc10_) && _loc10_.StrengthenLevel > 0)
         {
            if(_loc10_.isGold)
            {
               if(_loc10_.StrengthenLevel > PathManager.solveStrengthMax())
               {
                  this._nameTxt.text += LanguageMgr.GetTranslation("store.view.exalt.goodTips",_loc10_.StrengthenLevel - 12);
               }
               else
               {
                  this._nameTxt.text += LanguageMgr.GetTranslation("wishBead.StrengthenLevel");
               }
            }
            else if(_loc10_.StrengthenLevel <= PathManager.solveStrengthMax())
            {
               this._nameTxt.text += "(+" + (this._info as InventoryItemInfo).StrengthenLevel + ")";
            }
            else if(_loc10_.StrengthenLevel > PathManager.solveStrengthMax())
            {
               this._nameTxt.text += LanguageMgr.GetTranslation("store.view.exalt.goodTips",_loc10_.StrengthenLevel - 12);
            }
         }
         var _loc11_:int = this._nameTxt.text.indexOf("+");
         if(_loc11_ > 0)
         {
            _loc9_ = ComponentFactory.Instance.model.getSet("core.goodTip.ItemNameNumTxtFormat");
            this._nameTxt.setTextFormat(_loc9_,_loc11_,_loc11_ + 1);
         }
         if(Boolean(PlayerInfoViewControl.currentPlayer))
         {
            if(_loc10_ && _loc10_.Place == 12 && _loc10_.UserID == PlayerInfoViewControl.currentPlayer.ID && PlayerInfoViewControl.currentPlayer.necklaceLevel > 0 && _loc10_.CategoryID == EquipType.NECKLACE)
            {
               this._nameTxt.text += LanguageMgr.GetTranslation("bagAndInfo.bag.NecklacePtetrochemicalView.goodTip",PlayerInfoViewControl.currentPlayer.necklaceLevel);
            }
         }
         this._nameTxt.textColor = QualityType.QUALITY_COLOR[this._info.Quality];
         if(_tipData is GoodTipInfo && _loc10_ && Boolean(_loc10_.UserID))
         {
            _loc1_ = _tipData as GoodTipInfo;
            if(_loc1_.suitIcon)
            {
               if(_loc10_.CategoryID == 1 || _loc10_.CategoryID == 2 || _loc10_.CategoryID == 3 || _loc10_.CategoryID == 4 || _loc10_.CategoryID == 5 || _loc10_.CategoryID == 6 || _loc10_.CategoryID == 8 || _loc10_.CategoryID == 9 || _loc10_.CategoryID == 13 || _loc10_.CategoryID == 14 || _loc10_.CategoryID == 15)
               {
                  _loc2_ = PlayerManager.Instance.findPlayer(_loc10_.UserID).fineSuitExp;
                  _loc3_ = FineSuitManager.Instance.getSuitVoByLevel(1).exp;
                  _loc4_ = FineSuitManager.Instance.getSuitVoByExp(_loc2_);
                  _loc5_ = _loc4_.level;
                  if(_loc5_ > 14)
                  {
                     _loc5_ = int(_loc5_ % 14) == 0 ? int(14) : int(int(_loc5_ % 14));
                  }
                  _loc6_ = [0,1,2,3,4,5,11,13,12,16,9,10,7,8];
                  _loc7_ = _loc6_.indexOf(_loc10_.Place) + 1;
                  _loc8_ = _loc4_.type;
                  if(_loc7_ > _loc5_)
                  {
                     _loc8_--;
                  }
                  if(_loc2_ < _loc3_ || _loc8_ <= 0)
                  {
                     var _loc13_:* = this._displayIdx++;
                     this._displayList[_loc13_] = this._nameTxt;
                     return;
                  }
                  this._suitIcon.setFrame(_loc8_);
                  this._nameContent.addChild(this._suitIcon);
                  this._nameContent.addChild(this._nameTxt);
                  this._suitIcon.x = 0;
                  this._suitIcon.y = 0;
                  this._nameTxt.x = 30;
                  this._nameTxt.y = 8;
                  _loc13_ = this._displayIdx++;
                  this._displayList[_loc13_] = this._nameContent;
                  return;
               }
            }
         }
         var _loc12_:* = this._displayIdx++;
         this._displayList[_loc12_] = this._nameTxt;
      }
      
      private function createNecklaceItem() : void
      {
         var _loc3_:* = undefined;
         var _loc1_:InventoryItemInfo = null;
         var _loc2_:int = 0;
         if(this._info.CategoryID == 14)
         {
            this._necklaceItem.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.life") + ":" + LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.advance") + this._info.Property1 + "%";
            _loc1_ = this._info as InventoryItemInfo;
            if(_loc1_ && _loc1_.Place == 12 && _loc1_.UserID == PlayerInfoViewControl.currentPlayer.ID && PlayerInfoViewControl.currentPlayer.necklaceLevel > 0)
            {
               _loc2_ = StoreEquipExperience.getNecklaceStrengthPlus(PlayerInfoViewControl.currentPlayer.necklaceLevel);
               this._necklaceItem.text += LanguageMgr.GetTranslation("bagAndInfo.bag.NecklacePtetrochemicalView.goodTipII",_loc2_);
            }
            this._necklaceItem.textColor = ITEM_NECKLACE_COLOR;
            _loc3_ = this._displayIdx++;
            this._displayList[_loc3_] = this._necklaceItem;
         }
         else if(this._info.CategoryID == EquipType.HEALSTONE)
         {
            this._necklaceItem.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.life") + ":" + LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.reply") + this._info.Property2;
            this._necklaceItem.textColor = ITEM_NECKLACE_COLOR;
            _loc3_ = this._displayIdx++;
            this._displayList[_loc3_] = this._necklaceItem;
         }
      }
      
      private function createQualityItem() : void
      {
         var _loc1_:FilterFrameText = this._qualityItem.foreItems[0] as FilterFrameText;
         _loc1_.text = QualityType.QUALITY_STRING[this._info.Quality];
         _loc1_.textColor = QualityType.QUALITY_COLOR[this._info.Quality];
         var _loc2_:* = this._displayIdx++;
         this._displayList[_loc2_] = this._qualityItem;
      }
      
      private function createCategoryItem() : void
      {
         var _loc1_:FilterFrameText = this._typeItem.foreItems[0] as FilterFrameText;
         var _loc2_:Array = EquipType.PARTNAME;
         _loc1_.text = EquipType.PARTNAME[this._info.CategoryID];
         var _loc3_:* = this._displayIdx++;
         this._displayList[_loc3_] = this._typeItem;
      }
      
      private function createMainProperty() : void
      {
         var _loc1_:String = "";
         var _loc2_:int = 0;
         var _loc3_:FilterFrameText = this._mainPropertyItem.foreItems[0] as FilterFrameText;
         var _loc4_:ScaleFrameImage = this._mainPropertyItem.backItem as ScaleFrameImage;
         var _loc5_:InventoryItemInfo = this._info as InventoryItemInfo;
         GhostStarContainer(this._mainPropertyItem.foreItems[1]).visible = false;
         GhostStarContainer(this._armAngleItem.foreItems[1]).visible = false;
         this._autoGhostWidth = 0;
         var _loc6_:uint = 0;
         var _loc7_:* = NaN;
         var _loc8_:* = NaN;
         var _loc9_:PlayerInfo = PlayerInfoViewControl.currentPlayer || PlayerManager.Instance.Self;
         if(EquipType.isArm(this._info))
         {
            _loc7_ = 0;
            if(Boolean(_loc5_) && _loc5_.StrengthenLevel > 0)
            {
               _loc2_ = _loc5_.isGold ? int(_loc5_.StrengthenLevel + 1) : int(_loc5_.StrengthenLevel);
               _loc7_ = Number(StaticFormula.getHertAddition(int(_loc5_.Property7),_loc2_));
            }
            _loc4_.setFrame(1);
            _loc1_ = (_loc6_ = uint(_loc7_ + (!!this._ghostPropertyData ? this._ghostPropertyData.mainProperty : 0))) > 0 ? "(+" + _loc6_ + ")" : "";
            _loc3_.text = " " + this._info.Property7.toString() + _loc1_;
            FilterFrameText(this._armAngleItem.foreItems[0]).text = " " + this._info.Property5 + "°~" + this._info.Property6 + "°";
            var _loc10_:* = this._displayIdx++;
            this._displayList[_loc10_] = this._mainPropertyItem;
            var _loc11_:* = this._displayIdx++;
            this._displayList[_loc11_] = this._armAngleItem;
            if(this._ghostPropertyData != null)
            {
               this._ghostStartsContainer = this._armAngleItem.foreItems[1] as GhostStarContainer;
               this._ghostStartsContainer.x = this._armAngleItem.foreItems[0].width + this._armAngleItem.foreItems[0].x;
               this._ghostStartsContainer.y = this._armAngleItem.foreItems[0].y + 8;
               this._ghostStartsContainer.maxLv = EquipGhostManager.getInstance().model.topLvDic[this._info.CategoryID == 27 ? 7 : this._info.CategoryID];
               this._ghostStartsContainer.level = _loc9_.getGhostDataByCategoryID(this._info.CategoryID).level;
               this._ghostStartsContainer.visible = true;
               this._autoGhostWidth = this._ghostStartsContainer.x + this._ghostStartsContainer.width;
            }
         }
         else if(EquipType.isHead(this._info) || EquipType.isCloth(this._info))
         {
            _loc8_ = 0;
            if(Boolean(_loc5_) && _loc5_.StrengthenLevel > 0)
            {
               _loc2_ = _loc5_.isGold ? int(_loc5_.StrengthenLevel + 1) : int(_loc5_.StrengthenLevel);
               _loc8_ = Number(StaticFormula.getDefenseAddition(int(_loc5_.Property7),_loc2_));
            }
            _loc4_.setFrame(2);
            _loc1_ = (_loc6_ = uint(_loc8_ + (this._ghostPropertyData != null ? this._ghostPropertyData.mainProperty : 0))) > 0 ? "(+" + _loc6_ + ")" : "";
            _loc3_.text = " " + this._info.Property7.toString() + _loc1_;
            _loc10_ = this._displayIdx++;
            this._displayList[_loc10_] = this._mainPropertyItem;
            if(Boolean(_loc5_) && _loc5_.isGold)
            {
               FilterFrameText(this._otherHp.foreItems[0]).text = _loc5_.Boold.toString();
               _loc11_ = this._displayIdx++;
               this._displayList[_loc11_] = this._otherHp;
            }
            if(this._ghostPropertyData != null)
            {
               this._ghostStartsContainer = this._mainPropertyItem.foreItems[1] as GhostStarContainer;
               this._ghostStartsContainer.maxLv = EquipGhostManager.getInstance().model.topLvDic[this._info.CategoryID == 27 ? 7 : this._info.CategoryID];
               this._ghostStartsContainer.x = this._mainPropertyItem.foreItems[0].width + this._mainPropertyItem.foreItems[0].x;
               this._ghostStartsContainer.y = this._mainPropertyItem.foreItems[0].y + 8;
               this._ghostStartsContainer.level = _loc9_.getGhostDataByCategoryID(this._info.CategoryID).level;
               this._ghostStartsContainer.visible = true;
               this._autoGhostWidth = this._ghostStartsContainer.x + this._ghostStartsContainer.width;
            }
         }
         else if(StaticFormula.isDeputyWeapon(this._info))
         {
            if(this._info.Property3 == "32")
            {
               if(Boolean(_loc5_) && _loc5_.StrengthenLevel > 0)
               {
                  _loc2_ = _loc5_.isGold ? int(_loc5_.StrengthenLevel + 1) : int(_loc5_.StrengthenLevel);
                  _loc1_ = "(+" + StaticFormula.getRecoverHPAddition(int(_loc5_.Property7),_loc2_) + ")";
               }
               _loc4_.setFrame(3);
            }
            else
            {
               if(Boolean(_loc5_) && _loc5_.StrengthenLevel > 0)
               {
                  _loc2_ = _loc5_.isGold ? int(_loc5_.StrengthenLevel + 1) : int(_loc5_.StrengthenLevel);
                  _loc1_ = "(+" + StaticFormula.getDefenseAddition(int(_loc5_.Property7),_loc2_) + ")";
               }
               _loc4_.setFrame(4);
            }
            _loc3_.text = " " + this._info.Property7.toString() + _loc1_;
            _loc10_ = this._displayIdx++;
            this._displayList[_loc10_] = this._mainPropertyItem;
         }
      }
	  
	  private function careteEXP() : void
	  {
		  var _loc1_:FilterFrameText = _expItem.foreItems[0] as FilterFrameText;
		  if(EquipType.canBringUp(_info))
		  {
			  _loc1_.text = _exp + "/" + _UpExp;
			  _displayList[_displayIdx++] = _expItem;
		  }
	  }
	  
	  private function setJewelryExp(param1:ItemTemplateInfo) : void
	  {
		  if(param1 is InventoryItemInfo)
		  {
			  if((param1 as InventoryItemInfo).curExp == 0)
			  {
				  _exp = int(ItemManager.Instance.getTemplateById(param1.TemplateID).Property2);
			  }
			  else
			  {
				  _exp = (param1 as InventoryItemInfo).curExp;
			  }
		  }
		  else
		  {
			  _exp = int(param1.Property2);
		  }
		  if(param1.FusionType == 0)
		  {
			  _UpExp = 0;
		  }
		  else
		  {
			  _UpExp = int(ItemManager.Instance.getTemplateById(param1.FusionType).Property2);
		  }
	  }
      
      private function createProperties() : void
      {
         var _loc1_:InventoryItemInfo = null;
         var _loc2_:String = "";
         var _loc3_:String = "";
         var _loc4_:String = "";
         var _loc5_:String = "";
         var _loc6_:String = "";
         var _loc7_:String = "";
         var _loc8_:String = "";
         var _loc9_:String = "";
         if(this._info is InventoryItemInfo)
         {
            _loc1_ = this._info as InventoryItemInfo;
            if(_loc1_.AttackCompose > 0)
            {
               _loc2_ = "(+" + String(_loc1_.AttackCompose) + ")";
            }
            if(_loc1_.DefendCompose > 0)
            {
               _loc3_ = "(+" + String(_loc1_.DefendCompose) + ")";
            }
            if(_loc1_.AgilityCompose > 0)
            {
               _loc4_ = "(+" + String(_loc1_.AgilityCompose) + ")";
            }
            if(_loc1_.LuckCompose > 0)
            {
               _loc5_ = "(+" + String(_loc1_.LuckCompose) + ")";
            }
         }
         if(this._ghostPropertyData != null)
         {
            if(this._ghostPropertyData.attack > 0)
            {
               _loc6_ = LanguageMgr.GetTranslation("equipGhost.tip",String(this._ghostPropertyData.attack));
            }
            if(this._ghostPropertyData.defend > 0)
            {
               _loc7_ = LanguageMgr.GetTranslation("equipGhost.tip",String(this._ghostPropertyData.defend));
            }
            if(this._ghostPropertyData.agility > 0)
            {
               _loc8_ = LanguageMgr.GetTranslation("equipGhost.tip",String(this._ghostPropertyData.lucky));
            }
            if(this._ghostPropertyData.lucky > 0)
            {
               _loc9_ = LanguageMgr.GetTranslation("equipGhost.tip",String(this._ghostPropertyData.agility));
            }
         }
         if(this._info.Attack != 0)
         {
            this._attackTxt.htmlText = LanguageMgr.GetTranslation("goodTip.propertyStr",LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.fire") + ":" + String(this._info.Attack) + _loc2_) + _loc6_;
            var _loc10_:* = this._displayIdx++;
            this._displayList[_loc10_] = this._attackTxt;
         }
         if(this._info.Defence != 0)
         {
            this._defenseTxt.htmlText = LanguageMgr.GetTranslation("goodTip.propertyStr",LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.recovery") + ":" + String(this._info.Defence) + _loc3_) + _loc7_;
            _loc10_ = this._displayIdx++;
            this._displayList[_loc10_] = this._defenseTxt;
         }
         if(this._info.Agility != 0)
         {
            this._agilityTxt.htmlText = LanguageMgr.GetTranslation("goodTip.propertyStr",LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.agility") + ":" + String(this._info.Agility) + _loc4_) + _loc8_;
            _loc10_ = this._displayIdx++;
            this._displayList[_loc10_] = this._agilityTxt;
         }
         if(this._info.Luck != 0)
         {
            this._luckTxt.htmlText = LanguageMgr.GetTranslation("goodTip.propertyStr",LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.lucky") + ":" + String(this._info.Luck) + _loc5_) + _loc9_;
            _loc10_ = this._displayIdx++;
            this._displayList[_loc10_] = this._luckTxt;
         }
         if(this._info.TemplateID == PET_SPECIAL_FOOD)
         {
            this._gp.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.gp") + ":" + InventoryItemInfo(this._info).DefendCompose;
            this._gp.textColor = ITEM_PROPERTIES_COLOR;
            _loc10_ = this._displayIdx++;
            this._displayList[_loc10_] = this._gp;
            this._maxGP.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.maxGP") + ":" + InventoryItemInfo(this._info).AgilityCompose;
            this._maxGP.textColor = ITEM_PROPERTIES_COLOR;
            var _loc11_:* = this._displayIdx++;
            this._displayList[_loc11_] = this._maxGP;
         }
      }
      
      private function createHoleItem() : void
      {
         var _loc1_:Array = null;
         var _loc2_:Array = null;
         var _loc3_:InventoryItemInfo = null;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:Array = null;
         var _loc7_:FilterFrameText = null;
         var _loc8_:int = 0;
         if(!StringHelper.isNullOrEmpty(this._info.Hole))
         {
            _loc1_ = [];
            _loc2_ = this._info.Hole.split("|");
            _loc3_ = this._info as InventoryItemInfo;
            if(_loc2_.length > 0 && String(_loc2_[0]) != "" && _loc3_ != null)
            {
               _loc4_ = 0;
               while(_loc4_ < _loc2_.length)
               {
                  _loc5_ = String(_loc2_[_loc4_]);
                  _loc6_ = _loc5_.split(",");
                  if(_loc4_ < 4)
                  {
                     if(int(_loc6_[0]) > 0 && int(_loc6_[0]) - _loc3_.StrengthenLevel <= 3 || this.getHole(_loc3_,_loc4_ + 1) >= 0)
                     {
                        _loc8_ = int(_loc6_[0]);
                        _loc7_ = this.createSingleHole(_loc3_,_loc4_,_loc8_,_loc6_[1]);
                        var _loc9_:* = this._displayIdx++;
                        this._displayList[_loc9_] = _loc7_;
                     }
                  }
                  else if(_loc3_["Hole" + (_loc4_ + 1) + "Level"] >= 1 || _loc3_["Hole" + (_loc4_ + 1)] > 0)
                  {
                     _loc7_ = this.createSingleHole(_loc3_,_loc4_,int.MAX_VALUE,_loc6_[1]);
                     _loc9_ = this._displayIdx++;
                     this._displayList[_loc9_] = _loc7_;
                  }
                  _loc4_++;
               }
            }
         }
      }
      
      private function creatLevel() : void
      {
         if(this._info.CategoryID == 50 || this._info.CategoryID == 51 || this._info.CategoryID == 52)
         {
            this._levelTxt.text = LanguageMgr.GetTranslation("ddt.petEquipLevel",this._info.Property2);
            var _loc1_:* = this._displayIdx++;
            this._displayList[_loc1_] = this._levelTxt;
         }
      }
      
      private function creatGemstone() : void
      {
         var _loc11_:* = undefined;
         var _loc1_:InventoryItemInfo = null;
         var _loc2_:int = 0;
         var _loc3_:FilterFrameText = null;
         var _loc4_:GemstonTipItem = null;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         var _loc8_:Object = null;
         var _loc9_:* = null;
         var _loc10_:* = null;
         if(this._info is InventoryItemInfo)
         {
            _loc1_ = this._info as InventoryItemInfo;
            if(Boolean(_loc1_.gemstoneList))
            {
               if(_loc1_.gemstoneList.length == 0)
               {
                  return;
               }
               _loc2_ = 0;
               _loc9_ = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.GoldenAddAttack");
               _loc10_ = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.GoldenReduceDamage");
               while(_loc2_ < 3)
               {
                  if(_loc1_.gemstoneList[_loc2_].level > 0)
                  {
                     _loc3_ = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemNameTxtString");
                     _loc4_ = new GemstonTipItem();
                     _loc11_ = this._displayIdx++;
                     this._displayList[_loc11_] = _loc4_;
                     _loc5_ = _loc1_.gemstoneList[_loc2_].level;
                     if(_loc1_.gemstoneList[_loc2_].fightSpiritId == 100001)
                     {
                        if(_loc1_.gemstoneList[_loc2_].level == 6)
                        {
                           _loc6_ = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.goldenGemstoneAtc",GemstoneManager.Instance.redInfoList[_loc5_].attack + _loc9_);
                        }
                        else
                        {
                           _loc6_ = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.redGemstoneAtc",_loc5_,GemstoneManager.Instance.redInfoList[_loc5_].attack);
                        }
                        _loc7_ = GemstoneManager.Instance.redInfoList[_loc5_].attack;
                     }
                     else if(_loc1_.gemstoneList[_loc2_].fightSpiritId == 100002)
                     {
                        if(_loc1_.gemstoneList[_loc2_].level == 6)
                        {
                           _loc6_ = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.goldenGemstoneDef",GemstoneManager.Instance.bluInfoList[_loc5_].defence + _loc10_);
                        }
                        else
                        {
                           _loc6_ = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.bluGemstoneDef",_loc5_,GemstoneManager.Instance.bluInfoList[_loc5_].defence);
                        }
                        _loc7_ = GemstoneManager.Instance.bluInfoList[_loc5_].defence;
                     }
                     else if(_loc1_.gemstoneList[_loc2_].fightSpiritId == 100003)
                     {
                        if(_loc1_.gemstoneList[_loc2_].level == 6)
                        {
                           _loc6_ = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.goldenGemstoneAgi",GemstoneManager.Instance.greInfoList[_loc5_].agility + _loc9_);
                        }
                        else
                        {
                           _loc6_ = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.gesGemstoneAgi",_loc5_,GemstoneManager.Instance.greInfoList[_loc5_].agility);
                        }
                        _loc7_ = GemstoneManager.Instance.greInfoList[_loc5_].agility;
                     }
                     else if(_loc1_.gemstoneList[_loc2_].fightSpiritId == 100004)
                     {
                        if(_loc1_.gemstoneList[_loc2_].level == 6)
                        {
                           _loc6_ = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.goldenGemstoneLuk",GemstoneManager.Instance.yelInfoList[_loc5_].luck + _loc10_);
                        }
                        else
                        {
                           _loc6_ = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.yelGemstoneLuk",_loc5_,GemstoneManager.Instance.yelInfoList[_loc5_].luck);
                        }
                        _loc7_ = GemstoneManager.Instance.yelInfoList[_loc5_].luck;
                     }
                     else if(_loc1_.gemstoneList[_loc2_].fightSpiritId == 100005)
                     {
                        if(_loc1_.gemstoneList[_loc2_].level == 6)
                        {
                           _loc6_ = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.goldenGemstoneHp",GemstoneManager.Instance.purpleInfoList[_loc5_].blood + _loc10_);
                        }
                        else
                        {
                           _loc6_ = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.purpleGemstoneLuk",_loc5_,GemstoneManager.Instance.purpleInfoList[_loc5_].blood);
                        }
                        _loc7_ = GemstoneManager.Instance.purpleInfoList[_loc5_].blood;
                     }
                     _loc8_ = new Object();
                     _loc8_.id = _loc1_.gemstoneList[_loc2_].fightSpiritId;
                     _loc8_.str = _loc6_;
                     _loc4_.setInfo(_loc8_);
                  }
                  _loc2_++;
               }
            }
         }
      }
      
      private function createSingleHole(param1:InventoryItemInfo, param2:int, param3:int, param4:int) : FilterFrameText
      {
         var _loc5_:ItemTemplateInfo = null;
         var _loc6_:int = 0;
         var _loc7_:FilterFrameText = this._holes[param2];
         var _loc8_:int = this.getHole(param1,param2 + 1);
         if(param1.StrengthenLevel >= param3)
         {
            if(_loc8_ <= 0)
            {
               _loc7_.text = this.getHoleType(param4) + ":" + LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.holeenable");
               _loc7_.textColor = ITEM_HOLES_COLOR;
            }
            else
            {
               _loc5_ = ItemManager.Instance.getTemplateById(_loc8_);
               if(Boolean(_loc5_))
               {
                  _loc7_.text = _loc5_.Data;
                  _loc7_.textColor = ITEM_HOLE_RESERVE_COLOR;
               }
            }
         }
         else if(param2 >= 4)
         {
            _loc6_ = int(param1["Hole" + (param2 + 1) + "Level"]);
            if(_loc8_ > 0)
            {
               _loc5_ = ItemManager.Instance.getTemplateById(_loc8_);
               _loc7_.text = _loc5_.Data + LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.holeLv",param1["Hole" + (param2 + 1) + "Level"]);
               if(Math.floor(_loc5_.Level + 1 >> 1) <= _loc6_)
               {
                  _loc7_.textColor = ITEM_HOLE_RESERVE_COLOR;
               }
               else
               {
                  _loc7_.textColor = ITEM_HOLE_GREY_COLOR;
               }
            }
            else
            {
               _loc7_.text = this.getHoleType(param4) + StringHelper.format(LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.holeLv",param1["Hole" + (param2 + 1) + "Level"]));
               _loc7_.textColor = ITEM_HOLES_COLOR;
            }
         }
         else if(_loc8_ <= 0)
         {
            _loc7_.text = this.getHoleType(param4) + StringHelper.format(LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.holerequire"),param3.toString());
            _loc7_.textColor = ITEM_HOLE_GREY_COLOR;
         }
         else
         {
            _loc5_ = ItemManager.Instance.getTemplateById(_loc8_);
            if(Boolean(_loc5_))
            {
               _loc7_.text = _loc5_.Data + StringHelper.format(LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.holerequire"),param3.toString());
               _loc7_.textColor = ITEM_HOLE_GREY_COLOR;
            }
         }
         return _loc7_;
      }
      
      public function getHole(param1:InventoryItemInfo, param2:int) : int
      {
         return int(param1["Hole" + param2.toString()]);
      }
      
      private function getHoleType(param1:int) : String
      {
         switch(param1)
         {
            case 1:
               return LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.trianglehole");
            case 2:
               return LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.recthole");
            case 3:
               return LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.ciclehole");
            default:
               return LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.unknowhole");
         }
      }
      
      private function createOperationItem() : void
      {
         var _loc1_:uint = 0;
         if(this._info.NeedLevel > 1)
         {
            if(PlayerManager.Instance.Self.Grade >= this._info.NeedLevel)
            {
               _loc1_ = ITEM_NEED_LEVEL_COLOR;
            }
            else
            {
               _loc1_ = ITEM_NEED_LEVEL_FAILED_COLOR;
            }
            this._needLevelTxt.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.need") + ":" + String(this._info.NeedLevel);
            this._needLevelTxt.textColor = _loc1_;
            var _loc3_:* = this._displayIdx++;
            this._displayList[_loc3_] = this._needLevelTxt;
         }
         if(this._info.NeedSex == 1)
         {
            this._needSexTxt.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.man");
            this._needSexTxt.textColor = PlayerManager.Instance.Self.Sex ? uint(ITEM_NEED_SEX_COLOR) : uint(ITEM_NEED_SEX_FAILED_COLOR);
            _loc3_ = this._displayIdx++;
            this._displayList[_loc3_] = this._needSexTxt;
         }
         else if(this._info.NeedSex == 2)
         {
            this._needSexTxt.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.woman");
            this._needSexTxt.textColor = PlayerManager.Instance.Self.Sex ? uint(ITEM_NEED_SEX_FAILED_COLOR) : uint(ITEM_NEED_SEX_COLOR);
            _loc3_ = this._displayIdx++;
            this._displayList[_loc3_] = this._needSexTxt;
         }
         var _loc2_:String = "";
         if(this._info.CanStrengthen && this._info.CanCompose)
         {
            _loc2_ = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.may");
            if(EquipType.isRongLing(this._info))
            {
               _loc2_ += LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.melting");
            }
            this._upgradeType.text = _loc2_;
            this._upgradeType.textColor = ITEM_UPGRADE_TYPE_COLOR;
            _loc3_ = this._displayIdx++;
            this._displayList[_loc3_] = this._upgradeType;
         }
         else if(this._info.CanCompose)
         {
            _loc2_ = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.compose");
            if(EquipType.isRongLing(this._info))
            {
               _loc2_ += LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.melting");
            }
            this._upgradeType.text = _loc2_;
            this._upgradeType.textColor = ITEM_UPGRADE_TYPE_COLOR;
            _loc3_ = this._displayIdx++;
            this._displayList[_loc3_] = this._upgradeType;
         }
         else if(this._info.CanStrengthen)
         {
            _loc2_ = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.strong");
            if(EquipType.isRongLing(this._info))
            {
               _loc2_ += LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.melting");
            }
            this._upgradeType.text = _loc2_;
            this._upgradeType.textColor = ITEM_UPGRADE_TYPE_COLOR;
            _loc3_ = this._displayIdx++;
            this._displayList[_loc3_] = this._upgradeType;
         }
         else if(EquipType.isRongLing(this._info))
         {
            _loc2_ += LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.canmelting");
            this._upgradeType.text = _loc2_;
            this._upgradeType.textColor = ITEM_UPGRADE_TYPE_COLOR;
            _loc3_ = this._displayIdx++;
            this._displayList[_loc3_] = this._upgradeType;
         }
      }
      
      private function createDescript() : void
      {
         if(this._info.Description == "")
         {
            return;
         }
         this._descriptionTxt.text = this._info.Description;
         this._descriptionTxt.height = this._descriptionTxt.textHeight + 10;
         var _loc1_:* = this._displayIdx++;
         this._displayList[_loc1_] = this._descriptionTxt;
      }
      
      private function ShowBound(param1:InventoryItemInfo) : Boolean
      {
         return param1.CategoryID != EquipType.SEED && param1.CategoryID != EquipType.MANURE && param1.CategoryID != EquipType.VEGETABLE;
      }
      
      private function createBindType() : void
      {
         if(SyahManager.Instance.inView)
         {
            return;
         }
         var _loc1_:InventoryItemInfo = this._info as InventoryItemInfo;
         if(_loc1_ && this.ShowBound(_loc1_) && _loc1_.isShowBind)
         {
            if(_loc1_.IsVisleBound == true)
            {
               this._boundImage.setFrame(_loc1_.IsBinds ? int(BOUND) : int(UNBOUND));
               PositionUtils.setPos(this._boundImage,this._bindImageOriginalPos);
               addChild(this._boundImage);
            }
            if(!_loc1_.IsBinds)
            {
               if(_loc1_.BindType == 3)
               {
                  this._bindTypeTxt.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.bangding");
                  this._bindTypeTxt.textColor = ITEM_NORMAL_COLOR;
                  var _loc2_:* = this._displayIdx++;
                  this._displayList[_loc2_] = this._bindTypeTxt;
               }
               else if(this._info.BindType == 2)
               {
                  this._bindTypeTxt.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.zhuangbei");
                  this._bindTypeTxt.textColor = ITEM_NORMAL_COLOR;
                  _loc2_ = this._displayIdx++;
                  this._displayList[_loc2_] = this._bindTypeTxt;
               }
               else if(this._info.BindType == 4)
               {
                  if(Boolean(this._boundImage.parent))
                  {
                     this._boundImage.parent.removeChild(this._boundImage);
                  }
               }
            }
         }
         else if(Boolean(this._boundImage.parent))
         {
            this._boundImage.parent.removeChild(this._boundImage);
         }
      }
      
      private function createRemainTime() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:InventoryItemInfo = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:String = null;
         var _loc6_:Number = NaN;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:uint = 0;
         if(Boolean(this._remainTimeBg.parent))
         {
            this._remainTimeBg.parent.removeChild(this._remainTimeBg);
         }
         if(this._info is InventoryItemInfo)
         {
            _loc2_ = this._info as InventoryItemInfo;
            _loc3_ = _loc2_.getRemainDate();
            _loc4_ = _loc2_.getColorValidDate();
            _loc5_ = _loc2_.CategoryID == EquipType.ARM ? LanguageMgr.GetTranslation("bag.changeColor.tips.armName") : "";
            if(_loc4_ > 0 && _loc4_ != int.MAX_VALUE)
            {
               if(_loc4_ >= 1)
               {
                  this._remainTimeTxt.text = (_loc2_.IsUsed ? LanguageMgr.GetTranslation("bag.changeColor.tips.name") + LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.less") : LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.time")) + Math.ceil(_loc4_) + LanguageMgr.GetTranslation("shop.ShopIIShoppingCarItem.day");
                  this._remainTimeTxt.textColor = ITEM_NORMAL_COLOR;
                  var _loc10_:* = this._displayIdx++;
                  this._displayList[_loc10_] = this._remainTimeTxt;
               }
               else
               {
                  _loc6_ = Math.floor(_loc4_ * 24);
                  if(_loc6_ < 1)
                  {
                     _loc6_ = 1;
                  }
                  this._remainTimeTxt.text = (_loc2_.IsUsed ? LanguageMgr.GetTranslation("bag.changeColor.tips.name") + LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.less") : LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.time")) + _loc6_ + LanguageMgr.GetTranslation("hours");
                  this._remainTimeTxt.textColor = ITEM_NORMAL_COLOR;
                  _loc10_ = this._displayIdx++;
                  this._displayList[_loc10_] = this._remainTimeTxt;
               }
            }
            if(_loc3_ == int.MAX_VALUE)
            {
               this._remainTimeTxt.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.use");
               this._remainTimeTxt.textColor = ITEM_ETERNAL_COLOR;
               _loc10_ = this._displayIdx++;
               this._displayList[_loc10_] = this._remainTimeTxt;
            }
            else if(_loc3_ > 0)
            {
               if(_loc3_ > 1)
               {
                  _loc1_ = Math.ceil(_loc3_);
                  this._remainTimeTxt.text = (_loc2_.IsUsed ? _loc5_ + LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.less") : LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.time")) + "  " + _loc1_ + "  " + LanguageMgr.GetTranslation("shop.ShopIIShoppingCarItem.day");
                  this._remainTimeTxt.textColor = ITEM_NORMAL_COLOR;
                  _loc10_ = this._displayIdx++;
                  this._displayList[_loc10_] = this._remainTimeTxt;
               }
               else
               {
                  _loc1_ = Math.floor(_loc3_ * 24);
                  _loc1_ = _loc1_ < 1 ? Number(1) : Number(_loc1_);
                  this._remainTimeTxt.text = (_loc2_.IsUsed ? _loc5_ + LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.less") : LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.time")) + "  " + _loc1_ + "  " + LanguageMgr.GetTranslation("hours");
                  this._remainTimeTxt.textColor = ITEM_NORMAL_COLOR;
                  _loc10_ = this._displayIdx++;
                  this._displayList[_loc10_] = this._remainTimeTxt;
               }
               addChild(this._remainTimeBg);
            }
            else if(!isNaN(_loc3_))
            {
               this._remainTimeTxt.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.over");
               this._remainTimeTxt.textColor = ITEM_PAST_DUE_COLOR;
               _loc10_ = this._displayIdx++;
               this._displayList[_loc10_] = this._remainTimeTxt;
            }
            _loc7_ = null;
            _loc8_ = null;
            _loc9_ = 0;
            if(_loc2_.isHasLatentEnergy)
            {
               _loc7_ = TimeManager.Instance.getMaxRemainDateStr(_loc2_.latentEnergyEndTime,2);
               _loc8_ = this._remainTimeTxt.text;
               _loc8_ += LanguageMgr.GetTranslation("ddt.latentEnergy.tipRemainDateTxt",_loc7_);
               _loc9_ = this._remainTimeTxt.textColor;
               this._remainTimeTxt.text = _loc8_;
               this._remainTimeTxt.textColor = _loc9_;
            }
         }
      }
      
      private function createGoldRemainTime() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:InventoryItemInfo = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:String = null;
         if(SyahManager.Instance.inView)
         {
            return;
         }
         if(Boolean(this._remainTimeBg.parent))
         {
            this._remainTimeBg.parent.removeChild(this._remainTimeBg);
         }
         if(this._info is InventoryItemInfo)
         {
            _loc2_ = this._info as InventoryItemInfo;
            _loc3_ = _loc2_.getGoldRemainDate();
            _loc4_ = _loc2_.goldValidDate;
            _loc5_ = _loc2_.goldBeginTime;
            if((this._info as InventoryItemInfo).isGold)
            {
               if(_loc3_ >= 1)
               {
                  _loc1_ = Math.ceil(_loc3_);
                  this._goldRemainTimeTxt.text = LanguageMgr.GetTranslation("wishBead.GoodsTipPanel.txt1") + _loc1_ + LanguageMgr.GetTranslation("wishBead.GoodsTipPanel.txt2");
               }
               else
               {
                  _loc1_ = Math.floor(_loc3_ * 24);
                  _loc1_ = _loc1_ < 1 ? Number(1) : Number(_loc1_);
                  this._goldRemainTimeTxt.text = LanguageMgr.GetTranslation("wishBead.GoodsTipPanel.txt1") + _loc1_ + LanguageMgr.GetTranslation("wishBead.GoodsTipPanel.txt3");
               }
               addChild(this._remainTimeBg);
               this._goldRemainTimeTxt.textColor = ITEM_NORMAL_COLOR;
               var _loc6_:* = this._displayIdx++;
               this._displayList[_loc6_] = this._goldRemainTimeTxt;
            }
         }
      }
      
      private function createFightPropConsume() : void
      {
         if(this._info.CategoryID == EquipType.FRIGHTPROP)
         {
            this._fightPropConsumeTxt.text = " " + LanguageMgr.GetTranslation("tank.view.common.RoomIIPropTip.consume") + this._info.Property4;
            this._fightPropConsumeTxt.textColor = ITEM_FIGHT_PROP_CONSUME_COLOR;
            var _loc1_:* = this._displayIdx++;
            this._displayList[_loc1_] = this._fightPropConsumeTxt;
         }
      }
      
      private function createBoxTimeItem() : void
      {
         var _loc1_:Date = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(EquipType.isTimeBox(this._info))
         {
            _loc1_ = DateUtils.getDateByStr((this._info as InventoryItemInfo).BeginDate);
            _loc2_ = int(this._info.Property3) * 60 - (TimeManager.Instance.Now().getTime() - _loc1_.getTime()) / 1000;
            if(_loc2_ > 0)
            {
               _loc3_ = _loc2_ / 3600;
               _loc4_ = _loc2_ % 3600 / 60;
               _loc4_ = _loc4_ > 0 ? int(_loc4_) : int(1);
               this._boxTimeTxt.text = LanguageMgr.GetTranslation("ddt.userGuild.boxTip",_loc3_,_loc4_);
               this._boxTimeTxt.textColor = ITEM_NORMAL_COLOR;
               var _loc5_:* = this._displayIdx++;
               this._displayList[_loc5_] = this._boxTimeTxt;
            }
         }
      }
      
      private function createStrenthLevel() : void
      {
         var _loc1_:InventoryItemInfo = this._info as InventoryItemInfo;
         if(Boolean(_loc1_) && _loc1_.StrengthenLevel > 0)
         {
            if(_loc1_.isGold)
            {
               this._strengthenLevelImage.setFrame(16);
            }
            else
            {
               this._strengthenLevelImage.setFrame(_loc1_.StrengthenLevel);
            }
            addChild(this._strengthenLevelImage);
            if(Boolean(this._boundImage.parent))
            {
               this._boundImage.x = this._strengthenLevelImage.x + this._strengthenLevelImage.displayWidth / 2 - this._boundImage.width / 2;
               this._boundImage.y = this._lines[0].y + 4;
            }
            this._maxWidth = Math.max(this._strengthenLevelImage.x + this._strengthenLevelImage.displayWidth,this._maxWidth);
            if(EquipType.isHead(this._info) || EquipType.isCloth(this._info))
            {
               this._strengthenLevelImage.y = 90;
            }
            else
            {
               this._strengthenLevelImage.y = 119;
            }
            _width = _tipbackgound.width = this._maxWidth + 8;
            if(Boolean(this._ghostStartsContainer))
            {
               this._ghostStartsContainer.x = this._strengthenLevelImage.x + (this._strengthenLevelImage.displayWidth - this._ghostStartsContainer.width >> 1) - 23;
               this._autoGhostWidth = this._ghostStartsContainer.x + this._ghostStartsContainer.width;
            }
         }
      }
      
      private function getGhostPropertyData() : GhostPropertyData
      {
         var _loc1_:GhostPropertyData = null;
         var _loc2_:InventoryItemInfo = this._info as InventoryItemInfo;
         if(_loc2_ == null)
         {
            return null;
         }
         var _loc3_:PlayerInfo = PlayerInfoViewControl.currentPlayer || PlayerManager.Instance.Self;
         var _loc4_:* = _loc3_.ID != PlayerManager.Instance.Self.ID;
         var _loc5_:Boolean = _loc2_.BagType == 0 && _loc2_.Place <= 30;
         if(_loc4_)
         {
            _loc1_ = _loc5_ ? EquipGhostManager.getInstance().getPorpertyData(_loc2_,_loc3_) : null;
         }
         else
         {
            _loc1_ = _loc2_.fromBag && (_loc5_ || EquipGhostManager.getInstance().isEquipGhosting()) ? EquipGhostManager.getInstance().getPorpertyData(_loc2_,_loc3_) : null;
         }
         return _loc1_;
      }
      
      private function seperateLine() : void
      {
         var _loc1_:Image = null;
         ++this._lineIdx;
         if(this._lines.length < this._lineIdx)
         {
            _loc1_ = ComponentFactory.Instance.creatComponentByStylename("HRuleAsset");
            this._lines.push(_loc1_);
         }
         var _loc2_:* = this._displayIdx++;
         this._displayList[_loc2_] = this._lines[this._lineIdx - 1];
      }
   }
}
