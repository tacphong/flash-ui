package roomList.pveRoomList
{
   import com.pickgliss.manager.CacheSysManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import ddt.constants.CacheConsts;
   import ddt.data.map.DungeonInfo;
   import ddt.data.player.FriendListPlayer;
   import ddt.data.player.PlayerInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.AcademyManager;
   import ddt.manager.EffortMovieClipManager;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MapManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.PlayerTipManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StatisticManager;
   import ddt.states.BaseStateView;
   import ddt.states.StateType;
   import ddt.view.MainToolBar;
   import ddt.view.tips.PlayerTip;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import road7th.comm.PackageIn;
   import room.RoomManager;
   import room.model.RoomInfo;
   import roomList.LookupEnumerate;
   import roomList.LookupRoomFrame;
   import roomList.PassInputFrame;
   import roomList.pvpRoomList.RoomListCreateRoomView;
   
   public class DungeonListController extends BaseStateView
   {
      
      private static var isShowTutorial:Boolean = false;
       
      
      private var _container:Sprite;
      
      private var _model:roomList.pveRoomList.DungeonListModel;
      
      private var _view:roomList.pveRoomList.DungeonListView;
      
      private var _createview:roomList.pveRoomList.DungeonCreateRoomView;
      
      private var _passinput:PassInputFrame;
      
      private var _findRoom:LookupRoomFrame;
      
      private var _defaluDungeonMapId_3:int;
      
      private var _defaluDungeonMapId_4:int;
      
      public function DungeonListController()
      {
         this.upMapId();
         super();
      }
      
      public static function disorder(param1:Array) : Array
      {
         var _loc2_:int = 0;
         var _loc3_:RoomInfo = null;
         var _loc4_:int = 0;
         while(_loc4_ < param1.length)
         {
            _loc2_ = Math.random() * 10000 % param1.length;
            _loc3_ = param1[_loc4_];
            param1[_loc4_] = param1[_loc2_];
            param1[_loc2_] = _loc3_;
            _loc4_++;
         }
         var _loc5_:Array = [];
         var _loc6_:int = 0;
         while(_loc6_ < param1.length)
         {
            if(!(param1[_loc6_] as RoomInfo).isPlaying)
            {
               _loc5_.push(param1[_loc6_]);
            }
            else
            {
               _loc5_.unshift(param1[_loc6_]);
            }
            _loc6_++;
         }
         return _loc5_;
      }
      
      private function init() : void
      {
         this._model = new roomList.pveRoomList.DungeonListModel();
         this._container = new Sprite();
         this._container.graphics.beginFill(0,0);
         this._container.graphics.drawRect(0,0,1000,600);
         this._container.graphics.endFill();
         this._view = new roomList.pveRoomList.DungeonListView(this,this._model);
         this._container.addChild(this._view);
      }
      
      private function initEvent() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_ROOMLIST_UPDATE,this.__addRoom);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SCENE_ADD_USER,this.__addWaitingPlayer);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SCENE_REMOVE_USER,this.__removeWaitingPlayer);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ROOMLIST_PASS,this.__roomListPass);
         PlayerTipManager.instance.addEventListener(PlayerTip.CHALLENGE,this.__onChanllengeClick);
      }
      
      private function __addRoom(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:RoomInfo = null;
         var _loc4_:Array = [];
         var _loc5_:PackageIn = param1.pkg;
         this._model.roomTotal = _loc5_.readInt();
         var _loc6_:int = _loc5_.readInt();
         var _loc7_:int = 0;
         while(_loc7_ < _loc6_)
         {
            _loc2_ = _loc5_.readInt();
            _loc3_ = this._model.getRoomById(_loc2_);
            if(_loc3_ == null)
            {
               _loc3_ = new RoomInfo();
            }
            _loc3_.ID = _loc2_;
            _loc3_.type = _loc5_.readByte();
            _loc3_.timeType = _loc5_.readByte();
            _loc3_.totalPlayer = _loc5_.readByte();
            _loc3_.viewerCnt = _loc5_.readByte();
            _loc3_.maxViewerCnt = _loc5_.readByte();
            _loc3_.placeCount = _loc5_.readByte();
            _loc3_.IsLocked = _loc5_.readBoolean();
            _loc3_.mapId = _loc5_.readInt();
            _loc3_.isPlaying = _loc5_.readBoolean();
            _loc3_.Name = _loc5_.readUTF();
            _loc3_.gameMode = _loc5_.readByte();
            _loc3_.hardLevel = _loc5_.readByte();
            _loc3_.levelLimits = _loc5_.readInt();
            _loc3_.isOpenBoss = _loc5_.readBoolean();
            if(_loc3_.type != RoomInfo.FRESHMAN_ROOM)
            {
               _loc4_.push(_loc3_);
            }
            _loc7_++;
         }
         this.updataRoom(_loc4_);
      }
      
      private function updataRoom(param1:Array) : void
      {
         if(param1.length == 0)
         {
            this._model.updateRoom(param1);
            return;
         }
         if((param1[0] as RoomInfo).type > 2)
         {
            this._model.updateRoom(param1);
         }
      }
      
      private function __addWaitingPlayer(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:PlayerInfo = PlayerManager.Instance.findPlayer(_loc2_.clientId);
         _loc3_.beginChanges();
         _loc3_.Grade = _loc2_.readInt();
         _loc3_.Sex = _loc2_.readBoolean();
         _loc3_.NickName = _loc2_.readUTF();
         _loc3_.IsVIP = _loc2_.readBoolean();
         _loc3_.VIPLevel = _loc2_.readInt();
         _loc3_.ConsortiaName = _loc2_.readUTF();
         _loc3_.Offer = _loc2_.readInt();
         _loc3_.WinCount = _loc2_.readInt();
         _loc3_.TotalCount = _loc2_.readInt();
         _loc3_.EscapeCount = _loc2_.readInt();
         _loc3_.ConsortiaID = _loc2_.readInt();
         _loc3_.Repute = _loc2_.readInt();
         _loc3_.IsMarried = _loc2_.readBoolean();
         if(_loc3_.IsMarried)
         {
            _loc3_.SpouseID = _loc2_.readInt();
            _loc3_.SpouseName = _loc2_.readUTF();
         }
         _loc3_.LoginName = _loc2_.readUTF();
         _loc3_.FightPower = _loc2_.readInt();
         _loc3_.apprenticeshipState = _loc2_.readInt();
         _loc3_.commitChanges();
         this._model.addWaitingPlayer(_loc3_);
      }
      
      private function __removeWaitingPlayer(param1:CrazyTankSocketEvent) : void
      {
         this._model.removeWaitingPlayer(param1.pkg.clientId);
      }
      
      public function setRoomShowMode(param1:int) : void
      {
         this._model.roomShowMode = param1;
      }
      
      private function __roomListPass(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = param1.pkg.readInt();
         if(Boolean(this._passinput))
         {
            this._passinput.dispose();
         }
         this._passinput = null;
         if(!this._passinput)
         {
            this._passinput = ComponentFactory.Instance.creat("roomList.RoomList.passInputFrame");
            LayerManager.Instance.addToLayer(this._passinput,LayerManager.GAME_DYNAMIC_LAYER);
         }
         this._passinput.ID = _loc2_;
      }
      
      override public function enter(param1:BaseStateView, param2:Object = null) : void
      {
         SoundManager.instance.playMusic("062");
         super.enter(param1,param2);
         ++StatisticManager.loginRoomListNum;
         SocketManager.Instance.out.sendCurrentState(1);
         this.init();
         this.initEvent();
         SocketManager.Instance.out.sendSceneLogin(LookupEnumerate.DUNGEON_LIST);
         MainToolBar.Instance.show();
         EffortMovieClipManager.Instance.show();
         CacheSysManager.unlock(CacheConsts.ALERT_IN_FIGHT);
         CacheSysManager.getInstance().release(CacheConsts.ALERT_IN_FIGHT,1200);
         AcademyManager.Instance.showAlert();
         PlayerManager.Instance.Self.isUpGradeInGame = false;
      }
      
      override public function leaving(param1:BaseStateView) : void
      {
         this.dispose();
         GameInSocketOut.sendExitScene();
         MainToolBar.Instance.hide();
         super.leaving(param1);
      }
      
      override public function getView() : DisplayObject
      {
         return this._container;
      }
      
      override public function getType() : String
      {
         return StateType.DUNGEON_LIST;
      }
      
      public function sendGoIntoRoom(param1:RoomInfo) : void
      {
      }
      
      public function showFindRoom() : void
      {
         if(Boolean(this._findRoom))
         {
            this._findRoom.dispose();
         }
         this._findRoom = null;
         this._findRoom = ComponentFactory.Instance.creat("roomList.RoomList.lookupFrame");
         LayerManager.Instance.addToLayer(this._findRoom,LayerManager.GAME_DYNAMIC_LAYER);
      }
      
      protected function __onChanllengeClick(param1:Event) : void
      {
         if(PlayerTipManager.instance.info.Grade < 4)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.roomlist.cantBeChallenged"));
            return;
         }
         if(PlayerTipManager.instance.info.playerState.StateID == 0 && param1.target.info is FriendListPlayer)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.roomlist.friendOffline"));
            return;
         }
         var _loc2_:int = int(Math.random() * RoomListCreateRoomView.PREWORD.length);
         GameInSocketOut.sendCreateRoom(RoomListCreateRoomView.PREWORD[_loc2_],1,2,"");
         RoomManager.Instance.tempInventPlayerID = PlayerTipManager.instance.info.ID;
         PlayerTipManager.instance.removeEventListener(PlayerTip.CHALLENGE,this.__onChanllengeClick);
      }
      
      private function upMapId() : void
      {
         var _loc1_:DungeonInfo = MapManager.getListByType(3)[0] as DungeonInfo;
         if(Boolean(_loc1_))
         {
            this._defaluDungeonMapId_3 = _loc1_.ID;
         }
         var _loc2_:DungeonInfo = MapManager.getListByType(4)[0] as DungeonInfo;
         if(Boolean(_loc2_))
         {
            this._defaluDungeonMapId_4 = _loc2_.ID;
         }
      }
      
      override public function dispose() : void
      {
         PlayerTipManager.instance.removeEventListener(PlayerTip.CHALLENGE,this.__onChanllengeClick);
         if(Boolean(this._createview))
         {
            this._createview.dispose();
         }
         if(Boolean(this._findRoom))
         {
            this._findRoom.dispose();
         }
         if(Boolean(this._view))
         {
            this._view.dispose();
         }
         if(Boolean(this._model))
         {
            this._model.dispose();
         }
         this._createview = null;
         this._findRoom = null;
         this._view = null;
         this._model = null;
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.GAME_ROOMLIST_UPDATE,this.__addRoom);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.SCENE_ADD_USER,this.__addWaitingPlayer);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.SCENE_REMOVE_USER,this.__removeWaitingPlayer);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.ROOMLIST_PASS,this.__roomListPass);
      }
      
      override public function getBackType() : String
      {
         return StateType.MAIN;
      }
      
      public function showCreateView() : void
      {
         if(this._createview != null)
         {
            this._createview.dispose();
         }
         this._createview = null;
         this._createview = ComponentFactory.Instance.creat("roomList.pveRoomList.DungeonCreateRoomView");
         LayerManager.Instance.addToLayer(this._createview,LayerManager.GAME_DYNAMIC_LAYER,false,LayerManager.BLCAK_BLOCKGOUND);
      }
   }
}
