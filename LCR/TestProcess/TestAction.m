
//  TestAction.m
//  WorkingFrameWork
//
//  Created by mac on 2017/10/27.
//  Copyright © 2017年 macjinlongpiaoxu. All rights reserved.
//

#import "TestAction.h"


#define SNChangeNotice  @"SNChangeNotice"
NSString  const * param_path=@"Param";
NSString  const * OpNum = @"1234567890";

@interface TestAction ()<SaveDataToolDelegate,AgilentDelegate,ORSSerialPortDelegate>
{
    NSThread        * thread;                                   //开启的线程
    //************  通讯类 ***********
    ORSSerialPort   * serialport;                               //串口通讯类
    AgilentCommand  * agilentCommand;                           //安捷伦发送指令
    Alert           * alert;                                    //显示窗口类
    Calculate       * calculate;                                //计算类
    
    
    //************  BOOL ***********
    BOOL                   is_LRC_Collect;                       //LCR表是否连接
    BOOL                   is_JDY_Collect;                       //静电仪是否连接
    BOOL                   isPDCA;                               //上传PDCA
    BOOL                   isSFC;                                //上传SFC
    BOOL                   PF;                                   //产品结果
    BOOL                   isDebug;                              //空测测试
    BOOL                   Instrument;                           //仪器是否连接OK
    BOOL                   addDcr;                               //40组DCR数
    BOOL                   nulltest;
    BOOL                   isCurrentItemFinsh;                   //当前测试项是否测试结束
    BOOL                   isFinsh;                              //测试Finsh
    
    
    NSString               * SFCType;                            //SFC的类型
    NSString               * csvTitles;                          //csv除了测试项的titile
    
    //************存储数据*************
    NSMutableString        * testValueAppendString;              //存储测试结果的数
    NSString               * aglientStr;                         //安捷伦返回来的数据
    NSString               * DirPath;
    NSString               * txtLogPath;                         //Log日志的文件夹
    NSString               * showLogStr;                         //显示内容
    NSString               * UploadFileName;                     //需要上传的压缩文件名称
    

    
    
    //************  数据类型 ***********
    int        delayTime;                                        //延时时间
    int        index;                                            //测试流程具体步骤
    int        item_index;                                       //测试项下标
    int        row_index;                                        //测试项刷新列表
    int        fix_type;                                         //对应相应穴位

    NSMutableArray      * testItemTitleArr;                        //每个测试标题都加入数组中,生成数据文件要用到
    NSMutableArray      * testItemValueArr;                        //每个测试结果都加入数组中,生成数据文件要用到
    NSMutableArray      * testItemMinLimitArr;                     //每个测试项最小值数组
    NSMutableArray      * testItesmMaxLimitArr;                    //每个测试项最大值数组
    NSMutableArray      * testItemUnitArr;
    NSMutableArray      * txtLogMutableArr;
    NSMutableArray      * ItemArr;                                 //存测试对象的数组
   
    
    
    
    NSMutableString     * txtContentString;                        //打印txt文件中的log
    NSMutableString     * listFailItemString;                      //测试失败的项目
    NSMutableString     * ErrorMessageString;                      //失败测试项的原因
    NSMutableString     * dcrAppendString;                         //DCR拼接的数据
    NSMutableString     * serailAppendString;                      //治具中返回的数据
    
    NSString            * agilentReadString;
    NSString            * SonTestName;
    NSString            * testResultStr;                           //测试结果
    NSString            * testvalue;                               //测试项的字符串
    NSString            * tesCPtLogPath;                           //生成的时时LOG值
    NSString            * FixtureID;                               //治具的ID

   
    
    //***************************功能模块区***************************
    //SFC请求中使用
    NSString            * _Net_Port;                                //SFC的端口
    NSString            * _Product;                                 //测试产品
    NSString            * _Server_IP;                               //SFC的IP地址
    NSString            * _Station_Name;                            //工站的名称
    
    
    //连接设备中使用
    NSString            * _fixture_uart_port_name;                  //治具名称
    NSString            * _fixture_uart_baud;                       //治具波
    NSString            * _scan_uart_port_name;                     //扫描枪
    NSString            * _sw_ver;                                  //软件版本
    NSString            * _sw_name;                                 //软件名称
    NSString            * _instr_4980;
    NSString            * _instr_2987;
    NSString            * _instrument_name;                         //仿真仪器名称
    NSString            * _instrument_baud;                         //仿真仪器波特率
    NSString            * _lan4980_Port;                            //端口
    NSString            * _lan4980_IP;                              //IP地址
    
    
    //字典
    NSDictionary         *   dic;
    NSMutableDictionary  *   store_Dic;                       //所有的测试项存入字典中
    
