//
//  AlbumDetailViewController.m
//  MusicAppTest
//
//  Created by Sora Yeo on 2017. 6. 4..
//  Copyright © 2017년 DeGi. All rights reserved.
//

#import "AlbumDetailViewController.h"
#import "AlbumDetailTableViewCell.h"
#import "UILabel+Appearance.h"
#import "CustomTabBarViewController.h"


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
    
//    // viewController에서 view의 edge를 확장하지 마...
//    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
//        self.edgesForExtendedLayout = UIRectEdgeNone;
//    }
//    

    [self.navigationController.navigationBar.backItem setTitle:@"보관함"];
    [self.navigationController.navigationBar setFrame:CGRectMake(self.navigationController.navigationBar.frame.origin.x, self.navigationController.navigationBar.frame.origin.y-20, self.navigationController.navigationBar.frame.size.width, self.navigationController.navigationBar.frame.size.height+20)];
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
    
    UIView* viewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 156)];
    [viewHeader setBackgroundColor:[UIColor whiteColor]];
    
    MPMediaItem* itemMedia = [self.arAlbum.items objectAtIndex:0];
    
    UIImageView* imgAlbum = [[UIImageView alloc] initWithFrame:CGRectMake(20, 1, 140, 140)];
    [imgAlbum setBackgroundColor:[UIColor whiteColor]];
    imgAlbum.layer.cornerRadius = 4.0;
    imgAlbum.layer.borderWidth = 0.3;
    imgAlbum.layer.borderColor = [UIColor lightGrayColor].CGColor;
    imgAlbum.clipsToBounds = YES;
    [viewHeader addSubview:imgAlbum];
    
    MPMediaItemArtwork* artwork = [itemMedia valueForProperty:MPMediaItemPropertyArtwork];
    UIImage* image = [artwork imageWithSize:imgAlbum.frame.size];
    if (image) {
        [imgAlbum setImage:image];
        [imgAlbum setContentMode:UIViewContentModeScaleAspectFit];
    } else {
        [imgAlbum setImage:nil];
    }
    
    NSString* strTitle = [itemMedia valueForProperty:MPMediaItemPropertyAlbumTitle];
    UILabel* lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(178, 1, self.tableView.frame.size.width-178-20, [self getHeightLabelWithString:strTitle width:(self.tableView.frame.size.width-178-20) fontsize:16.0 bold:YES])];
    [lbTitle setFont:[UIFont boldSystemFontOfSize:16.0]];
    [lbTitle setText:strTitle];
    [lbTitle setTextColor:[UIColor blackColor]];
    [lbTitle setTextAlignment:NSTextAlignmentLeft];
    [lbTitle setNumberOfLines:0];
    [viewHeader addSubview:lbTitle];
    
    UILabel* lbArtist = [[UILabel alloc] initWithFrame:CGRectMake(178, lbTitle.frame.origin.y+lbTitle.frame.size.height, lbTitle.frame.size.width, 18)];
    [lbArtist setFont:[UIFont systemFontOfSize:16.0]];
    [lbArtist setText:[itemMedia valueForProperty:MPMediaItemPropertyArtist]];
    [lbArtist setTextColor:[UIColor lightGrayColor]];
    [lbArtist setTextAlignment:NSTextAlignmentLeft];
    [lbArtist sizeToFit];
    [lbArtist setFrame:CGRectMake(lbArtist.frame.origin.x, lbArtist.frame.origin.y+2, lbTitle.frame.size.width, lbArtist.frame.size.height)];
    [lbArtist setLineBreakMode:NSLineBreakByCharWrapping];
    [viewHeader addSubview:lbArtist];
    
    // 년도 표시(있을 경우에)
    NSNumber* year = [itemMedia valueForProperty:@"year"];
    if ([year intValue] > 0) {
        UILabel* lbYear = [[UILabel alloc] initWithFrame:CGRectMake(178, lbArtist.frame.origin.y+lbArtist.frame.size.height+2, lbTitle.frame.size.width, 18)];
        [lbYear setFont:[UIFont systemFontOfSize:16.0]];
        [lbYear setText:[NSString stringWithFormat:@"%d년", [year intValue]]];
        [lbYear setTextColor:[UIColor lightGrayColor]];
        [lbYear setTextAlignment:NSTextAlignmentLeft];
        [lbYear sizeToFit];
        [viewHeader addSubview:lbYear];
    }
    
    // 더보기 버튼
    UIButton* btnMore = [[UIButton alloc] initWithFrame:CGRectMake(326, 111, 30, 30)];
    [btnMore setImage:[UIImage imageNamed:@"btn_more.png"] forState:UIControlStateNormal];
    [btnMore addTarget:self action:@selector(showMoreInfomation) forControlEvents:UIControlEventTouchUpInside];
    [viewHeader addSubview:btnMore];
    
    CALayer* layerBottom = [CALayer layer];
    layerBottom.frame = CGRectMake(20, viewHeader.frame.size.height-0.3, self.tableView.frame.size.width, 0.3);
    layerBottom.backgroundColor = [UIColor lightGrayColor].CGColor;
    [viewHeader.layer addSublayer:layerBottom];
    
    self.tableView.tableHeaderView = viewHeader;
}


