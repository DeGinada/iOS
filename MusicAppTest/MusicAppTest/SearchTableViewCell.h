//
//  SearchTableViewCell.h
//  MusicAppTest
//
//  Created by Sora Yeo on 2017. 5. 23..
//  Copyright © 2017년 DeGi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchTableViewCell : UITableViewCell

@property IBOutlet UIButton* button;

- (void) setButtonInfo:(NSString*)string;

@end