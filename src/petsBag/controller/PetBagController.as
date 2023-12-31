package petsBag.controller
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import ddt.data.UIModuleTypes;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.ChatManager;
   import ddt.manager.ItemManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.TaskManager;
   import flash.display.DisplayObjectContainer;
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import pet.date.PetEquipData;
   import pet.date.PetInfo;
   import pet.date.PetTemplateInfo;
   import petsBag.data.PetFarmGuildeInfo;
   import petsBag.model.PetBagModel;
   import petsBag.view.PetsBagOutView;
   import road7th.comm.PackageIn;
   import road7th.data.DictionaryData;
   import trainer.data.ArrowType;
   import trainer.view.NewHandContainer;
   
   public class PetBagController extends EventDispatcher
   {
      
      private static var _instance:petsBag.controller.PetBagController;
       
      
      public var isOtherPetViewOpen:Boolean = false;
      
      public var petModel:PetBagModel;
      
      public var isEquip:Boolean = false;
      
      private var _view:PetsBagOutView;
      
      public var activateAlertFrameShow:Boolean = true;
      
      private var _newPetInfo:PetInfo;
      
      private var _washProItemLock:DictionaryData;
      
      private var _popuMsg:Array;
      
      private var _timer:Timer;
      
      public function PetBagController()
      {
         this._popuMsg = [];
         super();
         this._washProItemLock = new DictionaryData();
      }
      
      public static function instance() : petsBag.controller.PetBagController
      {
         if(!_instance)
         {
            _instance = new petsBag.controller.PetBagController();
         }
         return _instance;
      }
      
      public function set newPetInfo(param1:PetInfo) : void
      {
         this._newPetInfo = param1;
      }
      
      public function get newPetInfo() : PetInfo
      {
         return this._newPetInfo;
      }
      
      public function addPetWashProItemLock(param1:int, param2:Array) : void
      {
         if(this._washProItemLock == null)
         {
            this._washProItemLock = new DictionaryData();
         }
         this._washProItemLock.add(param1,param2);
      }
      
      public function getWashProLockByPetID(param1:PetInfo) : Array
      {
         if(this._washProItemLock && param1 && this._washProItemLock.hasKey(param1.ID))
         {
            return this._washProItemLock[param1.ID];
         }
         return new Array(0,0,0,0,0);
      }
      
      public function get view() : PetsBagOutView
      {
         return this._view;
      }
      
      public function set view(param1:PetsBagOutView) : void
      {
         this._view = param1;
      }
      
      public function setup() : void
      {
         this.petModel = new PetBagModel();
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.OPTION_CHANGE,this.__petGuildOptionChange);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.DEL_PET_EQUIP,this.delPetEquipHander);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ADD_PET_EQUIP,this.addPetEquipHander);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PET_EAT,this._eatPetsInfoHandler);
      }
      
      private function _eatPetsInfoHandler(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:DictionaryData = new DictionaryData();
         _loc2_.add("weaponExp",param1.pkg.readInt());
         _loc2_.add("weaponLevel",param1.pkg.readInt());
         _loc2_.add("clothesExp",param1.pkg.readInt());
         _loc2_.add("clothesLevel",param1.pkg.readInt());
         _loc2_.add("hatExp",param1.pkg.readInt());
         _loc2_.add("hatLevel",param1.pkg.readInt());
         if(this.petModel.eatPetsInfo.length == 0)
         {
            this.petModel.eatPetsLevelUp = false;
         }
         else if(_loc2_.weaponLevel > this.petModel.eatPetsInfo.weaponLevel || _loc2_.clothesLevel > this.petModel.eatPetsInfo.clothesLevel || _loc2_.hatLevel > this.petModel.eatPetsInfo.hatLevel)
         {
            this.petModel.eatPetsLevelUp = true;
         }
         else
         {
            this.petModel.eatPetsLevelUp = false;
         }
         this.petModel.eatPetsInfo = _loc2_;
      }
      
      protected function addPetEquipHander(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc7_:PetEquipData = null;
         var _loc8_:InventoryItemInfo = null;
         var _loc9_:InventoryItemInfo = null;
         var _loc10_:Boolean = param1.pkg.readBoolean();
         if(_loc10_)
         {
            _loc2_ = param1.pkg.readInt();
            _loc3_ = param1.pkg.readInt();
            _loc4_ = param1.pkg.readInt();
            _loc5_ = param1.pkg.readDateString();
            _loc6_ = param1.pkg.readInt();
            _loc7_ = new PetEquipData();
            _loc7_.eqTemplateID = _loc4_;
            _loc7_.eqType = _loc3_;
            _loc7_.startTime = _loc5_;
            _loc7_.ValidDate = _loc6_;
            _loc8_ = new InventoryItemInfo();
            _loc8_.TemplateID = _loc7_.eqTemplateID;
            _loc8_.ValidDate = _loc7_.ValidDate;
            _loc8_.BeginDate = _loc7_.startTime;
            _loc8_.IsBinds = true;
            _loc8_.IsUsed = true;
            _loc8_.Place = _loc7_.eqType;
            _loc9_ = ItemManager.fill(_loc8_) as InventoryItemInfo;
            if(Boolean(this.petModel.currentPetInfo.equipList[_loc3_]))
            {
               this.petModel.currentPetInfo.equipList[_loc3_] = _loc9_;
            }
            else
            {
               this.petModel.currentPetInfo.equipList.add(_loc3_,_loc9_);
            }
            if(this._view && this._view.parent && _loc2_ == this.petModel.currentPetInfo.Place)
            {
               this._view.addPetEquip(_loc9_);
            }
         }
      }
      
      protected function delPetEquipHander(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:Boolean = param1.pkg.readBoolean();
         var _loc3_:int = param1.pkg.readInt();
         var _loc4_:int = param1.pkg.readInt();
         if(_loc2_)
         {
            if(!this.petModel.currentPetInfo)
            {
               return;
            }
            if(Boolean(this.petModel.currentPetInfo.equipList[_loc4_]))
            {
               this.petModel.currentPetInfo.equipList.remove(_loc4_);
            }
            if(this._view && this._view.parent && _loc3_ == this.petModel.currentPetInfo.Place)
            {
               this._view.delPetEquip(_loc3_,_loc4_);
            }
         }
      }
      
      public function pushMsg(param1:String) : void
      {
         this._popuMsg.push(param1);
         if(!this._timer)
         {
            this._timer = new Timer(2000);
            this._timer.addEventListener(TimerEvent.TIMER,this.__popu);
            this._timer.start();
         }
      }
      
      private function __popu(param1:TimerEvent) : void
      {
         var _loc2_:String = "";
         if(this._popuMsg.length > 0)
         {
            _loc2_ = this._popuMsg.shift();
            MessageTipManager.getInstance().show(_loc2_);
            ChatManager.Instance.sysChatYellow(_loc2_);
         }
         else
         {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER,this.__popu);
            this._timer = null;
            this._popuMsg = [];
         }
      }
      
      public function getEquipdSkillIndex() : int
      {
         return this.view.getUnLockItemIndex();
      }
      
      public function getPetPic(param1:PetTemplateInfo, param2:int) : String
      {
         var _loc3_:String = "";
         if(param2 < 30)
         {
            _loc3_ = param1.Pic + "/icon1";
         }
         else if(30 <= param2 && param2 < 50)
         {
            _loc3_ = param1.Pic + "/icon2";
         }
         else if(50 <= param2)
         {
            _loc3_ = param1.Pic + "/icon3";
         }
         return _loc3_;
      }
      
      public function getPicStrByLv(param1:PetInfo) : String
      {
         var _loc2_:String = "";
         if(param1.Level < 30)
         {
            _loc2_ = param1.Pic + "/icon1";
         }
         else if(30 <= param1.Level && param1.Level < 50)
         {
            _loc2_ = param1.Pic + "/icon2";
         }
         else if(50 <= param1.Level)
         {
            _loc2_ = param1.Pic + "/icon3";
         }
         return _loc2_;
      }
      
      private function loadPetsGuildeUI(param1:Function) : void
      {
         var __Finish:Function = null;
         __Finish = null;
         var callBack:Function = param1;
         __Finish = function(param1:UIModuleEvent):void
         {
            if(param1.module == UIModuleTypes.FARM_PET_TRAINER_UI)
            {
               UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,__Finish);
               petModel.isLoadPetTrainer = true;
               if(Boolean(petModel.CurrentPetFarmGuildeArrow))
               {
                  callBack(petModel.CurrentPetFarmGuildeArrow);
               }
            }
         };
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.FARM_PET_TRAINER_UI);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,__Finish);
      }
      
      private function showLoadedArrow(param1:Object) : void
      {
         if(param1.id != 94 && param1.id != 119 && param1.id != 100)
         {
            NewHandContainer.Instance.showArrow(param1.id,param1.rotation,param1.arrowPos,param1.tip,param1.tipPos,param1.con,0,true);
         }
      }
      
      public function showPetFarmGuildArrow(param1:int, param2:int, param3:String, param4:String = "", param5:String = "", param6:DisplayObjectContainer = null, param7:int = 0) : void
      {
         if(this.petModel.isLoadPetTrainer)
         {
            if(this.petModel.preShowArrowID != 0)
            {
               if(param1 != this.petModel.nextShowArrowID)
               {
                  return;
               }
            }
            this.setAvailableArrow(param1);
            if(param1 != 94)
            {
               NewHandContainer.Instance.showArrow(param1,param2,param3,param4,param5,param6,0,true);
            }
         }
         else
         {
            this.petModel.CurrentPetFarmGuildeArrow = new Object();
            this.petModel.CurrentPetFarmGuildeArrow.id = param1;
            this.petModel.CurrentPetFarmGuildeArrow.rotation = param2;
            this.petModel.CurrentPetFarmGuildeArrow.arrowPos = param3;
            this.petModel.CurrentPetFarmGuildeArrow.tip = param4;
            this.petModel.CurrentPetFarmGuildeArrow.tipPos = param5;
            this.petModel.CurrentPetFarmGuildeArrow.con = param6;
            this.loadPetsGuildeUI(this.showLoadedArrow);
         }
      }
      
      private function setAvailableArrow(param1:int) : Boolean
      {
         var _loc2_:Vector.<PetFarmGuildeInfo> = null;
         var _loc3_:PetFarmGuildeInfo = null;
         for each(_loc2_ in this.petModel.petGuilde)
         {
            for each(_loc3_ in _loc2_)
            {
               if(_loc3_.arrowID == param1)
               {
                  _loc3_.isFinish = true;
                  this.petModel.nextShowArrowID = _loc3_.NextArrowID;
                  this.petModel.preShowArrowID = _loc3_.PreArrowID;
                  return true;
               }
            }
         }
         return false;
      }
      
      public function clearCurrentPetFarmGuildeArrow(param1:int) : void
      {
         NewHandContainer.Instance.clearArrowByID(param1);
      }
      
      public function haveTaskOrderByID(param1:int) : Boolean
      {
         return TaskManager.instance.isAvailable(TaskManager.getQuestByID(param1));
      }
      
      public function isPetFarmGuildeTask(param1:int) : Boolean
      {
         return this.petModel.petGuilde[param1];
      }
      
      public function finishTask() : void
      {
         this.petModel.preShowArrowID = 0;
         this.petModel.nextShowArrowID = 0;
      }
      
      private function __petGuildOptionChange(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = null;
         var _loc3_:int = 8;
         var _loc4_:Boolean = true;
         if(Boolean(param1))
         {
            _loc2_ = param1.pkg;
            _loc4_ = _loc2_.readBoolean();
            _loc3_ = _loc2_.readInt();
         }
         switch(_loc3_)
         {
            case 8:
               this.petModel.petGuildeOptionOnOff.add(ArrowType.CHOOSE_PET_SKILL,_loc3_);
               break;
            case 16:
               this.petModel.petGuildeOptionOnOff.add(ArrowType.USE_PET_SKILL,_loc3_);
         }
      }
      
      public function getPetQualityIndex(param1:Number) : int
      {
         var _loc2_:int = 0;
         var _loc3_:Array = ServerConfigManager.instance.petQualityConfig;
         _loc2_ = 0;
         while(_loc2_ < _loc3_.length)
         {
            if(param1 <= _loc3_[_loc2_])
            {
               return _loc2_;
            }
            _loc2_++;
         }
         return _loc3_.length - 1;
      }
      
      public function sendPetWashBone(param1:int, param2:Boolean, param3:Boolean, param4:Boolean, param5:Boolean, param6:Boolean) : void
      {
         SocketManager.Instance.out.sendPetWashBone(param1,param2,param3,param4,param5,param6);
      }
   }
}
