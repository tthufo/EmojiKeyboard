//
//  EK_First_ViewController.m
//  EmojiKeyboard
//
//  Created by thanhhaitran on 3/2/16.
//  Copyright © 2016 thanhhaitran. All rights reserved.
//

#import "EK_First_ViewController.h"

#import "EK_Saved_ViewController.h"

#import "btSimplePopUP.h"

@interface EK_First_ViewController ()<SaveDelegate, btSimplePopUpDelegate>
{
    IBOutlet UIView * emoView, * buttonView, * previewView, * innerView;
    
    IBOutlet UICollectionView * collectionView;
    
    NSMutableArray * dataList;
    
    UITextView * textView;
    
    BOOL isShow, isEdit, isKeyboard;
    
    IBOutlet UIScrollView * scrollView;
    
    NSString * uuidString;
    
    btSimplePopUP *popUpWithDelegate;
}

@end

@implementation EK_First_ViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self registerForKeyboardNotifications:NO andSelector:@[@"keyboardWasShown:",@"keyboardWillBeHidden:"]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self registerForKeyboardNotifications:YES andSelector:@[@"keyboardWasShown:",@"keyboardWillBeHidden:"]];
}

- (IBAction)didPressButton:(UIButton*)sender
{
    if(sender.tag == 0)
    {
        [textView becomeFirstResponder];
    }
    else
    {
        [self initEmoji:[NSString stringWithFormat:@"%i",sender.tag]];
    }
    
    if(sender.tag != 0)
    {
        [self.view endEditing:YES];
    }
    
    [self didHightlightButton:sender.tag];
}

- (void)keyboardWasShown:(NSNotification *)notification
{
    if(!isShow)
    {
        [UIView animateWithDuration:0.3 animations:^{
        CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        CGRect frame = buttonView.frame;
        frame.origin.y -= keyboardSize.height + 45 + (SYSTEM_VERSION_LESS_THAN(@"7") ? 20 : 0);
        buttonView.frame = frame;
            
        CGRect frame1 = previewView.frame;
        frame1.origin.y = (SYSTEM_VERSION_LESS_THAN(@"7") ? 0 : 20);
        frame1.size.height = screenHeight - keyboardSize.height - 20 - 60 - (SYSTEM_VERSION_LESS_THAN(@"7") ? 00 : 0);
        previewView.frame = frame1;
        
        emoView.frame = CGRectMake(0, screenHeight, screenWidth, keyboardSize.height);
        [self.view addSubview:emoView];
        CGRect frame2 = emoView.frame;
        frame2.origin.y -= keyboardSize.height + (SYSTEM_VERSION_LESS_THAN(@"7") ? 20 : 0);
        emoView.frame = frame2;
        
        isShow = YES;
        } completion:^(BOOL finished) {
            [self hideSVHUD];
        }];
        
        textView.frame = CGRectMake(innerView.frame.origin.x + 10, innerView.frame.origin.x + 10, innerView.frame.size.width - 20, innerView.frame.size.height - 20);
        
        
        popUpWithDelegate = [[btSimplePopUP alloc]initWithItemImage:@[
                                                                      [UIImage imageNamed:@"Fbook"],
                                                                      [UIImage imageNamed:@"Fmess"],
                                                                      [UIImage imageNamed:@"VOC_icon"],
                                                                      [UIImage imageNamed:@"Safari"],
                                                                      [UIImage imageNamed:@"twitte"],
                                                                      [UIImage imageNamed:@"share"]
                                                                      ]
                                                          andTitles:    @[
                                                                          @"Facebook", @"Messenger",@"Message", @"Safari",@"Twitter",@"Share"
                                                                          ]
                             
                                                     andActionArray:nil addToViewController:self];
        popUpWithDelegate.delegate = self;
        [self.view insertSubview:popUpWithDelegate aboveSubview: emoView];
        [popUpWithDelegate setPopUpStyle:BTPopUpStyleDefault];
        [popUpWithDelegate setPopUpBorderStyle:BTPopUpBorderStyleDefaultNone];
    }
}

