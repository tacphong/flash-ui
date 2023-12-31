package ddt.view.roulette
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.box.BoxGoodsTempInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.RouletteManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import road7th.comm.PackageIn;
   
   public class RouletteView extends Sprite implements Disposeable
   {
      
      public static const GLINT_ALL_GOODSTYPE:int = 4;
      
      public static const SELECTGOODS_SUM:int = 8;
      
      public static const GLINT_ONE_TIME:int = 3100;
      
      public static const GLINT_ALL_TIME:int = 7500;
       
      
      private var _keyCount:int = 0;
      
      private var _turnControl:ddt.view.roulette.TurnControl;
      
      private var _startButton:BaseButton;
      
      private var _buyKeyButton:BaseButton;
      
      private var _pointArray:Array;
      
      private var _selectNumber:int = 0;
      
      private var _needKeyCount:Array;
      
      private var _goodsList:Vector.<ddt.view.roulette.RouletteGoodsCell>;
      
      private var _templateIDList:Array;
      
      private var _selectGoodsList:Vector.<ddt.view.roulette.RouletteGoodsCell>;
      
      private var _selectGoogsNumber:int = 0;
      
      private var _turnSlectedNumber:int = 0;
      
      private var _selectedGoodsInfo:InventoryItemInfo;
      
      private var _selectedGoodsNumberInTemplateIDList:int = 0;
      
      private var _isTurn:Boolean = false;
      
      private var _isCanClose:Boolean = true;
      
      private var _isLoadSucceed:Boolean = false;
      
      private var _winTimeOut:uint = 1;
      
      private var _glintView:ddt.view.roulette.RouletteGlintView;
      
      private var _selectedItemType:int;
      
      private var _selectedCount:int;
      
      private var _selectedCellBox:HBox;
      
      private var _keyConutText:FilterFrameText;
      
      private var _selectNumberText:FilterFrameText;
      
      private var _needKeyText:FilterFrameText;
      
      public function RouletteView(param1:Array)
      {
         this._needKeyCount = [0,2,3,4,5,6,7,8,0];
         super();
         this._templateIDList = param1;
         this.init();
         this.initEvent();
      }
      
      private function init() : void
      {
         var _loc1_:int = 0;
         var _loc3_:ddt.view.roulette.RouletteGoodsCell = null;
         _loc1_ = 0;
         var _loc2_:Bitmap = null;
         _loc3_ = null;
         var _loc4_:BoxGoodsTempInfo = null;
         var _loc5_:InventoryItemInfo = null;
         var _loc6_:Bitmap = null;
         var _loc7_:ddt.view.roulette.RouletteGoodsCell = null;
         this._turnControl = new ddt.view.roulette.TurnControl();
         this._goodsList = new Vector.<RouletteGoodsCell>();
         this._selectGoodsList = new Vector.<RouletteGoodsCell>();
         var _loc8_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.awardSystem.roulette.RouletteBG");
         addChild(_loc8_);
         this._keyConutText = ComponentFactory.Instance.creat("roulette.RouletteStyleI");
         this._selectNumberText = ComponentFactory.Instance.creat("roulette.RouletteStyleII");
         this._needKeyText = ComponentFactory.Instance.creat("roulette.RouletteStyleIII");
         addChild(this._keyConutText);
         addChild(this._selectNumberText);
         addChild(this._needKeyText);
         this.getAllGoodsPoint();
         _loc1_ = 0;
         while(_loc1_ <= 17)
         {
            _loc2_ = ComponentFactory.Instance.creatBitmap("asset.awardSystem.roulette.CellBGAsset");
            _loc3_ = new ddt.view.roulette.RouletteGoodsCell(_loc2_,10,32);
            _loc3_.x = this._pointArray[_loc1_].x;
            _loc3_.y = this._pointArray[_loc1_].y;
            _loc3_.selected = true;
            _loc3_.cellBG = false;
            addChild(_loc3_);
            _loc4_ = this._templateIDList[_loc1_] as BoxGoodsTempInfo;
            _loc5_ = this.getTemplateInfo(_loc4_.TemplateId) as InventoryItemInfo;
            _loc5_.IsBinds = _loc4_.IsBind;
            _loc5_.ValidDate = _loc4_.ItemValid;
            _loc5_.IsJudge = true;
            _loc3_.info = _loc5_;
            _loc3_.count = _loc4_.ItemCount;
            this._goodsList.push(_loc3_);
            _loc1_++;
         }
         this._selectedCellBox = ComponentFactory.Instance.creat("roulette.SeletedHBox");
         this._selectedCellBox.beginChanges();
         var _loc9_:int = 0;
         while(_loc9_ < SELECTGOODS_SUM)
         {
            _loc6_ = ComponentFactory.Instance.creatBitmap("asset.awardSystem.roulette.SelectCellBGAsset");
            _loc7_ = new ddt.view.roulette.RouletteGoodsCell(_loc6_,4,26);
            _loc7_.selected = false;
            _loc7_.cellBG = false;
            this._selectGoodsList.push(_loc7_);
            this._selectedCellBox.addChild(_loc7_);
            _loc9_++;
         }
         this._selectedCellBox.commitChanges();
         addChild(this._selectedCellBox);
         this.selectNumber = 0;
         this._startButton = ComponentFactory.Instance.creat("roulette.StartTurnButton");
         addChild(this._startButton);
         this._buyKeyButton = ComponentFactory.Instance.creat("roulette.BuyKeyButton");
         addChild(this._buyKeyButton);
         this._glintView = new ddt.view.roulette.RouletteGlintView(this._pointArray);
         addChild(this._glintView);
         this._turnControl.turnPlateII(this._goodsList);
         this._turnControl.autoMove = false;
      }
      
      private function getAllGoodsPoint() : void
      {
         var _loc1_:Point = null;
         this._pointArray = new Array();
         var _loc2_:int = 0;
         while(_loc2_ < 18)
         {
            _loc1_ = ComponentFactory.Instance.creatCustomObject("roulette.point" + _loc2_);
            this._pointArray.push(_loc1_);
            _loc2_++;
         }
      }
      
      private function initEvent() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LOTTERY_GET_ITEM,this._getItem);
         RouletteManager.instance.addEventListener(RouletteEvent.ROULETTE_KEYCOUNT_UPDATE,this._keyUpdate);
         this._turnControl.addEventListener(TurnControl.TURNCOMPLETE,this._turnComplete);
         this._startButton.addEventListener(MouseEvent.CLICK,this._turnClick);
         this._buyKeyButton.addEventListener(MouseEvent.CLICK,this._buyKeyClick);
      }
      
      private function _getItem(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:PackageIn = param1.pkg;
         var _loc5_:Boolean = _loc4_.readBoolean();
         if(_loc5_)
         {
            _loc2_ = _loc4_.readInt();
            _loc3_ = _loc4_.readInt();
            this._selectedGoodsInfo = this.getTemplateInfo(_loc2_) as InventoryItemInfo;
            this._selectedGoodsInfo.StrengthenLevel = _loc4_.readInt();
            this._selectedGoodsInfo.AttackCompose = _loc4_.readInt();
            this._selectedGoodsInfo.DefendCompose = _loc4_.readInt();
            this._selectedGoodsInfo.LuckCompose = _loc4_.readInt();
            this._selectedGoodsInfo.AgilityCompose = _loc4_.readInt();
            this._selectedGoodsInfo.IsBinds = _loc4_.readBoolean();
            this._selectedGoodsInfo.ValidDate = _loc4_.readInt();
            this._selectedCount = _loc4_.readByte();
            this._selectedGoodsInfo.IsJudge = true;
            this._selectedItemType = _loc3_;
            this.turnSlectedNumber = this._findCellByItemID(_loc2_,this._selectedCount,this._selectedGoodsInfo.ValidDate,this._selectedGoodsInfo.IsBinds);
            this._selectedGoodsNumberInTemplateIDList = this._findSelectedGoodsNumberInTemplateIDList(_loc2_,this._selectedCount);
            if(this.turnSlectedNumber == -1)
            {
               this.isTurn = false;
            }
            else
            {
               this._startTurn();
               this._isCanClose = false;
            }
         }
         else
         {
            this.isTurn = false;
            this._turnControl.autoMove = true;
         }
      }
      
      private function _turnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._turnControl.autoMove = false;
         if(this.needKeyCount <= this.keyCount && !this.isTurn)
         {
            this.isTurn = true;
            SocketManager.Instance.out.sendStartTurn();
         }
         else if(this.needKeyCount > this.keyCount)
         {
            RouletteManager.instance.showBuyRouletteKey(this._needKeyCount[this._selectNumber],EquipType.ROULETTE_KEY);
         }
      }
      
      private function _startTurn() : void
      {
         this._startButton.enable = false;
         this._turnControl.turnPlate(this._goodsList,this.turnSlectedNumber);
      }
      
      private function _buyKeyClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:int = this._needKeyCount[this._selectNumber] == 0 ? int(1) : int(this._needKeyCount[this._selectNumber]);
         RouletteManager.instance.showBuyRouletteKey(_loc2_,EquipType.ROULETTE_KEY);
      }
      
      private function _keyUpdate(param1:RouletteEvent) : void
      {
         this.keyCount = param1.keyCount;
      }
      
      private function _turnComplete(param1:Event) : void
      {
         this._startButton.enable = true;
         this._goodsList[this.turnSlectedNumber].selected = false;
         this._winTimeOut = setTimeout(this._updateTurnList,GLINT_ONE_TIME);
         this._glintView.showOneCell(this._selectedGoodsNumberInTemplateIDList,GLINT_ONE_TIME);
         SoundManager.instance.play("126");
      }
      
      private function _updateTurnList() : void
      {
         this._moveToSelctView();
         SoundManager.instance.play("125");
         this._isCanClose = true;
         if(this._selectedItemType >= GLINT_ALL_GOODSTYPE)
         {
            this._glintView.showTwoStep(GLINT_ALL_TIME);
            SoundManager.instance.play("063");
            this._glintView.addEventListener(RouletteGlintView.BIGGLINTCOMPLETE,this._bigGlintComplete);
         }
         else
         {
            ++this.selectNumber;
            this.isTurn = this._selectNumber >= SELECTGOODS_SUM ? Boolean(true) : Boolean(false);
         }
      }
      
      private function _bigGlintComplete(param1:Event) : void
      {
         this._glintView.removeEventListener(RouletteGlintView.BIGGLINTCOMPLETE,this._bigGlintComplete);
         ++this.selectNumber;
         this.isTurn = this._selectNumber >= SELECTGOODS_SUM ? Boolean(true) : Boolean(false);
         SoundManager.instance.stop("063");
      }
      
      private function _moveToSelctView() : void
      {
         var _loc1_:Bitmap = null;
         _loc1_ = null;
         _loc1_ = ComponentFactory.Instance.creat("asset.awardSystem.roulette.StopAsset");
         _loc1_.x = this._goodsList[this.turnSlectedNumber].x - 1;
         _loc1_.y = this._goodsList[this.turnSlectedNumber].y - 1;
         addChild(_loc1_);
         this._goodsList[this.turnSlectedNumber].visible = false;
         var _loc2_:ddt.view.roulette.RouletteGoodsCell = this._goodsList.splice(this.turnSlectedNumber,1)[0] as RouletteGoodsCell;
         if(this.selectNumber < SELECTGOODS_SUM)
         {
            this._selectGoodsList[this.selectNumber].info = this._selectedGoodsInfo;
            this._selectGoodsList[this.selectNumber].count = this._selectedCount;
            this._selectGoodsList[this.selectNumber].cellBG = true;
            _loc2_.dispose();
         }
      }
      
      private function _findCellByItemID(param1:int, param2:int, param3:int, param4:Boolean) : int
      {
         var _loc5_:int = 0;
         while(_loc5_ < this._goodsList.length)
         {
            if(this._goodsList[_loc5_].info.TemplateID == param1 && this._goodsList[_loc5_].count == param2 && (this._goodsList[_loc5_].info as InventoryItemInfo).ValidDate == param3 && (this._goodsList[_loc5_].info as InventoryItemInfo).IsBinds == param4)
            {
               return _loc5_;
            }
            _loc5_++;
         }
         return -1;
      }
      
      private function _findSelectedGoodsNumberInTemplateIDList(param1:int, param2:int) : int
      {
         var _loc3_:int = 0;
         while(_loc3_ < this._templateIDList.length)
         {
            if(this._templateIDList[_loc3_].TemplateId == param1 && this._templateIDList[_loc3_].ItemCount == param2)
            {
               return _loc3_;
            }
            _loc3_++;
         }
         return -1;
      }
      
      private function _finish() : void
      {
         SocketManager.Instance.out.sendFinishRoulette();
      }
      
      public function set keyCount(param1:int) : void
      {
         this._keyCount = param1;
         this._keyConutText.text = String(this._keyCount);
      }
      
      public function get keyCount() : int
      {
         return this._keyCount;
      }
      
      public function set selectNumber(param1:int) : void
      {
         this._selectNumber = param1;
         this._selectNumberText.text = String(8 - this._selectNumber);
         this._needKeyText.text = String(this._needKeyCount[this._selectNumber]);
         if(this._selectNumber == 8)
         {
            this._startButton.enable = false;
         }
      }
      
      private function get needKeyCount() : int
      {
         return this._needKeyCount[this._selectNumber];
      }
      
      public function get selectNumber() : int
      {
         return this._selectNumber;
      }
      
      public function set turnSlectedNumber(param1:int) : void
      {
         this._turnSlectedNumber = param1;
      }
      
      public function get turnSlectedNumber() : int
      {
         return this._turnSlectedNumber;
      }
      
      public function set isTurn(param1:Boolean) : void
      {
         this._isTurn = param1;
         if(this._isTurn)
         {
            this._buyKeyButton.enable = false;
         }
         else
         {
            this._buyKeyButton.enable = true;
         }
      }
      
      public function get isTurn() : Boolean
      {
         return this._isTurn;
      }
      
      public function get isCanClose() : Boolean
      {
         return this._isCanClose;
      }
      
      private function getTemplateInfo(param1:int) : InventoryItemInfo
      {
         var _loc2_:InventoryItemInfo = new InventoryItemInfo();
         _loc2_.TemplateID = param1;
         ItemManager.fill(_loc2_);
         return _loc2_;
      }
      
      public function dispose() : void
      {
         RouletteManager.instance.removeEventListener(RouletteEvent.ROULETTE_KEYCOUNT_UPDATE,this._keyUpdate);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.LOTTERY_GET_ITEM,this._getItem);
         this._turnControl.removeEventListener(TurnControl.TURNCOMPLETE,this._turnComplete);
         this._startButton.removeEventListener(MouseEvent.CLICK,this._turnClick);
         this._buyKeyButton.removeEventListener(MouseEvent.CLICK,this._buyKeyClick);
         this._selectedGoodsInfo = null;
         if(Boolean(this._turnControl))
         {
            this._turnControl.dispose();
            this._turnControl = null;
         }
         if(Boolean(this._glintView))
         {
            this._glintView.removeEventListener(RouletteGlintView.BIGGLINTCOMPLETE,this._bigGlintComplete);
            this._glintView.dispose();
            this._glintView = null;
         }
         this._finish();
         this._templateIDList.splice(0,this._templateIDList.length);
         clearTimeout(this._winTimeOut);
         var _loc1_:int = 0;
         while(_loc1_ < this._goodsList.length)
         {
            this._goodsList[_loc1_].dispose();
            _loc1_++;
         }
         var _loc2_:int = 0;
         while(_loc2_ < this._selectGoodsList.length)
         {
            this._selectGoodsList[_loc2_].dispose();
            _loc2_++;
         }
         if(Boolean(this._startButton))
         {
            ObjectUtils.disposeObject(this._startButton);
         }
         this._startButton = null;
         if(Boolean(this._buyKeyButton))
         {
            ObjectUtils.disposeObject(this._buyKeyButton);
         }
         this._buyKeyButton = null;
         if(Boolean(this._keyConutText))
         {
            ObjectUtils.disposeObject(this._keyConutText);
         }
         this._keyConutText = null;
         if(Boolean(this._selectNumberText))
         {
            ObjectUtils.disposeObject(this._selectNumberText);
         }
         this._selectNumberText = null;
         if(Boolean(this._needKeyText))
         {
            ObjectUtils.disposeObject(this._needKeyText);
         }
         this._needKeyText = null;
         if(Boolean(this._selectedCellBox))
         {
            ObjectUtils.disposeObject(this._selectedCellBox);
         }
         this._selectedCellBox = null;
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(this.parent))
         {
            parent.removeChild(this);
         }
      }
   }
}
