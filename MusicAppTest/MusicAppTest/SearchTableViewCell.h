//
//  SearchTableViewCell.h
//  MusicAppTest
//
//  Created by DeGi on 2017. 5. 23..
//  Copyright © 2017년 DeGi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchTableViewCell : UITableViewCell

@property IBOutlet UIButton* button;
@property IBOutlet UIView* separator;

- (void) setButtonInfo:(NSString*)string last:(BOOL)isLastCell;

@end