- (void)keyboardWillBeHidden:(NSNotification *)notification
{
//    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
//    CGRect frame = buttonView.frame;
//    frame.origin.y += keyboardSize.height;
//    buttonView.frame = frame;
//
//    emoView.frame = CGRectMake(0, screenHeight, screenWidth, keyboardSize.height);
//    [self.view addSubview:emoView];
//    
//    CGRect frame1 = emoView.frame;
//    frame1.origin.y -= keyboardSize.height;
//    emoView.frame = frame1;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[AVHexColor colorWithHexString:@"#FFFFFF"]}];
    
    NSArray *ver = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    if ([[ver objectAtIndex:0] intValue] >= 7)
    {
        {
            self.navigationController.navigationBar.barTintColor = [AVHexColor colorWithHexString:kColor];
            
            self.navigationController.navigationBar.translucent = NO;
        }
    }
    else
    {
        {
            self.navigationController.navigationBar.tintColor = [AVHexColor colorWithHexString:kColor];
        }
    }
    
    dataList = [NSMutableArray new];
    
    [collectionView registerNib:[UINib nibWithNibName:@"EM_Cells" bundle:nil] forCellWithReuseIdentifier:@"imageCell"];
    
    [self initEmoji:@"1"];
    
    previewView.frame = CGRectMake(0, -screenHeight, screenWidth, 0);
    
    [self.view addSubview:previewView];
    
    buttonView.frame = CGRectMake(0, screenHeight, screenWidth, 45);

    [self.view addSubview:buttonView];
    
    [self initScrollView];
    
    [self didHightlightButton:0];
        
    [[LTRequest sharedInstance] didRequestInfo:@{@"absoluteLink":@"https://dl.dropboxusercontent.com/s/niogag1konj3pw5/EmojiBoard1_0.plist",@"overrideError":@(1),@"overrideLoading":@(1),@"host":self} withCache:^(NSString *cacheString) {
    } andCompletion:^(NSString *responseString, NSError *error, BOOL isValidated) {
        
        if(!isValidated)
        {
            return ;
        }
        
        NSData *data = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSError * er = nil;
        NSDictionary *dict = [self returnDictionary:[XMLReader dictionaryForXMLData:data
                                                                            options:XMLReaderOptionsProcessNamespaces
                                                                              error:&er]];
        
        [self addObject:@{@"banner":dict[@"banner"],@"fullBanner":dict[@"fullBanner"],@"adsMob":dict[@"ads"]} andKey:@"adsInfo"];
        
        BOOL isUpdate = [dict[@"version"] compare:[self appInfor][@"majorVersion"] options:NSNumericSearch] == NSOrderedDescending;
        
        if(isUpdate)
        {
            [[DropAlert shareInstance] alertWithInfor:@{/*@"option":@(0),@"text":@"wwww",*/@"cancel":@"Close",@"buttons":@[@"Download now"],@"title":@"New Update",@"message":dict[@"update_message"]} andCompletion:^(int indexButton, id object) {
                switch (indexButton)
                {
                    case 0:
                    {
                        if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:dict[@"url"]]])
                        {
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:dict[@"url"]]];
                        }
                    }
                        break;
                    case 1:
                        
                        break;
                    default:
                        break;
                }
            }];
        }
        
        [self didShowAdsBanner];
        
    }];
    
    [textView becomeFirstResponder];
    
    isKeyboard = YES;
    
    [self showSVHUD:@"Loading" andOption:0];
}

- (void)btSimplePopUP:(btSimplePopUP *)popUp
{
    if(isKeyboard)
    {
        [textView becomeFirstResponder];
    }
}

-(void)btSimplePopUP:(btSimplePopUP *)popUp didSelectItemAtIndex:(NSInteger)index
{
    UIPasteboard *appPasteBoard = [UIPasteboard generalPasteboard];
    
    appPasteBoard.persistent = YES;
    
    [appPasteBoard setString:textView.text];
    
    switch (index)
    {
        case 0:
        {
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fb://"]])
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"fb://"]];
            }
            else
            {
                [self alert:@"Attention" message:@"Can't open Facebook"];
            }
        }
            break;
        case 1:
        {
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fb://messaging"]])
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"fb://messaging"]];
            }
            else
            {
                [self alert:@"Attention" message:@"Can't open Facebook Messenger"];
            }
        }
            break;
        case 2:
        {
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"sms://"]])
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"sms://"]];
            }
            else
            {
                [self alert:@"Attention" message:@"Can't open Message"];
            }
        }
            break;
        case 3:
        {
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"https://facebook.com"]])
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://facebook.com"]];
            }
            else
            {
                [self alert:@"Attention" message:@"Can't open Safari"];
            }
        }
            break;
        case 4:
        {
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter://"]])
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"twitter://"]];
            }
            else
            {
                [self alert:@"Attention" message:@"Can't open Twitter"];
            }
        }
            break;
        case 5:
        {
            [[FB shareInstance] startShareWithInfo:@[@"Plenty of emotion and stickers for your message and chatting, have fun!",@"https://itunes.apple.com/us/developer/thanh-hai-tran/id1073174100",[UIImage imageNamed:@"emoboard"]] andBase:nil andRoot:self andCompletion:^(NSString *responseString, id object, int errorCode, NSString *description, NSError *error) {
                
            }];
        }
            break;
        default:
            break;
    }
    
    if(isKeyboard)
    {
        [textView becomeFirstResponder];
    }
}

