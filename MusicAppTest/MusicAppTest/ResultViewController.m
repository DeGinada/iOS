//
//  ResultViewController.m
//  MusicAppTest
//
//  Created by Sora Yeo on 2017. 5. 19..
//  Copyright © 2017년 DeGi. All rights reserved.
//

#import "ResultViewController.h"
#import "CustomTabBarViewController.h"

@interface ResultViewController ()

@end

@implementation ResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    
   
    UIView* viewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 45)];
    [viewHeader setBackgroundColor:[UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:250.0/255.0 alpha:1.0]];
    self.tableView.tableHeaderView = viewHeader;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    
//    // 현재 재생 중인 곡이 있을 경우 view 높이를 더 높임
//    if (!((CustomTabBarViewController*)self.tabBarController).isHiddenPlayer) {
//        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 64)];
//    }

    
    UIView* viewBack = [[UIView alloc] initWithFrame:self.tableView.frame];
    [viewBack setBackgroundColor:[UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:250.0/255.0 alpha:1.0]];
    self.tableView.backgroundView = viewBack;
    
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = 0;
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
//    // 현재 재생 중인 곡이 있을 경우 tableview 크기 조정
//    if (!((CustomTabBarViewController*)self.tabBarController).isHiddenPlayer) {
//        //        [self.tableView setFrame:CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, self.tableView.frame.size.height-64)];
//        
//        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 64)];
//        self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 64, 0);
//        
////        // visual effect view 밑에서 밝기 조정할 뷰 (여기에선 필요없음)
////        UIView* viewTemp = [[UIView alloc] initWithFrame:CGRectMake(0, self.tabBarController.tabBar.frame.origin.y-64, self.view.frame.size.width, 64)];
////        [viewTemp setBackgroundColor:[UIColor lightGrayColor]];
////        viewTemp.alpha = 0.7;
////        [self.view addSubview:viewTemp];
////        [self.view bringSubviewToFront:viewTemp];
//    }
    
    [self adjustTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear: animated];
    
    // [170528] 결과에 대한 tableview 크기 지정
    [self.tableView setFrame:CGRectMake(0, 20, self.tableView.frame.size.width, 598)];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // viewController에서 view의 edge를 확장하지 마...
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}


- (void) adjustTableView {
    
    if (!((CustomTabBarViewController*)self.tabBarController).isHiddenPlayer) {
        if (self.tableView.scrollIndicatorInsets.bottom == 0) {
            self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 64)];
            self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 64, 0);
        }
    } else {
        if (self.tableView.scrollIndicatorInsets.bottom == 64) {
            self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0);
            self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        }
    }
}

#pragma mark - TABLE_VIEW

// [170526] table hearder 수
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView  {
    
    int nCount = 0;
    
    if ([self.arAlbum collections].count > 0)
        nCount++;
    
    if ([self.arArtist collections].count > 0)
        nCount++;
    
    if (self.arSong.count > 0)
        nCount++;
    
    
    return nCount;
}


// [170526] 각 section별 row 수 (순서는 아티스트, 앨범, 노래)
// 지금 현재 코드가 너무 비효율적인것 같은데.. 수정해보자
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([self numberOfSectionsInTableView:tableView] == 3) {
        if (section == 0) {
            return [self.arArtist collections].count;
        } else if (section == 1) {
            return [self.arAlbum collections].count;
        } else {
            return self.arSong.count;
        }
    } else if ([self numberOfSectionsInTableView:tableView] == 2) {
        if (section == 0) {
            if ([self.arArtist collections].count) {
                return [self.arArtist collections].count;
            } else {
                return [self.arAlbum collections].count;
            }
        } else {
            if (self.arSong.count) {
                return self.arSong.count;
            } else {
                return [self.arAlbum collections].count;
            }
        }
    } else if ([self numberOfSectionsInTableView:tableView] == 1) {
        if ([self.arAlbum collections].count > 0)
            return [self.arAlbum collections].count;
        
        if ([self.arArtist collections].count > 0)
            return [self.arArtist collections].count;
        
        if (self.arSong.count > 0)
            return self.arSong.count;
    }
    
    
    return 0;
}


