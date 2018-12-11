//
//  ViewController.m
//  LCR
//
//  Created by mac on 04/10/2018.
//  Copyright © 2018 piaoxu. All rights reserved.
//

#import "ViewController.h"
/*
  相关说明:
  1.check按钮       TextField  的tag值，默认从101开始
  2.Sn输入框        TextField  的tag值，默认从201开始
  3.Result         TextField  的tag值，默认从301开始

*/




NSString   * path = @"Param";
NSString   * TestItem_path = @"TestItem";

@interface ViewController()<FlushMainWindowDelegate,NSTabViewDelegate,NSTextFieldDelegate,ORSSerialPortDelegate>
{
   
    //**************************控件**********************//
    //显示对应产品的测试数据
    IBOutlet NSView    *_Dut1_View;
    
    //显示的相对应Dut的Log日志
    IBOutlet NSTextView *Log1;
    IBOutlet NSTextView *Log2;
    IBOutlet NSTextView *Log3;
    IBOutlet NSTextView *Log4;
    
    //显示状态控制栏
    IBOutlet NSTextField *State_Lable;
    IBOutlet NSTextField *Title_Lable;
    IBOutlet NSTextField *Version_TF;
    IBOutlet NSTextField *Humiture_TF;
    
    //显示输入控件与选择的控件
    IBOutlet NSTextField *Enter_SN1_TF;
    IBOutlet NSTextField *Enter_SN2_TF;
    IBOutlet NSTextField *Enter_SN3_TF;
    IBOutlet NSTextField *Enter_SN4_TF;
    
    IBOutlet NSButton *check_SN1_Button;
    IBOutlet NSButton *check_SN2_Button;
    IBOutlet NSButton *check_SN3_Button;
    IBOutlet NSButton *check_SN4_Button;
    
    
    //选择SN长度控件
    IBOutlet NSPopUpButton *SN_Length_PopButton;
    
    //引用开始的控件
    IBOutlet NSButton *Start_Button;
    
    //显示测试结果的控件
    IBOutlet NSTextField *Dut1_Result;
    IBOutlet NSTextField *Dut2_Result;
    IBOutlet NSTextField *Dut3_Result;
    IBOutlet NSTextField *Dut4_Result;
  
    
    
    //统计显示数量
    IBOutlet NSTextField *Count_Lable;
    
    __weak IBOutlet NSTextField *pass_Lable;
    //统计显示时间
    IBOutlet NSTextField *Time_Lable;
    
    //TabView
    IBOutlet NSTabView *Dut_TabView;
    IBOutlet NSTabView *Log_TabView;
    
    //State
     IBOutlet NSTextField *PDCA_Lable;
     IBOutlet NSTextField *SFC_Lable;
    
    
    
    //**************************对象**********************//
    //创建的对象
    Table     *  table1;
    Table     *  table2;
    Table     *  table3;
    Table     *  table4;
    
    //开启主测试流程
    TestAction * testAction1;
    TestAction * testAction2;
    TestAction * testAction3;
    TestAction * testAction4;
    
    //加载数据流程
    Param      * param;
    Plist      * plist;
    
    //定时器
    MKTimer    * mkTimer;
    int          ct_cnt;     //0.1秒递增
    
    //定义基本数据类型
    NSMutableArray  * itemArr;
    NSMutableArray  * LedArray;
    float        totalNum;
    float        passNum;
    int          testCount; //测试产品数量
    
    //生成文件的类
    dispatch_queue_t  queue;
    dispatch_queue_t  ledQueue;
    SaveCsvData    * csvData;
    
