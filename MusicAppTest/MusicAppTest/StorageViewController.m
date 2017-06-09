//
//  StorageViewController.m
//  MusicAppTest
//
//  Created by DeGi on 2017. 5. 18..
//  Copyright © 2017년 DeGi. All rights reserved.
//

#import "StorageViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "AlbumDetailViewController.h"
#import "CustomTabBarViewController.h"


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
    
    CALayer* layerTop = [CALayer layer];
    layerTop.frame = CGRectMake(20, 87.7, self.tableView.frame.size.width, 0.3);
    layerTop.backgroundColor = [UIColor lightGrayColor].CGColor;
    [viewHeader.layer addSublayer:layerTop];
    
    UILabel* lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(18, 20, self.tableView.frame.size.width-36, 68)];
    [lbTitle setText:@"보관함"];
    [lbTitle setFont:[UIFont boldSystemFontOfSize:34]];
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
//    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    
    [self setTableFooterView];
    
    
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


// [170602] album 상세 화면으로 간다
- (void) goAlbumDetail:(id)sender {
    
    MPMediaItemCollection* album = (MPMediaItemCollection*)[(UIButton*)sender imageForState:UIControlStateDisabled];
    
    AlbumDetailViewController* vcAlbumDetail = [self.storyboard instantiateViewControllerWithIdentifier:@"AlbumDetailvc"];
    vcAlbumDetail.arAlbum = album;
    [self.navigationController pushViewController:vcAlbumDetail animated:YES];
    
}


- (void) setTableFooterView {
    
    // 정보 가져오기
//    MPMediaQuery* queryAlbum = [MPMediaQuery albumsQuery];
    
    /*
    // [170601] 최근 추가된 순서대로 정렬 하고 싶었으나 에러!
    // Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: '-[MPMediaQuery sortedArrayUsingComparator:]: unrecognized selector sent to instance
    NSArray* arAlbums = [[MPMediaQuery albumsQuery] copy];
    NSArray* sortedAlbums;
    sortedAlbums = [arAlbums sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSDate* first = [(MPMediaEntity*)obj1 valueForProperty:MPMediaItemPropertyDateAdded];
        NSDate* second = [(MPMediaEntity*)obj2 valueForProperty:MPMediaItemPropertyDateAdded];
        NSTimeInterval firstTime = [first timeIntervalSince1970];
        NSTimeInterval secondTime = [second timeIntervalSince1970];
        
        if (firstTime > secondTime) {
            return NSOrderedAscending;
        } else if (firstTime < secondTime) {
            return NSOrderedDescending;
        } else {
            return NSOrderedSame;
        }
    }];
    */
    
    MPMediaQuery* queryAlbum = [MPMediaQuery albumsQuery];
    
    // ascending:NO -> 최신부터 과거순, YES -> 과거부터 최신순
    NSSortDescriptor* sorter = [NSSortDescriptor sortDescriptorWithKey:@"representativeItem" ascending:NO comparator:^NSComparisonResult(MPMediaEntity* obj1, MPMediaEntity* obj2) {
        NSDate* first = [obj1 valueForProperty:MPMediaItemPropertyDateAdded];
        NSDate* second = [obj2 valueForProperty:MPMediaItemPropertyDateAdded];
        NSString* strFirst = [NSString stringWithFormat:@"%f", [first timeIntervalSince1970]];
        NSString* strSecond = [NSString stringWithFormat:@"%f", [second timeIntervalSince1970]];
        
        return [strFirst localizedStandardCompare:strSecond];
    }];
    NSArray *allAlbums = [queryAlbum.collections sortedArrayUsingDescriptors:@[sorter]];
    
    
//    NSLog(@"%@", allAlbums);
    
    // 너무 많으니까 최근부터 20개만 보여주게  최상단 높이 65, 216 (158*158, 58)
    // footer view 높이 정해주기
    float fFooterHeight = 0.0;
    if (allAlbums.count > 20) {
        fFooterHeight = 65+(216*10);
    } else {
        long nHeight = ((allAlbums.count)+1)/2;
        fFooterHeight = 65+(216*nHeight);
    }
    
    
    // footerview 만들기
    UIView* viewFooter = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, fFooterHeight)];
    [viewFooter setBackgroundColor:[UIColor whiteColor]];
    
    CALayer* layerTop = [CALayer layer];
    layerTop.frame = CGRectMake(20, 0, self.tableView.frame.size.width, 0.3);
    layerTop.backgroundColor = [UIColor lightGrayColor].CGColor;
    [viewFooter.layer addSublayer:layerTop];
    
    
    // 타이틀
    UILabel* lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(18, 13, self.tableView.frame.size.width-36, 52)];
    [lbTitle setText:@"최근 추가된 항목"];
    [lbTitle setTextColor:[UIColor blackColor]];
    [lbTitle setFont:[UIFont boldSystemFontOfSize:18]];
    [viewFooter addSubview:lbTitle];
    
    
    // 버튼 정렬
    int nCount = 0;
    for (MPMediaItemCollection* item in allAlbums) {
        
        // MPMediaItemCollection 값에서 바로 정보 뽑으니 전부 nil. 대표되는 하나의 item정보로 출력?
        MPMediaItem* firstItem = [[item items] objectAtIndex:0];
        
        // nCount가 짝수면 left, 홀수면 right
        // nCount/2로 해서 나온 몫이 높이 카운트
        UIButton* btnAlbum = [[UIButton alloc] initWithFrame:CGRectMake(nCount%2 == 0 ? 20 : 197, 65+((nCount/2)*216), 158, 216)];
        [btnAlbum setImage:(UIImage*)item forState:UIControlStateDisabled];
        [btnAlbum addTarget:self action:@selector(goAlbumDetail:) forControlEvents:UIControlEventTouchUpInside];
        [viewFooter addSubview:btnAlbum];
        
        
        UIImageView* imgAlbum = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 158.0, 158.0)];
        [imgAlbum setBackgroundColor:[UIColor whiteColor]];
        imgAlbum.layer.cornerRadius = 4.0;
        imgAlbum.layer.borderWidth = 0.3;
        imgAlbum.layer.borderColor = [UIColor lightGrayColor].CGColor;
        imgAlbum.clipsToBounds = YES;
        [btnAlbum addSubview:imgAlbum];
        
        MPMediaItemArtwork* artwork = [firstItem valueForProperty:MPMediaItemPropertyArtwork];
        UIImage* image = [artwork imageWithSize:imgAlbum.frame.size];
        if (image) {
            [imgAlbum setImage:image];
        } else {
            [imgAlbum setImage:nil];
        }
        [imgAlbum setContentMode:UIViewContentModeScaleToFill];
        
        // 뮤직처럼 보이게 하기 위해서 앨범 이미지 비율에 따라 보여지는거 다르게 계산
        float ratio = image.size.height/image.size.width;
        if (ratio < 0.9) {
            [imgAlbum setFrame:CGRectMake(imgAlbum.frame.origin.x, 158.0*(1.0-ratio), imgAlbum.frame.size.width, 158.0*ratio)];
        } else if (ratio > 1.1) {
            ratio = image.size.width/image.size.height;
            [imgAlbum setFrame:CGRectMake((158.0-(158.0*ratio))/2.0, imgAlbum.frame.origin.y, 158.0*ratio, imgAlbum.frame.size.height)];
        }
        
        UILabel* lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 162, 158, 19)];
        [lbTitle setText:[firstItem valueForProperty:MPMediaItemPropertyAlbumTitle]];
        [lbTitle setTextColor:[UIColor blackColor]];
        [lbTitle setFont:[UIFont systemFontOfSize:14]];
        [lbTitle setTextAlignment:NSTextAlignmentLeft];
