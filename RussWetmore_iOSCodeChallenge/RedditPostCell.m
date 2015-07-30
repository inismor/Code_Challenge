//
//  RedditPostCell.m
//  
//
//  Created by Russ Wetmore on 7/28/15.
//
//

#import "RedditPostCell.h"
#ifdef DEBUG
#import "ConstraintPack.h"
#endif

NSString * const kTitleTextKeyPath = @"title.text";


@interface RedditPostCell ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentsWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *upsWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *downsWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *upsCenterXConstraint;
@property (nonatomic, assign) CGFloat statsViewWidth;

@end


@implementation RedditPostCell

- (void) awakeFromNib
{
	[super awakeFromNib];
	
	_statsViewWidth = _statsView.bounds.size.width;
}

- (void) layoutSubviews
{
	[super layoutSubviews];
	
	// If necessary, we have to resize the various labels to match the background art
	
	CGFloat currentStatsViewWidth = self.statsView.bounds.size.width;

	if (currentStatsViewWidth != self.statsViewWidth) {
		
		// Recalc width constraints to match current screen size
		[self.commentsWidthConstraint setConstant:self.commentsWidthConstraint.constant / self.statsViewWidth * currentStatsViewWidth];
		[self.upsWidthConstraint setConstant:self.upsWidthConstraint.constant / self.statsViewWidth * currentStatsViewWidth];
		[self.downsWidthConstraint setConstant:self.downsWidthConstraint.constant / self.statsViewWidth * currentStatsViewWidth];
		
		// Fix ups label centerX offset
		[self.upsCenterXConstraint setConstant:self.upsCenterXConstraint.constant / self.statsViewWidth * currentStatsViewWidth];

		// Remember what the new value is
		[self setStatsViewWidth:currentStatsViewWidth];
		
		// Force a constraints update
		[self setNeedsUpdateConstraints];
		[self layoutIfNeeded];
	}
}

#ifdef DEBUG
- (void) updateConstraints
{
	[super updateConstraints];
	[self generateViewReportForUser:@"russ" addNames:YES];
	NSLog(@"");
}
#endif

@end
