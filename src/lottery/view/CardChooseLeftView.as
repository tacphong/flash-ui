package lottery.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import lottery.cell.SmallCardCell;
   import lottery.events.LotteryEvent;
   
   public class CardChooseLeftView extends Sprite implements Disposeable
   {
      
      private static const CARD_LIMIT:int = 24;
       
      
      private var _cardContainer:SimpleTileList;
      
      public function CardChooseLeftView()
      {
         super();
         this.initView();
         this.addEvent();
      }
      
      private function initView() : void
      {
         var _loc1_:SmallCardCell = null;
         this._cardContainer = ComponentFactory.Instance.creatComponentByStylename("lottery.cardChoose.allCardCcontainer",[4]);
         addChild(this._cardContainer);
         var _loc2_:int = 0;
         while(_loc2_ < CARD_LIMIT)
         {
            _loc1_ = new SmallCardCell();
            _loc1_.cardId = _loc2_ + 1;
            _loc1_.addEventListener(MouseEvent.CLICK,this.__onCardCellClick);
            _loc1_.addEventListener(MouseEvent.MOUSE_OVER,this.__cardCellMouseOver);
            _loc1_.addEventListener(MouseEvent.MOUSE_OUT,this.__cardCellMouseOut);
            this._cardContainer.addChild(_loc1_);
            _loc2_++;
         }
      }
      
      private function addEvent() : void
      {
      }
      
      private function removeEvent() : void
      {
         var _loc1_:DisplayObject = null;
         var _loc2_:int = 0;
         while(_loc2_ < CARD_LIMIT)
         {
            _loc1_ = this._cardContainer.getChildAt(_loc2_);
            _loc1_.removeEventListener(MouseEvent.CLICK,this.__onCardCellClick);
            _loc1_.removeEventListener(MouseEvent.MOUSE_OVER,this.__cardCellMouseOver);
            _loc1_.removeEventListener(MouseEvent.MOUSE_OUT,this.__cardCellMouseOut);
            _loc2_++;
         }
      }
      
      public function resetAllCard() : void
      {
         var _loc1_:SmallCardCell = null;
         var _loc2_:int = 0;
         while(_loc2_ < CARD_LIMIT)
         {
            _loc1_ = this._cardContainer.getChildAt(_loc2_) as SmallCardCell;
            _loc1_.enable = true;
            _loc2_++;
         }
      }
      
      public function resetCardById(param1:int) : void
      {
         SmallCardCell(this._cardContainer.getChildAt(param1 - 1)).enable = true;
      }
      
      private function __cardCellMouseOver(param1:MouseEvent) : void
      {
         SmallCardCell(param1.currentTarget).selected = true;
      }
      
      private function __cardCellMouseOut(param1:MouseEvent) : void
      {
         SmallCardCell(param1.currentTarget).selected = false;
      }
      
      private function __onCardCellClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:SmallCardCell = SmallCardCell(param1.currentTarget);
         dispatchEvent(new LotteryEvent(LotteryEvent.CARD_SELECT,_loc2_));
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._cardContainer))
         {
            ObjectUtils.disposeObject(this._cardContainer);
         }
         this._cardContainer = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}
