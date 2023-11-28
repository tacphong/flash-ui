package petsBag.view.item
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.tip.BaseTip;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.analyze.PetconfigAnalyzer;
   import ddt.manager.LanguageMgr;
   import ddt.manager.ServerConfigManager;
   import flash.display.Sprite;
   import pet.date.PetInfo;
   
   public class PetGrowUpTip extends BaseTip
   {
       
      
      protected var _name:FilterFrameText;
      
      protected var _attackLbl:FilterFrameText;
      
      protected var _attackTxt:FilterFrameText;
      
      protected var _defenceLbl:FilterFrameText;
      
      protected var _defenceTxt:FilterFrameText;
      
      protected var _HPLbl:FilterFrameText;
      
      protected var _HPTxt:FilterFrameText;
      
      protected var _agilitykLbl:FilterFrameText;
      
      protected var _agilityTxt:FilterFrameText;
      
      protected var _luckLbl:FilterFrameText;
      
      protected var _luckTxt:FilterFrameText;
      
      private var _splitImg:ScaleBitmapImage;
      
      protected var _bg:ScaleBitmapImage;
      
      protected var _container:Sprite;
      
      protected var _info:PetInfo;
      
      private var _gradeImg:ScaleFrameImage;
      
      private var _petQuality:Array;
      
      private var LEADING:int = 5;
      
      public function PetGrowUpTip()
      {
         super();
      }
      
      override protected function init() : void
      {
         this._name = ComponentFactory.Instance.creat("petbags.text.petName");
         this._name.text = LanguageMgr.GetTranslation("ddt.petbags.text.petGrowUptipTitleName");
         this._gradeImg = ComponentFactory.Instance.creatComponentByStylename("petsBag.washBone.petGrade");
         this._gradeImg.setFrame(1);
         this._attackLbl = ComponentFactory.Instance.creat("petbags.text.petGrowUpTipName");
         this._attackLbl.text = LanguageMgr.GetTranslation("attack") + ":";
         this._attackTxt = ComponentFactory.Instance.creat("petbags.text.petGrowUpTipValue");
         this._defenceLbl = ComponentFactory.Instance.creat("petbags.text.petGrowUpTipName");
         this._defenceLbl.text = LanguageMgr.GetTranslation("defence") + ":";
         this._defenceTxt = ComponentFactory.Instance.creat("petbags.text.petGrowUpTipValue");
         this._HPLbl = ComponentFactory.Instance.creat("petbags.text.petGrowUpTipName");
         this._HPLbl.text = LanguageMgr.GetTranslation("MaxHp") + ":";
         this._HPTxt = ComponentFactory.Instance.creat("petbags.text.petGrowUpTipValue");
         this._agilitykLbl = ComponentFactory.Instance.creat("petbags.text.petGrowUpTipName");
         this._agilitykLbl.text = LanguageMgr.GetTranslation("agility") + ":";
         this._agilityTxt = ComponentFactory.Instance.creat("petbags.text.petGrowUpTipValue");
         this._luckLbl = ComponentFactory.Instance.creat("petbags.text.petGrowUpTipName");
         this._luckLbl.text = LanguageMgr.GetTranslation("luck") + ":";
         this._luckTxt = ComponentFactory.Instance.creat("petbags.text.petGrowUpTipValue");
         this._bg = ComponentFactory.Instance.creat("core.GoodsTipBg");
         this._splitImg = ComponentFactory.Instance.creatComponentByStylename("petGrowUpTips.line");
         this._container = new Sprite();
         this._container.addChild(this._name);
         this._container.addChild(this._gradeImg);
         this._container.addChild(this._attackLbl);
         this._container.addChild(this._attackTxt);
         this._container.addChild(this._defenceLbl);
         this._container.addChild(this._defenceTxt);
         this._container.addChild(this._HPLbl);
         this._container.addChild(this._HPTxt);
         this._container.addChild(this._agilitykLbl);
         this._container.addChild(this._agilityTxt);
         this._container.addChild(this._luckLbl);
         this._container.addChild(this._luckTxt);
         this._container.addChild(this._splitImg);
         super.init();
         this.tipbackgound = this._bg;
      }
      
      protected function fixPos() : void
      {
         this._gradeImg.x = this._name.x + this._name.textWidth + this.LEADING * 2;
         this._gradeImg.y = 2;
         this._splitImg.y = this._name.y + this._name.textHeight + this.LEADING * 1.5;
         this._HPLbl.y = this._splitImg.y + this._splitImg.height + this.LEADING;
         this._HPTxt.y = this._HPLbl.y;
         this._HPTxt.x = this._HPLbl.x + this._HPLbl.textWidth + this.LEADING;
         this._attackLbl.y = this._HPLbl.y + this._HPLbl.textHeight + this.LEADING;
         this._attackTxt.x = this._attackLbl.x + this._attackLbl.textWidth + this.LEADING;
         this._attackTxt.y = this._attackLbl.y;
         this._defenceLbl.y = this._attackLbl.y + this._agilitykLbl.textHeight + this.LEADING;
         this._defenceTxt.y = this._defenceLbl.y;
         this._defenceTxt.x = this._defenceLbl.x + this._defenceLbl.textWidth + this.LEADING;
         this._agilitykLbl.y = this._defenceLbl.y + this._defenceLbl.textHeight + this.LEADING;
         this._agilityTxt.y = this._agilitykLbl.y;
         this._agilityTxt.x = this._agilitykLbl.x + this._agilitykLbl.textWidth + this.LEADING;
         this._luckLbl.y = this._agilitykLbl.y + this._agilitykLbl.textHeight + this.LEADING;
         this._luckTxt.y = this._luckLbl.y;
         this._luckTxt.x = this._luckLbl.x + this._luckLbl.textWidth + this.LEADING;
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
         addChild(this._container);
         this._container.mouseEnabled = false;
         this._container.mouseChildren = false;
         this.mouseChildren = false;
         this.mouseEnabled = false;
      }
      
      override public function get tipData() : Object
      {
         return this._info;
      }
      
      override public function set tipData(param1:Object) : void
      {
         this._info = param1 as PetInfo;
         if(Boolean(this._info))
         {
            this.updateView();
         }
      }
      
      protected function updateView() : void
      {
         this._name.text = this._info.Name;
         var _loc1_:Number = PetconfigAnalyzer.PetCofnig.PropertiesRate;
         var _loc2_:Number = this._info.AttackGrow / _loc1_;
         this._attackTxt.text = this._info.Attack > 0 ? "(" + _loc2_.toFixed(1) + ")" : "";
         var _loc3_:Number = this._info.DefenceGrow / _loc1_;
         this._defenceTxt.text = this._info.Defence > 0 ? "(" + _loc3_.toFixed(1) + ")" : "";
         var _loc4_:Number = this._info.AgilityGrow / _loc1_;
         this._agilityTxt.text = this._info.Agility > 0 ? "(" + _loc4_.toFixed(1) + ")" : "";
         this._HPTxt.text = this._info.Blood > 0 ? "(" + (this._info.BloodGrow / _loc1_).toFixed(1) + ")" : "";
         var _loc5_:Number = this._info.LuckGrow / _loc1_;
         this._luckTxt.text = this._info.Luck > 0 ? "(" + _loc5_.toFixed(1) + ")" : "";
         this.fixPos();
         this._bg.width = this._container.width + 15;
         this._bg.height = this._container.height + 20;
         _width = this._bg.width;
         _height = this._bg.height;
         if(this._info == null)
         {
            return;
         }
         var _loc6_:int = this._info.getPetQualityIndex(this._info.petGraded);
         this._gradeImg.setFrame(_loc6_ + 1);
         var _loc7_:int = this.getProDatumIndex(this._info.AttackGrowDatum) + 1;
         this._attackLbl.setFrame(_loc7_);
         this._attackTxt.setFrame(_loc7_);
         var _loc8_:int = this.getProDatumIndex(this._info.DefenceGrowDatum) + 1;
         this._defenceLbl.setFrame(_loc8_);
         this._defenceTxt.setFrame(_loc8_);
         var _loc9_:int = this.getProDatumIndex(this._info.AgilityGrowDatum) + 1;
         this._agilitykLbl.setFrame(_loc9_);
         this._agilityTxt.setFrame(_loc9_);
         var _loc10_:int = this.getProDatumIndex(this._info.BloodGrowDatum) + 1;
         this._HPLbl.setFrame(_loc10_);
         this._HPTxt.setFrame(_loc10_);
         var _loc11_:int = this.getProDatumIndex(this._info.LuckGrowDatum) + 1;
         this._luckLbl.setFrame(_loc11_);
         this._luckTxt.setFrame(_loc11_);
      }
      
      private function getProDatumIndex(param1:int) : int
      {
         return int(this.getPetQualityIndex(param1));
      }
      
      public function getPetQualityIndex(param1:Number) : int
      {
         var _loc2_:int = 0;
         if(this._petQuality == null)
         {
            this._petQuality = ServerConfigManager.instance.petQualityConfig;
         }
         _loc2_ = 0;
         while(_loc2_ < this._petQuality.length)
         {
            if(param1 <= this._petQuality[_loc2_])
            {
               return _loc2_;
            }
            _loc2_++;
         }
         return this._petQuality.length - 1;
      }
      
      override public function dispose() : void
      {
         this._info = null;
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
         }
         if(Boolean(this._luckTxt))
         {
            ObjectUtils.disposeObject(this._luckTxt);
            this._luckTxt = null;
         }
         if(Boolean(this._splitImg))
         {
            ObjectUtils.disposeObject(this._splitImg);
            this._splitImg = null;
         }
         if(Boolean(this._container))
         {
            ObjectUtils.disposeObject(this._container);
            this._container = null;
         }
         if(Boolean(this._luckLbl))
         {
            ObjectUtils.disposeObject(this._luckLbl);
            this._luckLbl = null;
         }
         if(Boolean(this._agilityTxt))
         {
            ObjectUtils.disposeObject(this._agilityTxt);
            this._agilityTxt = null;
         }
         if(Boolean(this._agilitykLbl))
         {
            ObjectUtils.disposeObject(this._agilitykLbl);
            this._agilitykLbl = null;
         }
         if(Boolean(this._HPLbl))
         {
            ObjectUtils.disposeObject(this._HPLbl);
            this._HPLbl = null;
         }
         if(Boolean(this._HPTxt))
         {
            ObjectUtils.disposeObject(this._HPTxt);
            this._HPTxt = null;
         }
         if(Boolean(this._defenceTxt))
         {
            ObjectUtils.disposeObject(this._defenceTxt);
            this._defenceTxt = null;
         }
         if(Boolean(this._defenceLbl))
         {
            ObjectUtils.disposeObject(this._defenceLbl);
            this._defenceLbl = null;
         }
         if(Boolean(this._attackTxt))
         {
            ObjectUtils.disposeObject(this._attackTxt);
            this._attackTxt = null;
         }
         if(Boolean(this._attackLbl))
         {
            ObjectUtils.disposeObject(this._attackLbl);
            this._attackLbl = null;
         }
         if(Boolean(this._name))
         {
            ObjectUtils.disposeObject(this._name);
            this._name = null;
         }
         super.dispose();
      }
   }
}