- (void) setTableViewFooterView {
    
    UIView* viewFooter = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, (49))];
    [viewFooter setBackgroundColor:[UIColor whiteColor]];
    
    UILabel* lbInfo = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.tableView.frame.size.width-40, 49)];
    [lbInfo setTextAlignment:NSTextAlignmentLeft];
    [lbInfo setFont:[UIFont systemFontOfSize:15]];
    [lbInfo setTextColor:[UIColor lightGrayColor]];
    [viewFooter addSubview:lbInfo];
    
    // 정보 가져오기
    NSInteger nCount = [self.arAlbum items].count;
    
    // 수록곡의 총 길이 가져오기
    CGFloat fSongLength = 0;
    for (MPMediaItem* item in [self.arAlbum items]) {
        
//        NSLog(@"%@ - %ld", [item valueForProperty:MPMediaItemPropertyTitle], [[item valueForProperty:MPMediaItemPropertyPlaybackDuration] integerValue]);
        // MPMediaItem의 곡 길이 가져오는 property -> MPMediaItemPropertyPlaybackDuration
        fSongLength = fSongLength + [[item valueForProperty:MPMediaItemPropertyPlaybackDuration] floatValue];
    }
    // 무조건 올림 처리 ceil() 이용. 내림은 floor() -> 그냥 반올림으로 바꿈
    NSInteger nAllSongLen = ceil(fSongLength/60.0);
    if (nAllSongLen > 60) {
        // 시간 단위로 넘어 갈경우, 시간으로 표시
        NSInteger nHour = nAllSongLen/60;
        [lbInfo setText:[NSString stringWithFormat:@"%ld곡, %ld시간 %ld분", nCount, nHour, nAllSongLen-(nHour*60)]];
    } else {
        [lbInfo setText:[NSString stringWithFormat:@"%ld곡, %ld분", nCount, nAllSongLen]];
    }
    
    CALayer* layerTop = [CALayer layer];
    layerTop.frame = CGRectMake(50, 0, self.tableView.frame.size.width, 0.3);
    layerTop.backgroundColor = [UIColor lightGrayColor].CGColor;
    [viewFooter.layer addSublayer:layerTop];
    
    
//    // 현재 재생 중인 곡이 있을 경우 view 높이를 더 높임
//    if (!((CustomTabBarViewController*)self.tabBarController).isHiddenPlayer) {
//        [viewFooter setFrame:CGRectMake(viewFooter.frame.origin.x, viewFooter.frame.origin.y, viewFooter.frame.size.width, viewFooter.frame.size.height+64)];
//    }
    
    self.tableView.tableFooterView = viewFooter;
    
    // 현재 재생 중인 곡이 있을 경우 tableview 크기 조정
    [self adjustTableView];
