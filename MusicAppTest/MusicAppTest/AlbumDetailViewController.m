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
    } else {
        [imgAlbum setImage:nil];
    }
    
    NSString* strTitle = [itemMedia valueForProperty:MPMediaItemPropertyAlbumTitle];
    UILabel* lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(178, 1, self.tableView.frame.size.width-178-20, [self getHeightAlbumTitle:strTitle])];
    [lbTitle setFont:[UIFont boldSystemFontOfSize:16.0]];
    [lbTitle setText:strTitle];
    [lbTitle setTextColor:[UIColor blackColor]];
    [lbTitle setTextAlignment:NSTextAlignmentLeft];
    [lbTitle setNumberOfLines:0];
    [viewHeader addSubview:lbTitle];
    
    
    self.tableView.tableHeaderView = viewHeader;
}


- (void) setTableViewFooterView {
    
    UIView* viewFooter = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, (49+64))];
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
    
    
    self.tableView.tableFooterView = viewFooter;
}


// string을 넘겨주면 album title창에 맞는 높이를 리턴해준다.
- (CGFloat) getHeightAlbumTitle:(NSString*)strTitle {
    
    CGFloat fWidht = self.tableView.frame.size.width-178-20;
    UILabel* lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(178, 0, fWidht, 100)];
    [lbTitle setFont:[UIFont boldSystemFontOfSize:16.0]];
    [lbTitle setText:strTitle];
    [lbTitle sizeToFit];
    
    CGFloat fHeight = lbTitle.frame.size.height;
    NSInteger nHeight = (lbTitle.frame.size.width/fWidht)+1;
    
    
//    NSLog(@"%f", fHeight*nHeight);
    return (fHeight*nHeight);
}

#pragma mark - TABLE_VIEW


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.arAlbum items].count+1;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    
    return cell;
}

@end
