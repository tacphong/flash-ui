package pyramid.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import pyramid.PyramidManager;
   import pyramid.data.PyramidSystemItemsInfo;
   import pyramid.event.PyramidEvent;
   
   public class PyramidCard extends Sprite implements Disposeable
   {
       
      
      private var _openCardMovie:MovieClip;
      
      private var _cell:pyramid.view.PyramidCell;
      
      public var index:String;
      
      private var _state:int = 0;
      
      private var _openMovieState:int = 0;
      
      public function PyramidCard()
      {
         super();
         this._openCardMovie = ComponentFactory.Instance.creat("assets.pyramid.openCard");
         addChild(this._openCardMovie);
         this._cell = new pyramid.view.PyramidCell(0,null);
         this._cell.setBgVisible(false);
         this._cell.width = 46.5;
         this._cell.height = 46.5;
         this._cell.x = 2;
         this._cell.y = 5;
         this._cell.visible = false;
         addChild(this._cell);
         this.initEvent();
         this.initData();
      }
      
      private function mouseMode(param1:Boolean) : void
      {
         this.buttonMode = param1;
         this.mouseEnabled = param1;
      }
      
      private function initEvent() : void
      {
         this._openCardMovie.addEventListener(Event.ENTER_FRAME,this.__enterFrame);
      }
      
      private function initData() : void
      {
         this.cardState(0);
      }
      
      private function playOpenCardMovie() : void
      {
         this._openMovieState = 1;
         this._openCardMovie.gotoAndStop(1);
      }
      
      private function playCloseCardMovie() : void
      {
         this._openMovieState = 2;
         this._openCardMovie.gotoAndStop(this._openCardMovie.totalFrames - 1);
      }
      
      private function __enterFrame(param1:Event) : void
      {
         if(this._openMovieState == 1)
         {
            if(this._openCardMovie.currentFrame < this._openCardMovie.totalFrames - 1)
            {
               this._openCardMovie.nextFrame();
            }
            else
            {
               this._cell.visible = true;
               this._openMovieState = 0;
               dispatchEvent(new PyramidEvent(PyramidEvent.OPENANDCLOSE_MOVIE));
            }
         }
         else if(this._openMovieState == 2)
         {
            if(this._openCardMovie.currentFrame > 1)
            {
               this._openCardMovie.prevFrame();
            }
            else
            {
               this._openMovieState = 0;
               dispatchEvent(new PyramidEvent(PyramidEvent.OPENANDCLOSE_MOVIE));
            }
         }
      }
      
      public function cardState(param1:int, param2:PyramidSystemItemsInfo = null) : void
      {
         this._state = param1;
         this.cellInfo(param2);
         switch(this._state)
         {
            case 0:
               this.mouseMode(false);
               this._cell.visible = false;
               this._openCardMovie.gotoAndStop(1);
               break;
            case 1:
               this.mouseMode(false);
               this._openCardMovie.gotoAndStop(this._openCardMovie.totalFrames - 1);
               this._cell.visible = true;
               break;
            case 2:
               this.mouseMode(false);
               this.playOpenCardMovie();
               break;
            case 3:
               this.mouseMode(true);
               this._cell.visible = false;
               this._openCardMovie.gotoAndStop(this._openCardMovie.totalFrames);
               break;
            case 4:
               this.mouseMode(false);
               this._cell.visible = false;
               this.playCloseCardMovie();
               break;
            case 5:
               this.mouseMode(false);
               this._cell.visible = true;
         }
      }
      
      private function cellInfo(param1:PyramidSystemItemsInfo) : void
      {
         var _loc2_:InventoryItemInfo = null;
         if(Boolean(param1))
         {
            _loc2_ = PyramidManager.instance.model.getInventoryItemInfo(param1);
         }
         this._cell.info = _loc2_;
      }
      
      public function get state() : int
      {
         return this._state;
      }
      
      public function reset() : void
      {
         this.cardState(0);
      }
      
      private function removeEvent() : void
      {
         this._openCardMovie.removeEventListener(Event.ENTER_FRAME,this.__enterFrame);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this.index = null;
         ObjectUtils.disposeObject(this._cell);
         this._cell = null;
         ObjectUtils.disposeObject(this._openCardMovie);
         this._openCardMovie = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}
