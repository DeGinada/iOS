//
//  CustomTabBarViewController.m
//  MusicAppTest
//
//  Created by Sora Yeo on 2017. 6. 9..
//  Copyright © 2017년 DeGi. All rights reserved.
//

#import "CustomTabBarViewController.h"
#import <MediaPlayer/MediaPlayer.h>

#import "StorageViewController.h"
#import "AlbumDetailViewController.h"
#import "ResultViewController.h"

@interface CustomTabBarViewController ()

@property (nonatomic, readwrite) UIView* viewPlayer;


@end

@implementation CustomTabBarViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    // 재생 관련 값 가져오기
    if ( ([[MPMusicPlayerController systemMusicPlayer] playbackState] == MPMusicPlaybackStatePlaying) ||
        ([[MPMusicPlayerController systemMusicPlayer] playbackState] == MPMusicPlaybackStatePaused) ){
        self.isHiddenPlayer = NO;
        
        [self setMiniPlayer];
    } else {
        self.isHiddenPlayer = YES;
    }
    
    
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
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    [[MPMusicPlayerController systemMusicPlayer] endGeneratingPlaybackNotifications];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#define VIEW_TAG            1000
#define VIEWEFFECT_TAG      1001
#define IMG_ALBUM_TAG        1200
#define LB_TITLE_TAG         1201
#define BTN_PLAY_TAG         1300


//- (UIVisualEffectView*) setMiniPlayer {
- (void) setMiniPlayer {

    

//    self.viewPlayer = [[UIView alloc] initWithFrame:CGRectMake(0, self.tabBar.frame.origin.y-0.3-64, self.view.frame.size.width, 64)];
//    [self.viewPlayer setBackgroundColor:[UIColor clearColor]];
//    [self.view addSubview:self.viewPlayer];
//    [self.view bringSubviewToFront:self.viewPlayer];
    
    
    // visual effect view 밑에서 밝기 조정할 뷰
    UIView* viewTemp = [[UIView alloc] initWithFrame:CGRectMake(0, self.tabBar.frame.origin.y-64, self.view.frame.size.width, 64)];
    [viewTemp setBackgroundColor:[UIColor lightGrayColor]];
    viewTemp.alpha = 0.4;
    viewTemp.tag = VIEW_TAG;
    [self.view addSubview:viewTemp];
//    [self.view bringSubviewToFront:viewTemp];
    
    UIVisualEffectView* viewEffect = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
    viewEffect.frame = CGRectMake(0, self.tabBar.frame.origin.y-64, self.view.frame.size.width, 64);
    viewEffect.tag = VIEWEFFECT_TAG;
    [self.view addSubview:viewEffect];
    [self.view bringSubviewToFront:viewEffect];

    CALayer* layerBottom = [CALayer layer];
    layerBottom.frame = CGRectMake(0, 64-0.3, viewEffect.frame.size.width, 0.3);
    layerBottom.backgroundColor = [UIColor lightGrayColor].CGColor;
    [viewEffect.layer addSublayer:layerBottom];
    
    
    // 곡 정보 가져와서 보여주기
    MPMediaItem* nowItem = [[MPMusicPlayerController systemMusicPlayer] nowPlayingItem];
    
    UIImageView* imgAlbum = [[UIImageView alloc] initWithFrame:CGRectMake(20, 8, 48, 48)];
    [imgAlbum setBackgroundColor:[UIColor lightGrayColor]];
    [imgAlbum setAlpha:0.7];
    imgAlbum.layer.cornerRadius = 4;
    imgAlbum.clipsToBounds = YES;
    imgAlbum.tag = IMG_ALBUM_TAG;
    imgAlbum.contentMode = UIViewContentModeScaleAspectFit;
    [viewEffect addSubview:imgAlbum];
    
    MPMediaItemArtwork* artwork = [nowItem valueForProperty:MPMediaItemPropertyArtwork];
    UIImage* album = [artwork imageWithSize:imgAlbum.frame.size];
    if (album) {
        imgAlbum.image = album;
    } else {
        imgAlbum.image = nil;
    }
    
    UILabel* lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(20+48+17, 0, 185, 64)];
    [lbTitle setText:[nowItem valueForProperty:MPMediaItemPropertyTitle]];
    [lbTitle setFont:[UIFont systemFontOfSize:14]];
    [lbTitle setTextColor:[UIColor blackColor]];
    [lbTitle setTextAlignment:NSTextAlignmentLeft];
    lbTitle.tag = LB_TITLE_TAG;
    lbTitle.lineBreakMode = NSLineBreakByCharWrapping;
    lbTitle.numberOfLines = 1;
    [viewEffect addSubview:lbTitle];
    
    
    UIButton* btnPlay = [[UIButton alloc] initWithFrame:CGRectMake(viewEffect.frame.size.width-65-30, 17, 30, 30)];
    [btnPlay setImage:[UIImage imageNamed:@"btn_mini_play.png"] forState:UIControlStateNormal];
    [btnPlay setImage:[UIImage imageNamed:@"btn_mini_pause.png"] forState:UIControlStateSelected];
    [btnPlay addTarget:self action:@selector(changePlayState) forControlEvents:UIControlEventTouchUpInside];
    btnPlay.tag = BTN_PLAY_TAG;
    [viewEffect addSubview:btnPlay];
    if ([[MPMusicPlayerController systemMusicPlayer] playbackState] == MPMusicPlaybackStatePlaying) {
        btnPlay.selected = YES;
    } else {
        btnPlay.selected = NO;
    }
    
    UIButton* btnNext = [[UIButton alloc] initWithFrame:CGRectMake(viewEffect.frame.size.width-20-30, 17, 30, 30)];
    [btnNext setImage:[UIImage imageNamed:@"btn_mini_next.png"] forState:UIControlStateNormal];
    [btnNext addTarget:self action:@selector(playNextTrack) forControlEvents:UIControlEventTouchUpInside];
    [viewEffect addSubview:btnNext];

}

