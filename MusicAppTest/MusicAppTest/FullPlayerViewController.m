//
//  FullPlayerViewController.m
//  MusicAppTest
//
//  Created by DeGi on 2017. 6. 14..
//  Copyright © 2017년 DeGi. All rights reserved.
//

#import "FullPlayerViewController.h"
#import "CustomTabBarViewController.h"
#import <MediaPlayer/MediaPlayer.h>

#define RED_COLOR       [UIColor colorWithRed:252.0/255.0 green:24.0/255.0 blue:88.0/255.0 alpha:1.0]
#define BTN_PLAY_TAG    1500
#define IMG_ALBUM_TAG           1550
#define LB_TITLE_TAG            1551
#define LB_ARTIST_TAG           1552


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
    
    
    // 재생이 되거나 곡이 넘어가는 경우등에 대한 스케쥴러
    NSNotificationCenter* notificationCenter = [NSNotificationCenter defaultCenter];
    
    // 재생되는 아이템이 변경되는 경우의 옵저버
    [notificationCenter addObserver:self
                           selector:@selector(handleNowPlayingItemChanged:)
                               name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification
                             object:[MPMusicPlayerController systemMusicPlayer]];
    
    // 재생상태가 변경되는 경우의 옵저버
    [notificationCenter addObserver:self
                           selector:@selector(handlePlayStateChanged:)
                               name:MPMusicPlayerControllerPlaybackStateDidChangeNotification
                             object:[MPMusicPlayerController systemMusicPlayer]];
    
    [[MPMusicPlayerController systemMusicPlayer] beginGeneratingPlaybackNotifications];
    
    
    MPMediaItem* nowItem = [[MPMusicPlayerController systemMusicPlayer] nowPlayingItem];
    
    
    UIView* viewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, self.tableView.frame.size.height+86)];
    
    UIButton* btnClose = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 32)];
    [btnClose setImage:[UIImage imageNamed:@"btn_full_close.png"] forState:UIControlStateNormal];
    [btnClose addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [viewHeader addSubview:btnClose];

    // tableview header에 정보 띄우기
    // 앨범이미지
    UIImageView* imgAlbum = [[UIImageView alloc] initWithFrame:CGRectMake(32, 32, 311, 311)];
    imgAlbum.layer.cornerRadius = 8;
    imgAlbum.clipsToBounds = YES;
    imgAlbum.tag = IMG_ALBUM_TAG;
    [viewHeader addSubview:imgAlbum];
    
    MPMediaItemArtwork* artwork = [nowItem valueForProperty:MPMediaItemPropertyArtwork];
    UIImage* image = [artwork imageWithSize:imgAlbum.frame.size];
    if (image) {
        [imgAlbum setImage:image];
        [imgAlbum setBackgroundColor:[UIColor clearColor]];
        
        if (image.size.width > image.size.height) {
            CGFloat rate = image.size.height/image.size.width;
            [imgAlbum setFrame:CGRectMake(32, 32+((1.0-rate)*311.0)/2, 311.0, 311.0*rate)];
        } else if (image.size.width < image.size.height) {
            CGFloat rate = image.size.width/image.size.height;
            [imgAlbum setFrame:CGRectMake(32+((1.0-rate)*311.0)/2, 32, 311.0*rate, 311.0)];
        }
    } else {
        [imgAlbum setImage:nil];
        [imgAlbum setBackgroundColor:[UIColor lightGrayColor]];
    }
    
    
    // 타이틀
    UILabel* lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 398, viewHeader.frame.size.width, 24)];
    [lbTitle setText:[nowItem valueForProperty:MPMediaItemPropertyTitle]];
    [lbTitle setTextColor:[UIColor blackColor]];
    [lbTitle setFont:[UIFont systemFontOfSize:20]];
    [lbTitle setTextAlignment:NSTextAlignmentCenter];
    lbTitle.tag = LB_TITLE_TAG;
    [viewHeader addSubview:lbTitle];
    
    
    // 가수
    UILabel* lbArtist = [[UILabel alloc] initWithFrame:CGRectMake(0, 426, viewHeader.frame.size.width, 24)];
    [lbArtist setText:[nowItem valueForProperty:MPMediaItemPropertyArtist]];
    [lbArtist setTextColor:RED_COLOR];
    [lbArtist setFont:[UIFont systemFontOfSize:20]];
    [lbArtist setTextAlignment:NSTextAlignmentCenter];
    lbArtist.tag = LB_ARTIST_TAG;
    [viewHeader addSubview:lbArtist];
    
    
    // 버튼
    UIButton* btnPrev = [[UIButton alloc] initWithFrame:CGRectMake(70, 485, 37, 37)];
    [btnPrev setImage:[UIImage imageNamed:@"btn_full_prev.png"] forState:UIControlStateNormal];
    [btnPrev addTarget:self action:@selector(goPrevTrack) forControlEvents:UIControlEventTouchUpInside];
    [viewHeader addSubview:btnPrev];
    

    UIButton* btnPlay = [[UIButton alloc] initWithFrame:CGRectMake(70+62+37, 485, 37, 37)];
    [btnPlay setImage:[UIImage imageNamed:@"btn_full_play.png"] forState:UIControlStateNormal];
    [btnPlay setImage:[UIImage imageNamed:@"btn_full_pause.png"] forState:UIControlStateSelected];
    [btnPlay addTarget:self action:@selector(changePlayState) forControlEvents:UIControlEventTouchUpInside];
    btnPlay.tag = BTN_PLAY_TAG;
    [viewHeader addSubview:btnPlay];
    
    if ([[MPMusicPlayerController systemMusicPlayer] playbackState] == MPMusicPlaybackStatePlaying) {
        btnPlay.selected = YES;
    } else {
        btnPlay.selected = NO;
    }
    
    
    UIButton* btnNext = [[UIButton alloc] initWithFrame:CGRectMake(70+124+74, 485, 37, 37)];
    [btnNext setImage:[UIImage imageNamed:@"btn_full_next.png"] forState:UIControlStateNormal];
    [btnNext addTarget:self action:@selector(goNextTrack) forControlEvents:UIControlEventTouchUpInside];
    [viewHeader addSubview:btnNext];
    
    
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
    
    // 옵저버 지우기
    [[MPMusicPlayerController systemMusicPlayer] endGeneratingPlaybackNotifications];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    [((CustomTabBarViewController*)rootViewController) closeBackground];
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


