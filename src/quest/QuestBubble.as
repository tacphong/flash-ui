package quest
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.utils.ObjectUtils;
   import flash.geom.Point;
   import flash.utils.Timer;
   
   public class QuestBubble extends Component
   {
       
      
      private var _bg:ScaleBitmapImage;
      
      private var _itemVec:Vector.<quest.BubbleItem>;
      
      private var _time:Timer;
      
      private var _questModeArr:Array;
      
      public const ACTISOVER:String = "act_is_over";
      
      public const SHOWTASKTIP:String = "show_task_tip";
      
      private var _regularPos:Point;
      
      private var _basePos:Point;
      
      private const BASEWIDTH:int = 25;
      
      public function QuestBubble()
      {
         super();
      }
      
      public function start(param1:Array) : void
      {
         this._questModeArr = param1;
      }
      
      public function show() : void
      {
         super.init();
         this._itemVec = new Vector.<BubbleItem>();
         this._bg = ComponentFactory.Instance.creatComponentByStylename("toolbar.bubbleBg");
         this._regularPos = ComponentFactory.Instance.creatCustomObject("toolbar.bubbleRegularPos");
         this._basePos = ComponentFactory.Instance.creatCustomObject("toolbar.bubbleBasePos");
         addChild(this._bg);
         this._countInfo();
         x = this._regularPos.x;
         y = this._regularPos.y - this._bg.height;
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_TOP_LAYER,false,LayerManager.NONE_BLOCKGOUND);
      }
      
      private function _countInfo() : void
      {
         var _loc1_:quest.BubbleItem = null;
         _loc1_ = null;
         var _loc2_:int = 0;
         while(_loc2_ < this._questModeArr.length)
         {
            _loc1_ = new quest.BubbleItem();
            addChild(_loc1_);
            _loc1_.setTextInfo(this._questModeArr[_loc2_].txtI,this._questModeArr[_loc2_].txtII,this._questModeArr[_loc2_].txtIII);
            _loc1_.y = _loc1_.height * _loc2_ * 5 / 4;
            this._itemVec.push(_loc1_);
            _loc2_++;
         }
         this._bg.height = (1 + this._itemVec.length) * this.BASEWIDTH;
      }
      
      override public function dispose() : void
      {
         var _loc1_:int = 0;
         super.dispose();
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         if(this._itemVec != null)
         {
            while(_loc1_ < this._itemVec.length)
            {
               ObjectUtils.disposeObject(this._itemVec[_loc1_]);
               _loc1_++;
            }
            this._itemVec = null;
         }
      }
   }
}
