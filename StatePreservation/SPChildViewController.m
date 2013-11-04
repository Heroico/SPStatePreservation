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
#import "SPModel.h"

@interface SPChildViewController ()
@end

@implementation SPChildViewController

#define kNonRelatedSwitch @"NonRelatedSwitchInChildViewController"
#define kChildItemCellReuseIdentifier @"ChildItemCellReuseIdentifier"

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    self.item = [[SPModel sharedModel] selectedItem];
    [self setupUIFromItem];
    [self setupUIFromPreservedState];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

#pragma mark - life cycle

- (void)willEnterBackground {
    [self.item saveChanges];
}

#pragma mark - Utils 

- (void)setupUIFromItem {
    self.title = self.item.name;
    self.optionSwitch.on = self.item.option;
    [self.tableView reloadData];
}

- (void)setupUIFromPreservedState {
    // The switch's state is not preserved by UIKit. So we restore it with a custom mechanism.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.nonrelatedSwitch.on = [defaults boolForKey:kNonRelatedSwitch];
}

#pragma mark - UI interaction

- (IBAction)optionChanged:(UISwitch *)sender {
    self.item.option = sender.on;
}

- (IBAction)nonrelatedChanged:(UISwitch *)sender {
    // The switch's state is not preserved by UIKit. So we preserve it with a custom mechanism.
    BOOL amazingEnabled = self.nonrelatedSwitch.isOn;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:amazingEnabled forKey:kNonRelatedSwitch];
    [defaults synchronize];
}
@end
