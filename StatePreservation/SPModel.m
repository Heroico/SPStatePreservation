//
//  SPModel.m
//  StatePreservation
//
//  Created by Alvaro Barbeira on 11/4/13.
//  Copyright (c) 2013 Zauber. All rights reserved.
//

#import "SPModel.h"
#import "SPItem.h"
#import "SPItem+Model.h"

@interface SPModel()
@property (nonatomic,strong) NSMutableArray *objects;
@end

@implementation SPModel

+ (SPModel *)sharedModel {
    static dispatch_once_t _singletonPredicate;
    static SPModel *_singleton = nil;
    
    dispatch_once(&_singletonPredicate, ^{
        _singleton = [[SPModel alloc] init];
        [_singleton dataWrangling];
    });
    
    return _singleton;
}

- (NSArray *)items {
    if (!self.objects.count) {
        [self loadData];
    }
    return self.objects;
}

- (void)saveChangesForItem:(SPItem *)item {
    // :/
    [self saveEverything];
}

#pragma mark - private methods

- (void)dataWrangling {
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *dataPath = [self jsonStorePath];
    if (![manager fileExistsAtPath:dataPath]) {
        NSString *defaultDataPath = [[NSBundle mainBundle] pathForResource:@"defaultData" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:defaultDataPath];
        NSError *error = nil;
        [data writeToFile:dataPath options:NSDataWritingAtomic error:&error];
        if (error) {
            DDLogError(@"Error writing file: %@", error);
        }
    }
}

- (void)loadData {
    NSString *dataPath = [self jsonStorePath];
    NSData *jsonData = [NSData dataWithContentsOfFile:dataPath];
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    if (error) {
        DDLogError(@"Error loading data: %@",error);
    }
    NSArray *jsonItems = json[@"items"];
    NSMutableArray *items = [NSMutableArray array];
    [self loadJsonItems:jsonItems intoArray:items];
    self.objects = items;
}

- (void)loadJsonItems:(NSArray *)jsonItems intoArray:(NSMutableArray *)items {
    for (NSDictionary *jsonItem in jsonItems) {
        SPItem *item = [[SPItem alloc] initWithModel:self];
        item.name = jsonItem[@"name"];
        item.option = [jsonItem[@"option"] boolValue];
        if ([jsonItem[@"children"] isKindOfClass:[NSArray class]]) {
            [self loadJsonItems:jsonItem[@"children"] intoArray:item.children];
        }
        [items addObject:item];
    }
}

- (NSString *)jsonStorePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"data.json"];
    return dataPath;
}

- (void)saveEverything {
    NSMutableArray *items = [NSMutableArray array];
    for (SPItem *item in self.objects) {
        [items addObject:[item toDict]];
    }
    NSDictionary *jsonObject = @{@"items": items};
    NSError *jsonError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonObject options:NSJSONWritingPrettyPrinted error:&jsonError];
    if (jsonError) {
        DDLogError(@"Error writing json data: %@",jsonError);
        return;
    }
    NSString *dataPath = [self jsonStorePath];
    NSError *fileError = nil;
    [jsonData writeToFile:dataPath options:NSDataWritingAtomic error:&fileError];
    if (fileError) {
        DDLogError(@"Error writing file");
    }
}

@end
