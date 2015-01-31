//
//  Seal.m
//  PeevedPenguins
//
//  Created by Junjia He on 1/26/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Seal.h"

@implementation Seal

- (instancetype)init {
  self = [super init];
  
  return self;
}

- (void)didLoadFromCCB {
  self.physicsBody.collisionType = @"seal";
  CCLOG(@"added collisiton type of seal to Seal");
}

@end
