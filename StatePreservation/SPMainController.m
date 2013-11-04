//
//  SPViewController.m
//  StatePreservation
//
//  Created by Alvaro Barbeira on 11/4/13.
//  Copyright (c) 2013 Zauber. All rights reserved.
//

#import "SPMainController.h"
#import "SPItem.h"
#import "SPChildViewController.h"

@interface SPMainController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic,strong) NSMutableArray *items;
@property (strong, nonatomic) SPItem *selectedItem;
@end

@implementation SPMainController

#define kMainToChildSegueIdentifier @"mainToChildSegueIdentifier"
#define kItemViewCellReuseIdentifier @"ItemViewCellIReuseIdentifier"

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
        self.selectedItem = selectedItem;
        [self performSegueWithIdentifier:kMainToChildSegueIdentifier sender:self];
    }
}

#pragma mark - UI Interaction

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ( [segue.identifier isEqualToString:kMainToChildSegueIdentifier]) {
        SPChildViewController *child = (SPChildViewController *)segue.destinationViewController;
        child.item = self.selectedItem;
    }
}

#pragma mark - utils

- (void)loadData {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"data.json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:dataPath];
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    if (error) {
        DDLogError(@"Error loading data: %@",error);
    }
    NSArray *jsonItems = json[@"items"];
    NSMutableArray *items = [NSMutableArray array];
    [self loadJsonItems:jsonItems intoArray:items];
    self.items = items;
}

- (void)loadJsonItems:(NSArray *)jsonItems intoArray:(NSMutableArray *)items {
    for (NSDictionary *jsonItem in jsonItems) {
        SPItem *item = [[SPItem alloc] init];
        item.name = jsonItem[@"name"];
        item.option = NO;
        if ([jsonItem[@"children"] isKindOfClass:[NSArray class]]) {
            [self loadJsonItems:jsonItem[@"children"] intoArray:item.children];
        }
        [items addObject:item];
    }
}

@end
