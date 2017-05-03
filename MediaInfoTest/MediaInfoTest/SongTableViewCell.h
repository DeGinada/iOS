//
//  SongTableViewCell.h
//  MediaInfoTest
//
//  Created by DeGi on 2017. 4. 26..
//  Copyright © 2017년 DeGi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SongTableViewCell : UITableViewCell

@property IBOutlet UITextView* textView;
@property IBOutlet UITextView* detailTextView;
@property IBOutlet UIImageView* imgView;

- (void) adjustContentPosition;
//- (void) setDetailTextViewText:(NSString*)text x:(CGFloat)x width:(CGFloat)width;

@end
