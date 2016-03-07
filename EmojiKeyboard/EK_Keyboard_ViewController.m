//
//  BinhLuanTinTucViewController.m
//  TheThaoSoVersion2
//
//  Created by thanhhaitran on 10/22/15.
//  Copyright © 2015 Hanh. All rights reserved.
//

#import "EK_Keyboard_ViewController.h"
#import "DAKeyboardControl.h"
#import "HPGrowingTextView.h"

@interface EK_Keyboard_ViewController ()<HPGrowingTextViewDelegate, UIAlertViewDelegate>
{
    IBOutlet UITableView * tableView;
    NSMutableArray * dataList;
    UIToolbar * toolBar;
    HPGrowingTextView * textView;
    BOOL isLoadMore;
}

@end

@implementation EK_Keyboard_ViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [tableView relaxHeader];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    dataList = [NSMutableArray new];
    
    UIBarButtonItem *menu = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"close"] style:UIBarButtonItemStylePlain target:self action:@selector(didPressBack:)];
    self.navigationItem.leftBarButtonItem = menu;
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{
                                                           NSForegroundColorAttributeName: [UIColor whiteColor],
                                                           NSFontAttributeName: [UIFont fontWithName:@"Helvetica-Bold" size:17.0f]
                                                           }];
    [self didSetupToolBar];
    
    [[NSNotificationCenter defaultCenter] addObserver:tableView selector:@selector(relaxHeader) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)didSetupToolBar
{
    toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f,
                                                          self.view.frame.size.height - 60.0f,
                                                          screenWidth,
                                                          60.0f)];
    
    toolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    toolBar.barTintColor = [AVHexColor colorWithHexString:@"#DADADA"];
    [self.view addSubview:toolBar];
    
    textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(10.0f,
                                                                   10.0f,
                                                                   toolBar.bounds.size.width - 65.0f,
                                                                   90.0f)];
    
    textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    textView.minNumberOfLines = 1;
    textView.maxNumberOfLines = 5;
    textView.returnKeyType = UIReturnKeyGo;
    textView.delegate = self;
    textView.internalTextView.autocorrectionType = UITextAutocorrectionTypeNo;
    textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    textView.backgroundColor = [UIColor whiteColor];
    textView.placeholder = @"";
    [textView withBorder:@{@"Bcorner":@(6)}];
    [toolBar addSubview:textView];
    
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [sendButton setBackgroundImage:[UIImage imageNamed:@"ic_send"] forState:UIControlStateNormal];
    [sendButton addTapTarget:self action:@selector(didPressSend)];
    sendButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    sendButton.frame = CGRectMake(toolBar.bounds.size.width - 45,
                                  11,
                                  36,
                                  36);
    [toolBar addSubview:sendButton];
    
    self.view.keyboardTriggerOffset = toolBar.bounds.size.height;
    
    __block UIView * _toolBar = toolBar;
    
    __block UITableView * _tableView = tableView;
    
    [self.view addKeyboardPanningWithFrameBasedActionHandler:^(CGRect keyboardFrameInView, BOOL opening, BOOL closing) {
        
        CGRect toolBarFrame = _toolBar.frame;
        toolBarFrame.origin.y = keyboardFrameInView.origin.y - toolBarFrame.size.height;
        _toolBar.frame = toolBarFrame;
        
        CGRect tableViewFrame = _tableView.frame;
        tableViewFrame.size.height = toolBarFrame.origin.y;
        _tableView.frame = tableViewFrame;
        
        if(opening)
        {
            _tableView.contentInset = UIEdgeInsetsMake(64 + 0, 0, 0, 0);
        }
        if(closing)
        {
            _tableView.contentInset = UIEdgeInsetsMake(64 + 0, 0, _toolBar.frame.size.height, 0);
        }
        
    } constraintBasedActionHandler:nil];
    
    CGRect tableViewFrame = tableView.frame;
    tableViewFrame.size.height -= toolBar.frame.size.height;
    tableView.frame = tableViewFrame;
    
    tableView.contentInset = UIEdgeInsetsMake(0, 0, toolBar.frame.size.height + 0, 0);
}

- (void)didPressSend
{

}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 35;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    return nil;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return dataList.count == 0 ? 88 : [dataList[indexPath.row][@"content"] didConfigHeight:17 andDistance:111 andExtra:65];
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"emoCell"];
    
    if(!cell)
    {
        cell = [[NSBundle mainBundle] loadNibNamed:@"EK_Cells" owner:self options:nil][0];
    }
    
//    [((UIImageView*)[self withView:cell tag:11]) sd_setImageWithURL:[NSURL URLWithString:[dataList[indexPath.row][@"user_avatar"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:kAvatar];
//    
//    ((UILabel*)[self withView:cell tag:12]).text = ((NSString*)dataList[indexPath.row][@"user_name"]).length == 0 ? @"Ẩn Danh" : dataList[indexPath.row][@"user_name"];
//
//    ((UILabel*)[self withView:cell tag:14]).text = [[[dataList[indexPath.row] getValueFromKey:@"time"] dateWithFormat:@"MM/dd/yyyy hh:mm:ss a"] timeAgo];
//
//    ((UIView*)[self withView:cell tag:15]).transform = CGAffineTransformMakeRotation(45 * M_PI/180);
//    
//    ((UILabel*)[self withView:cell tag:16]).text = ((NSString*)dataList[indexPath.row][@"content"]).length == 0 ? @"N/a" : dataList[indexPath.row][@"content"];
    
    return cell;
}

#pragma mark -

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    [UIView animateWithDuration:0.3 animations:^{
        
        float diff = (growingTextView.frame.size.height - height);
        CGRect r = toolBar.frame;
        r.size.height -= diff;
        r.origin.y += diff;
        toolBar.frame = r;
        
        CGRect tableViewFrame = tableView.frame;
        tableViewFrame.size.height = toolBar.frame.origin.y;
        tableView.frame = tableViewFrame;
    }];
    if(dataList.count != 0)
        [tableView didScrolltoTop:YES];
}

- (void)growingTextViewDidBeginEditing:(HPGrowingTextView *)growingTextView
{
    if(dataList.count != 0)
        [tableView performSelector:@selector(didScrolltoTop:) withObject:nil afterDelay:0.1];
}

- (IBAction)didPressBack:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [tableView removeHeader];
    [self.view removeKeyboardControl];
}

@end
