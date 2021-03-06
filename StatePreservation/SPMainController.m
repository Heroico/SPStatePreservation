//
//  SPViewController.m
//  StatePreservation
//
//  Created by Alvaro Barbeira on 11/4/13.
//  Copyright (c) 2013 Zauber. All rights reserved.
//

#import "SPMainController.h"
#import "SPModel.h"
#import "SPItem.h"
#import "SPChildViewController.h"

@interface SPMainController ()<UITableViewDataSource, UITableViewDelegate, UIDataSourceModelAssociation>
@property (nonatomic,strong) NSArray *items;
@property (strong, nonatomic) SPItem *selectedItem;
@end

@implementation SPMainController

#define kMainToChildSegueIdentifier @"mainToChildSegueIdentifier"
#define kItemViewCellReuseIdentifier @"ItemViewCellIReuseIdentifier"

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.items = [[SPModel sharedModel] items];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kItemViewCellReuseIdentifier];
    
    SPItem *item = self.items[indexPath.row];
    cell.textLabel.text = item.name;
    if (item.children.count) {
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SPItem *selectedItem = self.items[indexPath.row];
    if (selectedItem.children.count) {
        [[SPModel sharedModel] setSelectedItem:selectedItem];
        [self performSegueWithIdentifier:kMainToChildSegueIdentifier sender:self];
    }
}

#pragma mark - UI preservation

-(NSString *)modelIdentifierForElementAtIndexPath:(NSIndexPath *)idx inView:(UIView *)view {
    NSString *identifier = nil;
    if (idx && view)
    {
        SPItem *item = self.items[idx.row];
        identifier = item.name;
    }
    return identifier;
}

- (NSIndexPath *)indexPathForElementWithModelIdentifier:(NSString *)identifier inView:(UIView *)view {
    NSIndexPath *indexPath = nil;
    if (identifier && view) {
        NSInteger row = [self.items indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
            SPItem *item = (SPItem *)obj;
            BOOL found = [item.name isEqualToString:identifier];
            *stop = found;
            return found;
        }];
        
        if (row != NSNotFound) {
            indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        }
    }
    return indexPath;
}

#pragma mark - UI Interaction


@end
