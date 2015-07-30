//
//  RedditSearchTextField.m
//  
//
//  Created by Russ Wetmore on 7/27/15.
//
//

#import "RedditSearchTextField.h"
#import "RedditFetchController.h"


CGFloat const kMagnifyingGlassAlpha = 0.5f;
CGFloat const kMagnifyingGlassLeftOffset = 8.0f;
CGFloat const kMagnifyingGlassRightOffset = 8.0f;
CGFloat const kMagnifyingGlassTopOffset = 8.0f;


@interface RedditSearchTextField ()

@property (nonatomic, assign) CGRect magnifyingGlassRect;

@end

@implementation RedditSearchTextField

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
	if (( self = [super initWithCoder:aDecoder] )) {
		UIImageView *magnifyingGlass = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search14"]];
		[magnifyingGlass setOpaque:NO];
		[magnifyingGlass setAlpha:kMagnifyingGlassAlpha];
		[self setLeftView:magnifyingGlass];
		
		CGSize magnifyingGlassSize = magnifyingGlass.bounds.size;
		_magnifyingGlassRect = CGRectMake(kMagnifyingGlassLeftOffset,
										  kMagnifyingGlassTopOffset,
										  magnifyingGlassSize.width,
										  magnifyingGlassSize.height);
		[self setLeftViewMode:UITextFieldViewModeAlways];
		[self setDelegate:self];
	}
	
	return self;
}

- (CGRect) leftViewRectForBounds:(CGRect)bounds
{
	return self.magnifyingGlassRect;
}

- (CGRect) textRectForBounds:(CGRect)bounds
{
	CGRect boundsCopy = bounds;
	boundsCopy.origin.x += self.magnifyingGlassRect.size.width + kMagnifyingGlassRightOffset;
	return boundsCopy;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
	[[NSNotificationCenter defaultCenter] postNotificationName:START_FETCH_NOTIFICATION
														object:textField.text];
	
	return NO;
}

@end
