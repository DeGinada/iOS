//
//  ViewController.m
//  MediaInfoTest
//
//  Created by DeGi on 2017. 4. 25..
//  Copyright © 2017년 DeGi. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MPMediaQuery.h>
#import <MediaPlayer/MPMediaPlaylist.h>
#import "SongTableViewCell.h"
#import "SongDetailViewController.h"
#import <MediaPlayer/MediaPlayer.h>


@interface ViewController ()

@end

@implementation ViewController
{
    NSArray* g_arSongs;
    MPMediaItem* g_selSong;
    
    BOOL g_isShownKeyboard;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    // [170510] music control center
//    MPRemoteCommandCenter *rcc = [MPRemoteCommandCenter sharedCommandCenter];
//    [[rcc previousTrackCommand] addTarget:self action:@selector(remoteControlReceivedWithCommand:)];
//    [[rcc nextTrackCommand] addTarget:self action:@selector(remoteControlReceivedWithCommand:)];
//    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
//    NSError *error  = nil;
//    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker|AVAudioSessionCategoryOptionAllowAirPlay|AVAudioSessionCategoryOptionAllowBluetooth|AVAudioSessionCategoryOptionAllowBluetoothA2DP error:&error];
//
    
    g_isShownKeyboard = NO;

    // [170511] 시스템뮤직 play item이 바뀌면.. 옵저버 등록
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    [notificationCenter addObserver:self
                           selector:@selector(handleNowPlayingItemChanged:)
                               name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification
                             object:[MPMusicPlayerController systemMusicPlayer]];
    [[MPMusicPlayerController systemMusicPlayer] beginGeneratingPlaybackNotifications];
    
    
    // 테이블뷰 footerview 적용
    self.tableSongs.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableSongs.frame.size.width, 67)];
    
    // [170512] 하단 now playing bar에 정보 출력
    [self showNowPlaying];
    
    // [170513] 세그먼트 적용 -> 첫 시작은 첫번째 Songs;
    [self selectSongList];
}


- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // [170510] remote control event 받기 등록
//    UIDevice* devie = [UIDevice currentDevice];
//    if ([devie respondsToSelector:@selector(isMultitaskingSupported)]) {
//        if (devie.multitaskingSupported) {
//            [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
//            [self becomeFirstResponder];
//        }
//    }
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //End recieving events
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
}


- (BOOL) canBecomeFirstResponder {
    return YES;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// [170425] 유저가 만든 플레이리스트 가져오기
- (void) getPlaylist {
    
    MPMediaQuery* myPlaylistQuery = [MPMediaQuery playlistsQuery];
    NSArray* arPlaylist = [myPlaylistQuery collections];
    for (MPMediaPlaylist* playlist in arPlaylist) {
        
        // 플레이리스트 이름.
        NSLog(@"%@", [playlist valueForProperty:MPMediaPlaylistPropertyName]);
        
        // 플레이리스트에 있는 음악을 가져온다
        NSArray* arSongs = [playlist items];
        for (MPMediaItem* song in arSongs) {
            
            // 노래 제목
            NSLog(@"\t\t%@", [song valueForProperty:MPMediaItemPropertyTitle]);
        }
    }
}


// [170425] 유저 디바이스에 있는 곡 목록 가져오기
- (void) getSongs {
    
    MPMediaQuery* mySongsQuery = [MPMediaQuery songsQuery];
    NSArray* arSongs = [mySongsQuery items];
    for (MPMediaItem* song in arSongs) {
        
        // 노래 제목
        NSLog(@"\t\t%@", [song valueForProperty:MPMediaItemPropertyTitle]);
    }
    
    NSLog(@"total - %ld songs", [arSongs count]);
    /*
    // enumerateObjectsUsingBlock 테스트
    [[mySongsQuery items] enumerateObjectsUsingBlock:^(MPMediaItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"\t\t%@", [obj valueForProperty:MPMediaItemPropertyTitle]);
    }]; */
    
}


// [170425] 아티스트 이름별로 그룹핑하기
// [170510] 아티스트별로 sorting된 노래를 리턴한다.
- (NSArray*) getGroupSongsbyArtist {
    
    /*
    // 팟캐스트가 포함됨
    MPMediaQuery* mediaQuery = [[MPMediaQuery alloc] init];
    [mediaQuery setGroupingType:MPMediaGroupingArtist];
    NSArray* arArtist = [mediaQuery collections];
    for (MPMediaItemCollection* entity in arArtist) {
        
        NSLog(@"\t%@", [[[entity items] objectAtIndex:0] valueForProperty:MPMediaItemPropertyArtist]);
        
        NSArray* arSongs = [entity items];
        for (MPMediaItem* song in arSongs) {
            NSLog(@"\t\t%@", [song valueForProperty:MPMediaItemPropertyTitle]);
        }
    } */
    
    MPMediaQuery* artistQuery = [MPMediaQuery artistsQuery];
    NSArray* arArtist = [artistQuery collections];
    
    NSMutableArray* arSongList = [[NSMutableArray alloc] init];
    for (MPMediaItemCollection* entity in arArtist) {
        
        NSArray* arSongs = [entity items];
        for (MPMediaItem* song in arSongs) {
            [arSongList addObject:song];
        }
    }
    
    return arSongList;
    
}


// [170426] 셀 선택시 열리는 뷰에서 돌아오는 코드
- (IBAction) exitFromSecondViewController:(UIStoryboardSegue *)segue {
    
}


// [170427] 셀 선택으로 뷰이동 시, 데이터 넘기기
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([[segue identifier] isEqualToString:@"segShowDetail"]) {
        SongDetailViewController* vcSongDetail = [segue destinationViewController];
        vcSongDetail.m_songDetail = g_selSong;
    } else if ([[segue identifier] isEqualToString:@"seqNowPlay"]) {
        SongDetailViewController* vcSongDetail = [segue destinationViewController];
        vcSongDetail.m_songDetail = [[MPMusicPlayerController systemMusicPlayer] nowPlayingItem];
    }
}


