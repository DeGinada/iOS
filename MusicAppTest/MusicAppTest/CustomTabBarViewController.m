//
//  CustomTabBarViewController.m
//  MusicAppTest
//
//  Created by DeGi on 2017. 6. 9..
//  Copyright © 2017년 DeGi. All rights reserved.
//

#import "CustomTabBarViewController.h"
#import <MediaPlayer/MediaPlayer.h>

#import "StorageViewController.h"
#import "AlbumDetailViewController.h"
#import "ResultViewController.h"
#import "FullPlayerViewController.h"

#import <QuartzCore/QuartzCore.h>

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
#define VIEW_BG_TAG         1400


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
    
    
    // full player로 연결되는 버튼
    UIButton* btnFull = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, viewEffect.frame.size.width, 64)];
    [btnFull setBackgroundColor:[UIColor clearColor]];
    [btnFull addTarget:self action:@selector(goFullPlayer) forControlEvents:UIControlEventTouchUpInside];
    [viewEffect addSubview:btnFull];
    
    
    // 곡 정보 가져와서 보여주기
    MPMediaItem* nowItem = [[MPMusicPlayerController systemMusicPlayer] nowPlayingItem];
    
    UIImageView* imgAlbum = [[UIImageView alloc] initWithFrame:CGRectMake(20, 8, 48, 48)];
//    [imgAlbum setBackgroundColor:[UIColor lightGrayColor]];
//    [imgAlbum setAlpha:0.7];
    imgAlbum.layer.cornerRadius = 4;
//    UIBezierPath* shadowPath = [UIBezierPath bezierPathWithRect:imgAlbum.bounds];
//    [imgAlbum.layer setMasksToBounds:NO];
//    imgAlbum.layer.shadowRadius = 3.5;
//    imgAlbum.layer.shadowColor = [UIColor redColor].CGColor;
//    imgAlbum.layer.shadowOffset = CGSizeMake(0, 3);
//    imgAlbum.layer.shadowOpacity = 1.0;
//    [imgAlbum.layer setShadowPath:shadowPath.CGPath];
    imgAlbum.clipsToBounds = YES;
    imgAlbum.tag = IMG_ALBUM_TAG;
    imgAlbum.contentMode = UIViewContentModeScaleAspectFit;
    [viewEffect addSubview:imgAlbum];
    
//    // layer에 shadow 넣기
//    CAShapeLayer* shadow = [CAShapeLayer layer];
//    shadow.frame = imgAlbum.frame;
//    shadow.path = CFBridgingRetain([UIBezierPath bezierPathWithRoundedRect:imgAlbum.bounds cornerRadius:4]);
//    shadow.shadowOpacity = 1.0;
//    shadow.shadowRadius = 10;
//    shadow.shadowColor = [UIColor blackColor].CGColor;
//    shadow.masksToBounds = NO;
//    shadow.shadowOffset = CGSizeMake(0, 4);
////    shadow.shouldRasterize = YES;
//    [imgAlbum.layer addSublayer:shadow];
    
    
    MPMediaItemArtwork* artwork = [nowItem valueForProperty:MPMediaItemPropertyArtwork];
    UIImage* album = [artwork imageWithSize:imgAlbum.frame.size];
    NSLog(@"image size - %0.1f, %0.1f", album.size.width, album.size.height);
    if (album) {
        imgAlbum.image = album;
        [imgAlbum setBackgroundColor:[UIColor clearColor]];
        
        if (album.size.width < album.size.height) {
            CGFloat rate = album.size.width/album.size.height;
            [imgAlbum setFrame:CGRectMake(20+((1.0-rate)*48)/2, 8, 48.0*rate, 48)];
        } else if (album.size.width > album.size.height) {
            CGFloat rate = album.size.height/album.size.width;
            [imgAlbum setFrame:CGRectMake(20, 8+((1.0-rate)*48)/2, 48, 48.0*rate)];
        }
    } else {
        imgAlbum.image = nil;
        [imgAlbum setBackgroundColor:[UIColor lightGrayColor]];
    }
    
    UILabel* lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(20+48+17, 0, 185, 64)];
    [lbTitle setText:[nowItem valueForProperty:MPMediaItemPropertyTitle]];
    [lbTitle setFont:[UIFont systemFontOfSize:16]];
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

