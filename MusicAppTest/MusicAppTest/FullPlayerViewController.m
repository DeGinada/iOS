//
//  FullPlayerViewController.m
//  MusicAppTest
//
//  Created by DeGi on 2017. 6. 14..
//  Copyright © 2017년 DeGi. All rights reserved.
//

#import "FullPlayerViewController.h"

@interface FullPlayerViewController () <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>

@property IBOutlet UITableView* tableView;
@property IBOutlet UIView* viewTableBG;

@end

@implementation FullPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.viewTableBG.layer.cornerRadius = 8;
    self.viewTableBG.clipsToBounds = YES;
    
    
    
    UIView* viewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, self.tableView.frame.size.height+86)];
    
    UIButton* btnClose = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 10)];
    [btnClose setTitle:@"close" forState:UIControlStateNormal];
    [btnClose setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnClose addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [viewHeader addSubview:btnClose];
    self.tableView.tableHeaderView = viewHeader;
    
    
//    UISwipeGestureRecognizer* swipeGesture;
//    swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gestureSwipped:)];
//    swipeGesture.delegate = self;
//    [self.viewTableBG addGestureRecognizer:swipeGesture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


//- (void) gestureSwipped:(UISwipeGestureRecognizer*)sender {
//    if (sender.direction == UISwipeGestureRecognizerDirectionDown) {
//        [self close];
//    }
//}

- (void) close {
    [self removeFromParentViewController];
}

#pragma mark - TABLE_VIEW


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    return cell;
}

@end
