package winRank
{
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import flash.utils.Dictionary;
   import road7th.comm.PackageIn;
   import winRank.data.WinRankEvent;
   import winRank.data.WinRankVo;
   import winRank.views.WinRankView;
   import wonderfulActivity.ActivityType;
   import wonderfulActivity.WonderfulActivityManager;
   import wonderfulActivity.data.GmActivityInfo;
   import wonderfulActivity.data.LeftViewInfoVo;
   
   public class WinRankManager
   {
      
      private static var _instance:winRank.WinRankManager;
       
      
      public var actId:String;
      
      public var status:int;
      
      public var xmlData:GmActivityInfo;
      
      public var view:WinRankView;
      
      public var myConsume:int;
      
      public var rankList:Array;
      
      private var requestCount:int = 0;
      
      public function WinRankManager()
      {
         super();
      }
      
      public static function get instance() : winRank.WinRankManager
      {
         if(!_instance)
         {
            _instance = new winRank.WinRankManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         SocketManager.Instance.addEventListener(WinRankEvent.UPDATE,this.__updateInfo);
      }
      
      protected function __updateInfo(param1:WinRankEvent) : void
      {
         var _loc2_:* = 0;
         var _loc3_:* = 0;
         var _loc4_:WinRankVo = null;
         var _loc5_:PackageIn = param1.pkg;
         this.actId = _loc5_.readUTF();
         var _loc6_:Boolean = _loc5_.readBoolean();
         var _loc7_:Dictionary = WonderfulActivityManager.Instance.activityData;
         var _loc8_:Dictionary = WonderfulActivityManager.Instance.leftViewInfoDic;
         if(_loc6_)
         {
            this.status = _loc5_.readInt();
            this.xmlData = _loc7_[this.actId];
            if(!this.xmlData)
            {
               ++this.requestCount;
               if(this.requestCount <= 5)
               {
                  SocketManager.Instance.out.requestWonderfulActInit(0);
               }
               return;
            }
            if(WonderfulActivityManager.Instance.actList.indexOf(this.actId) == -1)
            {
               _loc8_[this.actId] = new LeftViewInfoVo(ActivityType.WIN_RANK,"· " + this.xmlData.activityName,this.xmlData.icon);
               WonderfulActivityManager.Instance.addElement(this.actId);
            }
            this.rankList = [];
            _loc2_ = _loc5_.readInt();
            if(_loc2_ <= 0)
            {
               _loc3_ = 0;
               while(_loc3_ < 10)
               {
                  _loc4_ = new WinRankVo();
                  _loc4_.userId = 0;
                  _loc4_.name = LanguageMgr.GetTranslation("wonderfulActivity.Default.RankName",_loc3_ + 1);
                  _loc4_.vipLvl = 0;
                  _loc4_.consume = int(this.xmlData.remain2);
                  this.rankList.push(_loc4_);
                  _loc3_++;
               }
            }
            else
            {
               _loc3_ = 0;
               while(_loc3_ <= _loc2_ - 1)
               {
                  _loc4_ = new WinRankVo();
                  _loc4_.userId = _loc5_.readInt();
                  _loc4_.name = _loc5_.readUTF();
                  _loc4_.vipLvl = _loc5_.readByte();
                  _loc4_.consume = _loc5_.readInt();
                  this.rankList.push(_loc4_);
                  _loc3_++;
               }
            }
            this.myConsume = _loc5_.readInt();
            if(Boolean(this.view))
            {
               this.view.updateView();
            }
         }
         else
         {
            WonderfulActivityManager.Instance.removeElement(this.actId);
         }
      }
   }
}