#pragma mark - DATA
// [170426] 디바이스에 있는 song 정보를 가져온다.
- (NSArray*) getSongList {
    
    // 단순하게 song list를 가져옴
//    MPMediaQuery* mediaQuery = [MPMediaQuery songsQuery];
//    NSArray* arSongs = [mediaQuery items];
    
    // [170510] 음악앱 보관함 노래 방식으로 sorting -> 아티스트별로 보여줌
    NSArray* arSongs = [self getGroupSongsbyArtist];
    
    return arSongs;
}


#pragma mark - TABLE_VIEW

// [170426] 셀에 곡 정보를 띄어줌 (이미지, 제목, 가수)
- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString* identifier = @"Cell";
    SongTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[SongTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    
    /*
    // cell 정보 띄어주기 (cell subtitle 포맷)
    // 현재 cell 형태는 subtitle, title에 artist, subtitle에 song title, image에 아트웍 넣기
    [cell.textLabel setText:[[g_arSongs objectAtIndex:indexPath.row] valueForProperty:MPMediaItemPropertyArtist]];
    [cell.textLabel setFont:[UIFont systemFontOfSize:13]];
    [cell.detailTextLabel setText:[[g_arSongs objectAtIndex:indexPath.row] valueForProperty:MPMediaItemPropertyTitle]];
    [cell.detailTextLabel setFont:[UIFont systemFontOfSize:15]];
    cell.detailTextLabel.numberOfLines = 0;
    
    
    MPMediaItemArtwork* artwork = [[g_arSongs objectAtIndex:indexPath.row] valueForProperty:MPMediaItemPropertyArtwork];
    UIImage* imgArtwork = [artwork imageWithSize:cell.imageView.image.size];
//    if (nil == imgArtwork) {
//        CGSize size = ((MPMediaItemArtwork*)[[m_arSongs objectAtIndex:indexPath.row] valueForProperty:MPMediaItemPropertyArtwork]).bounds.size;
//        if ( 0 < size.width && 0 < size.height) {
//            imgArtwork = [artwork imageWithSize:size];
//        }
//    }
    [cell.imageView setImage:imgArtwork];
    
    // 이미지 사이즈 변경
    CGSize itemSize = CGSizeMake(tableView.rowHeight-2, tableView.rowHeight-2);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
    CGRect imageRect = CGRectMake(1.0, 1.0, itemSize.width, itemSize.height);
    [cell.imageView.image drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    */
    
    
    // [170429] cell subtitle 형식으로 썼었던 걸 textview로 바꿔보기 -> 실패
    //[cell setTextViewText:[[g_arSongs objectAtIndex:indexPath.row] valueForProperty:MPMediaItemPropertyArtist] x:cell.imageView.bounds.origin.x*2+cell.imageView.bounds.size.width width:cell.frame.size.width-(cell.imageView.bounds.origin.x*3)-cell.imageView.bounds.size.width];
//    [cell.textView setBounds:cell.textLabel.bounds];
//    cell.textView.contentMode = cell.textLabel.contentMode;
//    [cell setTextViewText:[[g_arSongs objectAtIndex:indexPath.row] valueForProperty:MPMediaItemPropertyArtist] frame:cell.textLabel.frame];
    
    
    MPMediaItem* nowMItem = [g_arSongs objectAtIndex:indexPath.row];
    
    // [170430] cell custom 으로 변경
    // cell에 내용도 선택할 수 있게 하고 싶어 textview로 바꿨으나 user interaction 때문에 cell 선택에 문제가 생김.
    [cell.textView setText:[nowMItem valueForProperty:MPMediaItemPropertyArtist]];
    [cell.detailTextView setText:[nowMItem valueForProperty:MPMediaItemPropertyTitle]];

    
    MPMediaItemArtwork* artwork = [nowMItem valueForProperty:MPMediaItemPropertyArtwork];
    UIImage* imgArtwork = [artwork imageWithSize:cell.imgView.image.size];
    if (imgArtwork) {
        [cell.imgView setImage:imgArtwork];
    } else {
        // [170510] 이미지 없는 경우, nil 처리
        cell.imgView.image = nil;
    }
    cell.imgView.layer.masksToBounds = YES;
    cell.imgView.layer.cornerRadius = 5.0;
    
    // [170510] 현재 재생 중인 곡이라면 표시해주기
    [cell.imgView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if ([[MPMusicPlayerController systemMusicPlayer] playbackState] == MPMusicPlaybackStatePlaying) {
        MPMusicPlayerController* mpController = [MPMusicPlayerController systemMusicPlayer];
        MPMediaItem* nowPlaying = mpController.nowPlayingItem;
        if ([nowPlaying isEqual:nowMItem]) {
            
            UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.imgView.frame.size.width, cell.imgView.frame.size.height)];
            [imgView setBackgroundColor:[UIColor colorWithRed:161.0f/255.0f green:161.0f/255.0f blue:161.0f/255.0f alpha:0.7f]];
            [imgView setImage:[UIImage imageNamed:@"play.png"]];
            [cell.imgView addSubview:imgView];
        }
    }
    
    
    // [170430] 텍스트에 따라 textview 위치와 크기를 재설정한다.
    [cell adjustContentPosition];
    
    
    return cell;
}