    //PDCA与SFC
    UpLoadDataToPDCA     *   uploadPdca;                      //上传PDCA
    
    
    
    
    //************  其它对象 ***********
    Item                * testItem;                               //测试项
    Item                * showItem;                               //显示的测试项
    Plist               * plist;                                  //plist文件处理类
    Param               * param;                                  //打印当前的
    double num;

    
    //timer
    NSString            * start_time;                         //启动测试的时间
    NSString            * end_time;                           //结束测试的时间
    GetTimeDay          * timeDay;                            //创建日期类
    
    
    //************  文件处理对象 ***********
    SaveCsvData  * saveScv;                                   //csv文件对象
    SaveDataTool * saveTxt;                                   //生成txt文件
    
    
}
@end

@implementation TestAction

/**相关的说明
  1.Fixture ID 返回的值    Fixture ID?\r\nEW011X*_*\r\n       其中x代表治具中A,B,C,D
*/
-(id)initWithTable:(Table *)tab withTextView:(NSTextView *)LogView withFixParam:(Param *)paramObject withType:(int)type_num
      titile:(NSString *)title withDelegate:(id<FlushMainWindowDelegate>)delegate;
{
    
    if (self == [super init]) {
        
        param = paramObject;
        NSDictionary  * fix;
        if (type_num == 1) fix = param.Fix1;
        if (type_num == 2) fix = param.Fix2;
        if (type_num == 3) fix = param.Fix3;
        if (type_num == 4) fix = param.Fix4;
        
        
        //添加tab引用
        self.tab = tab;
        self.Log_View = LogView;
        fix_type = type_num;
        csvTitles = title;
        
        
        //初始化各种数据及其设备消息
        _fixture_uart_port_name     = [fix objectForKey:@"fixture_uart_port_name"];
        _fixture_uart_baud          = [fix objectForKey:@"fixture_uart_baud"];
        _scan_uart_port_name        = [fix objectForKey:@"scan_uart_port_name"];
        _instr_2987                 = [fix objectForKey:@"b2987_adress"];
        _instr_4980                 = [fix objectForKey:@"e4980_adress"];
        _lan4980_Port               = [fix objectForKey:@"e4980_Port"];
        _lan4980_IP                 = [fix objectForKey:@"e4980_IP"];
        
        
        //初始化各类BOOL变量
        is_JDY_Collect              = NO;
        is_LRC_Collect              = NO;
        Instrument                  = NO;
        isCurrentItemFinsh          = NO;
        PF                          = YES;
        //获取ServerFC相关的信息
        _Net_Port                   = [param.ServerFC objectForKey:@"Net_Port"];
        _Product                    = [param.ServerFC objectForKey:@"Product"];
        _Server_IP                  = [param.ServerFC objectForKey:@"Server_IP"];
        _Station_Name               = [param.ServerFC objectForKey:@"Station_Name"];
        isDebug                     =  param.isDebug;
      
        
        //相关路径
        DirPath    = [NSString stringWithFormat:@"/vault/LCR/%@",[[GetTimeDay shareInstance] getCurrentDay]];
        txtLogPath = [NSString stringWithFormat:@"%@/%@",DirPath,@"Log"];
        testValueAppendString = [[NSMutableString alloc] initWithCapacity:10];
        serailAppendString    = [[NSMutableString alloc] initWithCapacity:10];
        
        //对象初始化
        saveScv       = [[SaveCsvData  alloc] init];
        saveTxt       = [[SaveDataTool alloc] init];
        uploadPdca    = [[UpLoadDataToPDCA alloc] initWithNumber:1];
        timeDay       = [GetTimeDay shareInstance];
        alert         = [[Alert alloc] init];
        calculate     = [[Calculate alloc] init];
        
        
//        //仪器通信
//        agilentCommand = [[AgilentCommand alloc] initWithHost:_lan4980_IP Port:[_lan4980_Port intValue] Queue:dispatch_get_main_queue() Delegate:self tag:1 AgilentType:Agilent4980 MessageMode:AgilentE4980A_DC_RX];
        
        
        serialport    = [ORSSerialPort serialPortWithPath:_fixture_uart_port_name];
        serialport.delegate = self;
        serialport.baudRate = @115200;
        
        saveTxt.delegate     = self;
        serialport.delegate  = self;
        self.delegate = delegate;
        
        
        
        //代理，枚举，赋值
        index = 0;
        _qrCode = ManualCode;
        _ActionState = StateFinsh;
        if (isDebug) {
            _qrCode = DebugCode;
        }
    
        
       

        //获取全局变量
        if (thread==nil) {
            
            thread = [[NSThread alloc]initWithTarget:self selector:@selector(TestAction) object:nil];
            [thread start];
        }
       
      
        
    }


     return  self;
}



