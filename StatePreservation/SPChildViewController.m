//
//  SPChildViewController.m
//  StatePreservation
//
//  Created by Alvaro Barbeira on 11/4/13.
//  Copyright (c) 2013 Zauber. All rights reserved.
//

#import "SPChildViewController.h"
#import "SPItem.h"
#import "SPItem+Model.h"

@interface SPChildViewController ()
@end

@implementation SPChildViewController

#define kChildItemCellReuseIdentifier @"ChildItemCellReuseIdentifier"

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupUIFromItem];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.item saveChanges];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Stuff

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.item.children.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kChildItemCellReuseIdentifier];
    
    SPItem *item = self.item.children[indexPath.row];
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

#pragma mark - Utils 

- (void)setupUIFromItem {
    self.title = self.item.name;
    self.optionSwitch.on = self.item.option;
}

- (IBAction)optionChanged:(UISwitch *)sender {
    self.item.option = sender.on;
}
@end
