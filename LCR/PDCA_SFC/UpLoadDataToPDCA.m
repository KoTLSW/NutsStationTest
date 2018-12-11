//
//  UpLoadDataToPDCA.m
//  LeftButtonFlexCompassSenorTest
//
//  Created by linanlin on 2017/7/22.
//  Copyright © 2017年 linanlin. All rights reserved.
//

#import "UpLoadDataToPDCA.h"
#import "SaveDataTool.h"

@implementation UpLoadDataToPDCA

-(instancetype)initWithNumber:(int)number
{
    if (self=[super init]) {
        Number=number;
    }
    return self;
}
//************************************************************************
// Start Test
//************************************************************************
- (BOOL) UUTStartTest{
    [self updatePDCALogFile:[NSString stringWithFormat:@"[%d] *****************************************************", Number]];
    [self updatePDCALogFile:[NSString stringWithFormat:@"[%d] UUTStartTest: IP_UUTStart", Number]];
    
    IP_REPLY = IP_UUTStart(&IP_UID);
    if (!IP_success(IP_REPLY)) {
        const char*initInfo = " ";
        initInfo = IP_reply_getError(IP_REPLY);
        NSString* strErr= [NSString stringWithFormat:@"[%d] Error: IP_UUTStart: %@", Number, [NSString stringWithUTF8String:initInfo]];
        NSLog(@"PDCA%@", strErr);
        [self updatePDCALogFile:strErr];
        IP_UUTCancel(IP_UID);
        return NO;
    }
    
    return YES;
}


//************************************************************************
// Cancel Test
//************************************************************************
- (BOOL) UUTCancelTest{
    [self updatePDCALogFile:[NSString stringWithFormat:@"[%d] UUTCancelTest: IP_UUTCancel", Number]];
    if (!(IP_UID == NULL)) {
        IP_REPLY =  IP_UUTCancel(IP_UID);
    }
    if(!IP_success(IP_REPLY))
    {
    const char*initInfo = " ";
    initInfo = IP_reply_getError(IP_REPLY);
    NSString* strErr= [NSString stringWithFormat:@"[%d] Error: IP_UUTCancel: %@", Number, [NSString stringWithUTF8String:initInfo]];
    NSLog(@"PDCA%@", strErr);
    [self updatePDCALogFile:strErr];
    return NO;
    }
    
    [self updatePDCALogFile:[NSString stringWithFormat:@"[%d] *****************************************************\n\n", Number]];
    return YES;
}

