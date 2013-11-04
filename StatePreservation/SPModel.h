//
//  SPModel.h
//  StatePreservation
//
//  Created by Alvaro Barbeira on 11/4/13.
//  Copyright (c) 2013 Zauber. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SPItem;

@interface SPModel : NSObject

+ (SPModel *)sharedModel;

- (NSArray *)items;

- (void)saveChangesForItem:(SPItem *)item;

@end
