package littleGame
{
   import ddt.data.player.PlayerInfo;
   import ddt.data.socket.ePackageType;
   import ddt.ddt_internal;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.ChatManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import flash.display.DisplayObjectContainer;
   import flash.events.EventDispatcher;
   import littleGame.actions.LittleAction;
   import littleGame.actions.LittleLivingDieAction;
   import littleGame.actions.LittleLivingMoveAction;
   import littleGame.actions.LittleSelfMoveAction;
   import littleGame.data.Grid;
   import littleGame.data.LittleGamePackageOutType;
   import littleGame.data.Node;
   import littleGame.events.LittleGameEvent;
   import littleGame.interfaces.ILittleObject;
   import littleGame.model.LittleLiving;
   import littleGame.model.LittlePlayer;
   import littleGame.model.LittleSelf;
   import littleGame.model.Scenario;
   import littleGame.object.BoguGiveUp;
   import littleGame.object.NormalBoguInhaled;
   import littleGame.view.GameScene;
   import road7th.comm.PackageIn;
   import road7th.comm.PackageOut;
   
   [Event(name="activedChanged",type="littleGame.events.LittleGameEvent")]
   public class LittleGameManager extends EventDispatcher
   {
      
      public static const Player:int = 1;
      
      public static const Living:int = 2;
      
      public static const GameBackLayer:int = 0;
      
      public static const GameForeLayer:int = 1;
      
      private static var _ins:littleGame.LittleGameManager;
       
      
      private var _actived:Boolean = false;
      
      public var soundEnabled:Boolean = true;
      
      private var _current:Scenario;
      
      private var _mainStage:DisplayObjectContainer;
      
      private var _gamescene:GameScene;
      
      public function LittleGameManager()
      {
         super();
      }
      
      public static function get Instance() : littleGame.LittleGameManager
      {
         return _ins = _ins || new littleGame.LittleGameManager();
      }
      
      public function initialize() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LITTLEGAME_ACTIVED,this.__actived);
      }
      
      private function __actived(param1:CrazyTankSocketEvent) : void
      {
         this._actived = param1.pkg.readBoolean();
         dispatchEvent(new LittleGameEvent(LittleGameEvent.ActivedChanged));
      }
      
      public function hasActive() : Boolean
      {
         return this._actived;
      }
      
      public function hasCanStart(param1:PlayerInfo) : Boolean
      {
         return param1.Grade >= PathManager.LittleGameMinLv;
      }
      
      public function kickPlayer(param1:PackageIn) : void
      {
         StateManager.setState(StateType.MAIN);
      }
      
      public function fillPath(param1:LittleLiving, param2:Grid, param3:int, param4:int, param5:int, param6:int) : Array
      {
         var _loc7_:Array = null;
         if(param1.isSelf && param1.MotionState <= 1)
         {
            return null;
         }
         var _loc8_:Node = param2.getNode(param5,param6);
         if(Boolean(_loc8_) && _loc8_.walkable)
         {
            param2.setStartNode(param3,param4);
            param2.setEndNode(param5,param6);
            if(param2.fillPath())
            {
               return param2.path;
            }
            return null;
         }
         return null;
      }
      
      public function collide(param1:LittleSelf, param2:LittleLiving) : Boolean
      {
         return true;
      }
      
      public function enterWorld() : void
      {
         var _loc1_:PackageOut = this.createPackageOut();
         _loc1_.writeByte(LittleGamePackageOutType.ENTER_WORLD);
         this.sendPackage(_loc1_);
      }
      
      public function enterGame(param1:Scenario, param2:PackageIn) : void
      {
         BoguGiveUp.NoteCount = 0;
         NormalBoguInhaled.NoteCount = 0;
         this._current = param1;
         this._current.ddt_internal::drawNum();
         var _loc3_:int = param2.readInt();
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            param1.addLiving(this.readLivingFromPacket(param2,param1));
            _loc4_++;
         }
      }
      
      public function addObject(param1:Scenario, param2:String, param3:PackageIn = null) : ILittleObject
      {
         var _loc4_:ILittleObject = ObjectCreator.CreatObject(param2);
         if(Boolean(_loc4_))
         {
            _loc4_.initialize(param1,param3);
            param1.addObject(_loc4_);
         }
         return _loc4_;
      }
      
      public function removeObject(param1:Scenario, param2:PackageIn) : ILittleObject
      {
         var _loc3_:int = param2.readInt();
         return param1.removeObject(param1.findObject(_loc3_));
      }
      
      public function invokeObject(param1:Scenario, param2:PackageIn) : ILittleObject
      {
         var _loc3_:int = param2.readInt();
         var _loc4_:ILittleObject = param1.findObject(_loc3_);
         _loc4_.invoke(param2);
         return _loc4_;
      }
      
      public function addLiving(param1:Scenario, param2:PackageIn) : LittleLiving
      {
         return param1.addLiving(this.readLivingFromPacket(param2,param1));
      }
      
      public function removeLiving(param1:Scenario, param2:PackageIn) : LittleLiving
      {
         var _loc3_:int = param2.readInt();
         var _loc4_:LittleLiving = param1.livings[_loc3_];
         if(Boolean(_loc4_) && !_loc4_.dieing)
         {
            param1.removeLiving(_loc4_);
         }
         return _loc4_;
      }
      
      public function livingDie(param1:Scenario, param2:LittleLiving, param3:int = 6) : void
      {
         var _loc4_:LittleAction = new LittleLivingDieAction(param1,param2,param3);
         param2.act(_loc4_);
      }
      
      private function readLivingFromPacket(param1:PackageIn, param2:Scenario = null) : LittleLiving
      {
         var _loc3_:LittleLiving = null;
         var _loc4_:PlayerInfo = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:LittleAction = null;
         var _loc10_:int = param1.readInt();
         var _loc11_:int = param1.readInt();
         var _loc12_:int = param1.readInt();
         var _loc13_:int = param1.readInt();
         if(_loc13_ == Player)
         {
            _loc4_ = new PlayerInfo();
            _loc4_.ID = param1.readInt();
            _loc4_.Grade = param1.readInt();
            _loc4_.Repute = param1.readInt();
            _loc4_.NickName = param1.readUTF();
            _loc4_.typeVIP = param1.readByte();
            _loc4_.VIPLevel = param1.readInt();
            _loc4_.Sex = param1.readBoolean();
            _loc4_.Style = param1.readUTF();
            _loc4_.Colors = param1.readUTF();
            _loc4_.Skin = param1.readUTF();
            _loc4_.Hide = param1.readInt();
            _loc4_.FightPower = param1.readInt();
            _loc4_.WinCount = param1.readInt();
            _loc4_.TotalCount = param1.readInt();
            if(_loc4_.ID == PlayerManager.Instance.Self.ID)
            {
               _loc3_ = new LittleSelf(PlayerManager.Instance.Self,_loc10_,_loc11_,_loc12_,_loc13_);
            }
            else
            {
               _loc3_ = new LittlePlayer(_loc4_,_loc10_,_loc11_,_loc12_,_loc13_);
            }
         }
         else
         {
            _loc5_ = param1.readUTF();
            _loc6_ = param1.readUTF();
            _loc3_ = new LittleLiving(_loc10_,_loc11_,_loc12_,_loc13_,_loc6_);
            _loc3_.name = _loc5_;
         }
         var _loc14_:Boolean = param1.readBoolean();
         if(_loc14_)
         {
            _loc7_ = param1.readInt();
            _loc8_ = param1.readInt();
            if(Boolean(param2))
            {
               this.fillPath(_loc3_,param2.grid,_loc11_,_loc12_,_loc7_,_loc8_);
            }
         }
         var _loc15_:int = param1.readInt();
         var _loc16_:int = 0;
         while(_loc16_ < _loc15_)
         {
            _loc9_ = this.doAction(param2,param1);
            _loc9_.ddt_internal::initializeLiving(_loc3_);
            _loc3_.act(_loc9_);
            _loc16_++;
         }
         return _loc3_;
      }
      
      private function setLivingSize(param1:LittleLiving, param2:String) : void
      {
         if(param2 == "bogu4" || param2 == "bogu5" || param2 == "bogu8")
         {
            param1.size = 1;
         }
         else if(param2 == "bogu6")
         {
            param1.size = 2;
         }
         else if(param2 == "bogu7")
         {
            param1.size = 3;
         }
      }
      
      public function updatePos(param1:Scenario, param2:PackageIn) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:LittleLiving = null;
         param2.readDouble();
         var _loc7_:int = param2.readInt();
         var _loc8_:int = 0;
         while(_loc8_ < _loc7_)
         {
            _loc3_ = param2.readInt();
            _loc4_ = param2.readInt();
            _loc5_ = param2.readInt();
            _loc6_ = param1.findLiving(_loc3_);
            _loc8_++;
         }
      }
      
      public function livingMove(param1:Scenario, param2:PackageIn) : LittleLiving
      {
         var _loc3_:Array = null;
         var _loc4_:int = param2.readInt();
         var _loc5_:int = param2.readInt();
         var _loc6_:int = param2.readInt();
         var _loc7_:LittleLiving = param1.findLiving(_loc4_);
         if(_loc7_ && !_loc7_.lock && !_loc7_.dieing && !_loc7_.borning && _loc7_.MotionState > 1)
         {
            _loc3_ = LittleGameManager.Instance.fillPath(_loc7_,param1.grid,_loc7_.pos.x,_loc7_.pos.y,_loc5_,_loc6_);
            if(Boolean(_loc3_))
            {
               if(!_loc7_.isSelf)
               {
                  _loc7_.act(new LittleLivingMoveAction(_loc7_,_loc3_,param1));
               }
            }
            return _loc7_;
         }
         return null;
      }
      
      public function selfMoveTo(param1:Scenario, param2:LittleSelf, param3:int, param4:int, param5:int, param6:int, param7:int, param8:Array) : void
      {
         param2.act(new LittleSelfMoveAction(param2,param8,this._current,param7,param7 + param8.length * 40,true));
         var _loc9_:PackageOut = this.createPackageOut();
         _loc9_.writeByte(LittleGamePackageOutType.MOVE);
         _loc9_.writeInt(param3);
         _loc9_.writeInt(param4);
         _loc9_.writeInt(param5);
         _loc9_.writeInt(param6);
         _loc9_.writeInt(param7);
         this.sendPackage(_loc9_);
      }
      
      public function inhaled(param1:LittleSelf) : void
      {
         param1.inhaled = false;
      }
      
      public function updateLivingProperty(param1:Scenario, param2:PackageIn) : void
      {
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:* = undefined;
         var _loc6_:int = 0;
         var _loc7_:int = param2.readInt();
         var _loc8_:int = param2.readInt();
         var _loc9_:LittleLiving = param1.findLiving(_loc7_);
         if(Boolean(_loc9_))
         {
            _loc6_ = 0;
            for(; _loc6_ < _loc8_; _loc6_++)
            {
               _loc3_ = param2.readUTF();
               _loc4_ = param2.readInt();
               switch(_loc4_)
               {
                  case 1:
                     _loc5_ = param2.readInt();
                     break;
                  case 2:
                     _loc5_ = param2.readBoolean();
                     break;
                  case 3:
                     _loc5_ = param2.readUTF();
                     break;
                  default:
                     continue;
               }
               if(_loc9_.hasOwnProperty(_loc3_))
               {
                  _loc9_[_loc3_] = _loc5_;
               }
            }
         }
      }
      
      public function doAction(param1:Scenario, param2:PackageIn) : LittleAction
      {
         var _loc3_:String = param2.readUTF();
         var _loc4_:LittleAction = LittleActionCreator.CreatAction(_loc3_);
         if(Boolean(_loc4_))
         {
            _loc4_.parsePackege(param1,param2);
         }
         return _loc4_;
      }
      
      public function doMovie(param1:Scenario, param2:PackageIn) : void
      {
         var _loc3_:int = param2.readInt();
         var _loc4_:LittleLiving = param1.findLiving(_loc3_);
         var _loc5_:String = param2.readUTF();
         if(Boolean(_loc4_))
         {
         }
      }
      
      public function setClock(param1:Scenario, param2:PackageIn) : void
      {
         var _loc3_:int = param2.readInt();
      }
      
      public function pong(param1:Scenario, param2:PackageIn) : void
      {
         var _loc3_:int = param2.readInt();
         var _loc4_:PackageOut = this.createPackageOut();
         _loc4_.writeByte(LittleGamePackageOutType.PING);
         _loc4_.writeInt(_loc3_);
         this.sendPackage(_loc4_);
      }
      
      public function ping(param1:int) : void
      {
         var _loc2_:PackageOut = this.createPackageOut();
         _loc2_.writeByte(LittleGamePackageOutType.PING);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function setNetDelay(param1:Scenario, param2:PackageIn) : void
      {
         var _loc3_:int = param2.readInt();
         param1.delay = _loc3_;
         ChatManager.Instance.sysChatYellow("delay:" + _loc3_);
      }
      
      public function getScore(param1:Scenario, param2:PackageIn) : void
      {
         var _loc3_:int = param2.readInt();
         param1.selfPlayer.getScore(_loc3_);
      }
      
      public function livingClick(param1:Scenario, param2:LittleLiving, param3:int, param4:int) : void
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:LittleSelf = null;
         var _loc8_:Array = null;
         var _loc9_:PackageOut = null;
         if(!param2.isPlayer && !param2.dieing)
         {
            _loc5_ = param3 / this._current.grid.cellSize;
            _loc6_ = param4 / this._current.grid.cellSize;
            _loc7_ = this._current.selfPlayer;
            _loc8_ = this.fillPath(_loc7_,this._current.grid,_loc7_.pos.x,_loc7_.pos.y,_loc5_,_loc6_);
            if(Boolean(_loc8_))
            {
            }
            if(!param2.borning && _loc7_.MotionState > 1)
            {
               _loc9_ = this.createPackageOut();
               _loc9_.writeByte(LittleGamePackageOutType.CLICK);
               _loc9_.writeInt(param2.id);
               _loc9_.writeInt(param2.pos.x);
               _loc9_.writeInt(param2.pos.y);
               _loc9_.writeInt(_loc7_.pos.x);
               _loc9_.writeInt(_loc7_.pos.y);
               this.sendPackage(_loc9_);
            }
         }
      }
      
      public function cancelInhaled(param1:int) : void
      {
         var _loc2_:PackageOut = this.createPackageOut();
         _loc2_.writeByte(LittleGamePackageOutType.CANCEL_CLICK);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function synchronousLivingPos(param1:int, param2:int) : void
      {
         var _loc3_:PackageOut = this.createPackageOut();
         _loc3_.writeByte(LittleGamePackageOutType.POS_SYNC);
         _loc3_.writeInt(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function loadComplete() : void
      {
         var _loc1_:PackageOut = this.createPackageOut();
         _loc1_.writeByte(LittleGamePackageOutType.LOAD_COMPLETED);
         this.sendPackage(_loc1_);
      }
      
      public function createGame(param1:PackageIn) : Scenario
      {
         var _loc2_:Scenario = new Scenario();
         _loc2_.worldID = param1.readInt();
         _loc2_.id = param1.readInt();
         _loc2_.monsters = param1.readUTF();
         _loc2_.music = param1.readUTF();
         return _loc2_;
      }
      
      public function leave() : void
      {
         var _loc1_:PackageOut = this.createPackageOut();
         _loc1_.writeByte(LittleGamePackageOutType.LEAVE_WORLD);
         this.sendPackage(_loc1_);
         StateManager.setState(StateType.LITTLEHALL);
         LittleGamePacketQueue.Instance.shutdown();
      }
      
      public function get Current() : Scenario
      {
         return this._current;
      }
      
      public function sendScore(param1:int, param2:int) : void
      {
         var _loc3_:PackageOut = this.createPackageOut();
         _loc3_.writeByte(LittleGamePackageOutType.REPORT_SCORE);
         _loc3_.writeInt(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      private function createPackageOut() : PackageOut
      {
         return new PackageOut(ePackageType.LITTLEGAME_COMMAND);
      }
      
      public function sendPackage(param1:PackageOut) : void
      {
         SocketManager.Instance.out.sendPackage(param1);
      }
      
      public function setMainStage(param1:DisplayObjectContainer) : void
      {
         this._mainStage = param1;
      }
      
      public function setGameScene(param1:GameScene) : void
      {
         this._gamescene = param1;
      }
      
      public function get gameScene() : GameScene
      {
         return this._gamescene;
      }
      
      public function get mainStage() : DisplayObjectContainer
      {
         return this._mainStage;
      }
   }
}