//************************************************************************
// Validate Serial Number
//************************************************************************
- (NSString*) ValidateSerialNumber: (NSString*)SN{
    NSString* strLog = [NSString stringWithFormat:@"[%d] ValidateSerialNumber: IP_validateSerialNumber(%@)", Number, SN]; 
    [self updatePDCALogFile:strLog];
    
    NSString *trimmed = [SN stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    IP_API_Reply reply_ValidateSN = IP_validateSerialNumber(IP_UID, [trimmed UTF8String]);
    
    if (!IP_success(reply_ValidateSN)) {
        const char*errorInfo = " ";
        errorInfo = IP_reply_getError(reply_ValidateSN);
        NSString* failInfo = [NSString stringWithFormat:@"[%d] Error: IP_validateSerialNumber: %@", Number,[NSString stringWithUTF8String:errorInfo]];
        NSLog(@"PDCA%@",failInfo);
        [self updatePDCALogFile:failInfo];
         return failInfo;
    }
    
    IP_reply_destroy(reply_ValidateSN);
    
    return @"PASS";
}


//************************************************************************
// Add Attribute
//************************************************************************
- (void) AddAttribute: (NSString*)name AttributeValue: (NSString*)value{
    NSString* strLog = [NSString stringWithFormat:@"[%d] AttributeValue: IP_addAttribute(%@, %@)", Number, name, value];
    [self updatePDCALogFile:strLog];
    
    IP_API_Reply replyUploadAttr = IP_addAttribute(IP_UID,[name UTF8String],[value UTF8String]);
    if (!IP_success(replyUploadAttr)) {
        const char*errorInfo = " ";
        errorInfo = IP_reply_getError(replyUploadAttr);
        NSString* failInfo = [NSString stringWithFormat:@"[%d] Error: IP_addAttribute: %@", Number, [NSString stringWithUTF8String:errorInfo]];
        NSLog(@"PDCA%@",failInfo);
        [self updatePDCALogFile:failInfo];
        
    }
    
    IP_reply_destroy(replyUploadAttr);
}


//*****************************************************************************
// default attribute for PDCA: SN/SW verison/ SW name
//*****************************************************************************
- (void) AddDefaultAttribute: (NSString*)sn SoftwareVersion:(NSString*)swVer SoftwareName:(NSString*)swName{
    [self AddAttribute:[NSString stringWithUTF8String:IP_ATTRIBUTE_SERIALNUMBER] AttributeValue:sn];
    [self AddAttribute:[NSString stringWithUTF8String:IP_ATTRIBUTE_STATIONSOFTWAREVERSION] AttributeValue:swVer];
    [self AddAttribute:[NSString stringWithUTF8String:IP_ATTRIBUTE_STATIONSOFTWARENAME] AttributeValue:swName];
}


//*****************************************************************************
// Validate AM I OK
//*****************************************************************************
- (NSString*) ValidateAMIOK: (NSString*)SN{

    
    IP_API_Reply replyAMIOK = IP_amIOkay(IP_UID, [SN UTF8String]);
    if (!IP_success(replyAMIOK)) {
        const char*errorInfo = " ";
        errorInfo = IP_reply_getError(replyAMIOK);
        NSString* failInfo = [NSString stringWithFormat:@"%@[%d] Error: IP_amIOkay: %@",SN, Number, [NSString stringWithUTF8String:errorInfo]];
        return failInfo;
    }
    
    IP_reply_destroy(replyAMIOK);
    return @"PASS";
}


//*****************************************************************************
// Add a testItem
//*****************************************************************************
-(BOOL) AddTestItemWithItemName:(NSString*)itemName
                      TestValue:(NSString*)testValue
                     TestResult:(NSString*)testResult
                      HighLimit:(NSString*)highLimit
                       LowLimit:(NSString*)lowLimit
                       Unit:(NSString*)unit
                      ErrorInfo:(NSString*)errorInfo withModel:(NSString *)model{
    
    NSString* strLog = [NSString stringWithFormat:@"[%d] AddTestItem:%@, Value=%@, Result=%@, USL=%@ LSL=%@  ErrorInfo:%@",
                        Number,
                        itemName,
                        testValue,
                        testResult,
                        highLimit,
                        lowLimit,
                        errorInfo];
    [self updatePDCALogFile:strLog];
    
    //Need to make sure the units are set to something
    if([highLimit isEqualToString:@""])
    {
        highLimit = @"N/A";
    }
    if([lowLimit isEqualToString:@""])
    {
        lowLimit = @"N/A";
    }
//    if([testValue isEqualToString:@""])
//    {
//        testValue = @"0.0";
//    }
    //need to trim error info to a max of 512
    if([errorInfo length]>512)
        errorInfo = [errorInfo substringToIndex:512];
    
    //创建 specHandle
    IP_TestSpecHandle specHandle = IP_testSpec_create();
    if (!specHandle) {
        NSLog(@"PDCA[%d] Error: IP_testSpec_create :%@", Number, itemName);
        specHandle = NULL;
        return NO;
    }
    // set the item parameter
    // test name
    
    itemName= [itemName stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    
    BOOL bol_SetItem = IP_testSpec_setTestName(specHandle,[itemName UTF8String],[itemName length]);
    if (!bol_SetItem) {
        NSLog(@"PDCA[%d] Error: IP_testSpec_setTestName: %@", Number, itemName);
        return NO;
    }
    
    //Limits
     lowLimit= [lowLimit stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    highLimit= [highLimit stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSLog(@"%@:%@------%@",itemName,lowLimit,highLimit);
    bol_SetItem = IP_testSpec_setLimits(specHandle, [lowLimit UTF8String], [lowLimit length], [highLimit UTF8String], [highLimit length]);
    if (!bol_SetItem) {
        NSLog(@"PDCA[%d] Error: IP_testSpec_setLimits: %@", Number, itemName);
        return NO;
    }
    //Unit
    bol_SetItem = IP_testSpec_setUnits(specHandle, [unit UTF8String], [unit length]);
    if (!bol_SetItem) {
        NSLog(@"PDCA[%d] Error: IP_testSpec_setUnits: %@", Number, itemName);
        return NO;
    }
    
    // priority //使用默认优先级即可
    if ([model isEqualToString:@"MP"]) {
        bol_SetItem = IP_testSpec_setPriority(specHandle, IP_PRIORITY_REALTIME);
        
    }else{
        bol_SetItem = IP_testSpec_setPriority(specHandle, IP_PRIORITY_STATION_CALIBRATION_AUDIT);

    }
    
    
    if (!bol_SetItem) {
        NSLog(@"PDCA[%d] Error: IP_testSpec_setPriority: %@", Number, itemName);
        return NO;
    }
    NSString *units=@"N/A";
    // units
    bol_SetItem = IP_testSpec_setUnits(specHandle, [units UTF8String], [units length]);
    if (!bol_SetItem) {
        NSLog(@"PDCA[%d] Error: IP_testSpec_setUnits: %@", Number, itemName);
        
        return NO;
    }
    //创建resultHandle
    IP_TestResultHandle resultHandle = IP_testResult_create();
    if (!resultHandle) {
        NSLog(@"PDCA[%d] Error: IP_testResult_create: %@", Number, itemName);
        resultHandle = NULL;
        return NO;
    }
    //设置result
    if ([testResult  isEqualToString:@"PASS"]) {
        bol_SetItem = IP_testResult_setResult(resultHandle, IP_PASS);
        if (!bol_SetItem) {
            NSLog(@"PDCA[%d] Error: IP_testResult_setResult IP_PASS: %@", Number, itemName);
            return NO;
        }
    }else if([testResult  isEqualToString:@"FAIL"]){
        bol_SetItem = IP_testResult_setResult(resultHandle, IP_FAIL);
        BOOL bol_SetErrorInfo = IP_testResult_setMessage(resultHandle, [errorInfo UTF8String], [errorInfo length]);
        self.isFailed = true;
        if (!bol_SetItem || !bol_SetErrorInfo) {
            NSLog(@"PDCA[%d] Error: IP_testResult_setResult IP_FAIL: %@", Number, itemName);
            return NO;
        }
    }else{
        bol_SetItem = IP_testResult_setResult(resultHandle, IP_NA);
        if (!bol_SetItem) {
            NSLog(@"PDCA[%d] Error: IP_testResult_setResult IP_NA: %@", Number, itemName);
            return NO;
        }
    }
    

    // set value
    testValue= [testValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if(!([testValue isEqualToString:@"PASS"] || [testValue isEqualToString:@"FAIL"])){
        //NSLog(@"#####%@-------%@",testValue,itemName);
        bol_SetItem = IP_testResult_setValue(resultHandle, [testValue UTF8String], [testValue length]);
        if (!bol_SetItem) {
            NSLog(@"PDCA[%d] Error: IP_testResult_setValue: %@", Number, itemName);
            return NO;
        }
    }
    // replyAddResult
    IP_API_Reply replyAddResult = IP_addResult(IP_UID, specHandle, resultHandle);
    if (!IP_success(replyAddResult)) {
        const char*errorInfo = " ";
        errorInfo = IP_reply_getError(replyAddResult);
        NSString* failInfo = [NSString stringWithFormat:@"[%d] Error: IP_addResult: %@", Number, [NSString stringWithUTF8String:errorInfo]];
        NSLog(@"PDCA%@",failInfo);
        return NO;
    }else{

    }
    
    return YES;
}
//End add a test item

//*****************************************************************************
// Commit to PDCA
//*****************************************************************************
- (NSString*) CommitPDCA:(bool)isTestOk {
    //log done
    NSString* strLog = [NSString stringWithFormat:@"[%d] CommitPDCA: IP_UUTDone", Number];
    [self updatePDCALogFile:strLog];
    
    const char*errorInfo = " ";
    //说明前面的已经完成了准备妥当了
    IP_API_Reply reply_ReleaseResult = IP_UUTDone(IP_UID);
    if(!IP_success(reply_ReleaseResult)){
        errorInfo = IP_reply_getError(reply_ReleaseResult);
        NSString* failInfo = [NSString stringWithFormat:@"[%d] Error: IP_UUTDone: %@", Number, [NSString stringWithUTF8String:errorInfo]];
        NSLog(@"PDCA%@",failInfo);
        [self updatePDCALogFile:failInfo];
        IP_UUTCancel(IP_UID);
        
        [self updatePDCALogFile:[NSString stringWithFormat:@"[%d] *********************COMMIT ERROR*********************\n\n", Number]];
        
        return failInfo;
    }
    
    IP_reply_destroy(reply_ReleaseResult);
    // end UUT Done
    //log commit
    strLog = [NSString stringWithFormat:@"[%d] CommitPDCA: IP_UUTCommit(%@)", Number, self.isFailed ? @"FAIL" : @"PASS"];
    [self updatePDCALogFile:strLog];
    
    // Done成功的话就 begin Commit
    IP_API_Reply reply_Commit = IP_UUTCommit(IP_UID, isTestOk ? IP_PASS : IP_FAIL);
    NSMutableString* finalResult = [NSMutableString stringWithString:@"PASS"];
    if(!IP_success(reply_Commit)){
        errorInfo = IP_reply_getError(reply_Commit);
        finalResult = [NSMutableString stringWithFormat:@"[%d] Error: IP_UUTCommit: %@", Number, [NSString stringWithUTF8String:errorInfo]];
        NSLog(@"PDCA%@",finalResult);
        [self updatePDCALogFile:finalResult];
    }
    
    //snwh IP_reply_destroy(IP_UID);
    IP_reply_destroy(reply_Commit);
    IP_reply_destroy(IP_REPLY);
    
    [self updatePDCALogFile:[NSString stringWithFormat:@"[%d] *****************************************************\n\n", Number]];
    
    return finalResult;
}


//*****************************************************************************
// PDCA Log File
//*****************************************************************************
-(void)updatePDCALogFile:(NSString*)strMsg{
    
     //如果需要保存相关的log信息，再次天假saveData工具类。
    
}


-(NSString*)addBlobFileName:(NSString*)fileName filePath:(NSString*)filePath{
    
    
    NSString *printInfo = [NSString stringWithFormat:@"add Blob fileName = %@,filePath = %@",fileName,filePath];
    

    NSString *realfileName = [fileName stringByReplacingOccurrencesOfString:@":" withString:@"-"];
    
    NSString *realfilePath = [NSString stringWithFormat:@"%@/%@",filePath,realfileName] ;
    
    
    IP_API_Reply add_Result = IP_addBlob(IP_UID, [realfileName UTF8String],[realfilePath UTF8String]);
    NSString *info = nil;
    
    const char*error = " ";
    if (!IP_success(add_Result)) {
        error = IP_reply_getError(add_Result);
        info = [NSMutableString stringWithFormat:@"add BlobFile is Fail,the error is:%@",[NSString stringWithUTF8String:error]];
        IP_reply_destroy(add_Result);
        return info;
    }else{
        IP_reply_destroy(add_Result);
        return @"PASS";
    }
    
}



//检验SN的值
-(NSString *)SFC_CheckSN:(NSString *)Sn WithStationID:(NSString *)station_id
{
    //在PDCA服务器中查询当前SN
    IP_API_Reply reply =  IP_addAttribute( IP_UID, IP_ATTRIBUTE_STATIONIDENTIFIER, [station_id UTF8String] );//Set Station ID to “DFU-NAND-INIT”
    if (IP_success(reply)== false) {
        NSLog(@"IP_amIOkay_reply fail");
        NSLog(@"Message:%@", @(IP_reply_getError(reply)));
        return NO;
    }
    else
    {
        NSLog(@"IP_amIOkay_reply OK");
        NSLog(@"Message:%@", @(IP_reply_getError(reply)));
    }
    usleep(300000);
    IP_API_Reply doneReply = IP_amIOkay(IP_UID, [Sn UTF8String]);//Query to the process control system
    if (IP_success( doneReply ) == false)
    {
        NSLog(@"IP_amIOkay_doneReply fail");
        NSString  * backstring = @(IP_reply_getError(doneReply));
        NSLog(@"Message:%@", backstring);
        return backstring;
    }
    else
    {   NSLog(@"IP_amIOkay_doneReply OK");
        NSLog(@"Message:%@", @(IP_reply_getError(doneReply)));
        IP_reply_destroy(IP_UUTDone(IP_UID));
        IP_reply_destroy(doneReply);
        return @"PASS";
    }
}


@end