// [170426] 리스트 수 지정
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 
    return g_arSongs.count;
}


// [170427] tableviewcell will select 
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"willSelectRowAtIndexPath");
    
    // viewcontroller에 넘겨줄 데이터를 정의한다.
    g_selSong = [g_arSongs objectAtIndex:indexPath.row];
//    [self performSegueWithIdentifier:@"segShowDetail" sender:nil];
    
    return indexPath;
}

// [170427] tableviewcell did select (현재 상황에서 view 이동 후 호출)
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"didSelectRowAtIndexPath");
}


// [170510]
- (void) remoteControlReceivedWithCommand:(MPRemoteCommandEvent*)event {
    if (event.command == [[MPRemoteCommandCenter sharedCommandCenter] nextTrackCommand]) {
        [self.tableSongs reloadData];
    } else if (event.command == [[MPRemoteCommandCenter sharedCommandCenter] previousTrackCommand]) {
        [self.tableSongs reloadData];
    }
}


// [170510] remote command 동작시,
- (void) remoteControlReceivedWithEvent:(UIEvent *)event {
    if (event.type == UIEventTypeRemoteControl) {
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlNextTrack:
            case UIEventSubtypeRemoteControlPreviousTrack:
                [self.tableSongs reloadData];
                break;
                
            default:
                break;
        }
    }
}


// [170511] 시스템뮤직 play item이 바뀌면..
- (void)handleNowPlayingItemChanged:(id)notification {
    
    [self.tableSongs reloadData];
    [self showNowPlaying];
}


// [170512] now playing 정보 출력
- (void) showNowPlaying {
    
    [self.viewNowPlaying setHidden:NO];
    
    // 현재 재생 중이면 bar정보 수정
    if ([[MPMusicPlayerController systemMusicPlayer] playbackState] == MPMusicPlaybackStatePlaying) {
        
        // 이미지 등록
        MPMediaItem* nowPlaying = [[MPMusicPlayerController systemMusicPlayer] nowPlayingItem];
        MPMediaItemArtwork* artwork = [nowPlaying valueForProperty:MPMediaItemPropertyArtwork];
        UIImage* imgArtwork = [artwork imageWithSize:self.imgNowPlaying.image.size];
        if (imgArtwork) {
            [self.imgNowPlaying setImage:imgArtwork];
        } else {
            self.imgNowPlaying.image = nil;
        }
        self.imgNowPlaying.layer.masksToBounds = YES;
        self.imgNowPlaying.layer.borderWidth = 0.1;
        self.imgNowPlaying.layer.cornerRadius = 5.0;
        
        // 제목 등록
        [self.lbNowPlaying setText:[nowPlaying valueForKey:MPMediaItemPropertyTitle]];
        
    } else {
        
        // 재생 중이 아니면 bar가 안보임
        [self.viewNowPlaying setHidden:YES];
    }
}



