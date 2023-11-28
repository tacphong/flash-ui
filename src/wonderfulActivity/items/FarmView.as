package wonderfulActivity.items
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import wonderfulActivity.WonderfulActivityManager;
   import wonderfulActivity.views.IRightView;
   
   public class FarmView extends Sprite implements IRightView
   {
       
      
      private var _btn:SimpleBitmapButton;
      
      private var _back:Bitmap;
      
      private var endData:Date;
      
      private var nowdate:Date;
      
      private var _timerTxt:FilterFrameText;
      
      public function FarmView()
      {
         super();
      }
      
      public function init() : void
      {
         this._back = ComponentFactory.Instance.creat("wonderfulactivity.farme.backgroud");
         addChild(this._back);
         this._btn = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.farmeBtn");
         addChild(this._btn);
         this._btn.addEventListener(MouseEvent.CLICK,this.mouseClickHander);
         this._timerTxt = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.right.farmetimeTxt");
         addChild(this._timerTxt);
         this.initTimer();
      }
      
      public function setState(param1:int, param2:int) : void
      {
      }
      
      private function initTimer() : void
      {
         this.endData = WonderfulActivityManager.Instance.chickenEndTime;
         if(!this.endData)
         {
            this.endData = new Date(2013,5,5);
         }
         this.farmeTimerHander();
         WonderfulActivityManager.Instance.addTimerFun("farme",this.farmeTimerHander);
      }
      
      private function farmeTimerHander() : void
      {
         this.nowdate = TimeManager.Instance.Now();
         var _loc1_:String = WonderfulActivityManager.Instance.getTimeDiff(this.endData,this.nowdate);
         this._timerTxt.text = _loc1_;
      }
      
      protected function mouseClickHander(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
      }
      
      public function content() : Sprite
      {
         return this;
      }
      
      public function dispose() : void
      {
         WonderfulActivityManager.Instance.delTimerFun("farme");
         while(Boolean(this.numChildren))
         {
            ObjectUtils.disposeObject(this.getChildAt(0));
         }
         if(Boolean(parent))
         {
            ObjectUtils.disposeObject(this);
         }
      }
   }
}