//    if (!((CustomTabBarViewController*)self.tabBarController).isHiddenPlayer) {
////        [self.tableView setFrame:CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, self.tableView.frame.size.height-64)];
//        
//        viewFooter.frame = CGRectMake(viewFooter.frame.origin.x, viewFooter.frame.origin.y, viewFooter.frame.size.width, viewFooter.frame.size.height+64);
//        self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 64, 0);
//        
////        // visual effect view 밑에서 밝기 조정할 뷰
////        UIView* viewTemp = [[UIView alloc] initWithFrame:CGRectMake(0, self.tabBarController.tabBar.frame.origin.y-64, self.view.frame.size.width, 64)];
////        [viewTemp setBackgroundColor:[UIColor lightGrayColor]];
////        viewTemp.alpha = 0.7;
////        [self.view addSubview:viewTemp];
////        [self.view bringSubviewToFront:viewTemp];
//    }
    
    
}


- (void) adjustTableView {
    if (!((CustomTabBarViewController*)self.tabBarController).isHiddenPlayer) {
        [self.tableView.tableFooterView setFrame:CGRectMake(self.tableView.tableFooterView.frame.origin.x, self.tableView.tableFooterView.frame.origin.y, self.tableView.tableFooterView.frame.size.width, self.tableView.tableFooterView.frame.size.height + 64)];
        self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 64, 0);
    } else {
        if (self.tableView.scrollIndicatorInsets.bottom == 64) {
            self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0);
            [self.tableView.tableFooterView setFrame:CGRectMake(self.tableView.tableFooterView.frame.origin.x, self.tableView.tableFooterView.frame.origin.y, self.tableView.tableFooterView.frame.size.width, self.tableView.tableFooterView.frame.size.height - 64)];
        }
    }
}


// string을 넘겨주면 album title창에 맞는 높이를 리턴해준다.
- (CGFloat) getHeightLabelWithString:(NSString*)strTitle width:(CGFloat)width fontsize:(CGFloat)fontsize bold:(BOOL)bold {
    
//    CGFloat fWidht = self.tableView.frame.size.width-178-20;
    UILabel* lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 100)];
    if (bold) {
        [lbTitle setFont:[UIFont boldSystemFontOfSize:fontsize]];
    } else {
        [lbTitle setFont:[UIFont systemFontOfSize:fontsize]];
    }
    [lbTitle setText:strTitle];
    [lbTitle sizeToFit];
    
    CGFloat fHeight = lbTitle.frame.size.height;
    NSInteger nHeight = (lbTitle.frame.size.width/width)+1;
    
    
//    NSLog(@"%f", fHeight*nHeight);
    return (fHeight*nHeight);
}


