//
//  SPItem.m
//  StatePreservation
//
//  Created by Alvaro Barbeira on 11/4/13.
//  Copyright (c) 2013 Zauber. All rights reserved.
//

#import "SPItem.h"
#import "SPModel.h"

@interface SPItem()
@property (nonatomic, weak) SPModel *model;
@property (nonatomic, strong) NSMutableArray *children;
@end

@implementation SPItem

- (id)init {
    self = [super init];
    if (self) {
        self.children = [NSMutableArray array];
    }
    return self;
}

@end
