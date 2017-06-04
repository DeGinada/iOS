//
//  AlbumDetailViewController.m
//  MusicAppTest
//
//  Created by Sora Yeo on 2017. 6. 4..
//  Copyright © 2017년 DeGi. All rights reserved.
//

#import "AlbumDetailViewController.h"


#define RED_COLOR       [UIColor colorWithRed:252.0/255.0 green:24.0/255.0 blue:88.0/255.0 alpha:1.0]

@interface AlbumDetailViewController () <UITableViewDelegate, UITableViewDataSource>

@property IBOutlet UITableView* tableView;

@end

@implementation AlbumDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    // 테이블뷰 headerview에 앨범 상세 내용 넣기
    [self setTableViewHeaderView];
    
    
    // 테이블뷰 footerview에 앨범 곡수 표기
    [self setTableViewFooterView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar.backItem setTitle:@"보관함"];
    self.navigationController.navigationBar.clipsToBounds = YES;
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTintColor:RED_COLOR];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



- (void) setTableViewHeaderView {
    
}



- (void) setTableViewFooterView {
    
}

#pragma mark - TABLE_VIEW


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.arAlbum items].count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    
    return cell;
}

@end