- (void) goPrevTrack {
    if ([[MPMusicPlayerController systemMusicPlayer] currentPlaybackTime] > 3.0f) {
        [[MPMusicPlayerController systemMusicPlayer] skipToBeginning];
    } else {
        [[MPMusicPlayerController systemMusicPlayer] skipToPreviousItem];
    }
 
}


- (void) goNextTrack {
    [[MPMusicPlayerController systemMusicPlayer] skipToNextItem];
}


- (void) changePlayState {
    if ([[MPMusicPlayerController systemMusicPlayer] playbackState] == MPMusicPlaybackStatePlaying) {
        [[MPMusicPlayerController systemMusicPlayer] pause];
    } else if ([[MPMusicPlayerController systemMusicPlayer] playbackState] == MPMusicPlaybackStatePaused) {
        [[MPMusicPlayerController systemMusicPlayer] play];
    }
}


// 재생 중인 곡이 바꼈을 경우,
- (void) handleNowPlayingItemChanged:(id)notification {
    
    // skip next처리된 후 바뀐 아이템을 가져옴
    MPMediaItem* nowItem = [[MPMusicPlayerController systemMusicPlayer] nowPlayingItem];
        
}


// 재생에 대한 상태가 바꼈을 경우,
- (void) handlePlayStateChanged:(id)notification {
    // 재생 관련 값 가져오기
    UIView* viewHeader = self.tableView.tableHeaderView;
    UIButton* btnPlay = [viewHeader viewWithTag:BTN_PLAY_TAG];
    
    if ([[MPMusicPlayerController systemMusicPlayer] playbackState] == MPMusicPlaybackStatePlaying) {
        btnPlay.selected = YES;
    } else if ([[MPMusicPlayerController systemMusicPlayer] playbackState] == MPMusicPlaybackStatePaused) {
        btnPlay.selected = NO;
    }
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
