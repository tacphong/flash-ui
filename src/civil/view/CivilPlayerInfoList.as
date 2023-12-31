package civil.view
{
   import civil.CivilEvent;
   import civil.CivilModel;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.CivilPlayerInfo;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class CivilPlayerInfoList extends Sprite implements Disposeable
   {
      
      private static const MAXITEM:int = 12;
       
      
      private var _currentItem:civil.view.CivilPlayerItemFrame;
      
      private var _items:Vector.<civil.view.CivilPlayerItemFrame>;
      
      private var _infoItems:Array;
      
      private var _list:VBox;
      
      private var _model:CivilModel;
      
      private var _selectedItem:civil.view.CivilPlayerItemFrame;
      
      public function CivilPlayerInfoList()
      {
         super();
         this.init();
         this.addEvent();
      }
      
      private function init() : void
      {
         this._infoItems = [];
         this._list = ComponentFactory.Instance.creatComponentByStylename("civil.memberList");
         addChild(this._list);
         this._items = new Vector.<CivilPlayerItemFrame>();
      }
      
      public function MemberList(param1:Array) : void
      {
         var _loc2_:civil.view.CivilPlayerItemFrame = null;
         this.clearList();
         if(!param1 || param1.length == 0)
         {
            return;
         }
         var _loc3_:int = param1.length > MAXITEM ? int(MAXITEM) : int(param1.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = new civil.view.CivilPlayerItemFrame();
            _loc2_.info = param1[_loc4_];
            _loc2_.addEventListener(MouseEvent.CLICK,this.__onItemClick);
            this._list.addChild(_loc2_);
            this._items.push(_loc2_);
            if(_loc4_ == 0)
            {
               this.selectedItem = _loc2_;
            }
            _loc4_++;
         }
      }
      
      public function clearList() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._items.length)
         {
            this._items[_loc1_].removeEventListener(MouseEvent.CLICK,this.__onItemClick);
            ObjectUtils.disposeObject(this._items[_loc1_]);
            this._items[_loc1_] = null;
            _loc1_++;
         }
         this._items = new Vector.<CivilPlayerItemFrame>();
         this._currentItem = null;
         this._infoItems = [];
      }
      
      public function upItem(param1:CivilPlayerInfo) : void
      {
         var _loc2_:civil.view.CivilPlayerItemFrame = null;
         var _loc3_:int = 0;
         while(_loc3_ < this._items.length)
         {
            _loc2_ = this._items[_loc3_] as CivilPlayerItemFrame;
            if(_loc2_.info.info.ID == param1.info.ID)
            {
               _loc2_.info = param1;
               break;
            }
            _loc3_++;
         }
      }
      
      private function addEvent() : void
      {
      }
      
      private function removeEvent() : void
      {
         if(Boolean(this._model))
         {
            if(this._model.hasEventListener(CivilEvent.CIVIL_PLAYERINFO_ARRAY_CHANGE))
            {
               this._model.removeEventListener(CivilEvent.CIVIL_PLAYERINFO_ARRAY_CHANGE,this.__civilListHandle);
            }
         }
      }
      
      private function __civilListHandle(param1:CivilEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:civil.view.CivilPlayerItemFrame = null;
         if(this._model.civilPlayers == null)
         {
            return;
         }
         this.clearList();
         var _loc4_:Array = this._model.civilPlayers;
         var _loc5_:int = _loc4_.length > MAXITEM ? int(MAXITEM) : int(_loc4_.length);
         if(_loc5_ <= 0)
         {
            this.selectedItem = null;
         }
         else
         {
            _loc2_ = 0;
            while(_loc2_ < _loc5_)
            {
               _loc3_ = new civil.view.CivilPlayerItemFrame();
               _loc3_.info = _loc4_[_loc2_];
               this._list.addChild(_loc3_);
               this._items.push(_loc3_);
               if(_loc2_ == 0)
               {
                  this.selectedItem = _loc3_;
               }
               _loc3_.addEventListener(MouseEvent.CLICK,this.__onItemClick);
               _loc2_++;
            }
         }
      }
      
      private function __onItemClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:civil.view.CivilPlayerItemFrame = param1.currentTarget as CivilPlayerItemFrame;
         if(!_loc2_.selected)
         {
            this.selectedItem = _loc2_;
         }
      }
      
      public function get selectedItem() : civil.view.CivilPlayerItemFrame
      {
         return this._selectedItem;
      }
      
      public function set selectedItem(param1:civil.view.CivilPlayerItemFrame) : void
      {
         var _loc2_:civil.view.CivilPlayerItemFrame = null;
         if(this._selectedItem != param1)
         {
            _loc2_ = this._selectedItem;
            this._selectedItem = param1;
            if(Boolean(this._selectedItem))
            {
               this._selectedItem.selected = true;
               this._model.currentcivilItemInfo = this._selectedItem.info;
            }
            else
            {
               this._model.currentcivilItemInfo = null;
            }
            if(Boolean(_loc2_))
            {
               _loc2_.selected = false;
            }
            dispatchEvent(new CivilEvent(CivilEvent.SELECTED_CHANGE,param1));
         }
      }
      
      public function get model() : CivilModel
      {
         return this._model;
      }
      
      public function set model(param1:CivilModel) : void
      {
         if(this._model != param1)
         {
            if(Boolean(this._model))
            {
               this._model.removeEventListener(CivilEvent.CIVIL_PLAYERINFO_ARRAY_CHANGE,this.__civilListHandle);
            }
            this._model = param1;
            if(Boolean(this._model))
            {
               this._model.addEventListener(CivilEvent.CIVIL_PLAYERINFO_ARRAY_CHANGE,this.__civilListHandle);
            }
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this.clearList();
         if(Boolean(this._list))
         {
            this._list.dispose();
            this._list = null;
         }
         if(Boolean(this._currentItem))
         {
            this._currentItem.dispose();
         }
         this._currentItem = null;
         this.model = null;
         this._infoItems = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}
