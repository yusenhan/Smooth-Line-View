//
//  Smooth_Line_ViewViewController.m
//  Smooth Line View
//
//  Created by Levi Nunnink on 8/10/11.
//  Copyright 2011 culturezoo. All rights reserved.
//
//  modify by Hanson @ Splashtop

#import "Smooth_Line_ViewViewController.h"

@implementation Smooth_Line_ViewViewController

- (void)viewDidLoad
{
    slv = [[[SmoothLineView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y + 50, self.view.bounds.size.width, self.view.bounds.size.height - 50)] autorelease];
    [self.view addSubview:slv];

    [super viewDidLoad];

}


- (void) applyPickedColor: (InfColorPickerController*) picker
{
    const CGFloat *rgb = CGColorGetComponents(picker.resultColor.CGColor);
    
    float red = rgb[0];
    float green = rgb[1];
    float blue = rgb[2];
    
    float alpha = CGColorGetAlpha(picker.resultColor.CGColor);
    
    [slv setColor:red g:green b:blue a:alpha];
}

#pragma mark	UIPopoverControllerDelegate methods
//------------------------------------------------------------------------------

- (void) popoverControllerDidDismissPopover: (UIPopoverController*) popoverController
{
	if( [ popoverController.contentViewController isKindOfClass: [ InfColorPickerController class ] ] ) {
		InfColorPickerController* picker = (InfColorPickerController*) popoverController.contentViewController;
		[ self applyPickedColor: picker ];
	}
	
	if( popoverController == activePopover ) {
		[ activePopover release ];
		activePopover = nil;
	}
}

//------------------------------------------------------------------------------

- (void) showPopover: (UIPopoverController*) popover from: (id) sender
{
	popover.delegate = self;
	
	activePopover = [ popover retain ];
	
	if( [ sender isKindOfClass: [ UIBarButtonItem class ] ] ) {
		[ activePopover presentPopoverFromBarButtonItem: sender
							   permittedArrowDirections: UIPopoverArrowDirectionAny
											   animated: YES ];
	}
	else {
		UIView* senderView = sender;
		
		[ activePopover presentPopoverFromRect: [ senderView bounds ] 
										inView: senderView 
					  permittedArrowDirections: UIPopoverArrowDirectionAny 
									  animated: YES ];
	}
}

//------------------------------------------------------------------------------

- (BOOL) dismissActivePopover
{
	if( activePopover ) {
		[ activePopover dismissPopoverAnimated: YES ];
		[ self popoverControllerDidDismissPopover: activePopover ];
		
		return YES;
	}
	
	return NO;
}

//------------------------------------------------------------------------------
#pragma mark	InfHSBColorPickerControllerDelegate methods
//------------------------------------------------------------------------------

- (void) colorPickerControllerDidChangeColor: (InfColorPickerController*) picker
{
		[ self applyPickedColor: picker ];
}

//------------------------------------------------------------------------------

- (void) colorPickerControllerDidFinish: (InfColorPickerController*) picker
{
	[ self applyPickedColor: picker ];
    
	[ activePopover dismissPopoverAnimated: YES ];
}


-(IBAction)undoButtonClicked:(id)sender
{
    [slv undoButtonClicked];
    
}

-(IBAction)redoButtonClicked:(id)sender
{
    [slv redoButtonClicked];
    
}

-(IBAction)clearButtonClicked:(id)sender
{
    [slv clearButtonClicked];
    
}

-(IBAction)eraserButtonClicked:(id)sender
{
    [slv eraserButtonClicked];
    
}



-(IBAction)changeColorClicked:(id)sender
{
    if( [ self dismissActivePopover ] )
		return;
	
	InfColorPickerController* picker = [ InfColorPickerController colorPickerViewController ];
	
	picker.sourceColor = self.view.backgroundColor;
	picker.delegate = self;
	
	UIPopoverController* popover = [ [ [ UIPopoverController alloc ] initWithContentViewController: picker ] autorelease ];
	
	[ self showPopover: popover from: sender ];
}



@end


