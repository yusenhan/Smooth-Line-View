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

@synthesize undoButton;
@synthesize redoButton;
@synthesize clearButton;
@synthesize eraserButton;
@synthesize save2FileButton;
@synthesize save2AlbumButton;
@synthesize colorButton;

- (void)viewDidLoad
{
    slv = [[[SmoothLineView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y + 42, self.view.bounds.size.width, self.view.bounds.size.height - 42)] autorelease];
    slv.delegate = self;
    [self.view addSubview:slv];
    
    [self initButton];
    
    [super viewDidLoad];
    
}

-(void)setButtonAttrib:(UIGlossyButton*)_button
{
    [_button useWhiteLabel: YES];
    _button.buttonCornerRadius = 2.0; _button.buttonBorderWidth = 1.0f;
	[_button setStrokeType: kUIGlossyButtonStrokeTypeBevelUp];
    _button.tintColor = _button.borderColor = [UIColor colorWithRed:70.0f/255.0f green:105.0f/255.0f blue:192.0f/255.0f alpha:1.0f];
}

- (void) initButton
{
    undoButton = (UIGlossyButton*) [self.view viewWithTag: 1001];
    [self setButtonAttrib:undoButton];    
    
    redoButton = (UIGlossyButton*) [self.view viewWithTag: 1002];
    [self setButtonAttrib:redoButton];
    
    clearButton = (UIGlossyButton*) [self.view viewWithTag: 1003];
    [self setButtonAttrib:clearButton];
    
    eraserButton = (UIGlossyButton*) [self.view viewWithTag: 1004];
    [self setButtonAttrib:eraserButton];
    
    colorButton = (UIGlossyButton*) [self.view viewWithTag: 1005];
    [self setButtonAttrib:colorButton];
    
    save2FileButton = (UIGlossyButton*) [self.view viewWithTag: 1006];   
    [self setButtonAttrib:save2FileButton];
    
    save2AlbumButton = (UIGlossyButton*) [self.view viewWithTag: 1007];
    [self setButtonAttrib:save2AlbumButton];
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

-(IBAction)save2FileButtonClicked:(id)sender
{
    [slv save2FileButtonClicked];
    
}

-(IBAction)save2AlbumButtonClicked:(id)sender
{
    [slv save2AlbumButtonClicked];
    
}


#pragma mark toolbarDelegate 
-(void) setUndoButtonEnable:(NSNumber*)isEnable
{
    [undoButton setEnabled:[isEnable boolValue]];
}
-(void) setRedoButtonEnable:(NSNumber*)isEnable
{
    [redoButton setEnabled:[isEnable boolValue]];
}
-(void) setClearButtonEnable:(NSNumber*)isEnable
{
    [clearButton setEnabled:[isEnable boolValue]];
}
-(void) setEraserButtonEnable:(NSNumber*)isEnable
{
    [eraserButton setEnabled:[isEnable boolValue]];
}
-(void) setSave2FileButtonEnable:(NSNumber*)isEnable
{
    [save2FileButton setEnabled:[isEnable boolValue]];
}
-(void) setSave2AlbumButtonEnable:(NSNumber*)isEnable
{
    [save2AlbumButton setEnabled:[isEnable boolValue]];
}

@end


