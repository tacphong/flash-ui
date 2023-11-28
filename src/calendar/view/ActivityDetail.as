package calendar.view
{
   import activeEvents.data.ActiveEventsInfo;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.TextInput;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.TimeManager;
   import ddt.utils.PositionUtils;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class ActivityDetail extends Sprite implements Disposeable
   {
       
      
      private var _timeField:FilterFrameText;
      
      private var _awardField:FilterFrameText;
      
      private var _contentField:FilterFrameText;
      
      private var _timeTitle:FilterFrameText;
      
      private var _awardTitle:FilterFrameText;
      
      private var _contentTitle:FilterFrameText;
      
      private var _timeWidth:int;
      
      private var _awardWidth:int;
      
      private var _contentWidth:int;
      
      private var _time:DisplayObject;
      
      private var _award:DisplayObject;
      
      private var _content:DisplayObject;
      
      private var _input:DisplayObject;
      
      private var _lines:Vector.<DisplayObject>;
      
      private var _inputField:TextInput;
      
      private var _hasKey:int;
      
      private var _timer:Timer;
      
      private var _info:ActiveEventsInfo;
      
      public function ActivityDetail()
      {
         this._lines = new Vector.<DisplayObject>();
         super();
         this.configUI();
      }
      
      private static function calculateLast(param1:Date, param2:Date) : String
      {
         var _loc3_:int = param1.time - param2.time;
         var _loc4_:String = "";
         if(_loc3_ >= TimeManager.DAY_TICKS)
         {
            _loc4_ += Math.floor(_loc3_ / TimeManager.DAY_TICKS) + LanguageMgr.GetTranslation("day");
            _loc3_ %= TimeManager.DAY_TICKS;
         }
         if(_loc3_ >= TimeManager.HOUR_TICKS)
         {
            _loc4_ += Math.floor(_loc3_ / TimeManager.HOUR_TICKS) + LanguageMgr.GetTranslation("hour");
            _loc3_ %= TimeManager.HOUR_TICKS;
         }
         else if(_loc4_.length > 0)
         {
            _loc4_ += "00" + LanguageMgr.GetTranslation("hour");
         }
         if(_loc3_ >= TimeManager.Minute_TICKS)
         {
            _loc4_ += Math.floor(_loc3_ / TimeManager.Minute_TICKS) + LanguageMgr.GetTranslation("minute");
            _loc3_ %= TimeManager.Minute_TICKS;
         }
         else if(_loc4_.length > 0)
         {
            _loc4_ += "00" + LanguageMgr.GetTranslation("minute");
         }
         if(_loc3_ >= TimeManager.Second_TICKS)
         {
            _loc4_ += Math.floor(_loc3_ / TimeManager.Second_TICKS) + LanguageMgr.GetTranslation("second");
         }
         else if(_loc4_.length > 0)
         {
            _loc4_ += "00" + LanguageMgr.GetTranslation("second");
         }
         return _loc4_;
      }
      
      private function configUI() : void
      {
         this._timeTitle = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.ActivityState.TimeFieldTitle");
         this._timeTitle.text = LanguageMgr.GetTranslation("tank.calendar.ActivityDetail.TimeFieldTitle");
         addChild(this._timeTitle);
         this._awardTitle = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.ActivityState.AwardFieldTitle");
         this._awardTitle.text = LanguageMgr.GetTranslation("tank.calendar.ActivityDetail.AwardFieldTitle");
         addChild(this._awardTitle);
         this._contentTitle = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.ActivityState.ContentFieldTitle");
         this._contentTitle.text = LanguageMgr.GetTranslation("tank.calendar.ActivityDetail.ContentFieldTitle");
         addChild(this._contentTitle);
         this._timeField = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.ActivityState.TimeField");
         this._timeWidth = this._timeField.width;
         addChild(this._timeField);
         this._awardField = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.ActivityState.AwardField");
         this._awardWidth = this._awardField.width;
         addChild(this._awardField);
         this._contentField = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.ActivityState.StateContentField");
         this._contentWidth = this._contentField.width;
         addChild(this._contentField);
         var _loc1_:DisplayObject = ComponentFactory.Instance.creatBitmap("asset.ddtcalendar.ActivityState.SeparatorLine");
         PositionUtils.setPos(_loc1_,"ddtcalendar.ActivityState.LinePos" + this._lines.length);
         this._lines.push(_loc1_);
         addChild(_loc1_);
         _loc1_ = ComponentFactory.Instance.creatBitmap("asset.ddtcalendar.ActivityState.SeparatorLine");
         PositionUtils.setPos(_loc1_,"ddtcalendar.ActivityState.LinePos" + this._lines.length);
         this._lines.push(_loc1_);
         addChild(_loc1_);
         this._time = ComponentFactory.Instance.creatBitmap("asset.ddtcalendar.ActivityState.TimeIcon");
         addChild(this._time);
         this._award = ComponentFactory.Instance.creatBitmap("asset.ddtcalendar.ActivityState.AwardIcon");
         addChild(this._award);
         this._content = ComponentFactory.Instance.creatBitmap("asset.ddtcalendar.ActivityState.ContentIcon");
         addChild(this._content);
         this._input = ComponentFactory.Instance.creatBitmap("aaset.ddtcalendar.ActivityState.Pwd");
         addChild(this._input);
         this._inputField = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.ActivityState.InputField");
         addChild(this._inputField);
      }
      
      private function __timer(param1:Event) : void
      {
         var _loc2_:Date = TimeManager.Instance.Now();
         if(_loc2_.time > this._info.end.time)
         {
         }
      }
      
      private function startMark() : void
      {
         this._timer.addEventListener(TimerEvent.TIMER,this.__timer);
         this._timer.start();
         this.__timer(null);
      }
      
      public function setData(param1:ActiveEventsInfo) : void
      {
         if(this._info == param1)
         {
            return;
         }
         this._info = param1;
         if(this._timer == null)
         {
            this._timer = new Timer(TimeManager.Second_TICKS);
         }
         else
         {
            this._timer.removeEventListener(TimerEvent.TIMER,this.__timer);
         }
         this._awardField.y = this._award.y + this._award.height - 4;
         this._awardField.autoSize = "none";
         this._awardField.width = this._awardWidth;
         this._awardField.text = param1.AwardContent;
         this._awardField.autoSize = "left";
         this._awardTitle.x = this._award.x + this._award.width + 4;
         this._awardTitle.y = this._award.y;
         this._lines[0].y = this._awardField.y + this._awardField.height + 8;
         this._content.y = this._lines[0].y + this._lines[0].height + 4;
         this._contentField.y = this._content.y + this._content.height - 8;
         this._contentField.autoSize = "none";
         this._contentField.width = this._contentWidth;
         this._contentField.htmlText = param1.Content;
         this._contentField.autoSize = "left";
         this._contentField.mouseEnabled = true;
         this._contentField.selectable = false;
         this._contentTitle.x = this._content.x + this._content.width + 4;
         this._contentTitle.y = this._content.y;
         this._hasKey = param1.HasKey;
         if(this._hasKey == 1 || this._hasKey == 7)
         {
            this._input.visible = this._inputField.visible = true;
            this._inputField.y = this._contentField.y + this._contentField.height + 20;
            this._input.y = this._inputField.y + 4;
            this._lines[1].y = this._input.y + this._input.height + 14;
         }
         else
         {
            this._input.visible = this._inputField.visible = false;
            this._lines[1].y = this._contentField.y + this._contentField.height + 8;
         }
         this._timeField.y = this._lines[1].y + this._lines[1].height + 8;
         this._timeField.autoSize = "none";
         this._timeField.width = this._timeWidth;
         this._timeField.text = param1.activeTime();
         this._timeField.autoSize = "left";
         this._time.y = this._timeField.y - 2;
         this._timeTitle.x = this._time.x + this._time.width + 4;
         this._timeTitle.y = this._time.y;
      }
      
      override public function get height() : Number
      {
         var _loc1_:int = 0;
         return int(this._timeField.y + this._timeField.height + 10);
      }
      
      public function getInputField() : TextInput
      {
         return this._inputField;
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._timeField);
         this._timeField = null;
         ObjectUtils.disposeObject(this._awardField);
         this._awardField = null;
         ObjectUtils.disposeObject(this._contentField);
         this._contentField = null;
         ObjectUtils.disposeObject(this._time);
         this._time = null;
         ObjectUtils.disposeObject(this._award);
         this._award = null;
         ObjectUtils.disposeObject(this._content);
         this._content = null;
         ObjectUtils.disposeObject(this._input);
         this._input = null;
         ObjectUtils.disposeObject(this._inputField);
         this._inputField = null;
         ObjectUtils.disposeObject(this._timeTitle);
         this._timeTitle = null;
         ObjectUtils.disposeObject(this._awardTitle);
         this._awardTitle = null;
         ObjectUtils.disposeObject(this._contentTitle);
         this._contentTitle = null;
         var _loc1_:DisplayObject = this._lines.shift();
         while(_loc1_ != null)
         {
            ObjectUtils.disposeObject(_loc1_);
            _loc1_ = null;
            _loc1_ = this._lines.shift();
         }
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}
