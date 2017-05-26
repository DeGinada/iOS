//
//  ResultViewController.m
//  MusicAppTest
//
//  Created by Sora Yeo on 2017. 5. 19..
//  Copyright © 2017년 DeGi. All rights reserved.
//

#import "ResultViewController.h"

@interface ResultViewController ()

@end

@implementation ResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    
    UIView* viewBack = [[UIView alloc] initWithFrame:self.tableView.frame];
    [viewBack setBackgroundColor:[UIColor whiteColor]];
    self.tableView.backgroundView = viewBack;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - TABLE_VIEW

// [170526] table hearder 수
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView  {
    
    int nCount = 0;
    
    if (self.arAlbum.count > 0)
        nCount++;
    
    if (self.arArtist.count > 0)
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
            return self.arArtist.count;
        } else if (section == 1) {
            return self.arAlbum.count;
        } else {
            return self.arSong.count;
        }
    } else if ([self numberOfSectionsInTableView:tableView] == 2) {
        if (section == 0) {
            if (self.arArtist.count) {
                return self.arArtist.count;
            } else {
                return self.arAlbum.count;
            }
        } else {
            if (self.arSong.count) {
                return self.arSong.count;
            } else {
                return self.arAlbum.count;
            }
        }
    } else if ([self numberOfSectionsInTableView:tableView] == 1) {
        if (self.arAlbum.count > 0)
            return self.arAlbum.count;
        
        if (self.arArtist.count > 0)
            return self.arArtist.count;
        
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
            if (self.arArtist.count) {
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
        if (self.arAlbum.count > 0)
            return @"앨범";
        
        if (self.arArtist.count > 0)
            return @"아티스트";
        
        if (self.arSong.count > 0)
            return @"노래";
    }
    
    
    return @"정보 없음";
}


// [170526] header height
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 118.0;
}


// [170526] row height
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 170.0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* identifier = @"Cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }

    
    return cell;
}


@end
