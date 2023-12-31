package ddt.view.chat
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ChatManager;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SharedManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import ddt.utils.Helpers;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.geom.Rectangle;
   import flash.utils.Timer;
   
   public class ChatBugleView extends Sprite
   {
      
      private static const BIG_BUGLE:uint = 1;
      
      private static const SMALL_BUGLE:uint = 2;
      
      private static const ADMIN_NOTICE:uint = 3;
      
      private static const DEFY_AFFICHE:uint = 3;
      
      private static const CROSS_BUGLE:uint = 4;
      
      private static const CROSS_NOTICE:uint = 5;
      
      private static const MOVE_STEP:uint = 3;
      
      private static var _instance:ddt.view.chat.ChatBugleView;
       
      
      private var _scrollTimer:Timer;
      
      private var _showTimer:Timer;
      
      private var _isplaying:Boolean;
      
      private var _bugleList:Array;
      
      private var _currentBugle:String;
      
      private var _currentBugleType:int;
      
      private var _currentBigBugleType:int;
      
      private var _buggleTypeMc:ScaleFrameImage;
      
      private var _bg:Bitmap;
      
      private var _contentTxt:FilterFrameText;
      
      private var _animationTxt:FilterFrameText;
      
      private var _bigBugleAnimations:Vector.<MovieClip>;
      
      private var _fieldRect:Rectangle;
      
      private var _scrollCounter:int = 0;
      
      public function ChatBugleView()
      {
         super();
      }
      
      public static function get instance() : ddt.view.chat.ChatBugleView
      {
         if(_instance == null)
         {
            _instance = new ddt.view.chat.ChatBugleView();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         this._bigBugleAnimations = new Vector.<MovieClip>();
         this._bg = ComponentFactory.Instance.creatBitmap("asset.chat.BugleViewBg");
         this._buggleTypeMc = ComponentFactory.Instance.creatComponentByStylename("chat.BugleViewType");
         this._contentTxt = ComponentFactory.Instance.creatComponentByStylename("chat.BugleViewText");
         this._animationTxt = ComponentFactory.Instance.creatComponentByStylename("chat.BugleAnimationText");
         PositionUtils.setPos(this,"chat.BugleViewPos");
         var _loc1_:int = 0;
         while(_loc1_ < 6)
         {
            this._bigBugleAnimations.push(ComponentFactory.Instance.creat("chat.BugleAnimation_" + _loc1_.toString()));
            PositionUtils.setPos(this._bigBugleAnimations[_loc1_],"chat.BugleAnimationPos_" + _loc1_.toString());
            _loc1_++;
         }
         this._scrollTimer = new Timer(32);
         this._showTimer = new Timer(16000);
         this._isplaying = false;
         this._bugleList = [];
         this._currentBugleType = -1;
         addChild(this._bg);
         addChild(this._buggleTypeMc);
         addChild(this._contentTxt);
         mouseEnabled = mouseChildren = false;
         this.initEvent();
      }
      
      private function initEvent() : void
      {
         this._showTimer.addEventListener(TimerEvent.TIMER,this.__showTimer);
         ChatManager.Instance.model.addEventListener(ChatEvent.ADD_CHAT,this.__onAddChat);
      }
      
      private function __onAddChat(param1:ChatEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Object = null;
         var _loc4_:Number = NaN;
         var _loc5_:int = 0;
         var _loc6_:ItemTemplateInfo = null;
         var _loc7_:uint = 0;
         if(ChatManager.Instance.state == ChatManager.CHAT_WEDDINGROOM_STATE || ChatManager.Instance.state == ChatManager.CHAT_HOTSPRING_ROOM_VIEW || ChatManager.Instance.state == ChatManager.CHAT_TRAINER_STATE || ChatManager.Instance.state == ChatManager.CHAT_LITTLEGAME || ChatManager.Instance.isInGame || ChatManager.Instance.state == ChatManager.CHAT_CONSORTIABATTLE_SCENE)
         {
            return;
         }
         var _loc8_:ChatData = param1.data as ChatData;
         var _loc9_:String = "";
         var _loc10_:String = _loc8_.msg.replace("&lt;","<").replace("&gt;",">");
         _loc10_ = Helpers.deCodeString(_loc10_);
         if(Boolean(_loc8_.link))
         {
            _loc2_ = 0;
            _loc8_.link.sortOn("index");
            for each(_loc3_ in _loc8_.link)
            {
               _loc4_ = Number(_loc3_.ItemID);
               _loc5_ = int(_loc3_.TemplateID);
               _loc6_ = ItemManager.Instance.getTemplateById(_loc5_);
               _loc7_ = _loc3_.index + _loc2_;
               _loc10_ = _loc10_.substring(0,_loc7_) + "[" + _loc6_.Name + "]" + _loc10_.substring(_loc7_);
               _loc2_ += _loc6_.Name.length;
            }
         }
         var _loc11_:int = int(BIG_BUGLE);
         var _loc12_:int = int(ChatData.B_BUGGLE_TYPE_NORMAL);
         if(_loc8_.channel == ChatInputView.SMALL_BUGLE)
         {
            _loc11_ = int(SMALL_BUGLE);
            _loc9_ = "[" + _loc8_.sender + LanguageMgr.GetTranslation("tank.view.common.BuggleView.small") + _loc10_;
         }
         else if(_loc8_.channel == ChatInputView.BIG_BUGLE)
         {
            _loc11_ = int(BIG_BUGLE);
            if(_loc8_.bigBuggleType != ChatData.B_BUGGLE_TYPE_NORMAL)
            {
               _loc12_ = int(_loc8_.bigBuggleType);
               _loc9_ = "[" + _loc8_.sender + "]:" + _loc10_;
            }
            else
            {
               _loc12_ = int(ChatData.B_BUGGLE_TYPE_NORMAL);
               _loc9_ = "[" + _loc8_.sender + LanguageMgr.GetTranslation("tank.view.common.BuggleView.big") + _loc10_;
            }
         }
         else if(_loc8_.channel == ChatInputView.CROSS_BUGLE)
         {
            _loc11_ = int(CROSS_BUGLE);
            _loc9_ = "[" + _loc8_.sender + LanguageMgr.GetTranslation("tank.view.common.BuggleView.cross") + _loc10_;
         }
         else if(_loc8_.channel == ChatInputView.CROSS_NOTICE)
         {
            _loc11_ = int(ADMIN_NOTICE);
            _loc9_ = _loc10_;
         }
         else if(_loc8_.channel == ChatInputView.DEFY_AFFICHE)
         {
            _loc11_ = int(DEFY_AFFICHE);
            _loc9_ = _loc10_;
         }
         else
         {
            if(!(_loc8_.channel == ChatInputView.SYS_NOTICE || _loc8_.channel == ChatInputView.SYS_TIP))
            {
               return;
            }
            if(!(_loc8_.type == 1 || _loc8_.type == 3 || _loc8_.type == 9))
            {
               return;
            }
            _loc11_ = int(ADMIN_NOTICE);
            _loc9_ = _loc10_;
         }
         this._bugleList.push(new ChatBugleData(_loc9_,_loc11_,_loc12_));
         this.checkPlay();
      }
      
      private function __scrollTimer(param1:TimerEvent) : void
      {
         if(this._isplaying)
         {
            if(parent == null)
            {
               this.show();
            }
         }
         var _loc2_:Boolean = this._fieldRect.x + this._fieldRect.width < this._contentTxt.textWidth;
         if(!_loc2_)
         {
            if(this._currentBugleType != ADMIN_NOTICE && this._scrollCounter < 2)
            {
               this.checkScrollTimer();
               this._isplaying = true;
            }
            else
            {
               this._scrollCounter = 0;
               this._isplaying = false;
               this._scrollTimer.stop();
               this.checkPlay();
            }
         }
         else if(this._contentTxt.text != "")
         {
            if(_loc2_)
            {
               this._fieldRect.x += MOVE_STEP;
            }
            else
            {
               this._isplaying = false;
            }
            this._contentTxt.scrollRect = this._fieldRect;
         }
      }
      
      private function __showTimer(param1:TimerEvent) : void
      {
         this._isplaying = false;
         this._showTimer.stop();
         this.checkPlay();
      }
      
      private function checkPlay() : void
      {
         var _loc2_:String = null;
         var _loc1_:ChatBugleData = null;
         _loc2_ = null;
         if(this._isplaying)
         {
            return;
         }
         if(this._bugleList.length > 0)
         {
            _loc1_ = this._bugleList.splice(0,1)[0];
            _loc2_ = _loc1_.content;
            this._currentBugleType = _loc1_.BugleType;
            this._currentBigBugleType = _loc1_.subBugleType;
            if(Boolean(this._animationTxt.parent))
            {
               this._animationTxt.parent.removeChild(this._animationTxt);
            }
            this.removeAllBuggleAnimations();
            this._buggleTypeMc.setFrame(this._currentBugleType);
            addChild(this._bg);
            addChild(this._buggleTypeMc);
            addChild(this._contentTxt);
            if(this._currentBugleType == BIG_BUGLE)
            {
               this._contentTxt.textColor = ChatFormats.getColorByChannel(ChatInputView.BIG_BUGLE);
               if(this._currentBigBugleType != ChatData.B_BUGGLE_TYPE_NORMAL)
               {
                  if(Boolean(this._contentTxt.parent))
                  {
                     this._contentTxt.parent.removeChild(this._contentTxt);
                  }
                  if(Boolean(this._buggleTypeMc.parent))
                  {
                     this._buggleTypeMc.parent.removeChild(this._buggleTypeMc);
                  }
                  if(Boolean(this._bg.parent))
                  {
                     this._bg.parent.removeChild(this._bg);
                  }
                  this._animationTxt.textColor = ChatFormats.getColorByBigBuggleType(this._currentBigBugleType - 1);
                  this._animationTxt.x = this._bigBugleAnimations[this._currentBigBugleType - 1].x;
                  this._animationTxt.y = this._bigBugleAnimations[this._currentBigBugleType - 1].y;
                  this._bigBugleAnimations[this._currentBigBugleType - 1].play();
                  addChild(this._bigBugleAnimations[this._currentBigBugleType - 1]);
                  addChild(this._animationTxt);
                  this._animationTxt.text = _loc2_;
                  this._isplaying = true;
                  this.checkNeedTimer();
                  this.show();
                  return;
               }
            }
            else if(this._currentBugleType == SMALL_BUGLE)
            {
               this._contentTxt.textColor = ChatFormats.getColorByChannel(ChatInputView.SMALL_BUGLE);
            }
            else if(this._currentBugleType == ADMIN_NOTICE)
            {
               this._contentTxt.textColor = ChatFormats.getColorByChannel(ChatInputView.ADMIN_NOTICE);
            }
            else if(this._currentBugleType == DEFY_AFFICHE)
            {
               this._contentTxt.textColor = ChatFormats.getColorByChannel(ChatInputView.DEFY_AFFICHE);
            }
            else if(this._currentBugleType == CROSS_BUGLE)
            {
               this._contentTxt.textColor = ChatFormats.getColorByChannel(ChatInputView.CROSS_BUGLE);
            }
            else if(this._currentBugleType == CROSS_NOTICE)
            {
               this._contentTxt.textColor = ChatFormats.getColorByChannel(ChatInputView.CROSS_NOTICE);
            }
            this._contentTxt.text = "\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t" + _loc2_ + "\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t";
            this._scrollCounter = 0;
            this.checkScrollTimer();
            this._isplaying = true;
            this.show();
         }
         else
         {
            this.hide();
         }
      }
      
      private function checkScrollTimer() : void
      {
         this._scrollTimer.stop();
         this._scrollTimer.removeEventListener(TimerEvent.TIMER,this.__scrollTimer);
         this._fieldRect = new Rectangle(0,0,875,this._contentTxt.height);
         this._contentTxt.scrollRect = this._fieldRect;
         if(this._fieldRect.width < this._contentTxt.textWidth)
         {
            this._scrollTimer.addEventListener(TimerEvent.TIMER,this.__scrollTimer);
            this._scrollTimer.start();
         }
         ++this._scrollCounter;
      }
      
      private function checkNeedTimer() : void
      {
         this._showTimer.start();
      }
      
      public function show() : void
      {
         if(StateManager.currentStateType == StateType.FIGHTING || StateManager.currentStateType == StateType.SHOP || StateManager.currentStateType == StateType.HOT_SPRING_ROOM && ChatManager.Instance.state == ChatManager.CHAT_HOTSPRING_ROOM_VIEW)
         {
            return;
         }
         if(StateManager.currentStateType == StateType.TRAINER || StateManager.currentStateType == StateType.LODING_TRAINER)
         {
            return;
         }
         if(StateManager.currentStateType == StateType.FIGHT_LIB_GAMEVIEW || StateManager.currentStateType == StateType.WORLDBOSS_ROOM)
         {
            return;
         }
         this.updatePos();
         if(this._currentBugleType == ADMIN_NOTICE)
         {
            LayerManager.Instance.addToLayer(this,LayerManager.GAME_UI_LAYER,false,0,false);
            this.parent.setChildIndex(this,this.parent.numChildren - 1);
            return;
         }
         if(SharedManager.Instance.showTopMessageBar)
         {
            LayerManager.Instance.addToLayer(this,LayerManager.GAME_UI_LAYER,false,0,false);
            this.parent.setChildIndex(this,this.parent.numChildren - 1);
         }
         else
         {
            this.hide();
         }
      }
      
      public function updatePos() : void
      {
         if(StateManager.currentStateType == StateType.MAIN && this._currentBigBugleType == ChatData.B_BUGGLE_TYPE_NORMAL)
         {
            x = 100;
         }
         else
         {
            x = 0;
         }
      }
      
      private function removeAllBuggleAnimations() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._bigBugleAnimations.length)
         {
            if(Boolean(this._bigBugleAnimations[_loc1_].parent))
            {
               this._bigBugleAnimations[_loc1_].parent.removeChild(this._bigBugleAnimations[_loc1_]);
            }
            this._bigBugleAnimations[_loc1_].stop();
            _loc1_++;
         }
      }
      
      public function hide() : void
      {
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
         this.removeAllBuggleAnimations();
         if(Boolean(this._animationTxt.parent))
         {
            this._animationTxt.parent.removeChild(this._animationTxt);
         }
      }
   }
}

class ChatBugleData
{
    
   
   public var content:String;
   
   public var BugleType:int;
   
   public var subBugleType:int;
   
   public function ChatBugleData(param1:String, param2:int, param3:int)
   {
      super();
      this.content = param1;
      this.BugleType = param2;
      this.subBugleType = param3;
   }
}