-(void)TestAction
{
    [NSThread sleepForTimeInterval:0.5];
    while ([[NSThread currentThread] isCancelled]==NO) //线程未结束一直处于循环状态
    {

#pragma mark--------index = 0:连接治具
            if (index == 0) {
                
                [NSThread sleepForTimeInterval:0.5];
                
                if (isDebug) {
                    
                    NSLog(@"index= 0,连接治具%@,debug模式中",_fixture_uart_port_name);
                    [saveTxt saveTestInfoIntoTxt:[NSString stringWithFormat:@"index = %d,%@",index,@"Debug模式，连接治具中"] SN:nil Path:txtLogPath Collect:YES];
                    index =1;
                    
                }
                else
                {
                   
                    [serialport open];
                    if ([serialport isOpen]) {
                        
                        [saveTxt saveTestInfoIntoTxt:[NSString stringWithFormat:@"index = %d,%@",index,@"Fixture Connect"] SN:nil Path:txtLogPath Collect:YES];
                        
//                        //发送FIXTURE ID?指令
//                        NSString  * Command = @"FIXTURE ID?";
//                        [serialport sendData:[[Command appendString:@"\n"] dataUsingEncoding:NSUTF8StringEncoding]];
//                        
//                        //等待数据
//                        [self waitForData:1.0];
//                      
//                        FixtureID = param.isDebug?@"EW101":[serailAppendString subStringFrom:Command to:kEndString];
//                    
//                        //清空缓存
//                        [serailAppendString setString:@""];
                        
                        
                        index = index +1;
                    }
                    else{
                        
                         [saveTxt saveTestInfoIntoTxt:[NSString stringWithFormat:@"index = %d,%@",index,@"Serialport Disconnect"] SN:nil Path:txtLogPath Collect:YES];
                    }
                    
                }
            }
            
#pragma mark--------index = 1:连接扫码器
            if (index == 1) {
                
                index = 2;
                [saveTxt saveTestInfoIntoTxt:[NSString stringWithFormat:@"index = %d,%@",index,@"Scan OK"] SN:nil Path:txtLogPath Collect:YES];
               
            }
        
#pragma mark--------index = 2:连接LCR表4980 和 静电仪器2987A
            if (index == 2) {
                
                [NSThread sleepForTimeInterval:0.5];
                [saveTxt saveTestInfoIntoTxt:[NSString stringWithFormat:@"index = %d,%@",index,@"Instrument OK"] SN:nil Path:txtLogPath  Collect:NO];
                 index++;
                
                 _ActionState = StateReady;
            }
        
#pragma mark---------index=3:检测start按钮启动
        if (index == 3) {
            
            [NSThread sleepForTimeInterval:0.5];
            PF = YES;
            if (_ActionState == StateStart) {
                //获取PDCA或则SFC的状态
                [self getTheStateOfPDCAandSFC];
                [saveTxt saveTestInfoIntoTxt:[NSString stringWithFormat:@"index = %d,%@",index,@"StartButton Click"] SN:nil Path:txtLogPath  Collect:NO];
                index++;
            }
            else{
            
                 [saveTxt saveTestInfoIntoTxt:[NSString stringWithFormat:@"index = %d,%@",index,@"Please Click Button"] SN:nil Path:txtLogPath  Collect:NO];
            }
            
        }
        
#pragma mark---------index=4:开始扫码动作
        if (index == 4) {
            
            [NSThread sleepForTimeInterval:0.5];
            
            if (_qrCode == AutoCode) {
           
                
            }
            if (_qrCode == ManualCode) {
                
                if (_dut_sn.length == 17||_dut_sn.length==21) {
                    index++;
                }
                 _dut_sn = self.dut_sn;
                NSLog(@"print sn=%@",self.dut_sn);
                [saveTxt saveTestInfoIntoTxt:[NSString stringWithFormat:@"index = %d,%@",index,[NSString stringWithFormat:@"dut_sn:%@",_dut_sn]] SN:nil Path:txtLogPath  Collect:YES];
            }
            
            if (_qrCode == DebugCode) {
                
                _dut_sn = @"222222222222222222222";
                NSLog(@"print fix_type=%d，dut_sn = %@",fix_type,_dut_sn);
                
                [saveTxt saveTestInfoIntoTxt:[NSString stringWithFormat:@"index = %d,%@",index,[NSString stringWithFormat:@"dut_sn:%@",_dut_sn]] SN:nil Path:txtLogPath  Collect:YES];
                
                [self DeliverySN:_dut_sn];
                index = 5;
                
            }
            
        }
        
#pragma mark---------index=5:检测SN的位数，开始测试
        if (index == 5) {
            
            [NSThread sleepForTimeInterval:0.5];
            //清理界面
            [self.tab ClearTable:fix_type];
            //调用代理刷新其它View
            [self FlushViewStartTest];
//            NSString  * backStr;
//            //SFC检验
//            if ([SFCType isEqualToString:@"UOP"]) {
//                
//                if ([uploadPdca UUTStartTest]) {
//                    
//                    backStr = [uploadPdca ValidateSerialNumber:_dut_sn];
//                    
//                    if (![backStr containsString:@"PASS"]) {
//                        
//                        [saveTxt saveTestInfoIntoTxt:[NSString stringWithFormat:@"index=4,%@",backStr] SN:_dut_sn Path:txtLogPath  Collect:YES];
//                    }
//                    
//                    backStr = [uploadPdca ValidateAMIOK:_dut_sn];
//                    if (![backStr containsString:@"PASS"]) {
//                        
//                        [saveTxt saveTestInfoIntoTxt:[NSString stringWithFormat:@"index=4,%@",backStr] SN:_dut_sn Path:txtLogPath  Collect:YES];
//                        
//                    }else
//                    {
//                        
//                        [uploadPdca UUTCancelTest];
//                        [saveTxt saveTestInfoIntoTxt:[NSString stringWithFormat:@"index=5,%@",@"检验成功"] SN:_dut_sn Path:txtLogPath  Collect:YES];
//                        index++;
//                    }
//                }
//                else{
//                    
//                    [saveTxt saveTestInfoIntoTxt:[NSString stringWithFormat:@"index=4,%@",@"UUTStartTest 失败"] SN:_dut_sn Path:txtLogPath  Collect:YES];
//                }
//            }
//            else if ([SFCType isEqualToString:@"SFC"]){ //此处使用AFNetWorking通信
//                
//                 NSLog(@"index= 5,检测SN,并打印SN的值%@",_dut_sn);
//                 [saveTxt saveTestInfoIntoTxt:[NSString stringWithFormat:@"index=5,%@",@"SFC检验OK"] SN:_dut_sn Path:txtLogPath  Collect:YES];
//                 index++;
//                
//            }
//            else{ //不检验
//                
                NSLog(@"index= 5,检测SN,并打印SN的值%@",_dut_sn);
                 [saveTxt saveTestInfoIntoTxt:[NSString stringWithFormat:@"index=5,%@",@"No Need Check SFC"] SN:_dut_sn Path:txtLogPath  Collect:YES];
                index++;
//                
//            }
        
            //启动测试的时间,csv里面用
            start_time = [[GetTimeDay shareInstance] getFileTime];
        }
        
        
        
#pragma mark--------index = 6:进入正常测试中
            if (index == 6) {
                
                [NSThread sleepForTimeInterval:0.3];
                
                NSLog(@"self.tab.testArray count = %lu",(unsigned long)[self.tab.testArray count]);
                
                [saveTxt saveTestInfoIntoTxt:[NSString stringWithFormat:@"index = %d,%@",index,[NSString stringWithFormat:@"item_index=%d,Start Testing",item_index]] SN:_dut_sn Path:txtLogPath  Collect:YES];
                
                testItem = [[Item alloc]initWithItem:self.tab.testArray[item_index]];
                
                BOOL isPass =[self TestItem:testItem];
                
                if (isPass) {//测试成功
                    
                   [saveTxt saveTestInfoIntoTxt:[NSString stringWithFormat:@"index=5:testItem = %@  is OK",testItem.testName] SN:_dut_sn Path:txtLogPath  Collect:YES];
                    
                }
                else//测试结果失败
                {
                     [saveTxt saveTestInfoIntoTxt:[NSString stringWithFormat:@"index=5:testItem = %@ NG",testItem.testName] SN:_dut_sn Path:txtLogPath  Collect:YES];
                }
                
                [self.tab flushTableRow:testItem RowIndex:row_index with:fix_type];
            
                [saveTxt saveTestInfoIntoTxt:[NSString stringWithFormat:@"index = %d,%@",index,[NSString stringWithFormat:@"item_index=%d,End Testing",item_index]] SN:_dut_sn Path:txtLogPath  Collect:YES];
                
                item_index++;
                row_index++;
                //走完测试流程,进入下一步
                if (item_index == [self.tab.testArray count])
                {
                    [saveTxt saveTestInfoIntoTxt:@"index=5,Test has Finsh" SN:_dut_sn Path:txtLogPath  Collect:YES];
                    end_time =  [[GetTimeDay shareInstance] getFileTime];
                    index = 7;
                    
                }
                
            }
            
#pragma mark--------index = 7:生成本地数据
            if (index == 7) {
                
                [NSThread sleepForTimeInterval:0.2];
                
                [saveTxt saveTestInfoIntoTxt:[NSString stringWithFormat:@"index = %d,%@",index,@"Start writing single_sloat_csv"] SN:_dut_sn Path:txtLogPath  Collect:YES];
                
                //数据源
                [saveScv createCsvPath:DirPath csvName:[NSString stringWithFormat:@"TestLog_%d",fix_type] csvFileHead:csvTitles];
                NSMutableString  * contentStr = [[NSMutableString alloc] initWithCapacity:10];
                [contentStr appendFormat:@"%@,%@,%@,%@,%@,%@",start_time,end_time,param.sw_ver,_dut_sn,PF?@"PASS":@"FAIL",OpNum];
                [contentStr appendString:testValueAppendString];
                [contentStr appendString:@"\n"];
                
                //单通道数据
                [saveScv WriteCsvConent:contentStr];
                [saveTxt saveTestInfoIntoTxt:[NSString stringWithFormat:@"index = %d,%@",index,@"Start writing total csv"] SN:_dut_sn Path:txtLogPath  Collect:YES];
                

                //测试的总数据
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if ([self.delegate respondsToSelector:@selector(writeDataToTotalCsvPath:fileName:content:)]) {
                        [self.delegate writeDataToTotalCsvPath:DirPath fileName:@"totalFile" content:contentStr];
                    }
                });
                
                [saveTxt saveTestInfoIntoTxt:[NSString stringWithFormat:@"index = %d,%@",index,@"Start writing single_dut_csv"] SN:_dut_sn Path:txtLogPath  Collect:YES];
                
                

                //单个产品的数据，防止被覆盖
                UploadFileName = [NSString stringWithFormat:@"%@%@",_dut_sn,[[GetTimeDay shareInstance] getCurrentTime]];
                NSString  * singleFilePath = [NSString stringWithFormat:@"%@/%@",DirPath,UploadFileName];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if ([self.delegate respondsToSelector:@selector(writeDataToTotalCsvPath:fileName:content:)]) {
                        [self.delegate writeDataToTotalCsvPath:singleFilePath fileName:[NSString stringWithFormat:@"%@",_dut_sn] content:contentStr];
                    }
                });
                
                [saveTxt saveTestInfoIntoTxt:[NSString stringWithFormat:@"index = %d,%@",index,@"End writing All Csv"] SN:_dut_sn Path:txtLogPath  Collect:YES];
                
                
                //压缩文件
                [Piao_ZipArchive createZipFile:UploadFileName PreviousFolderPath:DirPath isRemove:NO];
                
                
                
                NSLog(@"index= 6,Local Data Write Finsh");
                
                index = 8;
            }
            
