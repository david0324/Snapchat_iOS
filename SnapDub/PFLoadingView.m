/*
 *  Copyright (c) 2014, Parse, LLC. All rights reserved.
 *
 *  You are hereby granted a non-exclusive, worldwide, royalty-free license to use,
 *  copy, modify, and distribute this software in source code or binary form for use
 *  in connection with the web services and APIs provided by Parse.
 *
 *  As with any software that integrates with the Parse platform, your use of
 *  this software is subject to the Parse Terms of Service
 *  [https://www.parse.com/about/terms]. This copyright notice shall be
 *  included in all copies or substantial portions of the software.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 *  FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 *  COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
 *  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 *  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 */

#import "PFLoadingView.h"

#import "PFRect.h"

@interface PFLoadingView ()

@property (nonatomic, strong) UIView* coverView;
@property (nonatomic, strong) UILabel *loadingLabel;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end

@implementation PFLoadingView

#pragma mark -
#pragma mark Init

-(void) setLabelText: (NSString*) msg
{
    _loadingLabel.text = msg;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        CGRect screenRect = CGRectMake(self.center.x-80, self.center.y+40, 160, 80);
        //create a new view with the same size
        _coverView = [[UIView alloc] initWithFrame:CGRectZero];
        // change the background color to black and the opacity to 0.6
        _coverView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        _coverView.center = self.center;
        _coverView.layer.cornerRadius = 05;
        // add this new view to your main view
        [self addSubview:_coverView];
    
        
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
      //  [_activityIndicator setColor:[UIColor colorWithRed:0.6 green:0.8 blue:1.0 alpha:1.0]];
        
        [_activityIndicator setColor:[UIColor whiteColor] ];
        /*
        _activityIndicator.layer.cornerRadius = 05;
        _activityIndicator.opaque = NO;
        _activityIndicator.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.6f];
        _activityIndicator.center = self.center;
        _activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [_activityIndicator setColor:[UIColor colorWithRed:0.6 green:0.8 blue:1.0 alpha:1.0]];
        */
        
        [_activityIndicator startAnimating];
        [self addSubview:_activityIndicator];

        _loadingLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _loadingLabel.text = NSLocalizedString(@"Loading...", @"Loading message of PFQueryTableViewController");
        _loadingLabel.backgroundColor = [UIColor clearColor];
        _loadingLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
        _loadingLabel.shadowColor = [UIColor blackColor];
        _loadingLabel.textColor = [UIColor whiteColor];
        [_loadingLabel sizeToFit];
        [self addSubview:_loadingLabel];
        
        
    }
    return self;
}

#pragma mark -
#pragma mark UIView

- (void)layoutSubviews {
    [super layoutSubviews];

    const CGRect bounds = self.bounds;

    CGFloat viewsInset = 4.0f;
    CGFloat startX = floorf((CGRectGetMaxX(bounds)
                             - CGRectGetWidth(_loadingLabel.frame)
                             - CGRectGetWidth(_activityIndicator.frame)
                             - viewsInset)
                            / 2.0f);

    CGRect activityIndicatorFrame = PFRectMakeWithSizeCenteredInRect(_activityIndicator.frame.size, bounds);
    activityIndicatorFrame.origin.x = startX;
    _activityIndicator.frame = activityIndicatorFrame;

    CGRect loadingLabelFrame = PFRectMakeWithSizeCenteredInRect(_loadingLabel.frame.size, bounds);
    loadingLabelFrame.origin.x = CGRectGetMaxX(activityIndicatorFrame) + viewsInset;
    _loadingLabel.frame = loadingLabelFrame;
    
    _coverView.frame = PFRectMakeWithSizeCenteredInRect(CGSizeMake(160, 80), bounds);
}

@end
