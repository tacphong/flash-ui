package com.pickgliss.ui.controls.list
{
   import com.pickgliss.events.InteractiveEvent;
   import com.pickgliss.events.ListItemEvent;
   import com.pickgliss.geom.IntDimension;
   import com.pickgliss.geom.IntPoint;
   import com.pickgliss.geom.IntRectangle;
   import com.pickgliss.ui.ComponentSetting;
   import com.pickgliss.ui.controls.cell.IListCell;
   import com.pickgliss.ui.controls.cell.IListCellFactory;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.core.IViewprot;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   [Event(name="listItemClick",type="com.pickgliss.events.ListItemEvent")]
   [Event(name="listItemDoubleclick",type="com.pickgliss.events.ListItemEvent")]
   [Event(name="listItemMouseDown",type="com.pickgliss.events.ListItemEvent")]
   [Event(name="listItemMouseUp",type="com.pickgliss.events.ListItemEvent")]
   [Event(name="listItemRollOver",type="com.pickgliss.events.ListItemEvent")]
   [Event(name="listItemRollOut",type="com.pickgliss.events.ListItemEvent")]
   public class List extends Component implements IViewprot, ListDataListener
   {
      
      public static const AUTO_INCREMENT:int = int.MIN_VALUE;
      
      public static const P_cellFactory:String = "cellFactory";
      
      public static const P_horizontalBlockIncrement:String = "horizontalBlockIncrement";
      
      public static const P_horizontalUnitIncrement:String = "horizontalUnitIncrement";
      
      public static const P_model:String = "model";
      
      public static const P_verticalBlockIncrement:String = "verticalBlockIncrement";
      
      public static const P_verticalUnitIncrement:String = "verticalUnitIncrement";
      
      public static const P_viewPosition:String = "viewPosition";
      
      public static const P_viewSize:String = "viewSize";
       
      
      protected var _cells:Vector.<IListCell>;
      
      protected var _cellsContainer:Sprite;
      
      protected var _factory:IListCellFactory;
      
      protected var _firstVisibleIndex:int;
      
      protected var _firstVisibleIndexOffset:int;
      
      protected var _horizontalBlockIncrement:int;
      
      protected var _horizontalUnitIncrement:int;
      
      protected var _lastVisibleIndex:int;
      
      protected var _lastVisibleIndexOffset:int;
      
      protected var _maskShape:Shape;
      
      protected var _model:com.pickgliss.ui.controls.list.IListModel;
      
      protected var _mouseActiveObjectShape:Shape;
      
      protected var _verticalBlockIncrement:int;
      
      protected var _verticalUnitIncrement:int;
      
      protected var _viewHeight:int;
      
      protected var _viewPosition:IntPoint;
      
      protected var _viewWidth:int;
      
      protected var _viewWidthNoCount:int;
      
      protected var _visibleCellWidth:int;
      
      protected var _visibleRowCount:int;
      
      protected var _currentSelectedIndex:int = -1;
      
      public function List()
      {
         this._horizontalBlockIncrement = ComponentSetting.SCROLL_BLOCK_INCREMENT;
         this._horizontalUnitIncrement = ComponentSetting.SCROLL_UINT_INCREMENT;
         this._verticalBlockIncrement = ComponentSetting.SCROLL_BLOCK_INCREMENT;
         this._verticalUnitIncrement = ComponentSetting.SCROLL_UINT_INCREMENT;
         super();
      }
      
      public function addStateListener(param1:Function, param2:int = 0, param3:Boolean = false) : void
      {
         addEventListener(InteractiveEvent.STATE_CHANGED,param1,false,param2);
      }
      
      public function get cellFactory() : IListCellFactory
      {
         return this._factory;
      }
      
      public function set cellFactory(param1:IListCellFactory) : void
      {
         if(this._factory == param1)
         {
            return;
         }
         this._factory = param1;
         onPropertiesChanged(P_cellFactory);
      }
      
      public function contentsChanged(param1:ListDataEvent) : void
      {
         if(param1.getIndex0() >= this._firstVisibleIndex && param1.getIndex0() <= this._lastVisibleIndex || param1.getIndex1() >= this._firstVisibleIndex && param1.getIndex1() <= this._lastVisibleIndex || this._lastVisibleIndex == -1)
         {
            this.updateListView();
         }
      }
      
      override public function dispose() : void
      {
         this._mouseActiveObjectShape.graphics.clear();
         this._mouseActiveObjectShape = null;
         this._maskShape.graphics.clear();
         this._maskShape = null;
         this.removeAllCell();
         this._cells = null;
         if(Boolean(this._model))
         {
            this._model.removeListDataListener(this);
         }
         this._model = null;
         super.dispose();
      }
      
      public function getExtentSize() : IntDimension
      {
         return new IntDimension(_width,_height);
      }
      
      public function getViewSize() : IntDimension
      {
         return new IntDimension(this._viewWidth,this._viewHeight);
      }
      
      public function getViewportPane() : Component
      {
         return this;
      }
      
      public function get horizontalBlockIncrement() : int
      {
         return this._horizontalBlockIncrement;
      }
      
      public function set horizontalBlockIncrement(param1:int) : void
      {
         if(this._horizontalBlockIncrement == param1)
         {
            return;
         }
         this._horizontalBlockIncrement = param1;
         onPropertiesChanged(P_horizontalBlockIncrement);
      }
      
      public function get horizontalUnitIncrement() : int
      {
         return this._horizontalUnitIncrement;
      }
      
      public function set horizontalUnitIncrement(param1:int) : void
      {
         if(this._horizontalUnitIncrement == param1)
         {
            return;
         }
         this._horizontalUnitIncrement = param1;
         onPropertiesChanged(P_horizontalUnitIncrement);
      }
      
      public function intervalAdded(param1:ListDataEvent) : void
      {
         this.refreshViewSize();
         onPropertiesChanged(P_viewSize);
         var _loc2_:int = int(this._factory.getCellHeight());
         var _loc3_:int = Math.floor(_height / _loc2_);
         if(param1.getIndex1() <= this._lastVisibleIndex || this._lastVisibleIndex == -1 || this.viewHeight < _height || this._lastVisibleIndex <= _loc3_)
         {
            this.updateListView();
         }
      }
      
      public function intervalRemoved(param1:ListDataEvent) : void
      {
         this.refreshViewSize();
         onPropertiesChanged(P_viewSize);
         var _loc2_:int = int(this._factory.getCellHeight());
         var _loc3_:int = Math.floor(_height / _loc2_);
         if(param1.getIndex1() <= this._lastVisibleIndex || this._lastVisibleIndex == -1 || this.viewHeight < _height || this._lastVisibleIndex <= _loc3_)
         {
            this.updateListView();
         }
      }
      
      public function isSelectedIndex(param1:int) : Boolean
      {
         return this._currentSelectedIndex == param1;
      }
      
      public function get model() : com.pickgliss.ui.controls.list.IListModel
      {
         return this._model;
      }
      
      public function set model(param1:com.pickgliss.ui.controls.list.IListModel) : void
      {
         if(param1 != this.model)
         {
            if(Boolean(this._model))
            {
               this._model.removeListDataListener(this);
            }
            this._model = param1;
            this._model.addListDataListener(this);
            onPropertiesChanged(P_model);
         }
      }
      
      public function removeStateListener(param1:Function) : void
      {
         removeEventListener(InteractiveEvent.STATE_CHANGED,param1);
      }
      
      public function scrollRectToVisible(param1:IntRectangle) : void
      {
         this.viewPosition = new IntPoint(param1.x,param1.y);
      }
      
      public function setListData(param1:Array) : void
      {
         var _loc2_:com.pickgliss.ui.controls.list.IListModel = new VectorListModel(param1);
         this.model = _loc2_;
      }
      
      public function setViewportTestSize(param1:IntDimension) : void
      {
      }
      
      public function updateListView() : void
      {
         if(this._factory == null)
         {
            return;
         }
         this.createCells();
         this.updateShowMask();
         this.updatePos();
      }
      
      public function get verticalBlockIncrement() : int
      {
         return this._verticalBlockIncrement;
      }
      
      public function set verticalBlockIncrement(param1:int) : void
      {
         if(this._verticalBlockIncrement == param1)
         {
            return;
         }
         this._verticalBlockIncrement = param1;
         onPropertiesChanged(P_verticalBlockIncrement);
      }
      
      public function get verticalUnitIncrement() : int
      {
         return this._verticalUnitIncrement;
      }
      
      public function set verticalUnitIncrement(param1:int) : void
      {
         if(this._verticalUnitIncrement == param1)
         {
            return;
         }
         this._verticalUnitIncrement = param1;
         onPropertiesChanged(P_verticalUnitIncrement);
      }
      
      public function get viewPosition() : IntPoint
      {
         return this._viewPosition;
      }
      
      public function set viewPosition(param1:IntPoint) : void
      {
         if(this._viewPosition.equals(this.restrictionViewPos(param1)))
         {
            return;
         }
         this._viewPosition.setLocation(param1);
         onPropertiesChanged(P_viewPosition);
      }
      
      protected function __onItemInteractive(param1:MouseEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:IListCell = param1.currentTarget as IListCell;
         var _loc4_:int = int(this._model.indexOf(_loc3_.getCellValue()));
         switch(param1.type)
         {
            case MouseEvent.CLICK:
               _loc2_ = ListItemEvent.LIST_ITEM_CLICK;
               this._currentSelectedIndex = _loc4_;
               this.updateListView();
               break;
            case MouseEvent.DOUBLE_CLICK:
               _loc2_ = ListItemEvent.LIST_ITEM_DOUBLE_CLICK;
               break;
            case MouseEvent.MOUSE_DOWN:
               _loc2_ = ListItemEvent.LIST_ITEM_MOUSE_DOWN;
               break;
            case MouseEvent.MOUSE_UP:
               _loc2_ = ListItemEvent.LIST_ITEM_MOUSE_UP;
               break;
            case MouseEvent.ROLL_OVER:
               _loc2_ = ListItemEvent.LIST_ITEM_ROLL_OVER;
               break;
            case MouseEvent.ROLL_OUT:
               _loc2_ = ListItemEvent.LIST_ITEM_ROLL_OUT;
         }
         dispatchEvent(new ListItemEvent(_loc3_,_loc3_.getCellValue(),_loc2_,_loc4_));
      }
      
      public function getCellAt(param1:int) : IListCell
      {
         return this._cells[param1];
      }
      
      public function getAllCells() : Vector.<IListCell>
      {
         return this._cells;
      }
      
      public function get currentSelectedIndex() : int
      {
         return this._currentSelectedIndex;
      }
      
      public function set currentSelectedIndex(param1:int) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc2_:* = null;
         if(_loc3_ = this._model.getElementAt(param1))
         {
            this._currentSelectedIndex = param1;
            this.updateListView();
            for each(_loc4_ in this._cells)
            {
               if(_loc4_.getCellValue() == _loc3_)
               {
                  _loc2_ = _loc4_;
                  break;
               }
            }
            if(_loc2_)
            {
               dispatchEvent(new ListItemEvent(_loc2_,_loc2_.getCellValue(),"listItemClick",this._currentSelectedIndex));
            }
         }
      }
      
      protected function addCellToContainer(param1:IListCell) : void
      {
         param1.addEventListener(MouseEvent.CLICK,this.__onItemInteractive);
         param1.addEventListener(MouseEvent.MOUSE_DOWN,this.__onItemInteractive);
         param1.addEventListener(MouseEvent.MOUSE_UP,this.__onItemInteractive);
         param1.addEventListener(MouseEvent.ROLL_OVER,this.__onItemInteractive);
         param1.addEventListener(MouseEvent.ROLL_OUT,this.__onItemInteractive);
         param1.addEventListener(MouseEvent.DOUBLE_CLICK,this.__onItemInteractive);
         this._cells.push(this._cellsContainer.addChild(param1.asDisplayObject()));
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
         addChild(this._mouseActiveObjectShape);
         addChild(this._maskShape);
         addChild(this._cellsContainer);
      }
      
      protected function creatMaskShape() : void
      {
         this._maskShape = new Shape();
         this._maskShape.graphics.beginFill(16711680,1);
         this._maskShape.graphics.drawRect(0,0,100,100);
         this._maskShape.graphics.endFill();
         this._mouseActiveObjectShape = new Shape();
         this._mouseActiveObjectShape.graphics.beginFill(16711680,0);
         this._mouseActiveObjectShape.graphics.drawRect(0,0,100,100);
         this._mouseActiveObjectShape.graphics.endFill();
      }
      
      protected function createCells() : void
      {
         if(this._factory.isShareCells())
         {
            this.createCellsWhenShareCells();
         }
         else
         {
            this.createCellsWhenNotShareCells();
         }
      }
      
      protected function createCellsWhenNotShareCells() : void
      {
      }
      
      protected function createCellsWhenShareCells() : void
      {
         var _loc1_:int = 0;
         var _loc2_:IListCell = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Vector.<IListCell> = null;
         var _loc7_:int = int(this._factory.getCellHeight());
         var _loc8_:int = Math.floor(_height / _loc7_) + 2;
         this._viewWidth = this._factory.getViewWidthNoCount();
         if(this._cells.length == _loc8_)
         {
            return;
         }
         if(this._cells.length < _loc8_)
         {
            _loc4_ = _loc8_ - this._cells.length;
            _loc1_ = 0;
            while(_loc1_ < _loc4_)
            {
               _loc2_ = this.createNewCell();
               _loc3_ = Math.max(_loc2_.width,_loc3_);
               this.addCellToContainer(_loc2_);
               _loc1_++;
            }
         }
         else if(this._cells.length > _loc8_)
         {
            _loc5_ = _loc8_;
            _loc6_ = this._cells.splice(_loc5_,this._cells.length - _loc5_);
            _loc1_ = 0;
            while(_loc1_ < _loc6_.length)
            {
               this.removeCellFromContainer(_loc6_[_loc1_]);
               _loc1_++;
            }
         }
      }
      
      protected function createNewCell() : IListCell
      {
         if(this._factory == null)
         {
            return null;
         }
         return this._factory.createNewCell();
      }
      
      protected function fireStateChanged(param1:Boolean = true) : void
      {
         dispatchEvent(new InteractiveEvent(InteractiveEvent.STATE_CHANGED));
      }
      
      protected function getListCellModelHeight(param1:int) : int
      {
         return 0;
      }
      
      protected function getViewMaxPos() : IntPoint
      {
         var _loc1_:IntDimension = this.getExtentSize();
         var _loc2_:IntDimension = this.getViewSize();
         var _loc3_:IntPoint = new IntPoint(_loc2_.width - _loc1_.width,_loc2_.height - _loc1_.height);
         if(_loc3_.x < 0)
         {
            _loc3_.x = 0;
         }
         if(_loc3_.y < 0)
         {
            _loc3_.y = 0;
         }
         return _loc3_;
      }
      
      override protected function init() : void
      {
         this.creatMaskShape();
         this._cellsContainer = new Sprite();
         addChild(this._cellsContainer);
         this._viewPosition = new IntPoint(0,0);
         this._firstVisibleIndex = 0;
         this._lastVisibleIndex = -1;
         this._firstVisibleIndexOffset = 0;
         this._lastVisibleIndexOffset = 0;
         this._visibleRowCount = -1;
         this._visibleCellWidth = -1;
         this._cells = new Vector.<IListCell>();
         super.init();
         this._model = new VectorListModel();
         this._model.addListDataListener(this);
      }
      
      protected function layoutWhenShareCellsHasNotSameHeight() : void
      {
         var _loc1_:IListCell = null;
         var _loc2_:int = 0;
         this.createCellsWhenShareCells();
         this.restrictionViewPos(this._viewPosition);
         var _loc3_:int = this._viewPosition.x;
         var _loc4_:int = this._viewPosition.y;
         var _loc5_:int = int(this._model.getStartIndexByPosY(_loc4_));
         var _loc6_:int = int(this._model.getSize());
         var _loc7_:int = -_loc3_;
         var _loc8_:int = _height;
         if(_loc6_ < 0)
         {
            this._lastVisibleIndex = -1;
         }
         var _loc9_:int = 0;
         while(_loc9_ < this._cells.length)
         {
            _loc1_ = this._cells[_loc9_];
            _loc2_ = _loc5_ + _loc9_;
            if(_loc2_ < _loc6_)
            {
               _loc1_.setCellValue(this._model.getElementAt(_loc2_));
               _loc1_.setListCellStatus(this,this.isSelectedIndex(_loc2_),_loc2_);
               _loc1_.visible = true;
               _loc1_.x = _loc7_;
               _loc1_.y = this._model.getCellPosFromIndex(_loc2_) - _loc4_;
               if(_loc1_.y < _loc8_)
               {
                  this._lastVisibleIndex = _loc2_;
               }
            }
            else
            {
               _loc1_.visible = false;
            }
            _loc9_++;
         }
         this.refreshViewSize();
         this._firstVisibleIndex = _loc5_;
      }
      
      protected function layoutWhenShareCellsHasSameHeight() : void
      {
         var _loc1_:IListCell = null;
         var _loc2_:int = 0;
         this.createCellsWhenShareCells();
         this.restrictionViewPos(this._viewPosition);
         var _loc3_:int = this._viewPosition.x;
         var _loc4_:int = this._viewPosition.y;
         var _loc5_:int = int(this._factory.getCellHeight());
         var _loc6_:int = Math.floor(_loc4_ / _loc5_);
         var _loc7_:int = _loc6_ * _loc5_ - _loc4_;
         var _loc8_:int = int(this._model.getSize());
         var _loc9_:int = -_loc3_;
         var _loc10_:int = _loc7_;
         var _loc11_:int = _height;
         if(_loc8_ < 0)
         {
            this._lastVisibleIndex = -1;
         }
         var _loc12_:int = 0;
         while(_loc12_ < this._cells.length)
         {
            _loc1_ = this._cells[_loc12_];
            _loc2_ = _loc6_ + _loc12_;
            if(_loc2_ < _loc8_)
            {
               _loc1_.setCellValue(this._model.getElementAt(_loc2_));
               _loc1_.setListCellStatus(this,this.isSelectedIndex(_loc2_),_loc2_);
               _loc1_.visible = true;
               _loc1_.x = _loc9_;
               _loc1_.y = _loc10_;
               if(_loc10_ < _loc11_)
               {
                  this._lastVisibleIndex = _loc2_;
               }
               _loc10_ += _loc5_;
            }
            else
            {
               _loc1_.visible = false;
            }
            _loc12_++;
         }
         this.refreshViewSize();
         this._firstVisibleIndex = _loc6_;
      }
      
      override protected function onProppertiesUpdate() : void
      {
         super.onProppertiesUpdate();
         var _loc1_:Boolean = false;
         this._cellsContainer.mask = this._maskShape;
         if(Boolean(_changedPropeties[P_model]) || Boolean(_changedPropeties[P_cellFactory]) || Boolean(_changedPropeties[P_viewPosition]) || Boolean(_changedPropeties[Component.P_width]) || Boolean(_changedPropeties[Component.P_height]))
         {
            if(Boolean(_changedPropeties[P_cellFactory]))
            {
               this.removeAllCell();
            }
            _loc1_ = true;
         }
         if(_loc1_)
         {
            this.updateListView();
         }
         if(Boolean(_changedPropeties[P_verticalBlockIncrement]) || Boolean(_changedPropeties[P_verticalUnitIncrement]) || Boolean(_changedPropeties[P_horizontalBlockIncrement]) || Boolean(_changedPropeties[P_horizontalUnitIncrement]) || Boolean(_changedPropeties[Component.P_height]) || Boolean(_changedPropeties[Component.P_width]) || Boolean(_changedPropeties[P_viewPosition]) || Boolean(_changedPropeties[P_viewSize]))
         {
            this.fireStateChanged();
         }
      }
      
      protected function refreshViewSize() : void
      {
         if(this._factory.isShareCells())
         {
            this._viewWidth = this._factory.getViewWidthNoCount();
            if(this._factory.isAllCellHasSameHeight())
            {
               this.viewHeight = this._model.getSize() * this._factory.getCellHeight();
            }
            else
            {
               this.viewHeight = this._model.getAllCellHeight();
            }
         }
      }
      
      public function get viewHeight() : Number
      {
         return this._viewHeight;
      }
      
      public function set viewHeight(param1:Number) : void
      {
         if(this._viewHeight == param1)
         {
            return;
         }
         this._viewHeight = param1;
         onPropertiesChanged(P_viewSize);
      }
      
      public function get viewWidth() : Number
      {
         return this._viewWidth;
      }
      
      public function set viewWidth(param1:Number) : void
      {
         if(this._viewWidth == param1)
         {
            return;
         }
         this._viewWidth = param1;
         onPropertiesChanged(P_viewSize);
      }
      
      public function unSelectedAll() : void
      {
         this._currentSelectedIndex = -1;
         this.updateListView();
      }
      
      protected function removeAllCell() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._cells.length)
         {
            this.removeCellFromContainer(this._cells[_loc1_]);
            _loc1_++;
         }
         this._cells = new Vector.<IListCell>();
      }
      
      protected function removeCellFromContainer(param1:IListCell) : void
      {
         param1.removeEventListener(MouseEvent.CLICK,this.__onItemInteractive);
         param1.removeEventListener(MouseEvent.MOUSE_DOWN,this.__onItemInteractive);
         param1.removeEventListener(MouseEvent.MOUSE_UP,this.__onItemInteractive);
         param1.removeEventListener(MouseEvent.ROLL_OVER,this.__onItemInteractive);
         param1.removeEventListener(MouseEvent.ROLL_OUT,this.__onItemInteractive);
         param1.removeEventListener(MouseEvent.DOUBLE_CLICK,this.__onItemInteractive);
         ObjectUtils.disposeObject(param1);
      }
      
      protected function restrictionViewPos(param1:IntPoint) : IntPoint
      {
         var _loc2_:IntPoint = this.getViewMaxPos();
         param1.x = Math.max(0,Math.min(_loc2_.x,param1.x));
         param1.y = Math.max(0,Math.min(_loc2_.y,param1.y));
         return param1;
      }
      
      protected function updatePos() : void
      {
         if(this._factory.isShareCells())
         {
            if(this._factory.isAllCellHasSameHeight())
            {
               this.layoutWhenShareCellsHasSameHeight();
            }
            else
            {
               this.layoutWhenShareCellsHasNotSameHeight();
            }
         }
      }
      
      protected function updateShowMask() : void
      {
         this._mouseActiveObjectShape.width = this._maskShape.width = _width;
         this._mouseActiveObjectShape.height = this._maskShape.height = _height;
      }
      
      public function get cell() : Vector.<IListCell>
      {
         return this._cells;
      }
   }
}
