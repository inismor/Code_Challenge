//
//  MainViewController.m
//  
//
//  Created by Russ Wetmore on 7/27/15.
//
//

@import Haneke_AFNetworking;

#import "MainViewController.h"
#import "RedditPostCell.h"
#import "RedditSearchTextField.h"
#import "RedditTitleLabel.h"


NSString * const kRedditPostCellReuseIdentifier = @"RedditPostCell";
NSString * const kNumberOfCommentsText = @"XXX Comments";
NSString * const kNumberOfUpsText = @"XXX Ups";
NSString * const kNumberOfDownsText = @"XXX Downs";
NSString * const kMailSubjectText = @"Check out what XXX said on Reddit: \"YYY\"";

CGFloat const kSlideAnimationDuration = 0.25f;
CGFloat const kSlideAnimationDistance = 20.0f;
CGFloat const kSlideAnimationDimAlpha = 0.0f;


@interface MainViewController ()

@property (nonatomic, strong) RedditFetchController *fetchController;
@property (weak, nonatomic) IBOutlet RedditSearchTextField *redditSearchTextField;
@property (nonatomic, strong) UIRefreshControl *refresh;

@end


@implementation MainViewController

#pragma mark - Object Lifecycle

- (void) dealloc
{
	// Clean up after ourselves
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - View Lifecycle

- (void) viewDidLoad
{
	[super viewDidLoad];
	
	// Prepare the table view
	UINib *cellNib = [UINib nibWithNibName:kRedditPostCellReuseIdentifier
									bundle:nil];
	[self.redditTableView registerNib:cellNib
			   forCellReuseIdentifier:kRedditPostCellReuseIdentifier];
	
	// Set up pull to refresh
	UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
	[refresh addTarget:self
				action:@selector(handlePullToRefresh:)
	  forControlEvents:UIControlEventValueChanged];
	[self.redditTableView addSubview:refresh];
	[self setRefresh:refresh];
	
	// Prepare for auto layout
	[self.redditTableView setRowHeight:UITableViewAutomaticDimension];
	[self.redditTableView setEstimatedRowHeight:132.0f];
	
	// Kick off the fetch controller with the default search term ("funny")
	[self setFetchController:[[RedditFetchController alloc] initWithDelegate:self]];
	[self.redditSearchTextField setText:_fetchController.searchTerm];
	
	UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg"]];
	[self.redditTableView setBackgroundView:background];

	// We need to know when the user hits the return key, so we can perform the same search
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleStartFetchNotification:)
												 name:START_FETCH_NOTIFICATION
											   object:nil];
}


#pragma mark - Notifications

// We get here if the user hits the return key.
// «note» holds the search term
- (void) handleStartFetchNotification:(NSNotification *)note
{
	[self.fetchController setSearchTerm:note.object];
	[self.fetchController start];
}


#pragma mark - TableView Data Source

- (NSInteger) tableView:(UITableView *)tableView
  numberOfRowsInSection:(NSInteger)section
{
	return self.fetchController.posts.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView
		  cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	RedditPostCell *cell = (RedditPostCell *)[tableView dequeueReusableCellWithIdentifier:kRedditPostCellReuseIdentifier];
	
	// Make sure we can see through to the table view's background image
	[cell setBackgroundColor:[UIColor clearColor]];
	
	// Fetch the post that occurs at the given row number
	NSDictionary *post = self.fetchController.posts[indexPath.row];
	
	// Fill in the blanks
	[cell.author setText:post[@"author"]];
	[cell.title setTitle:post[@"title"]];
	[cell.comments setText:[kNumberOfCommentsText stringByReplacingOccurrencesOfString:@"XXX"
																			withString:post[@"numComments"]]];
	[cell.ups setText:[kNumberOfUpsText stringByReplacingOccurrencesOfString:@"XXX"
																  withString:post[@"ups"]]];
	[cell.downs setText:[kNumberOfDownsText stringByReplacingOccurrencesOfString:@"XXX"
																	  withString:post[@"downs"]]];
	// Lazily load the author image
	[cell.thumbnail hnk_setImageFromURL:[NSURL URLWithString:post[@"thumbnail"]]];
	
	[cell updateConstraintsIfNeeded];
	
	return cell;
}


#pragma mark - TableView Delegate

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewAutomaticDimension;
}

- (void)       tableView:(UITableView *)tableView
 didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	// We never want the row to remain selected
	[tableView deselectRowAtIndexPath:indexPath
							 animated:YES];
	
	// Set up the mail's text
	RedditPostCell *cell = (RedditPostCell *)[tableView cellForRowAtIndexPath:indexPath];
	NSString *bodyText = [kMailSubjectText stringByReplacingOccurrencesOfString:@"XXX"
																	 withString:cell.author.text];
	// FIXME: we run the risk of finding the second key if it occurs in the author's name...
	bodyText = [bodyText stringByReplacingOccurrencesOfString:@"YYY"
												   withString:cell.title.text];
	// Invoke the activity and present it
	UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[bodyText]
																						 applicationActivities:nil];
	[self presentViewController:activityViewController
					   animated:YES
					 completion:nil];
}

- (void) tableView:(UITableView *)tableView
   willDisplayCell:(UITableViewCell *)cell
 forRowAtIndexPath:(NSIndexPath *)indexPath
{
	// We're animating the *content view* of the cell
	UIView *contentView = cell.contentView;
	
	// Calc the old and new frame values
	CGRect oldFrame = contentView.frame;
	CGRect newFrame = oldFrame;
	newFrame.origin.x += kSlideAnimationDistance;
	
	// Start with the slid-over frame, at 50% alpha
	[contentView setFrame:newFrame];
	[contentView setAlpha:kSlideAnimationDimAlpha];
	
	[UIView animateWithDuration:kSlideAnimationDuration
					  animations:^{
						  // and animate to the old frame at full alpha
						  [contentView setFrame:oldFrame];
						  [contentView setAlpha:1.0f];
					  }];
}


#pragma mark - RedditFetchController delegate

- (void) fetchControllerDidStartFetch:(RedditFetchController *)fetchController
{
	// FIXME: Nothing yet
}

- (void) fetchControllerDidEndFetch:(RedditFetchController *)fetchController
{
	[self.redditTableView reloadData];
}

- (void) fetchControllerDidFailFetchWithError:(RedditFetchController *)fetchController
										error:(NSError *)error
{
	NSLog(@"Failed to fetch posts...Error: %@", error);
}


#pragma mark - Handlers

- (IBAction) handleRedditSearchButton:(UIButton *)button
{
	[self.fetchController setSearchTerm:self.redditSearchTextField.text];
	[self.fetchController start];
}

- (void) handlePullToRefresh:(UIRefreshControl *)refresh
{
	
	// Kill the keyboard
	[self.view endEditing:YES];
	
	// Put the old search term back in the search bar
	[self.redditSearchTextField setText:self.fetchController.searchTerm];

	// Reexecute the fetch
	[self.fetchController start];
	[refresh endRefreshing];
}

@end
