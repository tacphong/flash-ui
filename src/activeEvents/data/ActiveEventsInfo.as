package activeEvents.data
{
   import calendar.view.goodsExchange.GoodsExchangeInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.TimeManager;
   import road7th.utils.DateUtils;
   
   public class ActiveEventsInfo
   {
      
      public static const COMMON:int = 0;
      
      public static const GOODS_EXCHANGE:int = 1;
      
      public static const PICC:int = 2;
      
      public static const SENIOR_PLAYER:int = 5;
       
      
      public var IconID:int;
      
      public var ActiveID:int;
      
      public var Title:String;
      
      public var isAttend:Boolean = false;
      
      public var Description:String;
      
      private var _StartDate:String;
      
      public var IsShow:Boolean;
      
      private var _start:Date;
      
      private var _EndDate:String;
      
      private var _end:Date;
      
      public var Content:String;
      
      public var AwardContent:String;
      
      public var IsAdvance:Boolean;
      
      public var Type:int;
      
      public var IsOnly:int;
      
      public var HasKey:int;
      
      public var ActiveType:int;
      
      public var GoodsExchangeTypes:String;
      
      public var limitType:String;
      
      public var limitValue:String;
      
      public var GoodsExchangeNum:String;
      
      public var goodsExchangeInfos:Vector.<GoodsExchangeInfo>;
      
      public var ActionTimeContent:String;
      
      public function ActiveEventsInfo()
      {
         super();
      }
      
      public function get StartDate() : String
      {
         return this._StartDate;
      }
      
      public function set StartDate(param1:String) : void
      {
         this._StartDate = param1;
         this._start = DateUtils.getDateByStr(this._StartDate);
      }
      
      public function get start() : Date
      {
         return this._start;
      }
      
      public function get EndDate() : String
      {
         return this._EndDate;
      }
      
      public function set EndDate(param1:String) : void
      {
         this._EndDate = param1;
         this._end = DateUtils.getDateByStr(this._EndDate);
      }
      
      public function get end() : Date
      {
         return this._end;
      }
      
      public function analyzeGoodsExchangeInfo() : void
      {
         var _loc1_:GoodsExchangeInfo = null;
         if(this.GoodsExchangeTypes == "")
         {
            return;
         }
         this.goodsExchangeInfos = new Vector.<GoodsExchangeInfo>();
         var _loc2_:Array = this.GoodsExchangeTypes.split(",");
         var _loc3_:Array = this.limitType.split(",");
         var _loc4_:Array = this.limitValue.split(",");
         var _loc5_:Array = this.GoodsExchangeNum.split(",");
         var _loc6_:int = 0;
         while(_loc6_ < _loc2_.length)
         {
            _loc1_ = new GoodsExchangeInfo();
            _loc1_.goodsExchangeType = _loc2_[_loc6_];
            _loc1_.limitType = _loc3_[_loc6_];
            _loc1_.LimitValue = _loc4_[_loc6_];
            _loc1_.GoodsExchangeNum = _loc5_[_loc6_];
            this.goodsExchangeInfos.push(_loc1_);
            _loc6_++;
         }
      }
      
      public function activeTime() : String
      {
         var _loc1_:String = null;
         var _loc2_:Date = null;
         var _loc3_:Date = null;
         if(Boolean(this.ActionTimeContent))
         {
            _loc1_ = this.ActionTimeContent;
         }
         else if(Boolean(this.EndDate))
         {
            _loc2_ = DateUtils.getDateByStr(this.StartDate);
            _loc3_ = DateUtils.getDateByStr(this.EndDate);
            _loc1_ = this.getActiveString(_loc2_) + "-" + this.getActiveString(_loc3_);
         }
         else
         {
            _loc1_ = LanguageMgr.GetTranslation("tank.data.MovementInfo.begin",this.getActiveString(_loc2_));
         }
         return _loc1_;
      }
      
      private function getActiveString(param1:Date) : String
      {
         return LanguageMgr.GetTranslation("tank.data.MovementInfo.date",this.addZero(param1.getFullYear()),this.addZero(param1.getMonth() + 1),this.addZero(param1.getDate()));
      }
      
      private function addZero(param1:Number) : String
      {
         var _loc2_:String = null;
         if(param1 < 10)
         {
            _loc2_ = "0" + param1.toString();
         }
         else
         {
            _loc2_ = param1.toString();
         }
         return _loc2_;
      }
      
      public function overdue() : Boolean
      {
         var _loc1_:Date = null;
         var _loc2_:Date = TimeManager.Instance.Now();
         var _loc3_:Number = _loc2_.time;
         var _loc4_:Date = DateUtils.getDateByStr(this.StartDate);
         if(_loc3_ < _loc4_.getTime())
         {
            return true;
         }
         if(Boolean(this.EndDate))
         {
            _loc1_ = DateUtils.getDateByStr(this.EndDate);
            if(_loc3_ > _loc1_.getTime())
            {
               return true;
            }
         }
         return false;
      }
   }
}