- (void) removeMiniPlayer {
    
    if ([self.view viewWithTag:VIEW_TAG]) {
        [[self.view viewWithTag:VIEW_TAG] removeFromSuperview];
    }
    
    if ([self.view viewWithTag:VIEWEFFECT_TAG]) {
        [[self.view viewWithTag:VIEWEFFECT_TAG] removeFromSuperview];
    }
}


- (void) changePlayState {
    
    if ([[MPMusicPlayerController systemMusicPlayer] playbackState] == MPMusicPlaybackStatePlaying) {
        [[MPMusicPlayerController systemMusicPlayer] pause];
    } else if ([[MPMusicPlayerController systemMusicPlayer] playbackState] == MPMusicPlaybackStatePaused) {
        [[MPMusicPlayerController systemMusicPlayer] play];
    }
}


- (void) playNextTrack {
    
}

// 재생 중인 곡이 바꼈을 경우,
- (void) handleNowPlayingItemChanged:(id)notification {
    
}


// 재생에 대한 상태가 바꼈을 경우,
- (void) handlePlayStateChanged:(id)notification {
    // 재생 관련 값 가져오기
    if ( ([[MPMusicPlayerController systemMusicPlayer] playbackState] == MPMusicPlaybackStatePlaying) ||
        ([[MPMusicPlayerController systemMusicPlayer] playbackState] == MPMusicPlaybackStatePaused) ){
        self.isHiddenPlayer = NO;
        
        if ([self.view viewWithTag:VIEWEFFECT_TAG]) {
            UIButton* btnPlay = [[self.view viewWithTag:VIEWEFFECT_TAG] viewWithTag:BTN_PLAY_TAG];
            
            if ([[MPMusicPlayerController systemMusicPlayer] playbackState] == MPMusicPlaybackStatePlaying) {
                btnPlay.selected = YES;
            } else if ([[MPMusicPlayerController systemMusicPlayer] playbackState] == MPMusicPlaybackStatePaused) {
                btnPlay.selected = NO;
            }
            
        } else {
            [self setMiniPlayer];
        }
    } else {
        self.isHiddenPlayer = YES;
        [self removeMiniPlayer];
    }
    
    // 현재 vc 가져오기
    UIViewController* presentVC = [self topMostViewController];
    
    if ([[presentVC class] isSubclassOfClass:[AlbumDetailViewController class]]) {
        [((AlbumDetailViewController*)presentVC) adjustTableView];
    } else if ([[presentVC class] isSubclassOfClass:[StorageViewController class]]) {
        [((StorageViewController*)presentVC) adjustTableView];
    } else if ([[presentVC class] isSubclassOfClass:[ResultViewController class]]) {
        [((ResultViewController*)presentVC) adjustTableView];
    }
}


- (UIViewController*)topMostViewController {
    UIViewController *topMostViewController = nil;
    
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        topMostViewController = navigationController.visibleViewController;
    } else if (rootViewController.presentedViewController) {
        topMostViewController = rootViewController.presentedViewController;
    } else if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController*)rootViewController;
        UIViewController* nextViewController = tabBarController.selectedViewController;
        
        if ([nextViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController* navigationController = (UINavigationController*)nextViewController;
            topMostViewController = navigationController.visibleViewController;
        } else if (nextViewController.presentedViewController) {
            topMostViewController = nextViewController.presentedViewController;
        }
    } else
        topMostViewController = rootViewController;
    
    return topMostViewController;
}

@end
