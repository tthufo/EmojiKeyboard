//
//  EK_Saved_ViewController.m
//  EmojiKeyboard
//
//  Created by thanhhaitran on 3/6/16.
//  Copyright © 2016 thanhhaitran. All rights reserved.
//

#import "EK_Saved_ViewController.h"

#import "DropButton.h"

#import "btSimplePopUP.h"

@interface EK_Saved_ViewController ()<btSimplePopUpDelegate>
{
    IBOutlet UITableView * tableView;
    
    NSMutableArray * dataList;
    
    btSimplePopUP *popUpWithDelegate;
    
    NSString * message;
}

@end

@implementation EK_Saved_ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    dataList = [[NSMutableArray alloc] initWithArray:[System getAll]];
    
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
    [self.view addSubview:popUpWithDelegate];
    [popUpWithDelegate setPopUpStyle:BTPopUpStyleDefault];
    [popUpWithDelegate setPopUpBorderStyle:BTPopUpBorderStyleDefaultNone];
    
    [self didShowAdsBanner];
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


-(void)btSimplePopUP:(btSimplePopUP *)popUp
{
    
}

-(void)btSimplePopUP:(btSimplePopUP *)popUp didSelectItemAtIndex:(NSInteger)index
{
    UIPasteboard *appPasteBoard = [UIPasteboard generalPasteboard];
    
    appPasteBoard.persistent = YES;
    
    [appPasteBoard setString:message];
    
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
}

- (IBAction)didPressReturn:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    if(![self getValue:@"return"])
    {
        [self addValue:@"1" andKey:@"return"];
    }
    else
    {
        int k = [[self getValue:@"return"] intValue] + 1 ;
        
        [self addValue:[NSString stringWithFormat:@"%i", k] andKey:@"return"];
    }
    
    if([[self getValue:@"return"] intValue] % 5 == 0)
    {
        [self performSelector:@selector(showAds) withObject:nil afterDelay:0.5];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return dataList.count == 0 ? 1 : dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return dataList.count == 0 ? screenHeight - 80 : [[System getValue:((System*)dataList[indexPath.row]).key]  didConfigHeight:17 andDistance: 8 + 56 andExtra:17];
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"saveCell"];
    
    if(dataList.count == 0)
    {
        return [[NSBundle mainBundle] loadNibNamed:@"EK_Cells" owner:self options:nil][2];
    }
    
    if(!cell)
    {
        cell = [[NSBundle mainBundle] loadNibNamed:@"EK_Cells" owner:self options:nil][1];
    }
    
    ((UILabel*)[self withView:cell tag:11]).text = [System getValue:((System*)dataList[indexPath.row]).key];
    
    [((DropButton*)[self withView:cell tag:99]) addTarget:self action:@selector(didSelectEdit:) forControlEvents:UIControlEventTouchUpInside];
    
    ((DropButton*)[self withView:cell tag:99]).accessibilityLabel = ((System*)dataList[indexPath.row]).key;
    
    return cell;
}

- (void)didSelectEdit:(DropButton*)sender
{
    [sender didDropDownWithData:@[@{@"icon":@"edit"},@{@"icon":@"delete"}] andCompletion:^(id object){
        switch ([object[@"index"] intValue]) {
            case 0:
            {
                [self.delegate didEditMessage:@{@"id":sender.accessibilityLabel}];
                
                [self didPressReturn:nil];
            }
                break;
            case 1:
            {
                [[DropAlert shareInstance] alertWithInfor:@{/*@"option":@(0),@"text":@"wwww",*/@"cancel":@"Close",@"buttons":@[@"Delete"],@"title":@"Attention",@"message":@"This will remove your Emoji Message, are you sure?"} andCompletion:^(int indexButton, id object) {
                    switch (indexButton)
                    {
                        case 0:
                        {
                            [System removeValue:sender.accessibilityLabel];
                            
                            [dataList removeAllObjects];
                             
                            [dataList addObjectsFromArray:[System getAll]];
                            
                            [tableView reloadDataWithAnimation:YES];
                        }
                            break;
                        case 1:
                            
                            break;
                        default:
                            break;
                    }
                }];
            }
                break;
            default:
                break;
        }
    }];
    
    if(![self getValue:@"edit"])
    {
        [self addValue:@"1" andKey:@"edit"];
    }
    else
    {
        int k = [[self getValue:@"edit"] intValue] + 1 ;
        
        [self addValue:[NSString stringWithFormat:@"%i", k] andKey:@"edit"];
    }
    
    if([[self getValue:@"edit"] intValue] % 4 == 0)
    {
        [self performSelector:@selector(showAds) withObject:nil afterDelay:0.5];
    }
}

- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(dataList.count == 0)
    {
        return;
    }
    
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [popUpWithDelegate show:BTPopUPAnimateWithFade];
    
    message = [System getValue:((System*)dataList[indexPath.row]).key];
    
    if(![self getValue:@"saved"])
    {
        [self addValue:@"1" andKey:@"saved"];
    }
    else
    {
        int k = [[self getValue:@"saved"] intValue] + 1 ;
        
        [self addValue:[NSString stringWithFormat:@"%i", k] andKey:@"saved"];
    }
    
    if([[self getValue:@"saved"] intValue] % 5 == 0)
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