#pragma mark - SEGMENT

// [170513] 세그먼트를 통해 리스트 바꿈
- (IBAction) changeSegmentValues:(id)sender {
    
    UISegmentedControl* selSegment = sender;
    
    if (selSegment.selectedSegmentIndex == 0) {
        [self selectSongList];
    } else if (selSegment.selectedSegmentIndex == 1) {
        [self selectAlbumList];
    }
    
    // tableview reload
    [self.tableSongs reloadData];
    [self.tableSongs setContentOffset:CGPointZero];
    
}

- (void) selectSongList {
    
    // 음악 정보 가져오기
    g_arSongs = [self getSongList];

}

//#define EFFECT_VIEW_BG      1024

- (void) selectAlbumList {
    
    // 음악 정보 가져오기
    g_arSongs = [self getAlbumSongs];
    
}


// [170513] album별 곡 목록을 가져온다.
- (NSArray*) getAlbumSongs {
    
    MPMediaQuery* albumsQuery = [MPMediaQuery albumsQuery];
    NSArray* arAlbum = [albumsQuery collections];
    
    NSMutableArray* arSongList = [[NSMutableArray alloc] init];
    for (MPMediaItemCollection* entity in arAlbum) {
        
        NSArray* arSongs = [entity items];
        for (MPMediaItem* song in arSongs) {
            [arSongList addObject:song];
        }
    }
    
    return arSongList;
}


#pragma mark - SEARCH

#define SEARCH_BG       1024
#define SEARCH_FIELD    1030

// [170514] 검색 창을 만들어 띄운다
- (IBAction) showSearchView:(id)sender  {
    
    
    UIButton* btnBG = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [btnBG setBackgroundColor:[UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.6]];
    btnBG.tag = SEARCH_BG;
    btnBG.userInteractionEnabled = YES;
    [btnBG addTarget:self action:@selector(closetSearchView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnBG];
    
    UIView* viewBG = [[UIView alloc] initWithFrame:CGRectMake(35, 80, self.view.frame.size.width-70, self.view.frame.size.height-160)];
//    viewBG.userInteractionEnabled = YES;
    viewBG.backgroundColor = [UIColor whiteColor];
    viewBG.layer.cornerRadius = 15.0;
    viewBG.layer.masksToBounds = YES;
    [btnBG addSubview:viewBG];
    
    
    // [170515] 서치창
    UITextField* txField = [[UITextField alloc] initWithFrame:CGRectMake(10, 18, viewBG.frame.size.width-25-50, 38)];
    txField.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0f];
    txField.clearButtonMode = UITextFieldViewModeWhileEditing;
    txField.delegate = self;
    txField.returnKeyType = UIReturnKeyDone;
    txField.layer.cornerRadius = 4.0;
    txField.layer.masksToBounds = YES;
    txField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 38)];
    txField.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 38)];
    txField.leftViewMode = UITextFieldViewModeAlways;
    txField.rightViewMode = UITextFieldViewModeAlways;
    txField.tintColor = [UIColor blackColor];
    txField.tag = SEARCH_FIELD;
    [viewBG addSubview:txField];
    
    // 서치 정보 보여줄 scrollview
    UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 73, viewBG.frame.size.width, viewBG.frame.size.height-73-15)];
    [scrollView setContentSize:scrollView.frame.size];
    scrollView.scrollEnabled = YES;
    [viewBG addSubview:scrollView];
    
    // 서치버튼
    UIButton* btnSearch = [[UIButton alloc] initWithFrame:CGRectMake(txField.frame.origin.x+txField.frame.size.width+5, 18, 50, 38)];
    [btnSearch setTitle:@"검색" forState:UIControlStateNormal];
    [btnSearch setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btnSearch.titleLabel.font = [UIFont systemFontOfSize:15];
    btnSearch.layer.cornerRadius = 4.0;
    btnSearch.layer.borderWidth = 0.2f;
    btnSearch.layer.masksToBounds = YES;
    // 꼼수지만, 이미지로 텍스트필드와 스크롤뷰를 넘긴다
    [btnSearch setImage:(UIImage*)txField forState:UIControlStateDisabled];
    [btnSearch setImage:(UIImage*)scrollView forState:UIControlStateSelected];
    [btnSearch addTarget:self action:@selector(searchSong:) forControlEvents:UIControlEventTouchUpInside];
    [viewBG addSubview:btnSearch];
    
}


