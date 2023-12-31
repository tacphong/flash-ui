package AvatarCollection.view
{
   import AvatarCollection.AvatarCollectionManager;
   import AvatarCollection.data.AvatarCollectionUnitVo;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.cell.IListCell;
   import com.pickgliss.ui.controls.list.List;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.utils.Helpers;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class AvatarCollectionUnitListCell extends Sprite implements Disposeable, IListCell
   {
       
      
      private var _bg:ScaleFrameImage;
      
      private var _nameTxt:FilterFrameText;
      
      private var _data:AvatarCollectionUnitVo;
      
      private var _canActivityIcon:Bitmap;
      
      private var _selector:SelectedCheckButton;
      
      private var _completeCount:int;
      
      public function AvatarCollectionUnitListCell()
      {
         super();
         this.mouseChildren = false;
         this.buttonMode = true;
         this.initView();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("avatarColl.unitListCell.bg");
         this._bg.setFrame(1);
         this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("avatarColl.unitListCell.nameTxt");
         this._nameTxt.setFrame(1);
         this._canActivityIcon = ComponentFactory.Instance.creatBitmap("asset.avatarColl.unitCell.canActivityIcon");
         this._canActivityIcon.visible = false;
         addChild(this._bg);
         addChild(this._nameTxt);
         addChild(this._canActivityIcon);
         this._selector = ComponentFactory.Instance.creat("avator.selector");
         addChild(this._selector);
         this.addEventListener("click",this.onClick);
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         if(this._data.totalActivityItemCount < this._completeCount)
         {
            this._selector.selected = false;
            return;
         }
         this._selector.selected = !this._selector.selected;
         AvatarCollectionManager.instance.onListCellClick(this._data,this._selector.selected);
      }
      
      public function set select(param1:Boolean) : void
      {
         if(this._data.totalActivityItemCount < this._completeCount)
         {
            this._selector.selected = false;
            return;
         }
         this._selector.selected = param1;
         AvatarCollectionManager.instance.onListCellClick(this._data,this._selector.selected);
      }
      
      public function get select() : Boolean
      {
         return this._selector.selected;
      }
      
      private function updateViewData() : void
      {
         if(this._data.totalActivityItemCount >= this._completeCount)
         {
            Helpers.grey(this._selector);
            this._selector.enable = true;
            this._selector.selected = AvatarCollectionManager.instance.getSelectState(this._data);
         }
         else
         {
            this._selector.selected = false;
            this._selector.enable = false;
         }
         var _loc1_:int = int(this._data.totalItemList.length);
         var _loc2_:int = this._data.totalActivityItemCount;
         this._nameTxt.text = this._data.name + "（" + _loc2_ + "/" + _loc1_ + "）";
         if(this._data.canActivityCount > 0)
         {
            this._canActivityIcon.visible = true;
         }
         else
         {
            this._canActivityIcon.visible = false;
         }
      }
      
      public function setListCellStatus(param1:List, param2:Boolean, param3:int) : void
      {
         this._bg.setFrame(param2 ? 2 : 1);
         this._nameTxt.setFrame(param2 ? 2 : 1);
      }
      
      public function getCellValue() : *
      {
         return this._data;
      }
      
      public function setCellValue(param1:*) : void
      {
         this._data = param1 as AvatarCollectionUnitVo;
         this._completeCount = this._data.totalItemList.length / 2;
         this.updateViewData();
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         removeEventListener("click",this.onClick);
         this._selector = null;
         this._bg = null;
         this._nameTxt = null;
         this._canActivityIcon = null;
         this._data = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}
