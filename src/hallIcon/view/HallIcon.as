package hallIcon.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.core.ITipedDisplay;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import hallIcon.info.HallIconInfo;
   
   public class HallIcon extends Sprite implements Disposeable, ITipedDisplay
   {
      
      public static const WONDERFULPLAY:int = 1;
      
      public static const ACTIVITY:int = 2;
       
      
      private var _timeTxt:FilterFrameText;
      
      private var _glowMovie:MovieClip;
      
      private var _icon:DisplayObject;
      
      private var _iconString:String;
      
      private var _iconNumBg:Bitmap;
      
      private var _iconTxt:FilterFrameText;
      
      private var _tipStyle:String;
      
      private var _tipDirctions:String;
      
      private var _tipData:Object;
      
      private var _tipGapH:int;
      
      private var _tipGapV:int;
      
      public var iconInfo:HallIconInfo;
      
      public function HallIcon(param1:String, param2:HallIconInfo)
      {
         super();
         this._iconString = param1;
         this.iconInfo = param2;
         this.initView();
         this.buttonCursorMode(true);
         this.mouseChildren = false;
      }
      
      public function initView() : void
      {
         this._icon = ComponentFactory.Instance.creat(this._iconString);
         addChild(this._icon);
         this._timeTxt = ComponentFactory.Instance.creatComponentByStylename("hallicon.IconTimeTxt");
         addChild(this._timeTxt);
         this._glowMovie = ClassUtils.CreatInstance("assets.hallIcon.iconGlow" + this.iconInfo.halltype);
         this._glowMovie.stop();
         this._glowMovie.visible = false;
         PositionUtils.setPos(this._glowMovie,"hallIcon.iconGlowPos" + this.iconInfo.halltype);
         addChild(this._glowMovie);
         this._iconNumBg = ComponentFactory.Instance.creatBitmap("assets.hallIcon.numIconBg");
         this._iconNumBg.visible = false;
         addChild(this._iconNumBg);
         this._iconTxt = ComponentFactory.Instance.creatComponentByStylename("assets.hallIcon.numTxt");
         this._iconTxt.visible = false;
         addChild(this._iconTxt);
      }
      
      public function updateIcon(param1:HallIconInfo) : void
      {
         this.iconInfo = param1;
         if(this.iconInfo.timemsg == null)
         {
            this.iconInfo.timemsg = "";
         }
         this.setTimeTxt(this.iconInfo.timemsg);
         if(this.iconInfo.timemsg == "")
         {
            this.setFightState(this.iconInfo.fightover);
         }
         if(this.iconInfo.timemsg == "" && !this.iconInfo.fightover)
         {
            this.setGlow(true);
         }
         else
         {
            this.setGlow(false);
         }
         this.setNumShow(this.iconInfo.num);
      }
      
      private function setTimeTxt(param1:String) : void
      {
         if(param1 == "")
         {
            this._icon.alpha = 1;
            this.buttonCursorMode(true);
         }
         else
         {
            this._icon.alpha = 0.6;
            this.buttonCursorMode(false);
         }
         this._timeTxt.text = param1;
      }
      
      private function setGlow(param1:Boolean) : void
      {
         if(param1)
         {
            this._glowMovie.play();
            this._glowMovie.visible = true;
         }
         else if(Boolean(this._glowMovie))
         {
            this._glowMovie.stop();
            this._glowMovie.visible = false;
         }
      }
      
      private function setFightState(param1:Boolean) : void
      {
         if(param1)
         {
            this._icon.alpha = 0.6;
         }
         else
         {
            this._icon.alpha = 1;
         }
      }
      
      private function setNumShow(param1:int) : void
      {
         this._iconTxt.text = param1.toString();
         if(param1 > -1)
         {
            this._iconNumBg.visible = true;
            this._iconTxt.visible = true;
         }
         else
         {
            this._iconNumBg.visible = false;
            this._iconTxt.visible = false;
         }
      }
      
      private function buttonCursorMode(param1:Boolean) : void
      {
         this.buttonMode = param1;
         this.mouseEnabled = param1;
      }
      
      public function get tipStyle() : String
      {
         return this._tipStyle;
      }
      
      public function get tipData() : Object
      {
         return this._tipData;
      }
      
      public function get tipDirctions() : String
      {
         return this._tipDirctions;
      }
      
      public function get tipGapV() : int
      {
         return this._tipGapV;
      }
      
      public function get tipGapH() : int
      {
         return this._tipGapH;
      }
      
      public function set tipStyle(param1:String) : void
      {
         this._tipStyle = param1;
      }
      
      public function set tipData(param1:Object) : void
      {
         this._tipData = param1;
      }
      
      public function set tipDirctions(param1:String) : void
      {
         this._tipDirctions = param1;
      }
      
      public function set tipGapV(param1:int) : void
      {
         this._tipGapV = param1;
      }
      
      public function set tipGapH(param1:int) : void
      {
         this._tipGapH = param1;
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._timeTxt);
         this._timeTxt = null;
         if(Boolean(this._glowMovie))
         {
            this._glowMovie.stop();
            ObjectUtils.disposeObject(this._glowMovie);
            this._glowMovie = null;
         }
         ObjectUtils.disposeObject(this._icon);
         this._icon = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}
