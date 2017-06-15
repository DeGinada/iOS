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
    [viewHeader addSubview:lbTitle];
    
    
    // 가수
    UILabel* lbArtist = [[UILabel alloc] initWithFrame:CGRectMake(0, 426, viewHeader.frame.size.width, 24)];
    [lbArtist setText:[nowItem valueForProperty:MPMediaItemPropertyArtist]];
    [lbArtist setTextColor:RED_COLOR];
    [lbArtist setFont:[UIFont systemFontOfSize:20]];
    [lbArtist setTextAlignment:NSTextAlignmentCenter];
    [viewHeader addSubview:lbArtist];
    
    
    
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
    
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    [((CustomTabBarViewController*)rootViewController) closeBackground];
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
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