- (void) goFullPlayer {
    
    UIView* viewBG = [[UIView alloc] initWithFrame:self.view.frame];
    [viewBG setBackgroundColor:[UIColor darkGrayColor]];
    viewBG.alpha = 0.3;
    viewBG.tag = VIEW_BG_TAG;
    [self.view addSubview:viewBG];
    [self.view bringSubviewToFront:viewBG];
    
    FullPlayerViewController* vcFullPlayer = [self.storyboard instantiateViewControllerWithIdentifier:@"FullPlayervc"];
//    [self.navigationController pushViewController:vcAlbumDetail animated:YES];
    [self presentViewController:vcFullPlayer animated:YES completion:^{

    }];
//    [[self topMostViewController] presentViewController:vcFullPlayer animated:YES completion:nil];
}


- (void) closeBackground {
    
    UIView* viewBG = [self.view viewWithTag:VIEW_BG_TAG];
    if (viewBG) {
        [viewBG removeFromSuperview];
    }
}


- (void) goAlbumDetail:(MPMediaItemCollection*)album {
    
    // 현재 vc 가져오기
    UIViewController* presentVC = [self topMostViewController];
    
    AlbumDetailViewController* vcAlbumDetail = [self.storyboard instantiateViewControllerWithIdentifier:@"AlbumDetailvc"];
    vcAlbumDetail.arAlbum = album;
    [presentVC.navigationController pushViewController:vcAlbumDetail animated:YES];
}


- (void) changePlayState {
    
    if ([[MPMusicPlayerController systemMusicPlayer] playbackState] == MPMusicPlaybackStatePlaying) {
        [[MPMusicPlayerController systemMusicPlayer] pause];
    } else if ([[MPMusicPlayerController systemMusicPlayer] playbackState] == MPMusicPlaybackStatePaused) {
        [[MPMusicPlayerController systemMusicPlayer] play];
    }
}


- (void) playNextTrack {
    
    [[MPMusicPlayerController systemMusicPlayer] skipToNextItem];
    
}

// 재생 중인 곡이 바꼈을 경우,
- (void) handleNowPlayingItemChanged:(id)notification {
    
    // skip next처리된 후 바뀐 아이템을 가져옴
    MPMediaItem* nowItem = [[MPMusicPlayerController systemMusicPlayer] nowPlayingItem];
    
    UIVisualEffectView* viewMiniBar = [self.view viewWithTag:VIEWEFFECT_TAG];
    if (viewMiniBar) {
        UIImageView* imgAlbum = [viewMiniBar viewWithTag:IMG_ALBUM_TAG];
        if (imgAlbum) {
            
            // 앨범 크기가 변경된 경우 원래대로 돌리기
            [imgAlbum setFrame:CGRectMake(20, 8, 48, 48)];
            
            MPMediaItemArtwork* artwork = [nowItem valueForProperty:MPMediaItemPropertyArtwork];
            UIImage* image = [artwork imageWithSize:imgAlbum.frame.size];
            NSLog(@"image size - %0.1f, %0.1f", image.size.width, image.size.height);
            if (image) {
                [imgAlbum setImage:image];
                [imgAlbum setBackgroundColor:[UIColor clearColor]];
                
                if (image.size.width < image.size.height) {
                    CGFloat rate = image.size.width/image.size.height;
                    [imgAlbum setFrame:CGRectMake(20+((1.0-rate)*48)/2, 8, 48.0*rate, 48)];
                } else if (image.size.width > image.size.height) {
                    CGFloat rate = image.size.height/image.size.width;
                    [imgAlbum setFrame:CGRectMake(20, 8+((1.0-rate)*48)/2, 48, 48.0*rate)];
                }
            } else {
                [imgAlbum setImage:nil];
                [imgAlbum setBackgroundColor:[UIColor lightGrayColor]];
            }
        }
        
        UILabel* lbTitle = [viewMiniBar viewWithTag:LB_TITLE_TAG];
        if (lbTitle) {
            [lbTitle setText:[nowItem valueForProperty:MPMediaItemPropertyTitle]];
        }
    }
    
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
