package trainer.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.PlayerManager;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import flash.utils.setTimeout;
   import trainer.controller.WeakGuildManager;
   import trainer.data.Step;
   
   public class NewHandContainer
   {
      
      private static var _instance:trainer.view.NewHandContainer;
       
      
      private var _arrows:Dictionary;
      
      private var _movies:Dictionary;
      
      public function NewHandContainer(param1:NewHandContainerEnforcer)
      {
         super();
         this._arrows = new Dictionary();
         this._movies = new Dictionary();
      }
      
      public static function get Instance() : trainer.view.NewHandContainer
      {
         if(!_instance)
         {
            _instance = new trainer.view.NewHandContainer(new NewHandContainerEnforcer());
         }
         return _instance;
      }
      
      public function showArrow(param1:int, param2:int, param3:*, param4:String = "", param5:String = "", param6:DisplayObjectContainer = null, param7:int = 0, param8:Boolean = false) : void
      {
         var _loc9_:Point = null;
         var _loc10_:MovieClip = null;
         var _loc11_:MovieClip = null;
         var _loc12_:Point = null;
         _loc9_ = null;
         _loc10_ = null;
         _loc11_ = null;
         _loc12_ = null;
         if(this.hasArrow(param1))
         {
            this.clearArrow(param1);
         }
         if(!WeakGuildManager.Instance.switchUserGuide || PlayerManager.Instance.Self.IsWeakGuildFinish(Step.OLD_PLAYER))
         {
            return;
         }
         var _loc13_:Object = {};
         _loc9_ = ComponentFactory.Instance.creatCustomObject(param3);
         _loc10_ = ClassUtils.CreatInstance("asset.trainer.TrainerArrowAsset");
         _loc10_.mouseChildren = false;
         _loc10_.mouseEnabled = false;
         _loc10_.rotation = param2;
         _loc10_.x = _loc9_.x;
         _loc10_.y = _loc9_.y;
         if(Boolean(param6))
         {
            param6.addChild(_loc10_);
         }
         else
         {
            LayerManager.Instance.addToLayer(_loc10_,LayerManager.GAME_TOP_LAYER,false,LayerManager.NONE_BLOCKGOUND);
         }
         _loc13_["arrow"] = _loc10_;
         if(param4 != "")
         {
            _loc11_ = ClassUtils.CreatInstance(param4);
            _loc11_.mouseChildren = false;
            _loc11_.mouseEnabled = false;
            if(param5 != "")
            {
               _loc12_ = ComponentFactory.Instance.creatCustomObject(param5);
               _loc11_.x = _loc12_.x;
               _loc11_.y = _loc12_.y;
            }
            if(Boolean(param6))
            {
               param6.addChild(_loc11_);
            }
            else
            {
               LayerManager.Instance.addToLayer(_loc11_,LayerManager.GAME_TOP_LAYER,false,LayerManager.NONE_BLOCKGOUND);
            }
            _loc13_["tip"] = _loc11_;
         }
         this._arrows[param1] = _loc13_;
         if(param7 > 0)
         {
            setTimeout(this.clearArrow,param7,param1);
         }
      }
      
      public function clearArrowByID(param1:int) : void
      {
         var _loc2_:* = null;
         if(param1 == -1)
         {
            for(_loc2_ in this._arrows)
            {
               this.clearArrow(int(_loc2_));
            }
         }
         else
         {
            this.clearArrow(param1);
         }
      }
      
      public function hasArrow(param1:int) : Boolean
      {
         return this._arrows[param1] != null;
      }
      
      public function showMovie(param1:String, param2:String = "") : void
      {
         var _loc3_:MovieClip = null;
         _loc3_ = null;
         var _loc4_:Point = null;
         if(Boolean(this._movies[param1]))
         {
            throw new Error("Already has a arrow with this id!");
         }
         _loc3_ = ClassUtils.CreatInstance(param1);
         _loc3_.mouseEnabled = _loc3_.mouseChildren = false;
         if(param2 != "")
         {
            _loc4_ = ComponentFactory.Instance.creatCustomObject(param2);
            _loc3_.x = _loc4_.x;
            _loc3_.y = _loc4_.y;
         }
         LayerManager.Instance.addToLayer(_loc3_,LayerManager.GAME_DYNAMIC_LAYER,false,LayerManager.NONE_BLOCKGOUND);
         this._movies[param1] = _loc3_;
      }
      
      public function hideMovie(param1:String) : void
      {
         var _loc2_:* = null;
         if(param1 == "-1")
         {
            for(_loc2_ in this._movies)
            {
               this.clearMovie(_loc2_);
            }
         }
         else
         {
            this.clearMovie(param1);
         }
      }
      
      private function clearArrow(param1:int) : void
      {
         var _loc2_:Object = this._arrows[param1];
         if(Boolean(_loc2_))
         {
            ObjectUtils.disposeObject(_loc2_["arrow"]);
            ObjectUtils.disposeObject(_loc2_["tip"]);
         }
         delete this._arrows[param1];
      }
      
      private function clearMovie(param1:String) : void
      {
         ObjectUtils.disposeObject(this._movies[param1]);
         delete this._movies[param1];
      }
      
      public function dispose() : void
      {
         _instance = null;
         this._arrows = null;
         this._movies = null;
      }
   }
}

class NewHandContainerEnforcer
{
    
   
   public function NewHandContainerEnforcer()
   {
      super();
   }
}