#pragma mark--------index = 8:上传PDCA
            if (index == 8)
            {
                
                isPDCA = NO;
                
                if (isPDCA) {
                    
                    if (![uploadPdca UUTStartTest]) {
                        
                         [saveTxt saveTestInfoIntoTxt:[NSString stringWithFormat:@"index = %d,%@",index,@"UUTStartTest Fail"] SN:_dut_sn Path:txtLogPath  Collect:YES];
                        
                    }else
                    {
                        
                      [saveTxt saveTestInfoIntoTxt:[NSString stringWithFormat:@"index = %d,%@",index,@"Start upload PDCA"] SN:_dut_sn Path:txtLogPath  Collect:YES];
                    
                      [uploadPdca AddDefaultAttribute:_dut_sn SoftwareVersion:param.sw_ver SoftwareName:param.sw_ver];
                        
                        for (int i=0;i<[ItemArr count];i++) {
                            
                            //上传数据
                            Item  * item = [ItemArr objectAtIndex:i];
                            if (![uploadPdca AddTestItemWithItemName:item.testName TestValue:item.value TestResult:item.result HighLimit:item.max LowLimit:item.min Unit:item.units ErrorInfo:item.messageError withModel:@"MP"])
                            {
                                //PDCA上传失败
                                 [saveTxt saveTestInfoIntoTxt:[NSString stringWithFormat:@"index = %d,%@",index,@"Upload Fail"] SN:_dut_sn Path:txtLogPath  Collect:NO];
                            }
                        }
                        
                        NSString  * fileName = [NSString stringWithFormat:@"%@.zip",UploadFileName];
                        if (![[uploadPdca addBlobFileName:fileName filePath:[NSString stringWithFormat:@"%@/%@",DirPath,fileName]] containsString:@"PASS"])
                        {
                            //文件上传失败
                            NSLog(@"文件上传失败");
                            [saveTxt saveTestInfoIntoTxt:[NSString stringWithFormat:@"index = %d,%@",index,@"Upload File Fail"] SN:_dut_sn Path:txtLogPath  Collect:NO];
                        };
                        
                        //上传最终结果
                        if (![uploadPdca CommitPDCA:YES]) {
                            NSLog(@"提交上传的结果失败");
                             [saveTxt saveTestInfoIntoTxt:[NSString stringWithFormat:@"index = %d,%@",index,@"Upload Result Fail"] SN:_dut_sn Path:txtLogPath  Collect:NO];
                        }
                        
                        [uploadPdca UUTCancelTest];
                        
                        [saveTxt saveTestInfoIntoTxt:[NSString stringWithFormat:@"index = %d,%@",index,@"End upload PDCA"] SN:_dut_sn Path:txtLogPath  Collect:YES];
                    }
                    
                }
                
                index = 9;
            }
            
