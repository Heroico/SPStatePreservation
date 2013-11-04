//
//  SPItem.h
//  StatePreservation
//
//  Created by Alvaro Barbeira on 11/4/13.
//  Copyright (c) 2013 Zauber. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPItem : NSObject

@property (copy, nonatomic) NSString *name;
@property (readonly, nonatomic) NSMutableArray *children;
@property (assign, nonatomic) BOOL option;

@end
