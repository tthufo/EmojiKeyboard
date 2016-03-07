//
//  EK_Saved_ViewController.h
//  EmojiKeyboard
//
//  Created by thanhhaitran on 3/6/16.
//  Copyright © 2016 thanhhaitran. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SaveDelegate <NSObject>

- (void)didEditMessage:(NSDictionary*)dict;

@end

@interface EK_Saved_ViewController : UIViewController

@property (nonatomic, assign) id <SaveDelegate> delegate;

@end
