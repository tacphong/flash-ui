package wonderfulActivity.limitActivity
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import wonderfulActivity.event.WonderfulActivityEvent;
   
   public class LimitActivityLeftUnit extends Sprite implements Disposeable
   {
       
      
      private var _selectedBtn:SelectedButton;
      
      private var _nameTxt:FilterFrameText;
      
      public var id:String;
      
      private var nameString:String;
      
      private var isCanGetReward:Bitmap;
      
      public function LimitActivityLeftUnit(param1:String, param2:String)
      {
         super();
         this.id = param1;
         this.nameString = param2;
         this.initView();
         this.initEvent();
      }
      
      public function showCanGetReward(param1:Boolean) : void
      {
         if(param1)
         {
            this.isCanGetReward.visible = true;
         }
         else
         {
            this.isCanGetReward.visible = false;
         }
      }
      
      private function initView() : void
      {
         this._selectedBtn = ComponentFactory.Instance.creatComponentByStylename("wonderful.limitActivity.LeftUnitlSelectedBtn");
         addChild(this._selectedBtn);
         this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("wonderful.limitActivity.listCellTxt");
         this._nameTxt.text = this.nameString;
         addChild(this._nameTxt);
         this.isCanGetReward = ComponentFactory.Instance.creat("wonderfulactivity.canGetRewardbG");
         addChild(this.isCanGetReward);
         this.isCanGetReward.visible = false;
      }
      
      private function initEvent() : void
      {
         this._selectedBtn.addEventListener(MouseEvent.CLICK,this.__selectedBtnClick);
      }
      
      private function __selectedBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         dispatchEvent(new WonderfulActivityEvent(WonderfulActivityEvent.SELECTED_CHANGE));
      }
      
      public function set selected(param1:Boolean) : void
      {
         this._selectedBtn.selected = param1;
      }
      
      public function dispose() : void
      {
         if(Boolean(this._selectedBtn))
         {
            this._selectedBtn.removeEventListener(MouseEvent.CLICK,this.__selectedBtnClick);
            ObjectUtils.disposeObject(this._selectedBtn);
            this._selectedBtn = null;
         }
         if(Boolean(this._nameTxt))
         {
            ObjectUtils.disposeObject(this._nameTxt);
            this._nameTxt = null;
         }
      }
   }
}