    //ORSSerialPortDelegate
    ORSSerialPort  *  mainSerialport;
    ORSSerialPort  *  ledSerialPort;
    NSMutableString * serialAppending;
    NSMutableString * ledSerialAppending;
    
}
@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [State_Lable setStringValue:@"Object Init"];
    //初始化对象
    itemArr = [[NSMutableArray alloc] initWithCapacity:10];

    //加载数据
    plist = [Plist shareInstance];
    param = [[Param alloc] init];
    [param ParamRead:path];
    itemArr = [plist PlistRead:TestItem_path Key:@"AllItems"];
    
    //设置代理
    Dut_TabView.delegate = self;
    Log_TabView.delegate = self;
    
    //界面控件赋值
    [Title_Lable setStringValue:[param.Global objectForKey:@"sw_name"]];
    [Version_TF setStringValue:[param.Global objectForKey:@"sw_ver"]];
    
    
    //刷新界面
    table1 = [[Table alloc]  init:_Dut1_View DisplayData:itemArr Count:4];
    
    
    
    //加载数据源
    testAction1 =[[TestAction alloc]initWithTable:table1 withTextView:Log1 withFixParam:param withType:1 titile:plist.titile withDelegate:self];
    testAction2 =[[TestAction alloc]initWithTable:table1 withTextView:Log2 withFixParam:param withType:2 titile:plist.titile withDelegate:self];
    testAction3 =[[TestAction alloc]initWithTable:table1 withTextView:Log3 withFixParam:param withType:3 titile:plist.titile withDelegate:self];
    testAction4 =[[TestAction alloc]initWithTable:table1 withTextView:Log4 withFixParam:param withType:4 titile:plist.titile withDelegate:self];
    
    
    //判断本地数据
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:kPDCAandSFCNotification] containsString:@"ALL"]) {
       
        self.testmode =  AllTest;
    }
    else if ([[[NSUserDefaults standardUserDefaults] objectForKey:kPDCAandSFCNotification] containsString:@"MIN"])
    {
        self.testmode = MinTest;
    }
    else if([[[NSUserDefaults standardUserDefaults] objectForKey:kPDCAandSFCNotification] containsString:@"MAX"]){
       
        self.testmode = MaxTest;
    
    }
    else{
    
        self.testmode = CheckTest;
    }
    
    
    //判断按钮是否能够点击
    NSButton  * check_SN_Button;
    if (self.testmode == AllTest) {
        for (int i=1;i<5;i++) {
          check_SN_Button  = [self.view viewWithTag:100+i];
          check_SN_Button.enabled = NO;
          check_SN_Button.state = YES;
        }
    }else if (self.testmode == MinTest)
    {
        for (int i=1;i<5;i++) {
            check_SN_Button  = [self.view viewWithTag:100+i];
            check_SN_Button.enabled = YES;
            if (1==i) {
                
                check_SN_Button.state = YES;
            }else
            {
                check_SN_Button.state = NO;
            }
        }
    }else
    {
        for (int i=1;i<5;i++) {
            check_SN_Button  = [self.view viewWithTag:100+i];
            check_SN_Button.enabled = YES;
            check_SN_Button.state = YES;
        }
    }
    
    //初始化串口队列
    NSThread  * thread =[[NSThread alloc] initWithTarget:self selector:@selector(initSerialPort) object:nil];
    [thread start];
    
    
    
    //定时器
    mkTimer     = [[MKTimer alloc]init];
    csvData     = [SaveCsvData shareInstnce];
    
    //PDCA和SFC的状态
    [self getTheStateOfPDCAandSFC];
    
    //新建异步串行队列
    queue = dispatch_queue_create("totalCsv", DISPATCH_QUEUE_SERIAL);
    
    //初始化基本数据
    totalNum  = 0;
    passNum   = 0;
    testCount = 0;
    
   
    
}



- (IBAction)check_button1_action:(id)sender {
    
    if (check_SN1_Button.state) {
        check_SN2_Button.state = NO;
        check_SN3_Button.state = NO;
        check_SN4_Button.state = NO;
    }
    
}

- (IBAction)check_button2_action:(id)sender {
    
    if (check_SN2_Button.state) {
        check_SN1_Button.state = NO;
        check_SN3_Button.state = NO;
        check_SN4_Button.state = NO;
    }
}


- (IBAction)check_button3_action:(id)sender {
    
    if (check_SN3_Button.state) {
        check_SN1_Button.state = NO;
        check_SN2_Button.state = NO;
        check_SN4_Button.state = NO;
    }
    
}

- (IBAction)check_button4_action:(id)sender {
    
    if (check_SN4_Button.state) {
        check_SN1_Button.state = NO;
        check_SN2_Button.state = NO;
        check_SN3_Button.state = NO;
    }
}










