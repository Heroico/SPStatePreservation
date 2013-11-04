//
//  SPChildViewController.h
//  StatePreservation
//
//  Created by Alvaro Barbeira on 11/4/13.
//  Copyright (c) 2013 Zauber. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SPItem;

@interface SPChildViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISwitch *optionSwitch;
@property (strong, nonatomic) SPItem *item;
- (IBAction)optionChanged:(UISwitch *)sender;
@end
