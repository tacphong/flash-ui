package farm.viewx.helper
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.ShopType;
   import ddt.data.goods.ShopItemInfo;
   import ddt.manager.ShopManager;
   import ddt.manager.SoundManager;
   import ddt.view.chat.ChatBasePanel;
   import farm.view.compose.event.SelectComposeItemEvent;
   import shop.view.ShopItemCell;
   
   public class FertilizerSelect extends ChatBasePanel implements Disposeable
   {
       
      
      private var _list:VBox;
      
      private var _bg:ScaleBitmapImage;
      
      private var _panel:ScrollPanel;
      
      private var _itemList:Vector.<farm.viewx.helper.HelperFerItem>;
      
      private var _result:ShopItemCell;
      
      public function FertilizerSelect()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         this._itemList = new Vector.<HelperFerItem>();
         this._bg = ComponentFactory.Instance.creatComponentByStylename("farm.SeedListBg");
         this._list = ComponentFactory.Instance.creatComponentByStylename("farm.helper.SeedList");
         this._panel = ComponentFactory.Instance.creatComponentByStylename("farm.helper.Seedselect");
         this._panel.setView(this._list);
         addChild(this._bg);
         addChild(this._panel);
         this.setList();
      }
      
      private function setList() : void
      {
         var _loc1_:farm.viewx.helper.HelperFerItem = null;
         var _loc2_:Vector.<ShopItemInfo> = ShopManager.Instance.getValidGoodByType(ShopType.FARM_MANURE_TYPE);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc1_ = new farm.viewx.helper.HelperFerItem();
            _loc1_.info = _loc2_[_loc3_];
            _loc1_.addEventListener(SelectComposeItemEvent.SELECT_FERTILIZER,this.__itemClick);
            this._itemList.push(_loc1_);
            this._list.addChild(_loc1_);
            _loc3_++;
         }
         this._panel.invalidateViewport();
      }
      
      private function __itemClick(param1:SelectComposeItemEvent) : void
      {
         SoundManager.instance.play("008");
         dispatchEvent(new SelectComposeItemEvent(SelectComposeItemEvent.SELECT_FERTILIZER,param1.data));
      }
      
      public function dispose() : void
      {
         var _loc1_:int = 0;
         if(Boolean(this._list))
         {
            ObjectUtils.disposeObject(this._list);
         }
         this._list = null;
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(Boolean(this._panel))
         {
            ObjectUtils.disposeObject(this._panel);
         }
         this._panel = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
         while(_loc1_ < this._itemList.length)
         {
            this._itemList[_loc1_].removeEventListener(SelectComposeItemEvent.SELECT_SEED,this.__itemClick);
            ObjectUtils.disposeObject(this._itemList[_loc1_]);
            this._itemList[_loc1_] = null;
            _loc1_++;
         }
         this._itemList = null;
      }
   }
}