//        [lbTitle setLineBreakMode:NSLineBreakByCharWrapping];
        [btnAlbum addSubview:lbTitle];
        
        UILabel* lbArtist = [[UILabel alloc] initWithFrame:CGRectMake(0, 182, 158, 19)];
        [lbArtist setText:[firstItem valueForProperty:MPMediaItemPropertyArtist]];
        [lbArtist setTextColor:[UIColor lightGrayColor]];
        [lbArtist setFont:[UIFont systemFontOfSize:14]];
        [lbArtist setTextAlignment:NSTextAlignmentLeft];
//        [lbArtist setLineBreakMode:NSLineBreakByCharWrapping];
        [btnAlbum addSubview:lbArtist];
        
        
//        NSLog(@"%@ - %0.1f, %0.1f", lbTitle.text, image.size.width, image.size.height);
        
        nCount++;
        if (nCount >= 20) {
            break;
        }
    }
    
//    // 현재 재생 중인 곡이 있을 경우 view 높이를 더 높임
//    if (!((CustomTabBarViewController*)self.tabBarController).isHiddenPlayer) {
//        [viewFooter setFrame:CGRectMake(viewFooter.frame.origin.x, viewFooter.frame.origin.y, viewFooter.frame.size.width, viewFooter.frame.size.height+64)];
//    }
    
    self.tableView.tableFooterView = viewFooter;
    
    // 현재 재생 중인 곡이 있을 경우 tableview 크기 조정
    if (!((CustomTabBarViewController*)self.tabBarController).isHiddenPlayer) {
        [self.tableView setFrame:CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, self.tableView.frame.size.height-64)];
    }
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
    [cell.textLabel setFont:[UIFont systemFontOfSize:20]];
    [cell.textLabel setFrame:CGRectMake(20, cell.textLabel.frame.origin.y, cell.textLabel.frame.size.width, cell.textLabel.frame.size.height)];
    
    
    return cell;
    
}

@end
