//
//  STPickerArea.m
//  STPickerView
//
//  Created by https://github.com/STShenZhaoliang/STPickerView on 16/2/15.
//  Copyright © 2016年 shentian. All rights reserved.
//

#import "STPickerArea.h"

@interface STPickerArea()<UIPickerViewDataSource, UIPickerViewDelegate>

/** 1.数据源数组 */
@property (nonatomic, strong, nullable)NSArray *arrayRoot;
/** 2.当前省数组 */
@property (nonatomic, strong, nullable)NSMutableArray *arrayProvince;
/** 3.当前城市数组 */
@property (nonatomic, strong, nullable)NSMutableArray *arrayCity;
/** 4.当前地区数组 */
@property (nonatomic, strong, nullable)NSMutableArray *arrayArea;
/** 5.当前选中省份的城市数组 */
@property (nonatomic, strong, nullable)NSMutableArray *cityListSelected;
/** 6.当前选中城市的地区数组 */
@property (nonatomic, strong, nullable)NSMutableArray *areaListSelected;

/** 6.省份 */
@property (nonatomic, strong, nullable) NSString *province;
@property (nonatomic, strong, nullable) NSDictionary *provinceInfo;
/** 7.城市 */
@property (nonatomic, strong, nullable) NSString *city;
@property (nonatomic, strong, nullable) NSDictionary *cityInfo;

/** 8.地区 */
@property (nonatomic, strong, nullable) NSString *area;
@property (nonatomic, strong, nullable) NSDictionary *areaInfo;


@end

@implementation STPickerArea

#pragma mark - --- init 视图初始化 ---

- (void)setupUI
{
    // 1.获取数据
    [self.arrayRoot enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.arrayProvince addObject:obj[@"regionName"]];
    }];

    NSMutableArray *citys = [NSMutableArray arrayWithArray:[self.arrayRoot firstObject][@"cityList"]];
    [citys enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.arrayCity addObject:obj[@"regionName"]];
    }];

    
    NSArray *areas = [citys firstObject][@"areaList"];
    [areas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.arrayArea addObject:obj[@"regionName"]];
    }];
    
    
    

    self.province = self.arrayProvince[0];
    self.provinceInfo = self.arrayRoot[0];
    self.city = self.arrayCity[0];
    self.cityInfo = [self getCityWithProvinceIndex:0 cityIndex:0];
    if (self.arrayArea.count != 0) {
        self.area = self.arrayArea[0];
        self.areaInfo = [self getAreaWithProvinceIndex:0 cityIndex:0 areaIndex:0];
    }else{
        self.area = @"";
    }
    
    // 2.设置视图的默认属性
    _heightPickerComponent = 32;
    [self setTitle:@"请选择城市地区"];
    [self.pickerView setDelegate:self];
    [self.pickerView setDataSource:self];

}
#pragma mark - --- delegate 视图委托 ---

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return self.arrayProvince.count;
    }else if (component == 1) {
        return self.arrayCity.count;
    }else{
        return self.arrayArea.count;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return self.heightPickerComponent;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        self.cityListSelected = self.arrayRoot[row][@"cityList"];

        [self.arrayCity removeAllObjects];
        [self.cityListSelected enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.arrayCity addObject:obj[@"regionName"]];
        }];
        
        self.areaListSelected = [self.cityListSelected firstObject][@"areaList"];
        [self.arrayArea removeAllObjects];
        [self.areaListSelected enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.arrayArea addObject:obj[@"regionName"]];
        }];
        
        

        [pickerView reloadComponent:1];
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        [pickerView selectRow:0 inComponent:2 animated:YES];

    }else if (component == 1) {
        if (self.cityListSelected.count == 0) {
            self.cityListSelected = [self.arrayRoot firstObject][@"cityList"];
        }
        
        self.areaListSelected = [self.cityListSelected objectAtIndex:row][@"areaList"];
        [self.arrayArea removeAllObjects];
        [self.areaListSelected enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.arrayArea addObject:obj[@"regionName"]];
        }];

        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:YES];

    }else{
    }

    [self reloadData];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view
{

    NSString *text;
    if (component == 0) {
        text =  self.arrayProvince[row];
    }else if (component == 1){
        text =  self.arrayCity[row];
    }else{
        if (self.arrayArea.count > 0 && self.arrayArea.count>row) {
            text = self.arrayArea[row];
        }else{
            text =  @"";
        }
    }


    UILabel *label = [[UILabel alloc]init];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont systemFontOfSize:17]];
    [label setText:text];
    return label;


}
#pragma mark - --- event response 事件相应 ---