// [170526] 각 section별 header title
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    
    if ([self numberOfSectionsInTableView:tableView] == 3) {
        if (section == 0) {
            return @"아티스트";
        } else if (section == 1) {
            return @"앨범";
        } else {
            return @"노래";
        }
    } else if ([self numberOfSectionsInTableView:tableView] == 2) {
        if (section == 0) {
            if ([self.arArtist items].count) {
                return @"아티스트";
            } else {
                return @"앨범";
            }
        } else {
            if (self.arSong.count) {
                return @"노래";
            } else {
                return @"앨범";
            }
        }
    } else if ([self numberOfSectionsInTableView:tableView] == 1) {
        if ([self.arAlbum items].count > 0)
            return @"앨범";
        
        if ([self.arArtist items].count > 0)
            return @"아티스트";
        
        if (self.arSong.count > 0)
            return @"노래";
    }
    
    
    return @"정보 없음";
}


// [170526] section header height
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 58.0;
}


// [170526] row height
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 85.0;
}


// [170529] section view
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView* viewBack = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 58)];
    [viewBack setBackgroundColor:[UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:250.0/255.0 alpha:1.0]];
    
    UILabel* lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 22, tableView.frame.size.width-30, 36)];
    [lbTitle setFont:[UIFont boldSystemFontOfSize:20.0]];
    [lbTitle setTextColor:[UIColor blackColor]];
    [lbTitle setTextAlignment:NSTextAlignmentLeft];
    [lbTitle setText:[self tableView:tableView titleForHeaderInSection:section]];
    [viewBack addSubview:lbTitle];
    
    
    return viewBack;
}


#define kImageAlbum     1300
#define kLabelFirst     1301
#define kLabelSecond    1302
#define kLabelThird     1303