#pragma mark------------开始测试软件
- (IBAction)StartButton_action:(id)sender {
    
    
    //如果被选择，确保输入了SN
    if([self JuageSN]){
        
        
        if (param.isDebug) {
            
            if (self.testmode == AllTest) {
                
                if (testAction1.ActionState==StateReady&&
                    testAction2.ActionState==StateReady&&testAction3.ActionState==StateReady
                    &&testAction4.ActionState==StateReady)
                {
                    [self setValueToTestActionObject];
                    
                    [State_Lable setStringValue:@"Start Test"];
                    
                }else{
                    
                    [State_Lable setStringValue:@"Not Ready,Check Again"];
                    
                }
            }
            else
            {
                [self setValueToTestActionObject];
            }
        }
        else{
            
            if (self.testmode == AllTest) {
                
                if (testAction1.ActionState==StateReady&&
                    testAction2.ActionState==StateReady&&testAction3.ActionState==StateReady
                    &&testAction4.ActionState==StateReady)
                {
                    //发送命令
                    NSString * command = [NSString stringWithFormat:@"start%@",@"\n"];
                    [mainSerialport sendData:[command dataUsingEncoding:NSUTF8StringEncoding]];
                    
                    [State_Lable setTextColor:[NSColor blueColor]];
                    [State_Lable setStringValue:@"Start Test"];
                    
                    
                    //控制板
//                    [self setValueToTestActionObject];
                    
                    
                }else{
                    
                    [State_Lable setStringValue:@"Not Ready,Check Again"];
                    [State_Lable setBackgroundColor:[NSColor redColor]];
                    
                    //                //debug模式
                    //                [self setValueToTestActionObject];
                    
                }
            }
            else{
                
                //发送命令
                NSString * command = [NSString stringWithFormat:@"start%@",@"\n"];
                [mainSerialport sendData:[command dataUsingEncoding:NSUTF8StringEncoding]];
    
//              [self setValueToTestActionObject];
                
            }
        }

    }
}



#pragma mark------------------NSTextFieldDelegate
-(void)controlTextDidChange:(NSNotification *)obj
{
    NSTextField   * tf = (NSTextField *)obj.object;
    NSLog(@"[SN_Length_PopButton.stringValue intValue]===%d",[SN_Length_PopButton.stringValue intValue]);
    
    if(tf.stringValue.length == [SN_Length_PopButton.titleOfSelectedItem intValue])
    {
        NSTextField *nextTF;
        
        if (tf.tag == 201) {
            
            testAction1.dut_sn = tf.stringValue;
        }
        if (tf.tag == 202) {
            testAction2.dut_sn = tf.stringValue;
        }
        if (tf.tag == 203) {
            
            testAction3.dut_sn = tf.stringValue;
        }
        if (tf.tag == 204) {
            
            testAction4.dut_sn = tf.stringValue;
        }
        
        //调到最后的时候吗，调到第一个
        if (tf.tag == 204) {
            
            nextTF = [self.view viewWithTag:tf.tag-3];
            
            //提示点击start开始测试
            dispatch_async(dispatch_get_main_queue(), ^{
                
                State_Lable.stringValue = @"Please Click StartButton";
            });
            
        }else{
            nextTF = [self.view viewWithTag:tf.tag+1];
        }
        
        [tf resignFirstResponder];
        [nextTF becomeFirstResponder];
        
    }
    
    
    
    
}




#pragma mark------------------FlushMainWindowDelegate

#pragma mark--开始测试，刷新界面
-(void)FlushMainViewStartTestSolat:(int)fixtype
{
    NSButton  * check_SN_Button = [self.view viewWithTag:100+fixtype];
    check_SN_Button.enabled = NO;
    NSTextField * Dut_Result    = [self.view viewWithTag:300+fixtype];
    [Dut_Result setStringValue:[NSString stringWithFormat:@"DUT%d",fixtype]];
    [Dut_Result setBackgroundColor:[NSColor whiteColor]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
       
        [State_Lable setStringValue:@"....Testing...."];
    });
    
    
}