- (void)didShowAdsBanner
{
    if([[self infoPlist][@"showAds"] boolValue])
    {
        if([[self getObject:@"adsInfo"][@"adsMob"] boolValue] && [self getObject:@"adsInfo"][@"banner"])
        {
            [[Ads sharedInstance] G_didShowBannerAdsWithInfor:@{@"host":self,@"X":@(screenWidth),@"Y":@(screenHeight - 50),@"adsId":[self getObject:@"adsInfo"][@"banner"]/*,@"device":@""*/} andCompletion:^(BannerEvent event, NSError *error, id banner) {
                
                switch (event)
                {
                    case AdsDone:
                        
                        break;
                    case AdsFailed:
                        
                        break;
                    default:
                        break;
                }
            }];
        }
    }
    
    if([[self infoPlist][@"showAds"] boolValue])
    {
        if(![[self getObject:@"adsInfo"][@"adsMob"] boolValue])
        {
            [[Ads sharedInstance] S_didShowBannerAdsWithInfor:@{@"host":self,@"Y":@(screenHeight - 50)} andCompletion:^(BannerEvent event, NSError *error, id bannerAd) {
                switch (event)
                {
                    case AdsDone:
                    {
                        
                    }
                        break;
                    case AdsFailed:
                    {
                        NSLog(@"%@",error);
                    }
                        break;
                    case AdsWillPresent:
                    {
                        
                    }
                        break;
                    case AdsWillLeave:
                    {
                        
                    }
                        break;
                    default:
                        break;
                }
            }];
        }
    }
}

- (NSDictionary*)returnDictionary:(NSDictionary*)dict
{
    NSMutableDictionary * result = [NSMutableDictionary new];
    
    for(NSDictionary * key in dict[@"plist"][@"dict"][@"key"])
    {
        result[key[@"jacknode"]] = dict[@"plist"][@"dict"][@"string"][[dict[@"plist"][@"dict"][@"key"] indexOfObject:key]][@"jacknode"];
    }
    
    return result;
}

