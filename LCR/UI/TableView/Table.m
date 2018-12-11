//
//  Table1.m
//  B312_BT_MIC_SPK
//
//  Created by EW on 16/5/12.
//  Copyright © 2016年 h. All rights reserved.
//

#import "Table.h"



//=============================================
@interface Table ()


@property(nonatomic,assign)int  index;
@end
//=============================================
@implementation Table
//=============================================
- (id)init:(NSView*)parent DisplayData:(NSArray*)arrayData Count:(int)count
{
    
    self = [super init];

    _index=0;
    
    if (self)
    {
        
         self.testArray =arrayData;
         [self InitTableView:arrayData Count:count];
         //添加约束
         [self addconstraintToParentView:parent subView:self.view];
        
    }

    return self;
}


//=============================================
- (void)tableViewColumnDidResize:(NSNotification *)aNotification
{
    NSTableView* aTableView = aNotification.object;
    NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,aTableView.numberOfRows)];
    [aTableView noteHeightOfRowsWithIndexesChanged:indexes];
    
    NSLog(@"aaa");
}

//=============================================
-(void)InitTableView:(NSArray*)arrayData Count:(int)count
{
    _arrayDataSource =[[NSMutableArray alloc] init];
    
    NSLog(@"传递进来元素的数量%lu",(unsigned long)[arrayData count]);
        int countDisplay=1;
        
        for (int i=0; i<[arrayData count]; i++)
        {
            //解析数组下标,取值
            Item* item=[arrayData objectAtIndex:i];
            
            if((item.isTest == YES)&&(item.isShow == YES))
            {
                NSMutableDictionary* dic=[[NSMutableDictionary alloc] init];
                
                //赋值,在tableView 上显示的数据(固定值)
                [dic setValue:[NSString stringWithFormat:@"%d",countDisplay] forKey:TABLE_COLUMN_ID];
                [dic setValue:item.testName?    item.testName:@"" forKey:TABLE_COLUMN_TESTNAME];
                [dic setValue:item.units?     item.units:    @""  forKey:TABLE_COLUMN_UNITS];
                [dic setValue:item.min?     item.min:    @""      forKey:TABLE_COLUMN_MIN];
                [dic setValue:item.max?  item.max: @""            forKey:TABLE_COLUMN_MAX];
                [dic setValue:item.freq?  item.freq: @""            forKey:TABLE_COLUMN_FREQ];
                
                
                for (int j = 1; j<=count; j++) {
                    
                  [dic setValue:@""    forKey:[NSString stringWithFormat:@"%@%d",TABLE_COLUMN_VALUE,j]];
                  [dic setValue:@""    forKey:[NSString stringWithFormat:@"%@%d",TABLE_COLUMN_RESULT,j]];

                }
                
                
                
                [_arrayDataSource addObject:dic];
                countDisplay++;
            }
        }
    
      NSLog(@"数组_arrayDataSource的个数%lu",(unsigned long)[_arrayDataSource count]);
        
        
        [self.table reloadData];
        [self.table needsDisplay];
    
}
//=============================================
-(void)SelectRow:(int)rowindex
{
    dispatch_async(dispatch_get_main_queue(), ^{

        NSIndexSet* indexSet = [[NSIndexSet alloc] initWithIndex:rowindex];
        [self.table selectRowIndexes:indexSet byExtendingSelection:NO];  // 选择指定行
        [self.table scrollRowToVisible:rowindex];                        // 滚动到指定行
        [self.table needsDisplay];
    });
}

//=============================================
-(void)flushTableRow:(Item*)item RowIndex:(NSInteger)rowIndex with:(int)fixtype
{

//    
//    dispatch_async(_queue, ^{
//        
        
        NSLog(@"打印_arrayDataSource = %lu元素",[_arrayDataSource count]);
        
        BOOL ispass = NO;
        if([item.result isEqualToString:@"PASS"])ispass=YES;
        NSDictionary* color = [NSDictionary dictionaryWithObjectsAndKeys:ispass?[NSColor blueColor]:[NSColor redColor],NSForegroundColorAttributeName, nil];
        NSAttributedString* result = [[NSAttributedString alloc] initWithString:ispass?@"PASS":@"FAIL" attributes:color];
    
        [[_arrayDataSource objectAtIndex:rowIndex] setValue:item.value       forKey:[NSString stringWithFormat:@"%@%d",TABLE_COLUMN_VALUE,fixtype]];
        [[_arrayDataSource objectAtIndex:rowIndex] setValue:result           forKey:[NSString stringWithFormat:@"%@%d",TABLE_COLUMN_RESULT,fixtype]];
    
    
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSIndexSet* indexSet = [[NSIndexSet alloc] initWithIndex:rowIndex];
            [self.table selectRowIndexes:indexSet byExtendingSelection:YES]; // 选择指定行
            [self.table scrollRowToVisible:rowIndex];// 滚动到指定行
            [self.table reloadData];
            [self.table needsDisplay];
        });
        
        
        
