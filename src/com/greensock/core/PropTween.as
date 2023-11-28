package com.greensock.core
{
   public final class PropTween
   {
       
      
      public var target:Object;
      
      public var property:String;
      
      public var start:Number;
      
      public var change:Number;
      
      public var name:String;
      
      public var priority:int;
      
      public var isPlugin:Boolean;
      
      public var nextNode:com.greensock.core.PropTween;
      
      public var prevNode:com.greensock.core.PropTween;
      
      public function PropTween(param1:Object, param2:String, param3:Number, param4:Number, param5:String, param6:Boolean, param7:com.greensock.core.PropTween = null, param8:int = 0)
      {
         super();
         this.target = param1;
         this.property = param2;
         this.start = param3;
         this.change = param4;
         this.name = param5;
         this.isPlugin = param6;
         if(Boolean(param7))
         {
            param7.prevNode = this;
            this.nextNode = param7;
         }
         this.priority = param8;
      }
   }
}
