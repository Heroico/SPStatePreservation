//
//  SPItem.m
//  StatePreservation
//
//  Created by Alvaro Barbeira on 11/4/13.
//  Copyright (c) 2013 Zauber. All rights reserved.
//

#import "SPItem.h"

@implementation SPItem

- (id)init {
    self = [super init];
    if (self) {
        self.children = [NSMutableArray array];
    }
    return self;
}

@end
