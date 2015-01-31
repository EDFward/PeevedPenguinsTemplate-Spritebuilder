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
  CCNode *_contentNode;
  CCNode *_pullbackNode;

  CCNode *_mouseJointNode;
  CCPhysicsJoint *_mouseJoint;

  CCNode *_currentPenguin;
  CCPhysicsJoint *_penguinCatapultJoint;
}

- (void)didLoadFromCCB {
  self.userInteractionEnabled = TRUE;
  CCScene *level = [CCBReader loadAsScene:@"Levels/Level1"];
  [_levelNode addChild:level];

  // for DEBUG
  _physicsNode.debugDraw = TRUE;

  _pullbackNode.physicsBody.collisionMask = @[];

  _mouseJointNode.physicsBody.collisionMask = @[];
}

- (void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
  CGPoint touchLocation = [touch locationInNode:_contentNode];

  if (CGRectContainsPoint([_catapultArm boundingBox], touchLocation)) {
    _mouseJointNode.position = touchLocation;
    _mouseJoint = [CCPhysicsJoint
        connectedSpringJointWithBodyA:_mouseJointNode.physicsBody
                                bodyB:_catapultArm.physicsBody
                              anchorA:ccp(0, 0)
                              anchorB:ccp(34, 138)
                           restLength:0.f
                            stiffness:3000.f
                              damping:150.f];

    _currentPenguin = [CCBReader load:@"Penguin"];
    CGPoint penguinPosition = [_catapultArm convertToWorldSpace:ccp(34, 183)];
    _currentPenguin.position =
        [_physicsNode convertToNodeSpace:penguinPosition];

    [_physicsNode addChild:_currentPenguin];
    _currentPenguin.physicsBody.allowsRotation = false;

    _penguinCatapultJoint = [CCPhysicsJoint
        connectedPivotJointWithBodyA:_currentPenguin.physicsBody
                               bodyB:_catapultArm.physicsBody
                             anchorA:_currentPenguin.anchorPointInPoints];
  }
}

- (void)touchMoved:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
  CGPoint touchLocation = [touch locationInNode:_contentNode];
  _mouseJointNode.position = touchLocation;
}

- (void)touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
  [self releaseCatapult];
}

- (void)touchCancelled:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
  [self releaseCatapult];
}

- (void)releaseCatapult {
  if (_mouseJoint != nil) {
    [_mouseJoint invalidate];
    _mouseJoint = NULL;

    [_penguinCatapultJoint invalidate];
    _penguinCatapultJoint = nil;

    _currentPenguin.physicsBody.allowsRotation = TRUE;

    CCActionFollow *follow = [CCActionFollow actionWithTarget:_currentPenguin
                                                worldBoundary:self.boundingBox];
    [_contentNode runAction:follow];
  }
}

- (void)launchPenguin {
  CCNode *penguin = [CCBReader load:@"Penguin"];
  penguin.position = ccpAdd(_catapultArm.position, ccp(16, 50));

  [_physicsNode addChild:penguin];

  CGPoint launchDirection = ccp(1, 0);
  CGPoint force = ccpMult(launchDirection, 8000);
  [penguin.physicsBody applyForce:force];

  self.position = ccp(0, 0);
  CCActionFollow *follow =
      [CCActionFollow actionWithTarget:penguin worldBoundary:self.boundingBox];
  [_contentNode runAction:follow];
}

- (void)retry {
  [[CCDirector sharedDirector]
      replaceScene:[CCBReader loadAsScene:@"Gameplay"]];
}

@end
