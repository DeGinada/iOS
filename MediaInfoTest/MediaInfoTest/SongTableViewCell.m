//
//  SongTableViewCell.m
//  MediaInfoTest
//
//  Created by Sora Yeo on 2017. 4. 26..
//  Copyright © 2017년 DeGi. All rights reserved.
//

#import "SongTableViewCell.h"

@implementation SongTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// [140729] artist 표시할 textview를 세팅한다
- (void) setTextViewText:(NSString *)text frame:(CGRect)frame {
    [self.textView setText:text];
    [self.textView setFrame:frame];
}

@end
