unitDef = {
  unitname            = [[amphassault]],
  name                = [[Grizzly]],
  description         = [[Heavy Amphibious Assault Walker]],
  acceleration        = 0.1,
  brakeRate           = 0.1,
  buildCostEnergy     = 2000,
  buildCostMetal      = 2000,
  builder             = false,
  buildPic            = [[amphassault.png]],
  buildTime           = 2000,
  canAttack           = true,
  canGuard            = true,
  canMove             = true,
  canPatrol           = true,
  category            = [[LAND SINK]],
  collisionVolumeOffsets  = [[0 0 0]],
  --collisionVolumeScales   = [[70 70 70]],
  --collisionVolumeTest	  = 1,
  --collisionVolumeType	  = [[ellipsoid]],
  corpse              = [[DEAD]],

  customParams        = {
    floattoggle = [[1]],
    --description_bp = [[Robô dispersador]],
    --description_fr = [[Robot Émeutier]],
	--description_de = [[Sturm Roboter]],
    helptext       = [[The Grizzly is a classic assault unit - relatively slow, clumsy and next to unstoppable. Its weapon is a high power laser beam with high range and damage, ineffective against swarmers and fast aircraft but not much else.]],
    --helptext_bp    = [[O raio de calor do Sumo é muito poderoso a curto alcançe, mas se dissipa com a distância e é bem mais fraca de longe. A velocidade alta de disparo o torna ideal para lutar contra grandes grupos de unidades baratas. ]],
    --helptext_fr    = [[Le rayon r chaleur du Sumo est capable de délivrer une puissance de feu important sur un point précis. Plus la cible est proche, plus les dégâts seront importants. La précision du rayon est idéale pour lutter contre de larges vagues d'ennemis, mais l'imposant blindage du Sumo le restreint r une vitesse réduite.]],
	--helptext_de    = [[Der Sumo nutzt seinen mächtigen Heat Ray in nächster Nähe, auf größerer Entfernung aber verliert er entsprechend an Feuerkraft. Er eignet sich ideal, um größere Gruppen von billigen, feindlichen Einheiten zu vernichten. Bemerkenswert ist, dass der Sumo in die Luft springen kann und schließlich auf feindlichen Einheiten landet, was diesen enormen Schaden zufügt.]],
	aimposoffset   = [[0 30 0]],
	midposoffset   = [[0 6 0]],
	modelradius    = [[35]],
  },

  explodeAs           = [[BIG_UNIT]],
  footprintX          = 4,
  footprintZ          = 4,
  iconType            = [[amphassault]],
  idleAutoHeal        = 5,
  idleTime            = 1800,
  leaveTracks         = true,
  mass                = 621,
  maxDamage           = 9000,
  maxSlope            = 36,
  maxVelocity         = 1.6,
  maxWaterDepth       = 5000,
  minCloakDistance    = 75,
  movementClass       = [[AKBOT4]],
  noAutoFire          = false,
  noChaseCategory     = [[TERRAFORM FIXEDWING SATELLITE SUB]],
  objectName          = [[amphassault.s3o]],
  script              = [[amphassault.lua]],
  seismicSignature    = 4,
  selfDestructAs      = [[BIG_UNIT]],

  sfxtypes            = {

    explosiongenerators = {
      [[custom:watercannon_muzzle]],
    },

  },

  side                = [[CORE]],
  sightDistance       = 605,
  smoothAnim          = true,
  trackOffset         = 0,
  trackStrength       = 8,
  trackStretch        = 1,
  trackType           = [[ComTrack]],
  trackWidth          = 66,
  turnRate            = 500,
  upright             = false,
  workerTime          = 0,

  weapons                       = {
    {
      def                = [[LASER]],
      badTargetCategory  = [[FIXEDWING]],
      onlyTargetCategory = [[FIXEDWING LAND SINK TURRET SHIP SWIM FLOAT GUNSHIP HOVER]],
    },
--	{
--      def                = [[TORPEDO]],
--      badTargetCategory  = [[FIXEDWING]],
--      mainDir            = [[0 0 1]],
--      maxAngleDif        = 180,
--      onlyTargetCategory = [[SWIM LAND SUB SINK TURRET FLOAT SHIP HOVER]],
--    },

  },


  weaponDefs                    = {

    LASER = {
      name                    = [[High-Energy Laserbeam]],
      areaOfEffect            = 14,
      beamTime                = 0.8,
	  beamttl                 = 1,
      coreThickness           = 0.5,
      craterBoost             = 0,
      craterMult              = 0,

      damage                  = {
        default = 300,
        planes  = 300,
        subs    = 15,
      },

      explosionGenerator      = [[custom:flash1bluedark]],
      fireStarter             = 90,
      impactOnly              = true,
      impulseBoost            = 0,
      impulseFactor           = 0.4,
      interceptedByShieldType = 1,
      largeBeamLaser          = true,
      laserFlareSize          = 10.4,
      minIntensity            = 1,
      noSelfDamage            = true,
	  projectiles             = 5,
      range                   = 600,
      reloadtime              = 6,
      rgbColor                = [[0 0 1]],
      scrollSpeed             = 5,
      soundStart              = [[weapon/laser/heavy_laser3]],
	  soundStartVolume        = 3,
      sweepfire               = false,
      targetMoveError         = 0.2,
      texture1                = [[largelaserdark]],
      texture2                = [[flaredark]],
      texture3                = [[flaredark]],
      texture4                = [[smallflaredark]],
      thickness               = 10.4024486300101,
      tileLength              = 300,
      tolerance               = 10000,
      turret                  = true,
      weaponType              = [[BeamLaser]],
      weaponVelocity          = 2250,
    },

    TORPEDO = {
      name                    = [[Torpedo Launcher]],
      areaOfEffect            = 16,
      avoidFriendly           = false,
      bouncerebound           = 0.5,
      bounceslip              = 0.5,
      burnblow                = true,
      collideFriendly         = false,
      craterBoost             = 0,
      craterMult              = 0,

      damage                  = {
        default = 300,
      },

      explosionGenerator      = [[custom:TORPEDO_HIT]],
	  fixedLauncher           = true,
      groundbounce            = 1,
      impactOnly              = true,
      impulseBoost            = 0,
      impulseFactor           = 0.4,
      interceptedByShieldType = 1,
      model                   = [[wep_t_longbolt.s3o]],
      numbounce               = 4,
      range                   = 550,
      reloadtime              = 4,
      soundHit                = [[explosion/wet/ex_underwater]],
      --soundStart              = [[weapon/torpedo]],
      startVelocity           = 90,
      tracks                  = true,
      turnRate                = 22000,
      turret                  = true,
      waterWeapon             = true,
      weaponAcceleration      = 90,
      weaponTimer             = 3,
      weaponType              = [[TorpedoLauncher]],
      weaponVelocity          = 160,
    },
  },

  featureDefs         = {

    DEAD = {
      description      = [[Wreckage - Grizzly]],
      blocking         = true,
      category         = [[corpses]],
      damage           = 10000,
      energy           = 0,
      featureDead      = [[HEAP]],
      featurereclamate = [[SMUDGE01]],
      footprintX       = 3,
      footprintZ       = 3,
      height           = [[20]],
      hitdensity       = [[100]],
      metal            = 800,
      object           = [[amphassault_wreck.s3o]],
      reclaimable      = true,
      reclaimTime      = 800,
      seqnamereclamate = [[TREE1RECLAMATE]],
      world            = [[All Worlds]],
    },


    HEAP = {
      description      = [[Debris - Grizzly]],
      blocking         = false,
      category         = [[heaps]],
      damage           = 10000,
      energy           = 0,
      featurereclamate = [[SMUDGE01]],
      footprintX       = 3,
      footprintZ       = 3,
      height           = [[4]],
      hitdensity       = [[100]],
      metal            = 400,
      object           = [[debris4x4c.s3o]],
      reclaimable      = true,
      reclaimTime      = 400,
      seqnamereclamate = [[TREE1RECLAMATE]],
      world            = [[All Worlds]],
    },

  },

}

return lowerkeys({ amphassault = unitDef })
