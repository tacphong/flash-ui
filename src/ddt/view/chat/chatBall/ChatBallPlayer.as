package ddt.view.chat.chatBall
{
   import com.pickgliss.ui.ComponentFactory;
   import flash.geom.Point;
   import flash.utils.Timer;
   
   public class ChatBallPlayer extends ChatBallBase
   {
       
      
      private var _currentPaopaoType:int = 0;
      
      private var _field2:ddt.view.chat.chatBall.ChatBallTextAreaBuff;
      
      public function ChatBallPlayer()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         _field = new ChatBallTextAreaPlayer();
         this._field2 = new ddt.view.chat.chatBall.ChatBallTextAreaBuff();
      }
      
      override protected function get field() : ChatBallTextAreaBase
      {
         if(this._currentPaopaoType != 9)
         {
            return _field;
         }
         return this._field2;
      }
      
      override public function setText(param1:String, param2:int = 0) : void
      {
         clear();
         if(param2 == 9)
         {
            _popupTimer = new Timer(2700,1);
         }
         else
         {
            _popupTimer = new Timer(4000,1);
         }
         if(this._currentPaopaoType != param2 || paopaoMC == null)
         {
            this._currentPaopaoType = param2;
            this.newPaopao();
         }
         var _loc3_:int = this.globalToLocal(new Point(500,10)).x;
         this.field.x = _loc3_ < 0 ? Number(0) : Number(_loc3_);
         this.field.text = param1;
         fitSize(this.field);
         this.show();
      }
      
      override public function show() : void
      {
         super.show();
         beginPopDelay();
      }
      
      override public function hide() : void
      {
         super.hide();
         if(Boolean(this.field) && Boolean(this.field.parent))
         {
            this.field.parent.removeChild(this.field);
         }
      }
      
      override public function set width(param1:Number) : void
      {
         super.width = param1;
      }
      
      private function newPaopao() : void
      {
         if(Boolean(paopao))
         {
            removeChild(paopao);
         }
         if(this._currentPaopaoType != 9)
         {
            paopaoMC = ComponentFactory.Instance.creat("ChatBall1600" + String(this._currentPaopaoType));
         }
         else
         {
            paopaoMC = ComponentFactory.Instance.creat("SpecificBall001");
         }
         _chatballBackground = new ChatBallBackground(paopaoMC);
         addChild(paopao);
      }
      
      override public function dispose() : void
      {
         this._field2.dispose();
         super.dispose();
      }
   }
}