// [170514] 검색 창을 닫는다
- (void) closetSearchView {
    
    UIButton* btnTemp = [self.view viewWithTag:SEARCH_BG];
    
    // [170515] 키보드가 띄어져있는 경우, 키보드부터 닫기
    if (g_isShownKeyboard) {
        [self.view endEditing:YES];
    } else {
        if (btnTemp) {
            [btnTemp.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        }
        
        [btnTemp removeFromSuperview];
    }
}


// [170515] 노래 검색하기
- (void) searchSong:(id)sender {
    
    UIButton* btnSelected = sender;
    UITextField* txSearch = (UITextField*)[btnSelected imageForState:UIControlStateDisabled];
    UIScrollView* scrollView = (UIScrollView*)[btnSelected imageForState:UIControlStateSelected];
    [scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSString* strResult = [txSearch.text lowercaseString];
    [txSearch resignFirstResponder];
    
    NSMutableArray* arSearchResult = [[NSMutableArray alloc] init];
    if (txSearch.text.length > 0) {
        // 검색하기
        for (MPMediaItem* song in g_arSongs) {
            
            NSString* strSongName = [[song valueForProperty:MPMediaItemPropertyTitle] lowercaseString];
            
            NSRange range = [strSongName rangeOfString:strResult];
            
            if (range.location != NSNotFound) {
                // 문자열 포함하니까 결과에 넣기
                [arSearchResult addObject:song];
            }
        }
    }
    
    // 결과 정보 띄어주기
    
    CGFloat height = 0.0;
    for (MPMediaItem* song in arSearchResult) {
        UIButton* btnTemp = [[UIButton alloc] initWithFrame:CGRectMake(0, height, scrollView.contentSize.width, 60)];
        [btnTemp addTarget:self action:@selector(showDetailInfo:) forControlEvents:UIControlEventTouchUpInside];
        // 해당하는 곡 정보 버튼에 실어서 넘겨주기
        [btnTemp setImage:(UIImage*)song forState:UIControlStateDisabled];
        [scrollView addSubview:btnTemp];
        
        // 정보 띄우기
        UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 4, 52, 52)];
        MPMediaItemArtwork* artwork = [song valueForProperty:MPMediaItemPropertyArtwork];
        UIImage* imgArtwork = [artwork imageWithSize:imgView.image.size];
        
        if (imgArtwork) {
            [imgView setImage:imgArtwork];
        } else {
            // [170510] 이미지 없는 경우, nil 처리
            imgView.image = nil;
        }
        imgView.layer.masksToBounds = YES;
        imgView.layer.cornerRadius = 52.0/2.0;
        imgView.layer.borderWidth = 0.1;
        imgView.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0f];
        [btnTemp addSubview:imgView];
        
        UILabel* lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(8+52+8, 0, btnTemp.frame.size.width-24-52, btnTemp.frame.size.height)];
        lbTitle.numberOfLines = 0;
        [lbTitle setText:[song valueForProperty:MPMediaItemPropertyTitle]];
        lbTitle.textColor = [UIColor blackColor];
        lbTitle.font = [UIFont systemFontOfSize:13.0];
        [btnTemp addSubview:lbTitle];
        
        height = height+60.0;
    }
    
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, height);
    
    
}


// [170515] 상세 화면 창으로 넘기기
- (void) showDetailInfo:(id)sender {
    
//    UIButton* btnSelected = sender;
//    MPMediaItem* selSong = (MPMediaItem*)[btnSelected imageForState:UIControlStateDisabled];
//
//    // 이러면 안돼..
//    SongDetailViewController* vcSongDetail = [[SongDetailViewController alloc] init];
//    vcSongDetail.m_songDetail = selSong;
//    [self presentViewController:vcSongDetail animated:YES completion:^{
//        
//    }];
    
}


#pragma mark - TEXTFIELD

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    g_isShownKeyboard = NO;
    [textField resignFirstResponder];
    
    return YES;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField {
    g_isShownKeyboard = YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    g_isShownKeyboard = NO;
}


@end
