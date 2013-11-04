//
//  SPItem+Model.m
//  StatePreservation
//
//  Created by Alvaro Barbeira on 11/4/13.
//  Copyright (c) 2013 Zauber. All rights reserved.
//

#import "SPItem+Model.h"
#import "SPModel.h"

@interface SPItem()
- (void)setModel:(SPModel *)model;
- (SPModel *)model;
- (void)setChildren:(NSMutableArray *)array;
@end

@implementation SPItem (Model)

- (id)initWithModel:(SPModel *)model {
    self = [super init];
    if (self) {
        self.model = model;
        self.children = [NSMutableArray array];
    }
    return self;
}

- (void)saveChanges {
    [self.model saveChangesForItem:self];
}

- (NSDictionary *)toDict {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"name"] = self.name;
    if (self.option) {
        dict[@"option"] = @"true";
    }
    
    NSMutableArray *children = [NSMutableArray array];
    for (SPItem *child in self.children) {
        [children addObject:[child toDict]];
    }
    if (children.count) {
        dict[@"children"] = children;
    }
    
    return dict;
}
@end