#pragma mark--------index = 9:刷新界面
            if (index == 9)
            {
                [saveTxt saveTestInfoIntoTxt:[NSString stringWithFormat:@"index = %d,%@",index,@"Start Flush View"] SN:_dut_sn Path:txtLogPath  Collect:YES];
                [self FlushViewEndTest];
                [self FlushCount];
                [saveTxt saveTestInfoIntoTxt:[NSString stringWithFormat:@"index = %d,%@",index,@"End Flush View"] SN:_dut_sn Path:txtLogPath  Collect:YES];
                index = 10;
            }
            
#pragma mark--------index = 10:测试完成，释放对象
            if (index == 10)
            {
                
                [saveTxt saveTestInfoIntoTxt:[NSString stringWithFormat:@"index = %d,%@",index,@"Start Release Object"] SN:_dut_sn Path:txtLogPath  Collect:YES];
                
                [NSThread sleepForTimeInterval:0.1];
                //清空缓存
                _dut_sn=@"";
                
                //重置相关变量
                _ActionState   = StateFinsh;
                Instrument     = NO;
                is_LRC_Collect = NO;
                is_JDY_Collect = NO;
                
                testValueAppendString = [NSMutableString stringWithString:@""];
                
                
                
               
                index = 2;
                item_index =0;
                row_index = 0;
                [saveTxt saveTestInfoIntoTxt:[NSString stringWithFormat:@"index = %d,%@",index,@"End Release Object"] SN:_dut_sn Path:txtLogPath  Collect:YES];
                
            }
            