// 각 앨범정보에 대한 더보기 버튼
- (void) showMoreInfomation {
    
    // alert
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    UIView* viewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 355, 122)];
    [viewHeader setBackgroundColor:[UIColor clearColor]];
    [alertController.view addSubview:viewHeader];
    
    MPMediaItem* itemMedia = [self.arAlbum.items objectAtIndex:0];
    
    // 15, 74, 74
    UIImageView* imgAlbum = [[UIImageView alloc] initWithFrame:CGRectMake(16, 16, 90, 90)];
    imgAlbum.layer.cornerRadius = 4.0;
    imgAlbum.clipsToBounds = YES;
    [imgAlbum setBackgroundColor:[UIColor clearColor]];
    [viewHeader addSubview:imgAlbum];
    
    MPMediaItemArtwork* artwork = [itemMedia valueForProperty:MPMediaItemPropertyArtwork];
    UIImage* image = [artwork imageWithSize:imgAlbum.frame.size];
    if (image) {
        [imgAlbum setImage:image];
    } else {
        [imgAlbum setImage:nil];
    }
    [imgAlbum setContentMode:UIViewContentModeScaleAspectFit];
    
    NSString* strAlbum = [itemMedia valueForProperty:MPMediaItemPropertyAlbumTitle];
    UILabel* lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(16+15+90, 15, 355-32-15-90, [self getHeightLabelWithString:strAlbum width:(355-32-15-90) fontsize:15.0 bold:YES])];
    [lbTitle setText:strAlbum];
    [lbTitle setFont:[UIFont boldSystemFontOfSize:15.0]];
    [lbTitle setTextColor:[UIColor blackColor]];
    lbTitle.numberOfLines = 2;
    [viewHeader addSubview:lbTitle];
    
    UILabel* lbArtist = [[UILabel alloc] initWithFrame:CGRectMake(16+15+90, 15, 355-32-15-90, 20)];
    [lbArtist setText:[itemMedia valueForProperty:MPMediaItemPropertyArtist]];
    [lbArtist setFont:[UIFont systemFontOfSize:15.0]];
    [lbArtist setTextColor:[UIColor blackColor]];
    [lbArtist setTextAlignment:NSTextAlignmentLeft];
    [lbArtist sizeToFit];
    [viewHeader addSubview:lbArtist];
    
    // 년도 표시(있을 경우에)
    NSNumber* year = [itemMedia valueForProperty:@"year"];
    if ([year intValue] > 0) {
        UILabel* lbYear = [[UILabel alloc] initWithFrame:CGRectMake(16+15+90, 15, 355-32-15-90, 20)];
        [lbYear setFont:[UIFont systemFontOfSize:15.0]];
        [lbYear setText:[NSString stringWithFormat:@"%d년", [year intValue]]];
        [lbYear setTextColor:[UIColor lightGrayColor]];
        [lbYear setTextAlignment:NSTextAlignmentLeft];
        [lbYear sizeToFit];
        [viewHeader addSubview:lbYear];
        
        
        // vertical center로 정렬
        float fHeight = lbTitle.frame.size.height + lbArtist.frame.size.height + lbYear.frame.size.height + 4;
        [lbTitle setFrame:CGRectMake(lbTitle.frame.origin.x, (viewHeader.frame.size.height-fHeight)/2, lbTitle.frame.size.width, lbTitle.frame.size.height)];
        // sizetofit 영향으로 label width 크기 길어졌을 경우 대비하여 title width로 지정
        [lbArtist setFrame:CGRectMake(lbArtist.frame.origin.x, lbTitle.frame.origin.y+lbTitle.frame.size.height+2, lbTitle.frame.size.width, lbArtist.frame.size.height)];
        [lbYear setFrame:CGRectMake(lbYear.frame.origin.x, lbArtist.frame.origin.y+lbArtist.frame.size.height+2, lbTitle.frame.size.width, lbYear.frame.size.height)];
    } else {
        // vertical center로 정렬
        float fHeight = lbTitle.frame.size.height + lbArtist.frame.size.height + 2;
        [lbTitle setFrame:CGRectMake(lbTitle.frame.origin.x, (viewHeader.frame.size.height-fHeight)/2, lbTitle.frame.size.width, lbTitle.frame.size.height)];
        // sizetofit 영향으로 label width 크기 길어졌을 경우 대비하여 title width로 지정
        [lbArtist setFrame:CGRectMake(lbArtist.frame.origin.x, lbTitle.frame.origin.y+lbTitle.frame.size.height+2, lbTitle.frame.size.width, lbArtist.frame.size.height)];
    }
    
    UIAlertAction* actionCancel = [UIAlertAction actionWithTitle:@"취소" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        // action sheet를 닫음
    }];
    
    UIAlertAction* actionDownload = [UIAlertAction actionWithTitle:@"다운로드" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 해당 앨범을 오프라인에서 들을 수 있게 다운로드 -> 다운로드 하면 제거로 바뀌고, 보관함에서 삭제가 사라짐
        // 제거로 바꼈을때 -> 다운로드 삭제, 보괌함에서 삭제로 나뉨
    }];
    
    UIAlertAction* actionRemove = [UIAlertAction actionWithTitle:@"보관함에서 삭제" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 해당 앨범을 삭제
    }];
    
    UIAlertAction* actionAddPlaylist = [UIAlertAction actionWithTitle:@"재생목록에 추가..." style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 해당 앨범을 플레이리스트에 추가 -> 최근 재생목록, 새로운 재생목록, 기존 재생목록 중 선택 가능
    }];
    
    UIAlertAction* actionPlayNext = [UIAlertAction actionWithTitle:@"다음 재생" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 해당 앨범을 현재 재생중인 곡 바로 뒤에 넣음
    }];
    
    UIAlertAction* actionPlayLast = [UIAlertAction actionWithTitle:@"나중에 재생" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 해당 앨범을 현재 재생중인 리스트 제일 아래에 넣음
        
    }];
    
    [actionCancel setValue:RED_COLOR forKey:@"titleTextColor"];
    [actionDownload setValue:RED_COLOR forKey:@"titleTextColor"];
    [actionRemove setValue:RED_COLOR forKey:@"titleTextColor"];
    [actionAddPlaylist setValue:RED_COLOR forKey:@"titleTextColor"];
    [actionPlayNext setValue:RED_COLOR forKey:@"titleTextColor"];
    [actionPlayLast setValue:RED_COLOR forKey:@"titleTextColor"];
    
    // 이미지 넣기
    [actionDownload setValue:[[UIImage imageNamed:@"btn_download.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];
    [actionRemove setValue:[[UIImage imageNamed:@"btn_remove.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];
    [actionAddPlaylist setValue:[[UIImage imageNamed:@"btn_addplaylist.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];
    [actionPlayNext setValue:[[UIImage imageNamed:@"btn_playnext.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];
    [actionPlayLast setValue:[[UIImage imageNamed:@"btn_playlast.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];
    
    [alertController addAction:actionDownload];
    [alertController addAction:actionRemove];
    [alertController addAction:actionAddPlaylist];
    [alertController addAction:actionPlayNext];
    [alertController addAction:actionPlayLast];
    [alertController addAction:actionCancel];
    
    /*
    // action에 title을 정렬시키고 싶은데 안됨..
    UILabel* lbDownload = [UILabel appearanceWhenContainedInInstancesOfClasses:@[[UIAlertController class]]];
    [lbDownload setAppearanceAlignment:NSTextAlignmentLeft];
     */
    
    
//    UIButton* lbDownload = [UIButton appearanceWhenContainedInInstancesOfClasses:@[[UIAlertController class]]];
//    [lbDownload.titleLabel setTextAlignment:NSTextAlignmentLeft];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - TABLE_VIEW


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.arAlbum items].count+1;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AlbumDetailTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (cell == nil) {
        cell = [[AlbumDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    
    if (indexPath.row == 0) {
        // 전체 재생 뛰울 위치
        [cell.imgShuffle setHidden:NO];
        [cell.lbNumber setHidden:YES];
        cell.lbTitle.text = @"전체 임의 재생";
    } else {
        
        MPMediaItem* mediaItem = [self.arAlbum.items objectAtIndex:(indexPath.row-1)];
        [cell.imgShuffle setHidden:YES];
        [cell.lbNumber setHidden:NO];
        cell.lbTitle.text = [mediaItem valueForProperty:MPMediaItemPropertyTitle];
        cell.lbNumber.text = [NSString stringWithFormat:@"%ld", indexPath.row];
        [cell.lbNumber setTextAlignment:NSTextAlignmentCenter];
//        [cell.lbNumber sizeToFit];
    }
    
    
    return cell;
}

@end