//    });
    
   
}


//=============================================
-(void)ClearTable:(int)fixType
{
    for (int i=0; i<[_arrayDataSource count]; i++)
    {
        
        [[_arrayDataSource objectAtIndex:i] setValue:@"" forKey:[NSString stringWithFormat:@"%@%d",TABLE_COLUMN_VALUE,fixType]];
        [[_arrayDataSource objectAtIndex:i] setValue:@"" forKey:[NSString stringWithFormat:@"%@%d",TABLE_COLUMN_RESULT,fixType]];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.table reloadData];
    });
}

#pragma mark-tableView Delegate/DataSource
//=============================================

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [_arrayDataSource count];
}
//=============================================
- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    if ([_arrayDataSource objectAtIndex:row]==nil)
        
        return @"";
    else
    {
        return [[_arrayDataSource objectAtIndex:row] objectForKey:[tableColumn identifier]];
    }
}



//- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row{
//    
//    if ([[tableView selectedColumnIndexes] containsIndex:row]) {
//        
//        [cell setBackgroundColor:[NSColor yellowColor]];
//        
//    }else
//    {
//        //[cell setBackgroundColor:[NSColor gridColor]];
//    }
//    [cell setDrawsBackground:YES];
//}



//=============================================
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}
//=============================================

//-(void)flushTableDic:(NSDictionary*)dic RowIndex:(NSInteger)rowIndex
//{
//
//
//    BOOL ispass = NO;
//    
//    if([dic[@"result"] isEqualToString:@"PASS"])ispass=YES;
//    
//    NSLog(@"================%@",dic[@"result"]);
//    
//    
//    NSDictionary* color = [NSDictionary dictionaryWithObjectsAndKeys:ispass?[NSColor greenColor]:[NSColor redColor],NSForegroundColorAttributeName, nil];
//    
//    NSAttributedString* result = [[NSAttributedString alloc] initWithString:ispass?@"                        PASS":@"                        FAIL" attributes:color];
//    
//    //给模型对应的 key 值赋值
//    [[_arrayDataSource objectAtIndex:rowIndex] setValue:dic[@"value"]   forKey:TABLE_COLUMN_VALUE];
//    [[_arrayDataSource objectAtIndex:rowIndex] setValue:result           forKey:TABLE_COLUMN_RESULT];
//    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        
//        NSIndexSet* indexSet = [[NSIndexSet alloc] initWithIndex:rowIndex];
//        [self.table selectRowIndexes:indexSet byExtendingSelection:NO]; // 选择指定行
//        [self.table scrollRowToVisible:rowIndex];// 滚动到指定行
//        [self.table reloadData];
//        [self.table needsDisplay];
//    });
//}




-(void)addconstraintToParentView:(NSView *)parent subView:(NSView *)subView
{

    [parent addSubview:self.view];
    
    self.view.translatesAutoresizingMaskIntoConstraints =NO;
    
    NSLayoutConstraint *constraint = nil;
    
    constraint = [NSLayoutConstraint constraintWithItem:subView
                                              attribute:NSLayoutAttributeLeading
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:parent
                                              attribute:NSLayoutAttributeLeading
                                             multiplier:1.0f
                                               constant:0];
    [parent addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:subView
                                              attribute:NSLayoutAttributeTrailing
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:parent
                                              attribute:NSLayoutAttributeTrailing
                                             multiplier:1.0f
                                               constant:0];
    [parent addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:subView
                                              attribute:NSLayoutAttributeTop
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:parent
                                              attribute:NSLayoutAttributeTop
                                             multiplier:1.0f
                                               constant:0];
    [parent addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:subView
                                              attribute:NSLayoutAttributeBottom
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:parent
                                              attribute:NSLayoutAttributeBottom
                                             multiplier:1.0f
                                               constant:0];
    [parent addConstraint:constraint];
    
    
    
}




//=============================================
@end

