//
//  CustomParticleSystem.m
//  MonsterForm
//
//  Created by shahid.latif on 10/22/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomParticleSystem.h"


@implementation CustomParticleSystem

+(CCParticleSystem*) particle {

    CCParticleSystem *particle=[[[CCParticleSystemQuad alloc] initWithTotalParticles:1500] autorelease];
    ///////**** Assignment Texture Filename!  ****///////
    CCTexture2D *texture=[[CCTextureCache sharedTextureCache] addImage:@"custom_PartileSystem.png"];
    particle.texture=texture;
    particle.emissionRate=187.50;
    particle.angle=287.0;
    particle.angleVar=36.0;
    ccBlendFunc blendFunc={GL_SRC_ALPHA,GL_ONE};
    particle.blendFunc=blendFunc;
    particle.duration=-1.00;
    particle.emitterMode=kCCParticleModeGravity;
    ccColor4F startColor={0.31,0.36,0.90,1.00};
    particle.startColor=startColor;
    ccColor4F startColorVar={0.00,0.00,0.00,0.00};
    particle.startColorVar=startColorVar;
    ccColor4F endColor={0.17,0.42,0.79,0.20};
    particle.endColor=endColor;
    ccColor4F endColorVar={0.10,0.10,0.10,0.20};
    particle.endColorVar=endColorVar;
    particle.startSize=20.00;
    particle.startSizeVar=2.00;
    particle.endSize=10.00;
    particle.endSizeVar=0.00;
    particle.gravity=ccp(276.00,20.00);
    particle.radialAccel=-1000.00;
    particle.radialAccelVar=0.00;
    particle.speed=400;
    particle.speedVar= 0;
    particle.tangentialAccel=45;
    particle.tangentialAccelVar= 0;
    particle.totalParticles=1500;
    particle.life=8.00;
    particle.lifeVar=1.00;
    particle.startSpin=0.00;
    particle.startSpinVar=0.00;
    particle.endSpin=0.00;
    particle.endSpinVar=0.00;
    particle.position=ccp(379.09,160.00);
    particle.posVar=ccp(0.00,0.00);
    

    return particle;
}

@end
