package game.view.smallMap
{
   import flash.display.Graphics;
   
   public class SmallPlayer extends SmallLiving
   {
      
      private static const AttackMaxOffset:int = 4;
      
      private static const triangleCoords:Vector.<Object> = Vector.<Object>([{
         "x":0,
         "y":-8
      },{
         "x":4,
         "y":-12
      },{
         "x":-4,
         "y":-12
      }]);
       
      
      public function SmallPlayer()
      {
         super();
      }
      
      override protected function draw() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Graphics = graphics;
         if(onMap)
         {
            _loc4_.clear();
            _loc4_.beginFill(_color);
            _loc4_.drawCircle(0,0,_radius);
            if(_elapsed >= MovieTime * 1000 >> 1)
            {
               _loc1_ = (MovieTime * 1000 - _elapsed) / (MovieTime * 1000 >> 1);
            }
            else
            {
               _loc1_ = _elapsed / (MovieTime * 1000 >> 1);
            }
            if(_isAttacking)
            {
               _loc2_ = AttackMaxOffset * _loc1_;
               _loc4_.moveTo(triangleCoords[0].x,triangleCoords[0].y - _loc2_);
               _loc4_.lineTo(triangleCoords[1].x,triangleCoords[1].y - _loc2_);
               _loc4_.lineTo(triangleCoords[2].x,triangleCoords[2].y - _loc2_);
            }
            _loc4_.endFill();
            if(this.isSelf)
            {
               _loc4_.lineStyle(2,_color,_loc1_);
               _loc4_.beginFill(0,0);
               _loc4_.drawCircle(0,0,_radius + 2 + 2 * _loc1_);
               _loc4_.endFill();
            }
         }
         else
         {
            _loc4_.beginFill(_color);
            _loc4_.drawCircle(0,0,_radius);
            _loc4_.endFill();
         }
      }
      
      override public function onFrame(param1:int) : void
      {
         _elapsed += param1;
         if(_elapsed >= MovieTime * 1000)
         {
            _elapsed = 0;
         }
         this.draw();
      }
      
      override public function set isAttacking(param1:Boolean) : void
      {
         super.isAttacking = param1;
         this.draw();
      }
      
      public function get isSelf() : Boolean
      {
         if(!_info)
         {
            return false;
         }
         return _info.isSelf;
      }
   }
}
