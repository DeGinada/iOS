//
//  StorageViewController.m
//  MusicAppTest
//
//  Created by DeGi on 2017. 5. 18..
//  Copyright © 2017년 DeGi. All rights reserved.
//

#import "StorageViewController.h"

@interface StorageViewController ()

@property IBOutlet UITableView* tableView;

@end

@implementation StorageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    // [170518] 네비아이템 안 보이게 세팅
    [self.navigationController setNavigationBarHidden:YES];
    
    // viewController에서 view의 edge를 확장하지 마...
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}


- (void) viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
}



#pragma mark - TABLE_VIEW


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return  88;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView* viewSection = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 88)];
    [viewSection setBackgroundColor:[UIColor whiteColor]];
    
    UILabel* lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, tableView.frame.size.width-30, 68)];
    [lbTitle setText:@"보관함"];
    [lbTitle setFont:[UIFont boldSystemFontOfSize:32]];
    [lbTitle setTextColor:[UIColor blackColor]];
    [lbTitle setTextAlignment:NSTextAlignmentLeft];
    [viewSection addSubview:lbTitle];
    
    // 68
    
    return viewSection;
}


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
