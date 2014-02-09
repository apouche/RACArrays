//
//  ViewController.m
//  RACArrays
//
//  Created by Johan on 2/9/14.
//  Copyright (c) 2014 Tutorial. All rights reserved.
//

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
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Events

- (void)onSliderValueChanged:(UISlider*)slider {
    NSInteger count = (NSInteger)roundf(slider.value*10.f);
    if (count > self.mutableArray.count)
        [self.mutableArray addObject:[NSDate date]];
    else if (count < self.mutableArray.count)
        [self.mutableArray removeLastObject];
    
    [self.tableview reloadData];
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
