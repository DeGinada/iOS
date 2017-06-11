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

}

- (void) removeMiniPlayer {
    
    if ([self.view viewWithTag:VIEW_TAG]) {
        [[self.view viewWithTag:VIEW_TAG] removeFromSuperview];
    }
    
    if ([self.view viewWithTag:VIEWEFFECT_TAG]) {
        [[self.view viewWithTag:VIEWEFFECT_TAG] removeFromSuperview];
    }
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
        [self setMiniPlayer];
    } else {
        self.isHiddenPlayer = YES;
        [self removeMiniPlayer];
    }
    
    UIViewController* presentVC = [self topMostViewController];
    
    if ([[presentVC class] isSubclassOfClass:[AlbumDetailViewController class]]) {
        [((AlbumDetailViewController*)presentVC) adjustTableView];
    } else if ([[presentVC class] isSubclassOfClass:[StorageViewController class]]) {
        [((StorageViewController*)presentVC) adjustTableView];
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
