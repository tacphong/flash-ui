package ddt.view.tips
{
   import bagAndInfo.info.PlayerInfoViewControl;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.tip.ITip;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.ChatManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.utils.PositionUtils;
   import ddt.view.SimpleItem;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import game.view.playerThumbnail.HeadFigure;
   import game.view.playerThumbnail.PlayerThumbnail;
   import im.IMController;
   
   [Event(name="playerThumbnailTipItemClick",type="flash.events.Event")]
   public class PlayerThumbnailTip extends Sprite implements Disposeable, ITip
   {
      
      public static const VIEW_INFO:int = 0;
      
      public static const MAKE_FRIEND:int = 1;
      
      public static const PRIVATE_CHAT:int = 2;
       
      
      private var _bg:Image;
      
      private var _items:Vector.<SimpleItem>;
      
      private var _playerTipDisplay:PlayerThumbnail;
      
      public function PlayerThumbnailTip()
      {
         super();
         this.init();
      }
      
      public function init() : void
      {
         var _loc1_:Point = null;
         var _loc2_:SimpleItem = null;
         _loc1_ = null;
         _loc2_ = null;
         this._bg = ComponentFactory.Instance.creatComponentByStylename("game.playerThumbnailTipBg");
         addChild(this._bg);
         this._items = new Vector.<SimpleItem>();
         _loc1_ = PositionUtils.creatPoint("game.PlayerThumbnailTipItemPos");
         var _loc3_:int = 0;
         while(_loc3_ < 3)
         {
            _loc2_ = ComponentFactory.Instance.creatComponentByStylename("game.PlayerThumbnailTipItem");
            (_loc2_.foreItems[0] as FilterFrameText).text = LanguageMgr.GetTranslation("game.PlayerThumbnailTipItemText_" + _loc3_.toString());
            _loc2_.addEventListener(MouseEvent.ROLL_OVER,this.__onMouseOver);
            _loc2_.addEventListener(MouseEvent.ROLL_OUT,this.__onMouseOut);
            _loc2_.addEventListener(MouseEvent.CLICK,this.__onMouseClick);
            _loc2_.backItem.visible = false;
            _loc2_.buttonMode = true;
            _loc2_.x = _loc1_.x;
            _loc2_.y = _loc1_.y;
            _loc1_.y += _loc2_.height - 2;
            this._items.push(_loc2_);
            addChild(_loc2_);
            _loc3_++;
         }
         addEventListener(Event.ADDED_TO_STAGE,this.__addStageEvent);
         addEventListener(Event.REMOVED_FROM_STAGE,this.__removeFromStage);
      }
      
      public function set tipDisplay(param1:PlayerThumbnail) : void
      {
         this._playerTipDisplay = param1;
      }
      
      public function get tipDisplay() : PlayerThumbnail
      {
         return this._playerTipDisplay;
      }
      
      private function __addStageEvent(param1:Event) : void
      {
         StageReferance.stage.addEventListener(MouseEvent.CLICK,this.__removeStageEvent);
      }
      
      private function __removeStageEvent(param1:MouseEvent) : void
      {
         if(param1.target is HeadFigure)
         {
            return;
         }
         StageReferance.stage.removeEventListener(MouseEvent.CLICK,this.__removeStageEvent);
         param1.stopImmediatePropagation();
         param1.stopPropagation();
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      private function __removeFromStage(param1:Event) : void
      {
         dispatchEvent(new Event("playerThumbnailTipItemClick"));
      }
      
      private function __onMouseOver(param1:MouseEvent) : void
      {
         var _loc2_:SimpleItem = param1.currentTarget as SimpleItem;
         if(Boolean(_loc2_) && Boolean(_loc2_.backItem))
         {
            _loc2_.backItem.visible = true;
         }
      }
      
      private function __onMouseOut(param1:MouseEvent) : void
      {
         var _loc2_:SimpleItem = param1.currentTarget as SimpleItem;
         if(Boolean(_loc2_) && Boolean(_loc2_.backItem))
         {
            _loc2_.backItem.visible = false;
         }
      }
      
      private function __onMouseClick(param1:MouseEvent) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:SimpleItem = param1.currentTarget as SimpleItem;
         var _loc4_:int = this._items.indexOf(_loc3_);
         switch(_loc4_)
         {
            case VIEW_INFO:
               PlayerInfoViewControl.view(this._playerTipDisplay.info,false);
               break;
            case MAKE_FRIEND:
               if(this._playerTipDisplay.info.ZoneID > 0 && this._playerTipDisplay.info.ZoneID != PlayerManager.Instance.Self.ZoneID)
               {
                  ChatManager.Instance.sysChatYellow(LanguageMgr.GetTranslation("core.crossZone.AddFriendUnable"));
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("core.crossZone.AddFriendUnable"));
               }
               else
               {
                  IMController.Instance.addFriend(this._playerTipDisplay.info.NickName);
               }
               break;
            case PRIVATE_CHAT:
               if(this._playerTipDisplay.info.ZoneID > 0 && this._playerTipDisplay.info.ZoneID != PlayerManager.Instance.Self.ZoneID)
               {
                  ChatManager.Instance.sysChatYellow(LanguageMgr.GetTranslation("core.crossZone.PrivateChatToUnable"));
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("core.crossZone.PrivateChatToUnable"));
               }
               else
               {
                  ChatManager.Instance.privateChatTo(this._playerTipDisplay.info.NickName);
                  _loc2_ = true;
               }
         }
         StageReferance.stage.removeEventListener(MouseEvent.CLICK,this.__removeStageEvent);
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
         if(_loc2_)
         {
            ChatManager.Instance.setFocus();
         }
      }
      
      public function get tipData() : Object
      {
         return null;
      }
      
      public function set tipData(param1:Object) : void
      {
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      public function dispose() : void
      {
         var _loc1_:SimpleItem = null;
         this._playerTipDisplay = null;
         ObjectUtils.disposeObject(this._bg);
         var _loc2_:int = 0;
         while(_loc2_ < this._items.length)
         {
            _loc1_ = this._items[_loc2_];
            ObjectUtils.disposeObject(_loc1_);
            _loc1_ = null;
            _loc2_++;
         }
         this._items = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}