#pragma mark--结束测试，刷新界面
-(void)FlushMainViewFinshTestSolat:(int)fixtype Result:(NSString *)result
{
    
    //ALLTest模式，测试结束后不可点击
    if (self.testmode != AllTest) {
        
        NSButton  * check_SN_Button = [self.view viewWithTag:100+fixtype];
        check_SN_Button.enabled = YES;
    }
    
    //点亮指示灯
    [NSThread sleepForTimeInterval:(float)fixtype/10];
    [ledSerialPort sendData:[[NSString stringWithFormat:@"LED%d_%@\n",fixtype,result] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSTextField * Dut_Result    = [self.view viewWithTag:300+fixtype];
    [Dut_Result setStringValue:result];
    [Dut_Result setBackgroundColor:[result isEqualToString:@"PASS"]?[NSColor greenColor]:[NSColor redColor]];
    
    testCount--;
    
    //========发送复位指令========
    if (testCount == 0) {
        
        //发送复位的指令
        if (param.isDebug) {
            
            //停止计时器
            [mkTimer endTimer];
            ct_cnt = 0;
            //释放硬盘
            [serialAppending setString:@""];
            
        }else{
        
            NSString * command = [NSString stringWithFormat:@"reset%@",@"\n"];
            [mainSerialport sendData:[command dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
        //开始按钮可以点击
        dispatch_async(dispatch_get_main_queue(), ^{
           
            //开始按钮不可点击
//            Start_Button.enabled = YES;
            Enter_SN1_TF.stringValue = @"";
            Enter_SN2_TF.stringValue = @"";
            Enter_SN3_TF.stringValue = @"";
            Enter_SN4_TF.stringValue = @"";
            State_Lable.stringValue = @"Test Finsh";
            
        });
        
    }
    
}


#pragma mark--统计数量
-(void)FlushTestCount:(BOOL)isPass
{
    totalNum++;
    if (isPass)passNum++;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [Count_Lable setStringValue:[NSString stringWithFormat:@"%d/%d",(int)passNum,(int)totalNum]];
        [pass_Lable setStringValue:[NSString stringWithFormat:@"%.1f%%",(passNum/totalNum)*100]];
    });
    
}


#pragma mark--刷新SN控件
-(void)DeliverySolat:(int)fixtype DutSn:(NSString *)dutSn
{
    dispatch_async(dispatch_get_main_queue(), ^{
       
        NSTextField * Enter_SN      = [self.view viewWithTag:200+fixtype];
        [Enter_SN setStringValue:dutSn];
    });
}


#pragma mark--写入数据到总文件
-(void)writeDataToTotalCsvPath:(NSString *)path fileName:(NSString *)fileName content:(NSString *)content
{
    
     dispatch_async(queue, ^{
         [csvData createCsvPath:path csvName:fileName csvFileHead:plist.titile];
         [csvData WriteCsvConent:content];
     });
}



-(void)getTheStateOfPDCAandSFC
{
     dispatch_async(dispatch_get_main_queue(), ^{
         NSString  * locationStr = [[NSUserDefaults standardUserDefaults] objectForKey:kPDCAandSFCNotification];
         [PDCA_Lable setStringValue:[locationStr containsString:@"PDCA"]?@"PDCA ON":@"PDCA OFF"];
         [PDCA_Lable setTextColor:[locationStr containsString:@"PDCA"]?[NSColor redColor]:[NSColor blueColor]];
         [SFC_Lable setStringValue:[locationStr containsString:@"SFC"]||[locationStr containsString:@"UOP"]?@"SFC ON":@"SFC OFF"];
         [SFC_Lable setTextColor:[locationStr containsString:@"SFC"]||[locationStr containsString:@"UOP"]?[NSColor redColor]:[NSColor blueColor]];
         
     });
}



#pragma mark-------------点击TabView控件
-(void)tabView:(NSTabView *)tabView didSelectTabViewItem:(NSTabViewItem *)tabViewItem
{
    
    NSInteger num = [tabView indexOfTabViewItem:tabViewItem];
    if ([tabView isEqual:Dut_TabView]) {
        
        [Log_TabView selectTabViewItemAtIndex:num];
        
    }
    else
    {
        [Dut_TabView selectTabViewItemAtIndex:num];
    }
}


#pragma mark-------------ORSSerialPortDelegate
-(void)serialPort:(ORSSerialPort *)serialPort didReceiveData:(NSData *)data
{
    
    NSString  *  string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"string ======= %@",string);
    
    if ([serialPort isEqualTo:mainSerialport]) {
        
        [serialAppending appendString:string];
        
        if ([serialAppending containsString:@"START"]&&[serialAppending containsString:@"OK@_@\r\n"]) {
            
            [self setValueToTestActionObject];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [State_Lable setStringValue:@"Ready!,Testing...."];
                Start_Button.enabled = NO;
                [State_Lable setBackgroundColor:[NSColor greenColor]];
            });
            
            //释放硬盘
            [serialAppending setString:@""];
            
            //灭掉灯光
            [ledSerialPort sendData:[@"LED_OFF\n" dataUsingEncoding:NSUTF8StringEncoding]];
            
        }
        if ([serialAppending containsString:@"RESET"]&&[serialAppending containsString:@"OK@_@\r\n"]) {
            //停止计时器
            [mkTimer endTimer];
            ct_cnt = 0;
            //释放硬盘
            [serialAppending setString:@""];
            
            //开始测试
            [State_Lable setStringValue:@"Testing Finsh，Reset"];
            
        }
        if ([serialAppending isEqualToString:@"READY OK@_@\r\n"]) {
           //Start 可以点击
            dispatch_async(dispatch_get_main_queue(), ^{
               
                Start_Button.enabled = YES;
            });
            //释放硬盘
            [serialAppending setString:@""];
        }
        if ([serialAppending containsString:@"NO_READY OK@_@\r\n"]) {
            //Start 可以点击
            dispatch_async(dispatch_get_main_queue(), ^{
                
                Start_Button.enabled = NO;
            });
            //释放硬盘
            [serialAppending setString:@""];
        }
        
        
 
    }
    else{
    
        [ledSerialAppending appendString:string];
        
    }
}




