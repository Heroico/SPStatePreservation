//
//  SPItem+Model.h
//  StatePreservation
//
//  Created by Alvaro Barbeira on 11/4/13.
//  Copyright (c) 2013 Zauber. All rights reserved.
//

#import "SPItem.h"

@class SPModel;

@interface SPItem (Model)
- (id)initWithModel:(SPModel *)model;

- (void)saveChanges;

- (NSDictionary *)toDict;
@end
