//
//  SongTableViewCell.h
//  MediaInfoTest
//
//  Created by Sora Yeo on 2017. 4. 26..
//  Copyright © 2017년 DeGi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SongTableViewCell : UITableViewCell

@property IBOutlet UITextView* textView;

- (void) setTextViewText:(NSString*)text frame:(CGRect)frame;
//- (void) setDetailTextViewText:(NSString*)text x:(CGFloat)x width:(CGFloat)width;

@end