#pragma mark===================发送消息，防止休眠
            if (index == 1000)
            {
                [NSThread sleepForTimeInterval:0.01];
            }

           
            
        }
}

//================================================
//测试项指令解析
//================================================
-(BOOL)TestItem:(Item*)subTestitem
{
    BOOL ispass=NO;
    NSDictionary  * dict;
    NSString      * subTestDevice;
    NSString      * subTestCommand;
    double          DelayTime;
    NSString      * startTime;
    NSString      * endTime;
    startTime = [timeDay getCurrentSecond];

    
    for (int i=0; i<[subTestitem.testAllCommand count]; i++)
    {
        
        dict =[subTestitem.testAllCommand objectAtIndex:i];
        subTestDevice = dict[@"TestDevice"];
        subTestCommand=dict[@"TestCommand"];
        DelayTime = [dict[@"TestDelayTime"] floatValue]/1000.0;
        NSLog(@"治具%@发送指令%@",subTestDevice,subTestCommand);
        //治具切换继电器
        if ([subTestDevice isEqualToString:@"Fixture"])
        {
        
         [saveTxt saveTestInfoIntoTxt:[NSString stringWithFormat:@"subTestDevice%@====subTestCommand:%@",subTestDevice,subTestCommand] SN:_dut_sn Path:txtLogPath  Collect:YES];
            
        //发送指令
        [serialport sendData:[[subTestCommand addDeadLineString:@"\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            
         //接收串口返回
        [self waitForData:1.0];
            
        }
        else if([subTestDevice isEqualToString:@"Read Fixture"])
        {
            [saveTxt saveTestInfoIntoTxt:[NSString stringWithFormat:@"subTestDevice%@====subTestCommand:%@",subTestDevice,subTestCommand] SN:_dut_sn Path:txtLogPath  Collect:YES];
            
            //发送指令
            [serialport sendData:[[subTestCommand addDeadLineString:@"\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            
            
            //接收有数据的返回
            [self waitForData:1.0];
            
            
            NSLog(@"serailAppendString===testvalue的值:%@",serailAppendString);
            testvalue = param.isDebug?@"111":[serailAppendString subStringFrom:subTestCommand to:kEndString];
            [serailAppendString setString:@""];
            
            [saveTxt saveTestInfoIntoTxt:[NSString stringWithFormat:@"receive:%@",testvalue] SN:_dut_sn Path:txtLogPath  Collect:YES];
            
        }
        
        //LCR表
        else if ([subTestDevice isEqualToString:@"LCR"])
        {
            [saveTxt saveTestInfoIntoTxt:[NSString stringWithFormat:@"subTestDevice%@====subTestCommand:%@",subTestDevice,subTestCommand] SN:_dut_sn Path:txtLogPath  Collect:YES];
            
            //设置测试模式
            if ([subTestCommand containsString:@"RES"]) {
                
                [agilentCommand SendAgilentCommandsWithType:Agilent4980 MessageMode:AgilentE4980A_DC_RX];
            }
            if ([subTestCommand containsString:@"CPD"]){
                [agilentCommand SendAgilentCommandsWithType:Agilent4980 MessageMode:AgilentE4980A_CPD];
            }
            if ([subTestCommand containsString:@"Read"]) {
                
                [agilentCommand readData];
                
                //返回的测试数据
                while (1) {
                    
                    [NSThread sleepForTimeInterval:0.02];
                    if ([aglientStr length]>0) {
                        
                        break;
                    }
                }
                num = [aglientStr doubleValue];
                aglientStr = @"";
            }
            //获取测试数据
            
        }
        //静电仪
        else if ([subTestDevice isEqualToString:@"DMM"])
        {
            [saveTxt saveTestInfoIntoTxt:[NSString stringWithFormat:@"subTestDevice%@====subTestCommand:%@",subTestDevice,subTestCommand] SN:_dut_sn Path:txtLogPath  Collect:YES];
            //使用socket通信
            
        }
        //延迟时间
        else if ([subTestDevice isEqualToString:@"SW"])
        {
            [saveTxt saveTestInfoIntoTxt:[NSString stringWithFormat:@"subTestDevice%@====subTestCommand:%@",subTestDevice,subTestCommand] SN:nil Path:txtLogPath  Collect:YES];
            
            [NSThread sleepForTimeInterval:DelayTime];
            
        }
        else
        {
            NSLog(@"其它的情形");
        }
        
    }
    
    
#pragma mark--------对数据进行处理
    
//     NSLog(@"*********************\n%f\n*********************",num);
//     testvalue = @"";
//     testvalue = [calculate calculateTestItem:subTestitem TestValue:num];
//
//     num = 0;
    
//       testvalue = [NSString stringWithFormat:@"%u",arc4random()%50];
//       NSLog(@"打印fixtype=%d，testvalue=%@",fix_type,testvalue);
    
    

#pragma mark--------对测试出来的结果进行判断和赋值
    if ([calculate JuageResultupperLimit:subTestitem.max LowerLimit:subTestitem.min TestVaule:testvalue]) {
        
        subTestitem.messageError=nil;
        subTestitem.value = testvalue;
        subTestitem.result = @"PASS";
        ispass = YES;

        
    }else{
    
        PF = NO;
        subTestitem.value = testvalue;
        subTestitem.result = @"FAIL";
        subTestitem.messageError=@"NA";
    }
    

    
    //对时间进行赋值
    endTime = [timeDay getCurrentSecond];
    subTestitem.startTime = startTime;
    subTestitem.endTime   = endTime;
    
    [testValueAppendString appendFormat:@",%@",testvalue];
    [ItemArr addObject:subTestitem];      //将测试项加入数组中

    return ispass;
}



//更新upodateView
-(void)UpdateTextView:(NSString*)strMsg andClear:(BOOL)flagClearContent andTextView:(NSTextView *)textView
{
    if (flagClearContent)
    {
        dispatch_async(dispatch_get_main_queue(),
                       ^{
                           [textView setString:@""];
                       });
    }
    else
    {
        
        if (![strMsg isEqualToString:showLogStr]) {
            
            NSString  *  LogStrMessage = [NSString stringWithFormat:@"%@-->%@",[timeDay getCurrentDateAndTime],strMsg];
            
            dispatch_async(dispatch_get_main_queue(),
                           ^{
                               if ([[textView string]length]>0)
                               {
                                   NSRange range = NSMakeRange([textView.textStorage.string length] , LogStrMessage.length);
                                   [textView insertText:LogStrMessage replacementRange:range];
                                   
                               }
                               else
                               {
                                   [textView setString:[NSString stringWithFormat:@"%@",LogStrMessage]];
                               }
                               
                               [textView setTextColor:[NSColor blackColor]];
                               
                               //超过5万个字节，清理数据
                               if ([textView.textStorage length] > 50000) {
                                   
                                   [textView setString:@""];
                               }
                           });
            
            showLogStr = strMsg;
        }
    }
}



//线程开始
-(void)threadStart
{
    [thread start];
    
}


//线程结束
-(void)threadEnd
{
    [thread cancel];
    [serialport close];
    serialport = nil;
}




#pragma mark-------------获取PDCA和SFC的状态，调用代理刷新界面
-(void)getTheStateOfPDCAandSFC
{
    //1.获取保存的内容
    NSString  * locationStr = [[NSUserDefaults standardUserDefaults] objectForKey:kPDCAandSFCNotification];
    if ([locationStr containsString:@"PDCA"]) {
        
        isPDCA = YES;
    }
    if ([locationStr containsString:@"SFC"]) {
        
        SFCType = @"SFC";
        isSFC = YES;
    }
    if ([locationStr containsString:@"UOP"]) {
        
        SFCType = @"UOP";
        isSFC = YES;
    }
}




#pragma mark---------FlushMainWindowDelegate

-(void)FlushViewStartTest
{
    dispatch_async(dispatch_get_main_queue(), ^{
       
        if ([self.delegate respondsToSelector:@selector(FlushMainViewStartTestSolat:)]) {
            
             [self.delegate FlushMainViewStartTestSolat:fix_type];
        }
    });
}

-(void)FlushViewEndTest
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if ([self.delegate respondsToSelector:@selector(FlushMainViewFinshTestSolat:Result:)]) {
            
            [self.delegate FlushMainViewFinshTestSolat:fix_type Result:PF?@"PASS":@"FAIL"];
        }
    });
}

-(void)FlushCount
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if ([self.delegate respondsToSelector:@selector(FlushTestCount:)]) {
            [self.delegate FlushTestCount:PF];
        }
    });
}