- (void)initScrollView
{
    NSArray * icons = @[@"😀",@"🐵",@"🎨",@"🍇",@"💘",@"💌",@"🏔",@"🇦🇫"];
    
    for(int i = 0 ; i < (SYSTEM_VERSION_LESS_THAN(@"7") ? 5 : 8); i ++)
    {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        button.tag = i + 1;
        
        button.frame = CGRectMake(i * 35, 7, 35, 35);
        
        [button setTitle:icons[i] forState:UIControlStateNormal];
        
        [scrollView addSubview:button];
        
        [button addTarget:self action:@selector(didPressButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    scrollView.contentSize = CGSizeMake((SYSTEM_VERSION_LESS_THAN(@"7") ? 5 : 8) * 35, 35);
}

- (IBAction)didSelectOptions:(UIButton*)sender
{
    switch (sender.tag)
    {
        case 0:
        {
            [popUpWithDelegate show:BTPopUPAnimateWithFade];
            
            if([textView isFirstResponder])
            {
                [self.view endEditing:YES];
            }
        }
            break;
        case 1:
        {
            if(textView.text.length == 0)
            {
                [self showToast:@"Emoji Message empty" andPos:1];
                return;
            }
            
            [[DropAlert shareInstance] alertWithInfor:@{/*@"option":@(0),@"text":@"wwww",*/@"cancel":@"Close",@"buttons":@[@"Save"],@"title":@"Attention",@"message":isEdit ? @"Are you sure want to edit Emoji Message ?" : @"Are you sure want to save this Emoji Message?"} andCompletion:^(int indexButton, id object) {
                switch (indexButton)
                {
                    case 0:
                    {
                        [System addValue:textView.text andKey: isEdit ? uuidString : [self uuidString]];
                        
                        [self showToast:isEdit ? @"Emoji Message is edited" : @"Emoji Message is saved" andPos:0];
                        
                        if(isEdit)
                        {
                            textView.text = [self getValue:@"recent"];
                        }
                        
                        isEdit = NO;
                    }
                        break;
                    default:
                        break;
                }
            }];
        }
            break;
        case 2:
        {
            EK_Saved_ViewController * save = [EK_Saved_ViewController new];
            
            save.delegate = self;
            
            [self presentViewController:save animated:YES completion:^{
                
            }];
        }
            break;
        default:
            break;
    }
}

- (void)didHightlightButton:(int)tag
{
    for(UIView * view in buttonView.subviews)
    {
        if([view isKindOfClass:[UIButton class]])
        {
            if(view.tag == tag)
            {
                view.transform = CGAffineTransformMakeScale(1.3, 1.3);
            }
            else
            {
                view.transform = CGAffineTransformMakeScale(1.0, 1.0);
            }
        }
        for(UIView * vi in scrollView.subviews)
        {
            if([vi isKindOfClass:[UIButton class]])
            {
                if(vi.tag == tag)
                {
                    vi.transform = CGAffineTransformMakeScale(1.5, 1.5);
                }
                else
                {
                    vi.transform = CGAffineTransformMakeScale(1.0, 1.0);
                }
            }
        }
    }
    isKeyboard = tag == 0;
}

- (void)initEmoji:(NSString*)name
{
    [dataList removeAllObjects];
    
    for(NSDictionary * emo in [[NSArray new] arrayWithPlist:name])
    {
        [dataList addObject:emo];
    }
    
    [collectionView reloadData];
}


- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    return dataList.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"imageCell" forIndexPath:indexPath];
    
    ((UILabel*)[self withView:cell tag:15]).text = dataList[indexPath.item][@"image"];

    ((UILabel*)[self withView:cell tag:15]).font = [UIFont fontWithName:@"AppleColorEmoji" size:29];
    
    [((UILabel*)[self withView:cell tag:15]) withBorder:@{@"Bwidth":@(1)}];
    
    
    ((UIView*)[self withView:cell tag:16]).hidden = YES;
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(screenWidth / 8 - 0.0, screenWidth / 8 - 0.0);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0;
}

- (void)collectionView:(UICollectionView *)_collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    [self pulse:[_collectionView cellForItemAtIndexPath:indexPath] toSize:1.4 withDuration:0.3];

    [textView replaceRange:textView.selectedTextRange withText:dataList[indexPath.item][@"image"]];

    [textView scrollRangeToVisible:NSMakeRange([textView.text length], 0)];
    
    if(![self getValue:@"multi"])
    {
        [self addValue:@"1" andKey:@"multi"];
    }
    else
    {
        int k = [[self getValue:@"multi"] intValue] + 1 ;
        
        [self addValue:[NSString stringWithFormat:@"%i", k] andKey:@"multi"];
    }
    
    if([[self getValue:@"multi"] intValue] % 10 == 0)
    {
        [self performSelector:@selector(showAds) withObject:nil afterDelay:0.5];
    }
}

- (void)showAds
{
    if([[self infoPlist][@"showAds"] boolValue])
    {
        if(![[self getObject:@"adsInfo"][@"adsMob"] boolValue])
        {
            [[Ads sharedInstance] S_didShowFullAdsWithInfor:@{} andCompletion:^(BannerEvent event, NSError *error, id bannerAd) {
                switch (event)
                {
                    case AdsDone:
                    {
                        
                    }
                        break;
                    case AdsFailed:
                    {
                        
                    }
                        break;
                    case AdsWillPresent:
                    {
                        
                    }
                        break;
                    case AdsWillLeave:
                    {
                        
                    }
                        break;
                    default:
                        break;
                }
            }];
        }
        else
        {
            if([self getObject:@"adsInfo"][@"fullBanner"])
            {
                [[Ads sharedInstance] G_didShowFullAdsWithInfor:@{@"host":self,@"adsId":[self getObject:@"adsInfo"][@"fullBanner"]/*,@"device":@""*/} andCompletion:^(BannerEvent event, NSError *error, id banner) {
                    
                    switch (event)
                    {
                        case AdsDone:
                            
                            break;
                        case AdsFailed:
                            
                            break;
                        default:
                            break;
                    }
                }];
            }
        }
    }
}

- (void)didEditMessage:(NSDictionary*)dict
{
    [self addValue:textView.text andKey:@"recent"];
    
    textView.text = [System getValue:dict[@"id"]];
    
    uuidString = dict[@"id"];
    
    isEdit = YES;
}

- (void)pulse:(UIView*)view toSize: (float) value withDuration:(float) duration
{
    [UIView animateWithDuration:duration
                     animations:^{
                         CABasicAnimation *pulseAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
                         pulseAnimation.duration = duration;
                         pulseAnimation.toValue = [NSNumber numberWithFloat:value];;
                         pulseAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                         pulseAnimation.autoreverses = YES;
                         pulseAnimation.repeatCount = 1;
                         [view.layer addAnimation:pulseAnimation forKey:nil];
                     }
                     completion:^(BOOL finished)
     {
     }];
}

- (IBAction)didPressKeyboard:(id)sender
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