#define BlankHieght     2.0f


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* identifier = @"Cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        
    }
    
    UIImageView* imgView = [cell viewWithTag:kImageAlbum];
    if (imgView == nil) {
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 12, 61, 61)];
        [imgView setBackgroundColor:[UIColor lightGrayColor]];
        imgView.clipsToBounds = YES;
        [imgView setTag:kImageAlbum];
        imgView.layer.borderWidth = 0.3;
        imgView.layer.borderColor = [UIColor grayColor].CGColor;
        [cell addSubview:imgView];
    }
    
    UILabel* lbFirst = [cell viewWithTag:kLabelFirst];
    if (lbFirst == nil) {
        lbFirst = [[UILabel alloc] initWithFrame:CGRectMake(88, 0, tableView.frame.size.width-90-15, 30)];
        [lbFirst setFont:[UIFont boldSystemFontOfSize:14.0]];
        [lbFirst setTextColor:[UIColor blackColor]];
        [lbFirst setTag:kLabelFirst];
        [lbFirst setTextAlignment:NSTextAlignmentLeft];
        [cell addSubview:lbFirst];
    }
    
    UILabel* lbSecond = [cell viewWithTag:kLabelSecond];
    if (lbSecond == nil) {
        lbSecond = [[UILabel alloc] initWithFrame:CGRectMake(88, 0, tableView.frame.size.width-90-15, 30)];
        [lbSecond setFont:[UIFont systemFontOfSize:12.0]];
        [lbSecond setTextColor:[UIColor grayColor]];
        [lbSecond setTag:kLabelSecond];
        [lbSecond setTextAlignment:NSTextAlignmentLeft];
        [cell addSubview:lbSecond];
    }
    
    UILabel* lbThird = [cell viewWithTag:kLabelThird];
    if (lbThird == nil) {
        lbThird = [[UILabel alloc] initWithFrame:CGRectMake(88, 0, tableView.frame.size.width-90-15, 30)];
        [lbThird setFont:[UIFont systemFontOfSize:12.0]];
        [lbThird setTextColor:[UIColor grayColor]];
        [lbThird setTag:kLabelThird];
        [lbThird setTextAlignment:NSTextAlignmentLeft];
        [cell addSubview:lbThird];
    }
    
    
    NSString* strSection = [self tableView:tableView titleForHeaderInSection:indexPath.section];
    if ([strSection isEqualToString:@"아티스트"]) {
        MPMediaItemCollection* media = [[self.arArtist collections] objectAtIndex:indexPath.row];
        MPMediaItem* mediaEntity = [[media items] objectAtIndex:0]; // 대표 하나 가져와서 처리
        
        [lbFirst setText:[mediaEntity valueForProperty:MPMediaItemPropertyArtist]];
        [lbFirst sizeToFit];
        [lbFirst setFrame:CGRectMake(lbFirst.frame.origin.x, (85.0-lbFirst.frame.size.height)/2.0, lbFirst.frame.size.width, lbFirst.frame.size.height)];
        
        lbSecond.text = @"";
        lbThird.text = @"";
        
        
        imgView.image = nil;
        imgView.layer.cornerRadius = imgView.frame.size.height/2.0;
    } else if ([strSection isEqualToString:@"앨범"]) {
        float fHeight = 0.0;
        MPMediaItemCollection* media = [[self.arAlbum collections] objectAtIndex:indexPath.row];
        MPMediaItem* mediaEntity = [[media items] objectAtIndex:0]; // 대표 하나 가져와서 처리
        
        [lbFirst setText:[mediaEntity valueForProperty:MPMediaItemPropertyAlbumTitle]];
        [lbFirst sizeToFit];
        fHeight = fHeight + lbFirst.frame.size.height + BlankHieght;

        [lbSecond setText:[mediaEntity valueForProperty:MPMediaItemPropertyAlbumArtist]];
        if (lbSecond.text.length > 0) {
            [lbSecond sizeToFit];
            fHeight = fHeight + lbSecond.frame.size.height + BlankHieght;
        }
        
        // 앨범 발행 년도 가져오기
        NSNumber* year = [mediaEntity valueForProperty:@"year"];
        if ([year intValue] > 0) {
            [lbThird setText:[NSString stringWithFormat:@"%d년", [year intValue]]];
            [lbThird sizeToFit];
            fHeight = fHeight + lbThird.frame.size.height;
        } else {
            [lbThird setText:@""];
        }
        
        MPMediaItemArtwork* artwork = [mediaEntity valueForProperty:MPMediaItemPropertyArtwork];
        UIImage* imgArtwork = [artwork imageWithSize:imgView.image.size];
        if (imgArtwork) {
            imgView.image = imgArtwork;
        } else {
            imgView.image = nil;
        }
        imgView.layer.cornerRadius = 5.0;
        
        float fY = (85.0 - fHeight)/2.0;
        [lbFirst setFrame:CGRectMake(lbFirst.frame.origin.x, fY, lbFirst.frame.size.width, lbFirst.frame.size.height)];
        fY = fY + BlankHieght + lbFirst.frame.size.height;
        [lbSecond setFrame:CGRectMake(lbSecond.frame.origin.x, fY, lbSecond.frame.size.width, lbSecond.frame.size.height)];
        fY = fY + BlankHieght + lbSecond.frame.size.height;
        [lbThird setFrame:CGRectMake(lbThird.frame.origin.x, fY, lbThird.frame.size.width, lbThird.frame.size.height)];
    } else {
        float fHeight = 0.0;
        MPMediaItem* mediaEntity = [self.arSong objectAtIndex:indexPath.row];
        [lbFirst setText:[mediaEntity valueForProperty:MPMediaItemPropertyTitle]];
        [lbFirst sizeToFit];
        fHeight = fHeight + lbFirst.frame.size.height + BlankHieght;
        
        [lbSecond setText:[mediaEntity valueForProperty:MPMediaItemPropertyArtist]];
        if (lbSecond.text.length > 0) {
            [lbSecond sizeToFit];
            fHeight = fHeight + lbSecond.frame.size.height + BlankHieght;
        }
        
        [lbThird setText:[mediaEntity valueForProperty:MPMediaItemPropertyAlbumTitle]];
        if (lbThird.text.length > 0) {
            [lbThird sizeToFit];
            fHeight = fHeight + lbThird.frame.size.height;
        }
        
        MPMediaItemArtwork* artwork = [mediaEntity valueForProperty:MPMediaItemPropertyArtwork];
        UIImage* imgArtwork = [artwork imageWithSize:imgView.image.size];
        if (imgArtwork) {
            imgView.image = imgArtwork;
        } else {
            imgView.image = nil;
        }
        imgView.layer.cornerRadius = 5.0;
        
        float fY = (85.0 - fHeight)/2.0;
        [lbFirst setFrame:CGRectMake(lbFirst.frame.origin.x, fY, lbFirst.frame.size.width, lbFirst.frame.size.height)];
        fY = fY + BlankHieght + lbFirst.frame.size.height;
        [lbSecond setFrame:CGRectMake(lbSecond.frame.origin.x, fY, lbSecond.frame.size.width, lbSecond.frame.size.height)];
        fY = fY + BlankHieght + lbSecond.frame.size.height;
        [lbThird setFrame:CGRectMake(lbThird.frame.origin.x, fY, lbThird.frame.size.width, lbThird.frame.size.height)];
    }

    
    return cell;
}


@end
