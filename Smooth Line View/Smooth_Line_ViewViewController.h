//
//  Smooth_Line_ViewViewController.h
//  Smooth Line View
//
//  Created by Levi Nunnink on 8/10/11.
//  Copyright 2011 culturezoo. All rights reserved.
//
//  modify by Hanson @ Splashtop

#import <UIKit/UIKit.h>
#import "SmoothLineView.h"
#import "InfColorPicker.h"

@interface Smooth_Line_ViewViewController : UIViewController < InfColorPickerControllerDelegate,UIPopoverControllerDelegate>
{
    SmoothLineView *slv;  
    UIPopoverController* activePopover;

}
@end
