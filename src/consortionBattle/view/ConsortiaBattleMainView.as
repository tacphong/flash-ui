package consortionBattle.view
{
   import com.pickgliss.manager.CacheSysManager;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.utils.ObjectUtils;
   import consortionBattle.ConsortiaBattleManager;
   import ddt.constants.CacheConsts;
   import ddt.manager.ChatManager;
   import ddt.manager.InviteManager;
   import ddt.manager.KeyboardShortcutsManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.BaseStateView;
   import ddt.states.StateType;
   import ddt.view.MainToolBar;
   import flash.display.Sprite;
   import flash.events.Event;
   import game.GameManager;
   
   public class ConsortiaBattleMainView extends BaseStateView
   {
       
      
      private var _mapView:consortionBattle.view.ConsortiaBattleMapView;
      
      private var _exitBtn:consortionBattle.view.ConsBatExitBtn;
      
      private var _infoView:consortionBattle.view.ConsBatInfoView;
      
      private var _inTimerView:consortionBattle.view.ConsBatInTimer;
      
      private var _twoBtnView:consortionBattle.view.ConsBatTwoBtnView;
      
      private var _hideBtn:consortionBattle.view.ConsBatHideBtn;
      
      private var _helpBtn:consortionBattle.view.ConsBatHelpBtn;
      
      private var _socreView:consortionBattle.view.ConsBatScoreView;
      
      private var _broadcastView:consortionBattle.view.ConsBatChatView;
      
      private var _chatView:Sprite;
      
      public function ConsortiaBattleMainView()
      {
         super();
      }
      
      override public function enter(param1:BaseStateView, param2:Object = null) : void
      {
         var prev:BaseStateView = param1;
         var data:Object = param2;
         if(!ConsortiaBattleManager.instance.isOpen)
         {
            this.closeHandler(null);
            return;
         }
         try
         {
            SocketManager.Instance.out.sendUpdateSysDate();
            InviteManager.Instance.enabled = false;
            CacheSysManager.lock(CacheConsts.CONSORTIA_BATTLE_IN_ROOM);
            KeyboardShortcutsManager.Instance.forbiddenFull();
            super.enter(prev,data);
            LayerManager.Instance.clearnGameDynamic();
            LayerManager.Instance.clearnStageDynamic();
            MainToolBar.Instance.hide();
            SoundManager.instance.playMusic("12019");
            this.initView();
            this.initEvent();
            this.initData();
            ConsortiaBattleManager.instance.isInMainView = true;
            return;
         }
         catch(err:Error)
         {
            SocketManager.Instance.out.sendConsBatExit();
            closeHandler(null);
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortiaBattle.loadResError"));
            throw new Error(err.message);
         }
      }
      
      private function initView() : void
      {
         this._mapView = new consortionBattle.view.ConsortiaBattleMapView("tank.consortiaBattle.Map",ConsortiaBattleManager.instance.playerDataList);
         addChild(this._mapView);
         this._mapView.addSelfPlayer();
         this._exitBtn = new consortionBattle.view.ConsBatExitBtn();
         addChild(this._exitBtn);
         this._infoView = new consortionBattle.view.ConsBatInfoView();
         addChild(this._infoView);
         this._inTimerView = new consortionBattle.view.ConsBatInTimer();
         addChild(this._inTimerView);
         this._twoBtnView = new consortionBattle.view.ConsBatTwoBtnView();
         addChild(this._twoBtnView);
         this._hideBtn = new consortionBattle.view.ConsBatHideBtn();
         addChild(this._hideBtn);
         this._helpBtn = new consortionBattle.view.ConsBatHelpBtn();
         addChild(this._helpBtn);
         this._socreView = new consortionBattle.view.ConsBatScoreView();
         addChild(this._socreView);
         this._broadcastView = new consortionBattle.view.ConsBatChatView();
         addChild(this._broadcastView);
         this._chatView = ChatManager.Instance.view;
         addChild(this._chatView);
         ChatManager.Instance.state = ChatManager.CHAT_CONSORTIABATTLE_SCENE;
         ChatManager.Instance.setFocus();
         ChatManager.Instance.lock = true;
      }
      
      private function initEvent() : void
      {
         GameManager.Instance.addEventListener(GameManager.START_LOAD,this.__startLoading);
         StateManager.getInGame_Step_1 = true;
         ConsortiaBattleManager.instance.addEventListener(ConsortiaBattleManager.CLOSE,this.closeHandler);
      }
      
      private function closeHandler(param1:Event) : void
      {
         StateManager.setState(StateType.MAIN);
      }
      
      private function initData() : void
      {
      }
      
      private function __startLoading(param1:Event) : void
      {
         StateManager.getInGame_Step_6 = true;
         ChatManager.Instance.input.faceEnabled = false;
         LayerManager.Instance.clearnGameDynamic();
         StateManager.setState(StateType.ROOM_LOADING,GameManager.Instance.Current);
         StateManager.getInGame_Step_7 = true;
      }
      
      override public function leaving(param1:BaseStateView) : void
      {
         InviteManager.Instance.enabled = true;
         CacheSysManager.unlock(CacheConsts.CONSORTIA_BATTLE_IN_ROOM);
         CacheSysManager.getInstance().release(CacheConsts.CONSORTIA_BATTLE_IN_ROOM);
         KeyboardShortcutsManager.Instance.cancelForbidden();
         GameManager.Instance.removeEventListener(GameManager.START_LOAD,this.__startLoading);
         StateManager.getInGame_Step_8 = true;
         ConsortiaBattleManager.instance.removeEventListener(ConsortiaBattleManager.CLOSE,this.closeHandler);
         super.leaving(param1);
         ObjectUtils.disposeObject(this._mapView);
         this._mapView = null;
         ObjectUtils.disposeObject(this._exitBtn);
         this._exitBtn = null;
         ObjectUtils.disposeObject(this._infoView);
         this._infoView = null;
         ObjectUtils.disposeObject(this._inTimerView);
         this._inTimerView = null;
         ObjectUtils.disposeObject(this._twoBtnView);
         this._twoBtnView = null;
         ObjectUtils.disposeObject(this._hideBtn);
         this._hideBtn = null;
         ObjectUtils.disposeObject(this._helpBtn);
         this._helpBtn = null;
         ObjectUtils.disposeObject(this._socreView);
         this._socreView = null;
         ObjectUtils.disposeObject(this._broadcastView);
         this._broadcastView = null;
         if(Boolean(this._chatView) && this.contains(this._chatView))
         {
            this.removeChild(this._chatView);
         }
         this._chatView = null;
         ConsortiaBattleManager.instance.clearPlayerInfo();
         ConsortiaBattleManager.instance.isInMainView = false;
      }
      
      override public function getType() : String
      {
         return StateType.CONSORTIA_BATTLE_SCENE;
      }
      
      override public function dispose() : void
      {
      }
   }
}