-(void)DeliverySN:(NSString *)dutSn
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if ([self.delegate respondsToSelector:@selector(DeliverySolat:DutSn:)]) {
            
            [self.delegate DeliverySolat:fix_type DutSn:dutSn];
        }
    });

}

#pragma mark------------SaveDataToolDelegate
-(void)reloadLogViewWithLogList:(NSString *)logStr Collect:(BOOL)isCollect{
    
   [self UpdateTextView:logStr andClear:NO andTextView:self.Log_View ];
}


#pragma mark------------AgilentCommandDelegate
-(void)getValueFromAgilentValue:(NSString *)value AgilentType:(enum AgilentType)agilentType
{
    aglientStr = value;
    
}


#pragma mark------------ORSSerialPortDelegate
-(void)serialPort:(ORSSerialPort *)serialPort didReceiveData:(NSData *)data
{

    NSString  *  backStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
   
    [serailAppendString appendString:backStr];
    
    if ([serailAppendString containsString:@"OK@_@\r\n"]) {
        isFinsh = YES;
        [serailAppendString setString:@""];
    }
    else if([serailAppendString containsString:@"@_@\r\n"])
    {
        isFinsh = YES;
    }
}


-(void)waitForData:(float)timeout
{
    isFinsh = NO;
    float time = 0;
    while (YES) {
        
        if (isFinsh) {
            
            break;
        }
        if (time>timeout) {
            
            break;
        }
        
        [NSThread sleepForTimeInterval:0.02];
        time+=0.02;
    }
    isFinsh = NO;
}




-(void)serialPortWasClosed:(ORSSerialPort *)serialPort
{
    
    NSLog(@"串口已经被关闭");
}

@end