#pragma mark--------------开启测试线程
-(void)setValueToTestActionObject
{
    
    //下压已经成功
    if (check_SN1_Button.state&&testAction1.ActionState==StateReady) {
        testAction1.ActionState = StateStart;
        testAction1.dut_sn = Enter_SN1_TF.stringValue;
        testCount++;
    }
    if (check_SN2_Button.state&&testAction2.ActionState==StateReady) {
        testAction2.ActionState = StateStart;
        testAction2.dut_sn = Enter_SN2_TF.stringValue;
        testCount++;
    }
    if (check_SN3_Button.state&&testAction3.ActionState==StateReady) {
        testAction3.ActionState = StateStart;
        testAction3.dut_sn = Enter_SN3_TF.stringValue;
        testCount++;
    }
    if (check_SN4_Button.state&&testAction4.ActionState==StateReady) {
        testAction4.ActionState = StateStart;
        testAction4.dut_sn = Enter_SN4_TF.stringValue;
        testCount++;
    }
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
       
        State_Lable.textColor = [NSColor blueColor];
    });
    
    
    //开始定时器
    [Time_Lable setStringValue:@"0"];
    [mkTimer setTimer:0.1];
    [mkTimer startTimerWithTextField:Time_Lable];
    ct_cnt = 1;

    
    //释放硬盘
    [serialAppending setString:@""];
    
}



-(BOOL)JuageSN
{

    
    if (check_SN1_Button.state) {
        
        if (!([Enter_SN1_TF.stringValue length]==17||[Enter_SN1_TF.stringValue length]==21)) {
            
            State_Lable.stringValue = @"SN1 is Error,Enter Again";
            [State_Lable setBackgroundColor:[NSColor redColor]];
            return false;
        }
    }
    if (check_SN2_Button.state) {
        
        if (!([Enter_SN2_TF.stringValue length]==17||[Enter_SN2_TF.stringValue length]==21)) {
            
            State_Lable.stringValue = @"SN2 is Error,Enter Again";
            [State_Lable setBackgroundColor:[NSColor redColor]];
            return false;
        }
    }
    if (check_SN3_Button.state) {
        
        if (!([Enter_SN3_TF.stringValue length]==17||[Enter_SN3_TF.stringValue length]==21)) {
            
            State_Lable.stringValue = @"SN3 is Error,Enter Again";
            [State_Lable setBackgroundColor:[NSColor redColor]];
            return false;
        }
    }
    if (check_SN4_Button.state) {
        
        if (!([Enter_SN4_TF.stringValue length]==17||[Enter_SN4_TF.stringValue length]==21)) {
            
            State_Lable.stringValue = @"SN4 is Error,Enter Again";
            [State_Lable setBackgroundColor:[NSColor redColor]];
           return false;
        }
    }
    
    
    return true;
}




-(void)initSerialPort
{
    //初始化串口队列
    mainSerialport = [ORSSerialPort serialPortWithPath:param.contollerBoard_uart_name];
    mainSerialport.delegate = self;
    mainSerialport.baudRate = @115200;
    serialAppending = [[NSMutableString alloc] initWithCapacity:10];
    
    ledSerialPort   = [ORSSerialPort serialPortWithPath:param.led_uart_name];
    ledSerialPort.delegate = self;
    ledSerialPort.baudRate = @115200;
    ledSerialAppending = [[NSMutableString alloc] initWithCapacity:10];
    

    //打开主控制板
    while (YES) {
        
        [mainSerialport open];
        
        [NSThread sleepForTimeInterval:0.5];
        
        if ([mainSerialport isOpen]) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [State_Lable setStringValue:@"MainBoard has Open"];
                
            });
            break;
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [State_Lable setStringValue:@"MainBoard Not Open"];
                
            });
        }
        
    }
    
    //打开亮灯的板子
    while (YES) {
        
        [ledSerialPort open];
        
        [NSThread sleepForTimeInterval:0.5];
        
        if ([ledSerialPort isOpen]) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [State_Lable setStringValue:@"LEDBoard has Open"];
                
            });
            break;
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [State_Lable setStringValue:@"LEDBoard Not Open"];
                
            });
        }
    }
    
    [NSThread sleepForTimeInterval:0.5];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [State_Lable setStringValue:@"Please Enter SN"];
            
        });
        
    });
}


-(void)viewWillDisappear{

    //完全退出程序
    exit(1);

}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}



@end
