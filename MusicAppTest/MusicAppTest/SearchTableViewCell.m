//
//  SearchTableViewCell.m
//  MusicAppTest
//
//  Created by Sora Yeo on 2017. 5. 23..
//  Copyright © 2017년 DeGi. All rights reserved.
//

#import "SearchTableViewCell.h"

#define RED_COLOR       [UIColor colorWithRed:252.0/255.0 green:24.0/255.0 blue:88.0/255.0 alpha:1.0]

@implementation SearchTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


// [170523] 버튼을 세팅한다
- (void) setButtonInfo:(NSString*)string {
    
    [self.button setTitle:string forState:UIControlStateNormal];
    [self.button setTitleColor:RED_COLOR forState:UIControlStateNormal];
    [self.button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    
}

@end
