//
//  RedditTitleLabel.m
//  
//
//  Created by Russ Wetmore on 7/28/15.
//
//

#import "RedditTitleLabel.h"


@implementation RedditTitleLabel

- (void) setTitle:(NSString *)titleText
{
	[self setText:titleText];
	[self setPreferredMaxLayoutWidth:self.bounds.size.width];
}

@end
