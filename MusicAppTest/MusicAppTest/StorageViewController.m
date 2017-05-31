//
//  StorageViewController.m
//  MusicAppTest
//
//  Created by DeGi on 2017. 5. 18..
//  Copyright © 2017년 DeGi. All rights reserved.
//

#import "StorageViewController.h"
#import <MediaPlayer/MediaPlayer.h>


#define RED_COLOR       [UIColor colorWithRed:252.0/255.0 green:24.0/255.0 blue:88.0/255.0 alpha:1.0]


@interface StorageViewController ()

@property IBOutlet UITableView* tableView;
@property (nonatomic, readwrite) NSMutableArray* arListTitle;

@end

@implementation StorageViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 보관함 리스트 가져오기
    self.arListTitle = [[[NSUserDefaults standardUserDefaults] objectForKey:@"ListTitle"] mutableCopy];
    if (!self.arListTitle) {
        self.arListTitle = [[NSMutableArray alloc] initWithObjects:@"재생목록", @"아티스트", @"앨범", @"노래", @"다운로드한 음악", nil];
        [[NSUserDefaults standardUserDefaults] setObject:self.arListTitle forKey:@"ListTitle"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    
    // [170531] section으로 적용했던 view header view로 옮기기
    UIView* viewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 88)];
    [viewHeader setBackgroundColor:[UIColor whiteColor]];
    
    UILabel* lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, self.tableView.frame.size.width-30, 68)];
    [lbTitle setText:@"보관함"];
    [lbTitle setFont:[UIFont boldSystemFontOfSize:32]];
    [lbTitle setTextColor:[UIColor blackColor]];
    [lbTitle setTextAlignment:NSTextAlignmentLeft];
    [viewHeader addSubview:lbTitle];
    
    
    UIButton* btnEdit = [[UIButton alloc] initWithFrame:CGRectMake(self.tableView.frame.size.width-68, 34, 68, 54)];
    [btnEdit setTitleColor:RED_COLOR forState:UIControlStateNormal];
    [btnEdit setTitle:@"편집" forState:UIControlStateNormal];
    [btnEdit.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [btnEdit addTarget:self action:@selector(changeStorageList) forControlEvents:UIControlEventTouchUpInside];
    [viewHeader addSubview:btnEdit];
    
    self.tableView.tableHeaderView = viewHeader;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    
    
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


// [170531] 보관함 리스트 값 변경하기
- (void) changeStorageList {
    
}


#pragma mark - TABLE_VIEW

/*
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return  88;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    // [170531] 이걸 section에 넣는게 맞나? 왠지 테이블 뷰에 해얄것 같은 느낌 -> 나중에 보고 수정
    UIView* viewSection = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 88)];
    [viewSection setBackgroundColor:[UIColor whiteColor]];
    
    UILabel* lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, tableView.frame.size.width-30, 68)];
    [lbTitle setText:@"보관함"];
    [lbTitle setFont:[UIFont boldSystemFontOfSize:32]];
    [lbTitle setTextColor:[UIColor blackColor]];
    [lbTitle setTextAlignment:NSTextAlignmentLeft];
    [viewSection addSubview:lbTitle];
    
    
    UIButton* btnEdit = [[UIButton alloc] initWithFrame:CGRectMake(tableView.frame.size.width-68, 34, 68, 54)];
    [btnEdit setTitleColor:RED_COLOR forState:UIControlStateNormal];
    [btnEdit setTitle:@"편집" forState:UIControlStateNormal];
    [btnEdit.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [btnEdit addTarget:self action:@selector(changeStorageList) forControlEvents:UIControlEventTouchUpInside];
    [viewSection addSubview:btnEdit];
    
    return viewSection;
}

*/


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 
    return self.arListTitle.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    [cell.textLabel setText:[self.arListTitle objectAtIndex:indexPath.row]];
    [cell.textLabel setTextColor:RED_COLOR];
    [cell.textLabel setFont:[UIFont systemFontOfSize:18]];
    
    
    return cell;
    
}

@end
