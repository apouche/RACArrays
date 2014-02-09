//
//  ViewController.m
//  RACArrays
//
//  Created by Johan on 2/9/14.
//  Copyright (c) 2014 Tutorial. All rights reserved.
//

// Frameworks
#import <ReactiveCocoa/ReactiveCocoa.h>

// Controllers
#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, strong) IBOutlet UISlider* slider;
@property (nonatomic, strong) IBOutlet UITableView* tableview;
@property (nonatomic, strong) NSMutableArray* mutableArray;

- (void)onSliderValueChanged:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.slider addTarget:self action:@selector(onSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.mutableArray = [[NSMutableArray alloc] initWithCapacity:10];
    
    RACSignal* signal = [self rac_valuesAndChangesForKeyPath:@keypath(self,mutableArray)
                                                     options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld
                                                    observer:self];
    
    [signal subscribeNext:^(RACTuple* tuple) {
        NSDictionary* changes = tuple.second;
        
        NSArray* oldArray = changes[NSKeyValueChangeOldKey];
        NSArray* newArray = changes[NSKeyValueChangeNewKey];
        
        [self.tableview beginUpdates];
        
        NSIndexPath* indexpath = nil;
        if (newArray.count > oldArray.count) {
            indexpath = [NSIndexPath indexPathForRow:newArray.count-1 inSection:0];
            [self.tableview insertRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        else if (newArray.count < oldArray.count) {
            indexpath = [NSIndexPath indexPathForRow:oldArray.count-1 inSection:0];
            [self.tableview deleteRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        
        [self.tableview endUpdates];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Events

- (void)onSliderValueChanged:(UISlider*)slider {
    NSInteger count = (NSInteger)floorf(slider.value*10.f);
    NSMutableArray* array = [NSMutableArray arrayWithArray:self.mutableArray];
    
    if (count > self.mutableArray.count) {
        [array addObject:[NSDate date]];
    }
    else if (count < self.mutableArray.count) {
        [array removeLastObject];
    }
    
    if (array.count != self.mutableArray.count)
        self.mutableArray = [NSMutableArray arrayWithArray:array];
}

#pragma mark - TableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([self class])];
    
    NSDate* date = self.mutableArray[indexPath.row];
    
    cell.textLabel.text = [date description];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.mutableArray.count;
}

@end
