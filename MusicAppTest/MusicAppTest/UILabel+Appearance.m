//
//  UILabel+Appearance.m
//  MusicAppTest
//
//  Created by DeGi on 2017. 6. 7..
//  Copyright © 2017년 DeGi. All rights reserved.
//

#import "UILabel+Appearance.h"




@implementation UILabel (FontAppearance)

-(void)setAppearanceAlignment:(NSTextAlignment)alignment {
    [self setTextAlignment:alignment];
}

-(NSTextAlignment)appearanceAlignment {
    return self.textAlignment;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
