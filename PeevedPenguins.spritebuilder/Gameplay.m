//
//  Gameplay.m
//  PeevedPenguins
//
//  Created by Junjia He on 1/30/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Gameplay.h"

@implementation Gameplay {
  CCPhysicsNode *_physicsNode;
  CCNode *_catapultArm;
  CCNode *_levelNode;
}

- (void)didLoadFromCCB{
  self.userInteractionEnabled = TRUE;
  CCScene *level = [CCBReader loadAsScene:@"Levels/Level1"];
  [_levelNode addChild: level];
}

- (void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
  [self launchPenguin];
}

- (void)launchPenguin {
  CCNode *penguin = [CCBReader load:@"Penguin"];
  penguin.position = ccpAdd(_catapultArm.position, ccp(16, 50));
  
  [_physicsNode addChild:penguin];
  
  CGPoint launchDirection = ccp(1, 0);
  CGPoint force = ccpMult(launchDirection, 8000);
  [penguin.physicsBody applyForce:force];
}

@end
