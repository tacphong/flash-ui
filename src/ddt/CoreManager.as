package ddt
{
   import com.pickgliss.loader.CodeLoader;
   import com.pickgliss.ui.ComponentSetting;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   
   public class CoreManager extends EventDispatcher
   {
       
      
      private var _codeLoader:CodeLoader;
      
      private var _codeURL:String;
      
      public function CoreManager(param1:IEventDispatcher = null)
      {
         super(param1);
      }
      
      final public function show(param1:String = "2.png") : void
      {
         this._codeURL = param1;
         if(CodeLoader.loaded(this._codeURL) || ComponentSetting.FLASHSITE == "")
         {
            this.onLoaded();
         }
         else
         {
            this._codeLoader = new CodeLoader();
            this._codeLoader.loadPNG(param1,this.onLoaded,this.onProgress);
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
         }
      }
      
      private function onProgress(param1:Number) : void
      {
         UIModuleSmallLoading.Instance.progress = param1 * 100;
      }
      
      protected function __onClose(param1:Event) : void
      {
         this._codeLoader.stop();
         CodeLoader.removeURL(this._codeURL);
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener("close",this.__onClose);
      }
      
      protected function onLoaded() : void
      {
         UIModuleSmallLoading.Instance.hide();
         dispatchEvent(new Event("complete"));
         this.start();
      }
      
      protected function start() : void
      {
      }
   }
}
