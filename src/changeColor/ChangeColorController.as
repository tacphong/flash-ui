package changeColor
{
   import changeColor.view.ChangeColorFrame;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   
   public class ChangeColorController
   {
       
      
      private var _changeColorModel:changeColor.ChangeColorModel;
      
      private var _changeColorFrame:ChangeColorFrame;
      
      public function ChangeColorController()
      {
         super();
      }
      
      public function get changeColorModel() : changeColor.ChangeColorModel
      {
         if(!this._changeColorModel)
         {
            this._changeColorModel = new changeColor.ChangeColorModel();
         }
         return this._changeColorModel;
      }
      
      public function show() : void
      {
         if(!this._changeColorFrame)
         {
            this._changeColorFrame = ComponentFactory.Instance.creatComponentByStylename("changeColor.ChangeColorFrame");
            this._changeColorFrame.moveEnable = false;
            this._changeColorFrame.changeColorController = this;
            this._changeColorFrame.show();
         }
      }
      
      public function close() : void
      {
         if(Boolean(this._changeColorFrame))
         {
            ObjectUtils.disposeObject(this._changeColorFrame);
            this._changeColorFrame = null;
         }
         if(Boolean(this._changeColorModel))
         {
            this._changeColorModel = null;
         }
      }
   }
}
