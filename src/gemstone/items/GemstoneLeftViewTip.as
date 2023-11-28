package gemstone.items
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.tip.BaseTip;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.text.TextFormat;
   import gemstone.info.GemstoneTipVO;
   
   public class GemstoneLeftViewTip extends BaseTip
   {
       
      
      private var _bg:ScaleBitmapImage;
      
      private var _tempData:Object;
      
      private var _titleTxt:FilterFrameText;
      
      private var _curPropertyTxt:FilterFrameText;
      
      private var _nextTxt:FilterFrameText;
      
      private var _nextPropertyTxt:FilterFrameText;
      
      private var _line1:Image;
      
      private var _line2:Image;
      
      public function GemstoneLeftViewTip()
      {
         super();
      }
      
      override protected function init() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("gemstone.tipBG");
         this.tipbackgound = this._bg;
         this._titleTxt = ComponentFactory.Instance.creatComponentByStylename("gemstone.tipTxt1");
         addChild(this._titleTxt);
         this._line1 = ComponentFactory.Instance.creatComponentByStylename("gemstone.line1");
         addChild(this._line1);
         this._curPropertyTxt = ComponentFactory.Instance.creatComponentByStylename("gemstone.tipTxt2");
         addChild(this._curPropertyTxt);
         this._line2 = ComponentFactory.Instance.creatComponentByStylename("gemstone.line2");
         addChild(this._line2);
         this._nextTxt = ComponentFactory.Instance.creatComponentByStylename("gemstone.nextTxt");
         this._nextTxt.text = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.nextLevel");
         addChild(this._nextTxt);
         this._nextPropertyTxt = ComponentFactory.Instance.creatComponentByStylename("gemstone.tipTxt3");
         addChild(this._nextPropertyTxt);
      }
      
      override public function set tipData(param1:Object) : void
      {
         this._tempData = param1;
         if(!this._tempData)
         {
            return;
         }
         this.updateView();
      }
      
      override public function get tipData() : Object
      {
         return this._tempData;
      }
      
      private function updateView() : void
      {
         var _loc1_:TextFormat = null;
         var _loc2_:TextFormat = null;
         var _loc3_:GemstoneTipVO = this._tempData as GemstoneTipVO;
         switch(_loc3_.gemstoneType)
         {
            case 1:
               _loc1_ = ComponentFactory.Instance.model.getSet("gemstone.Tip.TF1");
               this._titleTxt.text = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.redGemstoneAtc2",_loc3_.level);
               this._curPropertyTxt.text = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.AtcAdd",_loc3_.increase);
               _loc2_ = ComponentFactory.Instance.model.getSet("gemstone.Tip.TF5");
               this._nextPropertyTxt.text = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.AtcAdd",_loc3_.nextIncrease);
               break;
            case 2:
               _loc1_ = ComponentFactory.Instance.model.getSet("gemstone.Tip.TF2");
               this._titleTxt.text = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.bluGemstoneDef2",_loc3_.level);
               this._curPropertyTxt.text = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.DefAdd",_loc3_.increase);
               _loc2_ = ComponentFactory.Instance.model.getSet("gemstone.Tip.TF6");
               this._nextPropertyTxt.text = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.DefAdd",_loc3_.nextIncrease);
               break;
            case 3:
               _loc1_ = ComponentFactory.Instance.model.getSet("gemstone.Tip.TF3");
               this._titleTxt.text = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.greGemstoneAgi2",_loc3_.level);
               this._curPropertyTxt.text = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.AgiAdd",_loc3_.increase);
               _loc2_ = ComponentFactory.Instance.model.getSet("gemstone.Tip.TF7");
               this._nextPropertyTxt.text = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.AgiAdd",_loc3_.nextIncrease);
               break;
            case 4:
               _loc1_ = ComponentFactory.Instance.model.getSet("gemstone.Tip.TF4");
               this._titleTxt.text = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.purpleGemstoneLuk2",_loc3_.level);
               this._curPropertyTxt.text = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.LukAdd",_loc3_.increase);
               _loc2_ = ComponentFactory.Instance.model.getSet("gemstone.Tip.TF8");
               this._nextPropertyTxt.text = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.LukAdd",_loc3_.nextIncrease);
               break;
            case 5:
               _loc1_ = ComponentFactory.Instance.model.getSet("gemstone.Tip.TF4_1");
               this._titleTxt.text = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.purpleGemstoneLuk2",_loc3_.level);
               this._curPropertyTxt.text = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.BloodAdd",_loc3_.increase);
               _loc2_ = ComponentFactory.Instance.model.getSet("gemstone.Tip.TF8_1");
               this._nextPropertyTxt.text = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.BloAdd",_loc3_.nextIncrease);
         }
         if(_loc3_.level == 0)
         {
            this._curPropertyTxt.text = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.inactive");
         }
         if(_loc3_.level >= 5)
         {
            this._nextPropertyTxt.text = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.fullLevel");
         }
         this._titleTxt.setTextFormat(_loc1_);
         this._curPropertyTxt.setTextFormat(_loc1_);
         this._nextPropertyTxt.setTextFormat(_loc2_);
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._titleTxt);
         this._titleTxt = null;
         ObjectUtils.disposeObject(this._curPropertyTxt);
         this._curPropertyTxt = null;
         ObjectUtils.disposeObject(this._nextTxt);
         this._nextTxt = null;
         ObjectUtils.disposeObject(this._nextPropertyTxt);
         this._nextPropertyTxt = null;
         ObjectUtils.disposeObject(this._line1);
         this._line1 = null;
         ObjectUtils.disposeObject(this._line2);
         this._line2 = null;
         super.dispose();
      }
   }
}