- (void)selectedOk
{
    [self.delegate pickerArea:self province:self.provinceInfo city:self.cityInfo area:self.areaInfo];
    [super selectedOk];
}

#pragma mark - --- private methods 私有方法 ---

- (void)reloadData
{
    NSInteger index0 = [self.pickerView selectedRowInComponent:0];
    NSInteger index1 = [self.pickerView selectedRowInComponent:1];
    NSInteger index2 = [self.pickerView selectedRowInComponent:2];
    self.province = self.arrayProvince[index0];
    self.provinceInfo = self.arrayRoot[index0];
    self.city = self.arrayCity[index1];
    self.cityInfo = [self getCityWithProvinceIndex:index0 cityIndex:index1];
    if (self.arrayArea.count != 0) {
        self.area = self.arrayArea[index2];
        self.areaInfo = [self getAreaWithProvinceIndex:index0 cityIndex:index1 areaIndex:index2];
    }else{
        self.area = @"";
        self.areaInfo = nil;

    }
    
    NSString *title = [NSString stringWithFormat:@"%@ %@ %@", self.province, self.city, self.area];
    [self setTitle:title];

}

//获取cityInfo
- (NSDictionary *)getCityWithProvinceIndex:(NSInteger)pIndex cityIndex:(NSInteger)cIndex {
    NSDictionary *provinceInfo = [self.arrayRoot objectAtIndex:pIndex];
    NSArray *cityList = [provinceInfo objectForKey:@"cityList"];
    if (!cityList.count || cityList.count <= cIndex) {
        return nil;
    }
    NSDictionary *cityInfo = [cityList objectAtIndex:cIndex];
    return cityInfo;
}

//获取areaInfo
- (NSDictionary *)getAreaWithProvinceIndex:(NSInteger)pIndex cityIndex:(NSInteger)cIndex areaIndex:(NSInteger)aIndex {
    NSDictionary *cityInfo = [self getCityWithProvinceIndex:pIndex cityIndex:cIndex];
    
    NSArray *areaList = [cityInfo objectForKey:@"areaList"];
    if (!areaList.count) {
        return nil;
    }
    return [areaList objectAtIndex:aIndex];
}


#pragma mark - --- setters 属性 ---

#pragma mark - --- getters 属性 ---

- (NSArray *)arrayRoot
{
    if (!_arrayRoot) {
        NSString *path = [[NSBundle mainBundle]pathForResource:@"area" ofType:@"plist"];
        _arrayRoot = [[NSArray alloc]initWithContentsOfFile:path];
    }
    return _arrayRoot;
}

- (NSMutableArray *)arrayProvince
{
    if (!_arrayProvince) {
        _arrayProvince = [NSMutableArray array];
    }
    return _arrayProvince;
}

- (NSMutableArray *)arrayCity
{
    if (!_arrayCity) {
        _arrayCity = [NSMutableArray array];
    }
    return _arrayCity;
}

- (NSMutableArray *)arrayArea
{
    if (!_arrayArea) {
        _arrayArea = [NSMutableArray array];
    }
    return _arrayArea;
}

- (NSMutableArray *)cityListSelected
{
    if (!_cityListSelected) {
        _cityListSelected = [NSMutableArray array];
    }
    return _cityListSelected;
}

- (NSMutableArray *)areaListSelected {
    if (!_areaListSelected) {
        _areaListSelected = [NSMutableArray array];
    }
    return _areaListSelected;
}

@end


