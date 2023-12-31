package game.view.propertyWaterBuff
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.UICreatShortcut;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BuffInfo;
   import ddt.data.EquipType;
   import ddt.manager.PlayerManager;
   import flash.display.Sprite;
   import road7th.data.DictionaryData;
   
   public class PropertyWaterBuffBar extends Sprite implements Disposeable
   {
       
      
      private var _container:HBox;
      
      private var _buffList:DictionaryData;
      
      private var _iconList:Vector.<game.view.propertyWaterBuff.PropertyWaterBuffIcon>;
      
      public function PropertyWaterBuffBar()
      {
         super();
         this.init();
      }
      
      public static function getPropertyWaterBuffList(param1:DictionaryData) : DictionaryData
      {
         var _loc2_:BuffInfo = null;
         var _loc3_:DictionaryData = new DictionaryData();
         for each(_loc2_ in param1)
         {
            if(EquipType.isPropertyWater(_loc2_.buffItemInfo))
            {
               _loc3_.add(_loc2_.Type,_loc2_);
            }
         }
         return _loc3_;
      }
      
      private function init() : void
      {
         this._container = UICreatShortcut.creatAndAdd("game.view.propertyWaterBuffBer",this);
         this._buffList = getPropertyWaterBuffList(PlayerManager.Instance.Self.buffInfo);
         this.createIconList();
      }
      
      private function createIconList() : void
      {
         var _loc1_:BuffInfo = null;
         var _loc2_:game.view.propertyWaterBuff.PropertyWaterBuffIcon = null;
         this._iconList = new Vector.<PropertyWaterBuffIcon>();
         for each(_loc1_ in this._buffList)
         {
            _loc2_ = ComponentFactory.Instance.creat("game.view.propertyWaterBuff.propertyWaterBuffIcon",[_loc1_]);
            this._iconList.push(_loc2_);
            this._container.addChild(_loc2_);
         }
      }
      
      private function disposeIconList() : void
      {
         var _loc1_:game.view.propertyWaterBuff.PropertyWaterBuffIcon = null;
         for each(_loc1_ in this._iconList)
         {
            ObjectUtils.disposeObject(_loc1_);
            _loc1_ = null;
         }
      }
      
      public function dispose() : void
      {
         this.disposeIconList();
         ObjectUtils.disposeObject(this._container);
         this._container = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}
