package game.view.prop
{
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import consortionBattle.ConsortiaBattleManager;
   import consortionBattle.player.ConsortiaBattlePlayerInfo;
   import consortionBattle.view.ConsBatLosingStreakBuff;
   import ddt.data.EquipType;
   import ddt.data.PropInfo;
   import ddt.data.UsePropErrorCode;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.events.LivingEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import game.model.LocalPlayer;
   import org.aswing.KeyStroke;
   import room.RoomManager;
   import room.model.RoomInfo;
   import trainer.controller.NewHandGuideManager;
   import trainer.data.ArrowType;
   import trainer.data.Step;
   import trainer.view.NewHandContainer;
   
   public class WeaponPropBar extends FightPropBar
   {
       
      
      private var _canEnable:Boolean = true;
      
      protected var _losingStreakIcon:ConsBatLosingStreakBuff;
      
      private var _localFlyVisible:Boolean = true;
      
      private var _localDeputyWeaponVisible:Boolean = true;
      
      private var _localVisible:Boolean = true;
      
      public function WeaponPropBar(param1:LocalPlayer)
      {
         super(param1);
         this._canEnable = this.weaponEnabled();
         this.updatePropByEnergy();
         this.initLosingStreakInConsBat();
      }
      
      private function initLosingStreakInConsBat() : void
      {
         if(RoomManager.Instance.current.type != RoomInfo.CONSORTIA_BATTLE)
         {
            return;
         }
         var _loc1_:ConsortiaBattlePlayerInfo = ConsortiaBattleManager.instance.getPlayerInfo(PlayerManager.Instance.Self.ID);
         if(_loc1_.failBuffCount > 0)
         {
            this._losingStreakIcon = ComponentFactory.Instance.creatComponentByStylename("gameView.ConsBatLosingStreakBuff");
            addChild(this._losingStreakIcon);
            if(Boolean(_cells[1]))
            {
               _cells[1].visible = false;
            }
         }
      }
      
      private function weaponEnabled() : Boolean
      {
         var _loc1_:ItemTemplateInfo = null;
         var _loc2_:int = 0;
         _loc1_ = _self.currentDeputyWeaponInfo.Template;
         if(RoomManager.Instance.current.type == RoomInfo.CONSORTIA_BATTLE)
         {
            return false;
         }
         return true;
      }
      
      override protected function updatePropByEnergy() : void
      {
         _cells[0].enabled = _self.flyEnabled;
         if(!this._canEnable)
         {
            _self.deputyWeaponEnabled = false;
            _cells[1].setGrayFilter();
            _cells[1].removeEventListener(MouseEvent.CLICK,this.__itemClicked);
         }
         _cells[1].enabled = _self.deputyWeaponEnabled;
         if(!_self.flyEnabled)
         {
            this.hideGuidePlane();
         }
      }
      
      override protected function __itemClicked(param1:MouseEvent) : void
      {
         var _loc2_:String = null;
         if(!this._localVisible)
         {
            return;
         }
         var _loc3_:PropCell = param1.currentTarget as PropCell;
         SoundManager.instance.play("008");
         var _loc4_:int = _cells.indexOf(_loc3_);
         switch(_loc4_)
         {
            case 0:
               if(!this._localFlyVisible)
               {
                  return;
               }
               _loc2_ = _self.useFly();
               break;
            case 1:
               if(!this._localDeputyWeaponVisible)
               {
                  return;
               }
               _loc2_ = _self.useDeputyWeapon();
               break;
            default:
               _loc2_ = UsePropErrorCode.None;
         }
         if(_loc2_ == UsePropErrorCode.FlyNotCoolDown)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.game.prop.NotCoolDown",_self.flyCoolDown));
         }
         else if(_loc2_ == UsePropErrorCode.DeputyWeaponNotCoolDown)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.game.prop.NotCoolDown",_self.deputyWeaponCoolDown));
         }
         else if(_loc2_ == UsePropErrorCode.DeputyWeaponEmpty)
         {
            switch(_self.selfInfo.DeputyWeapon.TemplateID)
            {
               case EquipType.Angle:
               case EquipType.TrueAngle:
               case EquipType.ExllenceAngle:
               case EquipType.FlyAngle:
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.game.deputyWeapon.canNotUse"));
                  break;
               case EquipType.TrueShield:
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.game.deputyWeapon.canNotUse2"));
                  break;
               case EquipType.ExcellentShield:
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.game.deputyWeapon.canNotUse3"));
            }
         }
         else if(_loc2_ != UsePropErrorCode.None)
         {
            if(_loc2_ != "LockState" || RoomManager.Instance.current.type != RoomInfo.ACTIVITY_DUNGEON_ROOM)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.game.prop." + _loc2_));
            }
         }
         else if(_loc4_ == 0)
         {
            this.hideGuidePlane();
            if(NewHandGuideManager.Instance.mapID == 115)
            {
               if(_self.pos.x < 990)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("game.view.arrow.ArrowView.energy"));
               }
            }
            else if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.GUIDE_PLANE) && PlayerManager.Instance.Self.IsWeakGuildFinish(Step.PLANE_OPEN))
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("game.view.arrow.ArrowView.energy"));
            }
         }
         StageReferance.stage.focus = null;
      }
      
      override protected function __keyDown(param1:KeyboardEvent) : void
      {
         switch(param1.keyCode)
         {
            case KeyStroke.VK_F.getCode():
               _cells[0].useProp();
               break;
            case KeyStroke.VK_R.getCode():
               if(RoomManager.Instance.current.type != RoomInfo.CONSORTIA_BATTLE)
               {
                  _cells[1].useProp();
               }
         }
         super.__keyDown(param1);
      }
      
      override protected function addEvent() : void
      {
         var _loc1_:PropCell = null;
         _self.addEventListener(LivingEvent.FLY_CHANGED,this.__flyChanged);
         _self.addEventListener(LivingEvent.DEPUTYWEAPON_CHANGED,this.__deputyWeaponChanged);
         _self.addEventListener(LivingEvent.ATTACKING_CHANGED,this.__changeAttack);
         for each(_loc1_ in _cells)
         {
            _loc1_.addEventListener(MouseEvent.CLICK,this.__itemClicked);
         }
         super.addEvent();
      }
      
      override protected function __changeAttack(param1:LivingEvent) : void
      {
         if(_self.isAttacking)
         {
            this.showGuidePlane();
            this.updatePropByEnergy();
         }
         else
         {
            this.hideGuidePlane();
         }
      }
      
      private function showGuidePlane() : void
      {
         if(NewHandGuideManager.Instance.mapID == 115)
         {
            if(_self.pos.x < 990)
            {
               if(_self.flyEnabled)
               {
                  NewHandContainer.Instance.showArrow(ArrowType.TIP_PLANE,30,"trainer.posPlaneI");
               }
            }
         }
         else if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.GUIDE_PLANE) && PlayerManager.Instance.Self.IsWeakGuildFinish(Step.PLANE_OPEN))
         {
            if(_self.flyEnabled)
            {
               NewHandContainer.Instance.showArrow(ArrowType.TIP_PLANE,30,"trainer.posPlaneI");
            }
         }
      }
      
      private function hideGuidePlane() : void
      {
         if(NewHandContainer.Instance.hasArrow(ArrowType.TIP_PLANE))
         {
            NewHandContainer.Instance.clearArrowByID(ArrowType.TIP_PLANE);
         }
      }
      
      private function __setDeputyWeaponNumber(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = param1.pkg.readInt();
         _cells[1].enabled = _loc2_ != 0;
         WeaponPropCell(_cells[1]).setCount(_loc2_);
      }
      
      private function __deputyWeaponChanged(param1:LivingEvent) : void
      {
         if(!this._canEnable)
         {
            _self.deputyWeaponEnabled = false;
         }
         _cells[1].enabled = _self.deputyWeaponEnabled;
         if(this._canEnable)
         {
            WeaponPropCell(_cells[1]).setCount(_self.deputyWeaponCount);
         }
      }
      
      private function __flyChanged(param1:LivingEvent) : void
      {
         _cells[0].enabled = _self.flyEnabled;
         if(RoomManager.Instance.current.type == RoomInfo.CONSORTIA_BATTLE)
         {
            (_cells[0] as WeaponPropCell).setCount(_self.flyCount);
            if(_self.flyCount <= 0)
            {
               _cells[0].setGrayFilter();
               _cells[0].removeEventListener(MouseEvent.CLICK,this.__itemClicked);
            }
         }
      }
      
      override protected function configUI() : void
      {
         _background = ComponentFactory.Instance.creatBitmap("asset.game.prop.WeaponBack");
         addChild(_background);
         super.configUI();
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(Boolean(this._losingStreakIcon))
         {
            ObjectUtils.disposeObject(this._losingStreakIcon);
            this._losingStreakIcon = null;
         }
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
      
      override protected function drawCells() : void
      {
         var _loc1_:Point = null;
         var _loc2_:WeaponPropCell = null;
         _loc2_ = new WeaponPropCell("f",_mode);
         _loc2_.info = new PropInfo(ItemManager.Instance.getTemplateById(10016));
         _loc1_ = ComponentFactory.Instance.creatCustomObject("WeaponPropCellPosf");
         _loc2_.setPossiton(_loc1_.x,_loc1_.y);
         addChild(_loc2_);
         var _loc3_:WeaponPropCell = new WeaponPropCell("r",_mode);
         _loc1_ = ComponentFactory.Instance.creatCustomObject("WeaponPropCellPosr");
         _loc3_.setPossiton(_loc1_.x,_loc1_.y);
         addChild(_loc3_);
         if(_self.hasDeputyWeapon())
         {
            _loc3_.info = new PropInfo(_self.currentDeputyWeaponInfo.Template);
            _loc3_.setCount(_self.deputyWeaponCount);
         }
         _cells.push(_loc2_);
         _cells.push(_loc3_);
         super.drawCells();
      }
      
      override protected function removeEvent() : void
      {
         var _loc1_:PropCell = null;
         _self.removeEventListener(LivingEvent.FLY_CHANGED,this.__flyChanged);
         _self.removeEventListener(LivingEvent.DEPUTYWEAPON_CHANGED,this.__deputyWeaponChanged);
         _self.removeEventListener(LivingEvent.ATTACKING_CHANGED,this.__changeAttack);
         for each(_loc1_ in _cells)
         {
            _loc1_.removeEventListener(MouseEvent.CLICK,this.__itemClicked);
         }
         super.removeEvent();
      }
      
      public function setFlyVisible(param1:Boolean) : void
      {
         if(this._localFlyVisible != param1)
         {
            this._localFlyVisible = param1;
            if(this._localFlyVisible)
            {
               if(!_cells[0].parent)
               {
                  addChild(_cells[0]);
               }
            }
            else if(Boolean(_cells[0].parent))
            {
               _cells[0].parent.removeChild(_cells[0]);
            }
         }
      }
      
      public function setDeputyWeaponVisible(param1:Boolean) : void
      {
         if(this._localDeputyWeaponVisible != param1)
         {
            this._localDeputyWeaponVisible = param1;
            if(this._localDeputyWeaponVisible)
            {
               if(!_cells[1].parent)
               {
                  addChild(_cells[1]);
               }
            }
            else if(Boolean(_cells[1].parent))
            {
               _cells[1].parent.removeChild(_cells[1]);
            }
         }
      }
      
      public function setVisible(param1:Boolean) : void
      {
         this._localVisible = param1;
      }
   }
}
