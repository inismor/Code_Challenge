//
//  UIView+AutoLayoutDebugging.m
//  
//
//  Created by Russ Wetmore on 7/28/15.
//
//


#import "UIView+AutoLayoutDebugging.h"


@implementation UIView (AutoLayoutDebugging)

- (void) printAutoLayoutTrace
{
#ifdef DEBUG
	NSLog(@"%@", [self performSelector:@selector(_autolayoutTrace)]);
#endif
}

- (void) exerciseAmbiguityInLayoutRepeatedly:(BOOL)recursive
{
#ifdef DEBUG
	if (self.hasAmbiguousLayout) {
		[NSTimer scheduledTimerWithTimeInterval:.5
										 target:self
									   selector:@selector(exerciseAmbiguityInLayout)
									   userInfo:nil
										repeats:YES];
	}
	if (recursive) {
		for (UIView *subview in self.subviews) {
			[subview exerciseAmbiguityInLayoutRepeatedly:YES];
		}
	}
#endif
}

@end
