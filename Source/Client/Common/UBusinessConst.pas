unit UBusinessConst;

interface
uses SysUtils, cxMCListBox, cxListView, UDataModule, Classes, DB, Controls;

type
  TPoundStationData = record
    FStation  : string;            //磅站标识
    FValue    : Double;           //皮重
    FDate     : TDateTime;        //称重日期
    FOperator : string;           //操作员
  end;

  PLadingBillItem = ^TLadingBillItem;
  TLadingBillItem = record
    FID         : string;          //交货单号
    FCard       : string;          //billcode
    FZhiKa      : string;          //pk_meambill
    FCusID      : string;          //客户编号
    FCusName    : string;          //客户名称
    FTruck      : string;          //车牌号码

    FType       : string;          //品种类型
    FStockNo    : string;          //品种编号
    FStockName  : string;          //品种名称
    FValue      : Double;          //提货量
    FPrice      : Double;          //提货单价

    FBatchCode  : string;          //批次号
    FBatckrest  : Double;          //本批次剩余量

    FStatus     : string;
    FNextStatus : string;

    FPData      : TPoundStationData; //称皮
    FMData      : TPoundStationData; //称毛
    FFactory    : string;          //工厂编号
    FPModel     : string;          //称重模式
    FPType      : string;          //业务类型
    FPoundID    : string;          //称重记录
    FSelected   : Boolean;         //选中状态

    FKZValue    : Double;         //扣杂数量
    FKZComment  : string;         //扣杂原因
    FPDValue    : Double;         //暗扣数量
    FAreaName   : string;         //地点

    FMKBillUnit : string;         //制单公司
    FMKBillMan  : string;         //制单人
    FMKBillDate : TDateTime;      //制单时间
    FTransport  : string;         //运输单位

    FBillOrign  : string;         //订单来源（N、NC；S、自开单）

    FNCChanged  : Boolean;         //NC可用量变化
    FChangeValue: Double;          //NC 减少
  end;

  TLadingBillItems = array of TLadingBillItem;
  //交货单列表

  TOrderItemInfo = record    
    FCusID: string;       //客户号
    FCusName: string;     //客户名
    FCusCode: string;     //客户代码
    FSaleID: string;     //业务员
    FSaleMan: string;     //业务员 
    FStockID: string;     //物料号
    FStockName: string;   //物料名
    FStockType: string;   //物料类型
    FTruck: string;       //车牌号
    FBatchCode: string;   //批次号
    FOrders: string;      //订单号(可多张)
    FValue: Double;       //可用量

    FAreaName: string;    //到货地点
    FBillID: string;      //xxxx

    FMaxValue: Double;      //最大可用
    FKDValue: Double;       //开单量

    FMKBillUnit: string;    //制单公司
    FMKBillMan:string;      //制单人
    FMKBillDate: TDateTime; //制单时间
  end;

  TOrderItems = array of TOrderItemInfo;
  //订单列表

function GetSQLQueryOrder(var nOutData: string; nInData: string='';
  nExtParam: string=''): Boolean;
function GetSQLQueryCustomer(var nOutData: string; nInData: string='';
  nExtParam: string=''): Boolean;
function GetSQLQueryDispatch(var nOutData: string; nInData: string='';
  nExtParam: string=''): Boolean;
function GetSQLQueryBatchCode(var nOutData: string; nInData: string='';
  nExtParam: string=''):Boolean;

function GetOrderGYValueLocal(var nOutData: string; nInData: string='';
  nExtParam: string=''): Boolean;
function GetOrderFHValueLocal(var nOutData: string; nInData: string='';
  nExtParam: string=''): Boolean;
function GetOrderFHValue(const nOrders: TStrings;
  const nQueryFreeze: Boolean=True): Boolean;
function GetOrderGYValue(const nOrders: TStrings): Boolean;
function GetNCBatchSent(nBatch: string): Double;
function GetTruckPValue(nTruck: string):Double;

function GetQueryCustomerSQL(const nCusID,nCusName: string): string;

function PrintBillReport(nBill: string; const nAsk: Boolean): Boolean;
function PrintPoundReport(const nPound: string; nAsk: Boolean): Boolean;
function PrintSalePoundReport(const nPound: string; nAsk: Boolean): Boolean;

function SaveTruckPoundItem(const nStrBills: String;
  var nOutData:string): Boolean;
function SaveLadingBills(const nPost: string; const nStrBills: String;
  var nOutBillID, nErrHint: string): Boolean;

function GetLadingBills(nID: string; var nOutBills: TLadingBillItems):Boolean;
function GetTruckPoundItem(const nTruck: string;
  var nPoundData: TLadingBillItems): Boolean;

function GetSerailID(var nOutData: string; nInData: string='';
  nExtParam: string=''): Boolean;
function SyncNC_ME03(var nOutData: string; nInData: string='';
  nExtParam: string=''): Boolean;
function SyncNC_ME25(var nOutData: string; nInData: string='';
  nExtParam: string=''): Boolean;

function GetNCBillTypeCHS(const nNCType: string; var nSysType: string): string;

procedure AnalyzeOrderInfo(const nOrder: string; var nItem: TOrderItemInfo);
function BuildOrderInfo(const nItem: TOrderItemInfo): string;
procedure LoadOrderInfo(const nOrder: TOrderItemInfo; const nList: TcxMCListBox);
function LoadCustomerInfo(const nCID: string; const nList: TcxMCListBox;
 var nHint: string): TDataSet;
function LoadDispatchUnitInfo(const nUID: string; const nList: TcxMCListBox;
 var nHint: string): TDataSet;

function CombineBillItmes(const nItems: TLadingBillItems): string;
procedure AnalyseBillItems(const nData: string; var nItems: TLadingBillItems);

function TruckInFact(nTruck: string):Boolean;
function GetHistoryTruckPValue(nTruck: string): Double;
function VerifyTruckPValue(nPValue: Double; nTruck: string; var nOut: string):Boolean;

function SaveBill(var nOutData:string; const nBillData: TStrings=nil): string;
function DeleteBill(const nBill: string): Boolean;
function ChangeLadingTruckNo(const nBill,nTruck: string): Boolean;

function GetSysValidDate: Integer;
function LoadSysDictItem(const nItem: string; const nList: TStrings): TDataSet;

implementation
uses USysDB, USysConst, UFormCtrl, ULibFun, UBase64, UDataReport,
     UBusinessPacker, UFormBase, USysLoger, ZnMD5;

//Date: 2015/4/9
//Parm: NC交易类型;
//Desc: 获取NC交易类型对应系统交易类型；
function GetNCBillTypeCHS(const nNCType: string; var nSysType: string): string;
begin
  if CompareStr(UpperCase(nNCType), 'ME25')=0 then
  begin
    Result := nNCType + '、销售';
    nSysType := sFlag_Sale;
  end
  else if CompareStr(UpperCase(nNCType), 'ME09')=0 then
  begin
    Result := nNCType + '、调拨';
    nSysType := sFlag_Dispatch;
  end
  else if CompareStr(UpperCase(nNCType), 'ME03')=0 then
  begin
    Result := nNCType + '、供应';
    nSysType := sFlag_Provide;
  end;
end;
//Date: 2014-12-24
//Parm: 订单号(多个)[FIn.FData]
//Desc: 获取订单的已发货量
function GetOrderFHValue(const nOrders: TStrings;
  const nQueryFreeze: Boolean): Boolean;
var nOutData, nFlag:string;
begin
  if nQueryFreeze then
       nFlag := sFlag_Yes
  else nFlag := sFlag_No;
  Result := GetOrderFHValueLocal(nOutData, nOrders.Text, nFlag);
  if Result then nOrders.Text := nOutData;
end;

//Date: 2015-01-08
//Parm: 订单列表
//Desc: 获取指定的发货量
function GetOrderGYValue(const nOrders: TStrings): Boolean;
var nOutData:string;
begin
  Result := GetOrderGYValueLocal(nOutData, nOrders.Text);
  if Result then nOrders.Text := nOutData;
end;

//Date: 2014-09-17
//Parm: 交货单数据;解析结果
//Desc: 解析nData为结构化列表数据
procedure AnalyseBillItems(const nData: string; var nItems: TLadingBillItems);
var nStr: string;
    nIdx,nInt: Integer;
    nListA,nListB: TStrings;
begin
  nListA := TStringList.Create;
  nListB := TStringList.Create;
  try
    nListA.Text := PackerDecodeStr(nData);
    //bill list
    nInt := 0;
    SetLength(nItems, nListA.Count);

    for nIdx:=0 to nListA.Count - 1 do
    begin
      nListB.Text := PackerDecodeStr(nListA[nIdx]);
      //bill item

      with nListB,nItems[nInt] do
      begin
        FID         := Values['ID'];
        FCard       := Values['Card'];
        FZhiKa      := Values['ZhiKa'];
        FCusID      := Values['CusID'];
        FCusName    := Values['CusName'];
        FTruck      := Values['Truck'];

        FBatchCode  := Values['BatchCode'];

        FType       := Values['Type'];
        FStockNo    := Values['StockNo'];
        FStockName  := Values['StockName'];

        FStatus     := Values['Status'];
        FNextStatus := Values['NextStatus'];

        FFactory    := Values['Factory'];
        FPModel     := Values['PModel'];
        FPType      := Values['PType'];
        FPoundID    := Values['PoundID'];
        FSelected   := Values['Selected'] = sFlag_Yes;

        with FPData do
        begin
          FStation  := Values['PStation'];
          FDate     := Str2DateTime(Values['PDate']);
          FOperator := Values['PMan'];

          nStr := Trim(Values['PValue']);
          if (nStr <> '') and IsNumber(nStr, True) then
               FPData.FValue := StrToFloat(nStr)
          else FPData.FValue := 0;
        end;

        with FMData do
        begin
          FStation  := Values['MStation'];
          FDate     := Str2DateTime(Values['MDate']);
          FOperator := Values['MMan'];

          nStr := Trim(Values['MValue']);
          if (nStr <> '') and IsNumber(nStr, True) then
               FMData.FValue := StrToFloat(nStr)
          else FMData.FValue := 0;
        end;

        nStr := Trim(Values['Value']);
        if (nStr <> '') and IsNumber(nStr, True) then
             FValue := StrToFloat(nStr)
        else FValue := 0;

        nStr := Trim(Values['Price']);
        if (nStr <> '') and IsNumber(nStr, True) then
             FPrice := StrToFloat(nStr)
        else FPrice := 0;

        nStr := Trim(Values['KZValue']);
        if (nStr <> '') and IsNumber(nStr, True) then
             FKZValue := StrToFloat(nStr)
        else FKZValue := 0;

        FKZComment := Values['KZComment'];
        FAreaName  := Values['AreaName'];
        FTransport := Values['Transport'];

        FMKBillUnit:= Values['MKBillUnit'];
        FMKBillMan := Values['MKBillMan'];
        FMKBillDate:= Str2DateTime(Values['MKBillDate']);

        FBillOrign := Values['BillOrgin'];
      end;

      Inc(nInt);
    end;
  finally
    nListB.Free;
    nListA.Free;
  end;
end;

//Date: 2014-09-18
//Parm: 交货单列表
//Desc: 将nItems合并为业务对象能处理的
function CombineBillItmes(const nItems: TLadingBillItems): string;
var nIdx: Integer;
    nListA,nListB: TStrings;
begin
  nListA := TStringList.Create;
  nListB := TStringList.Create;
  try
    Result := '';
    nListA.Clear;
    nListB.Clear;

    for nIdx:=Low(nItems) to High(nItems) do
    with nItems[nIdx] do
    begin
      if not FSelected then Continue;
      //ignored

      with nListB do
      begin
        Values['ID']         := FID;
        Values['Card']       := FCard;
        Values['ZhiKa']      := FZhiKa;
        Values['CusID']      := FCusID;
        Values['CusName']    := FCusName;
        Values['Truck']      := FTruck;

        Values['Type']       := FType;
        Values['StockNo']    := FStockNo;
        Values['StockName']  := FStockName;
        Values['Value']      := FloatToStr(FValue);
        Values['Price']      := FloatToStr(FPrice);

        Values['Status']     := FStatus;
        Values['NextStatus'] := FNextStatus;

        Values['Factory']    := FFactory;
        Values['PModel']     := FPModel;
        Values['PType']      := FPType;
        Values['PoundID']    := FPoundID;

        with FPData do
        begin
          Values['PStation'] := FStation;
          Values['PValue']   := FloatToStr(FPData.FValue);
          Values['PDate']    := DateTime2Str(FDate);
          Values['PMan']     := FOperator;
        end;

        with FMData do
        begin
          Values['MStation'] := FStation;
          Values['MValue']   := FloatToStr(FMData.FValue);
          Values['MDate']    := DateTime2Str(FDate);
          Values['MMan']     := FOperator;
        end;

        if FSelected then
             Values['Selected'] := sFlag_Yes
        else Values['Selected'] := sFlag_No;

        Values['KZValue']    := FloatToStr(FKZValue);
        Values['KZComment']  := FKZComment;

        Values['BatchCode']  := FBatchCode;
        Values['AreaName']   := FAreaName;
        Values['Transport']  := FTransport;

        Values['MKBillUnit']:= FMKBillUnit;
        Values['MKBillMan'] := FMKBillMan;
        Values['MKBillDate']:= DateTime2Str(FMKBillDate);

        Values['BillOrgin'] := FBillOrign;
      end;

      nListA.Add(PackerEncodeStr(nListB.Text));
      //add bill
    end;

    Result := PackerEncodeStr(nListA.Text);
    //pack all
  finally
    nListB.Free;
    nListA.Free;
  end;
end;

//Date: 2014-12-23
//Parm: 待解析;订单数据
//Desc: 解析nOrder,存入nItem
procedure AnalyzeOrderInfo(const nOrder: string; var nItem: TOrderItemInfo);
var nList: TStrings;
begin
  nList := TStringList.Create;
  try
    with nList,nItem do
    begin
      Text := DecodeBase64(nOrder);
      //解码

      FCusID := Values['CusID'];
      FCusName := Values['CusName'];
      FSaleMan := Values['SaleMan'];
      FStockID := Values['StockID'];
      FStockName := Values['StockName'];
      FTruck := Values['Truck'];
      FBatchCode := Values['BatchCode'];
      FOrders := PackerDecodeStr(Values['Orders']);
      FValue := StrToFloat(Values['Value']);
      FBillID:= Values['BillID'];
      FAreaName:= Values['AreaName'];
      
      FMKBillUnit:= Values['MKBillUnit'];
      FMKBillMan := Values['MKBillMan'];
      FMKBillDate:= Str2DateTime(Values['MKBillDate']);
    end;
  finally
    nList.Free;
  end;
end;

//Date: 2014-12-23
//Parm: 订单项
//Desc: 将nItem数据打包
function BuildOrderInfo(const nItem: TOrderItemInfo): string;
var nList: TStrings;
begin
  nList := TStringList.Create;
  try
    with nList,nItem do
    begin
      Clear;
      Values['CusID']     := FCusID;
      Values['CusName']   := FCusName;
      Values['SaleMan']   := FSaleMan;
      Values['StockID']   := FStockID;
      Values['StockName'] := FStockName;
      Values['Truck']     := FTruck;
      Values['BatchCode'] := FBatchCode;
      Values['Orders']    := PackerEncodeStr(FOrders);
      Values['Value']     := FloatToStr(FValue);
      Values['BillID']    := FBillID;
      Values['AreaName']  := FAreaName;

      Values['MKBillUnit']:= FMKBillUnit;
      Values['MKBillMan'] := FMKBillMan;
      Values['MKBillDate']:= DateTime2Str(FMKBillDate);
    end;

    Result := EncodeBase64(nList.Text);
    //编码
  finally
    nList.Free;
  end;
end;

//Date: 2014-12-23
//Parm: 订单;列表
//Desc: 将nOrder现实到nList中
procedure LoadOrderInfo(const nOrder: TOrderItemInfo; const nList: TcxMCListBox);
var nStr: string;
begin
  with nList.Items, nOrder do
  begin
    Clear;
    nStr := StringReplace(FOrders, #13#10, ',', [rfReplaceAll]);

    Add('客户编号:' + nList.Delimiter + FCusID + ' ');
    Add('客户名称:' + nList.Delimiter + FCusName + ' ');
    Add('业务类型:' + nList.Delimiter + FSaleMan + ' ');
    Add('物料编号:' + nList.Delimiter + FStockID + ' ');
    Add('物料名称:' + nList.Delimiter + FStockName + ' ');
    Add('订单编号:' + nList.Delimiter + nStr + ' ');
    Add('可提货量:' + nList.Delimiter + Format('%.2f',[FValue]) + ' 吨');
  end;
end;

//Desc: 载入nCID客户的信息到nList中,并返回数据集
function LoadCustomerInfo(const nCID: string; const nList: TcxMCListBox;
 var nHint: string): TDataSet;
var nStr: string;
begin
  nStr := 'select custcode,t2.pk_cubasdoc,custname,user_name,' +
          't1.createtime from Bd_cumandoc t1' +
          '  left join bd_cubasdoc t2 on t2.pk_cubasdoc=t1.pk_cubasdoc' +
          '  left join sm_user t_su on t_su.cuserid=t1.creator ' +
          ' where custcode=''%s''';
  nStr := Format(nStr, [nCID]);

  nList.Clear;
  Result := FDM.QueryTemp(nStr, True);

  if Result.RecordCount > 0 then
  with nList.Items,Result do
  begin
    Add('客户编号:' + nList.Delimiter + FieldByName('custcode').AsString);
    Add('客户名称:' + nList.Delimiter + FieldByName('custname').AsString + ' ');
    Add('创 建 人:' + nList.Delimiter + FieldByName('user_name').AsString + ' ');
    Add('创建时间:' + nList.Delimiter + FieldByName('createtime').AsString + ' ');
  end else
  begin
    Result := nil;
    nHint := '客户信息已丢失';
  end;
end;

function LoadDispatchUnitInfo(const nUID: string; const nList: TcxMCListBox;
 var nHint: string): TDataSet;
var nStr: string;
begin
  nStr := 'select * from Bd_Corp where pk_Corp=''%s''';
  nStr := Format(nStr, [nUID]);

  nList.Clear;
  Result := FDM.QueryTemp(nStr, True);

  if Result.RecordCount > 0 then
  with nList.Items,Result do
  begin
    Add('客户编号:' + nList.Delimiter + FieldByName('unitcode').AsString);
    Add('客户名称:' + nList.Delimiter + FieldByName('unitname').AsString + ' ');
  end else
  begin
    Result := nil;
    nHint := '客户信息已丢失';
  end;
end;

//------------------------------------------------------------------------------
//Desc: 构建字段内容
function MakeField(const nDS: TDataSet; const nName: string; nPos: Integer;
 nField: string = ''): string;
var nStr: string;
begin
  if nPos > 0 then
       nStr := Format('%s_%d', [nName, nPos])
  else nStr := nName;

  if nField = '' then
    nField := nName;
  //xxxxx

  Result := Trim(nDS.FieldByName(nStr).AsString);
  Result := SF(nField, Result);
end;
//Date: 2015/4/9
//Parm: 订单ID；
//Desc: 模糊查询订单列表
function GetLadingBills(nID: string; var nOutBills: TLadingBillItems):Boolean;
var nIdx: Integer;
    nStr: string;
    nP: TFormCommandParam;
    nListA, nListB, nListC:TStrings;
begin
  Result := False;

  nP.FParamA := nID;
  CreateBaseFormItem(cFI_FormGetNCBill, '', @nP);
  if (nP.FCommand <> cCmd_ModalResult) or (nP.FParamA <> mrOK) then
  begin
    Exit;
  end;

  Result := True;
  nListA := TStringList.Create;
  nListB := TStringList.Create;
  nListC := TStringList.Create;

  try
    nListA.Clear;
    nListA.Text := nP.FParamB;
    SetLength(nOutBills, nListA.Count);

    nListC.Clear;
    for nIdx:=0 to nListA.Count-1 do
    begin
      with nListB,nOutBills[nIdx] do
      begin
        Clear;
        Text := PackerDecodeStr(nListA[nIdx]);

        FID       := Values['BillID'];
        FCard     := Values['Card'];
        FZhiKa    := Values['ZhiKa'];

        FCusID    := Values['CusCode'];
        FCusName  := Values['CusName'];
        FAreaName := Values['AreaName'];
        //客户信息

        FType     := Values['StockTP'];
        FStockNo  := Values['StockCD'];
        FStockName:= Values['StockNM'];
        FBatchCode:= Values['BatchCode'];
        //物料信息

        FTruck    := Values['Truck'];
        FValue    := StrToFloat(Values['KDValue']);
        //车辆以及开单量

        GetNCBillTypeCHS(Values['BillType'], nStr);
        FPType    := nStr;
        //订单类型

        FMKBillUnit:= Values['MKBillUnit'];
        FMKBillMan := Values['MKBillMan'];
        FMKBillDate:= Str2DateTime(Values['MKBillDate']);

        FPoundID := '';
        FSelected := True;
        FNextStatus:=sFlag_TruckBFP;

        FBillOrign := Values['BillOrign'];
        nListC.Add(FCard);
      end;
    end;
  finally
    nListA.Free;
    nListB.Free;
    nListC.Free;
  end;
end;
//Date: 2015/4/9
//Parm: 车牌号
//Desc:  保存车牌号
function SaveTruck(nInData: string=''): Boolean;
var nStr: string;
begin
  Result := True;
  if nInData='' then Exit;

  nStr := 'Select Count(*) From %s Where T_Truck=''%s''';
  nStr := Format(nStr, [sTable_Truck, UpperCase(nInData)]);
  //xxxxx

  with FDM.QuerySQL(nStr) do
  if Fields[0].AsInteger < 1 then
  begin
    nStr := 'Insert Into %s(T_Truck, T_PY) Values(''%s'', ''%s'')';
    nStr := Format(nStr, [sTable_Truck, nInData, GetPinYinOfStr(nInData)]);
    FDM.ExecuteSQL(nStr);
  end;
end;
//Date: 2015/4/9
//Parm: 车牌号；返回订单信息
//Desc:  获取车牌号未完成订单列表
function GetTruckPoundItem(const nTruck: string;
  var nPoundData: TLadingBillItems): Boolean;
var nStr: string;
    nIdx: Integer;
begin
  nStr := 'Select * From %s left join %s on P_Bill=L_ID ' +
          'Where P_Truck=''%s'' And P_MValue Is Null And P_PModel=''%s''';
  nStr := Format(nStr, [sTable_PoundLog, sTable_Bill, nTruck, sFlag_PoundPD]);

  with FDM.QuerySQL(nStr) do
  begin
    if RecordCount > 0 then
    begin
      SetLength(nPoundData, RecordCount);

      First;
      nIdx := 0;
      while not Eof do
      begin
        with nPoundData[nIdx] do
        begin
          FID         := FieldByName('P_Bill').AsString;
          FCard       := FieldByName('P_Order').AsString;
          FBillOrign  := FieldByName('P_Card').AsString;

          FZhiKa      := FID;
          FCusID      := FieldByName('P_CusID').AsString;
          FCusName    := FieldByName('P_CusName').AsString;
          FTruck      := FieldByName('P_Truck').AsString;

          FType       := FieldByName('P_MType').AsString;
          FStockNo    := FieldByName('P_MID').AsString;
          FStockName  := FieldByName('P_MName').AsString;

          with FPData do
          begin
            FStation  := FieldByName('P_PStation').AsString;
            FValue    := FieldByName('P_PValue').AsFloat;
            FDate     := FieldByName('P_PDate').AsDateTime;
            FOperator := FieldByName('P_PMan').AsString;
          end;

          FValue      := FieldByName('P_LimValue').AsFloat;

          FFactory    := FieldByName('P_FactID').AsString;
          FPModel     := FieldByName('P_PModel').AsString;
          FPType      := FieldByName('P_Type').AsString;
          FPoundID    := FieldByName('P_ID').AsString;

          if FPType<>sFlag_Provide then
          begin
            FBatchCode:= FieldByName('L_Seal').AsString;
            FCard     := FieldByName('L_Card').AsString;
            FZhiKa    := FieldByName('L_ZhiKa').AsString;
          end;

          FStatus     := sFlag_TruckBFP;
          FNextStatus := sFlag_TruckBFM;

          FKZComment := FieldByName('P_KZComment').AsString;
          FTransport := FieldByName('P_Transport').AsString;
          FSelected   := True;
        end;
        Inc(nIdx);
        Next;
      end;
    end else
    begin
      SetLength(nPoundData, 1);
      FillChar(nPoundData[0], SizeOf(TLadingBillItem), #0);
      with nPoundData[0] do
      begin
        FTruck      := nTruck;
        FPModel     := sFlag_PoundPD;

        FStatus     := '';
        FNextStatus := sFlag_TruckBFP;
        FSelected   := True;
      end;
    end;
  end;

  Result := True;
end;
//Date: 2015/4/9
//Parm: 客户ID;客户名称
//Desc: 获取客户信息查询语句
function GetQueryCustomerSQL(const nCusID,nCusName: string): string;
var nSQL: string;
begin
  if GetSQLQueryCustomer(nSQL, nCusID, nCusName) then
       Result := nSQL
  else Result := '';
end;
//Date: 2015/4/9
//Parm: 返回信息；查询条件；
//Desc: 获取指定类型系统规则编号
function GetSerailID(var nOutData: string; nInData: string='';
  nExtParam: string=''): Boolean;
var nInt: Integer;
    nStr,nP,nB: string;
    nListA: TStrings;
begin
  Result := False;
  nListA := TStringList.Create;
  try
    try
      nListA.Text := nInData;
      //param list

      nStr := 'Update %s Set B_Base=B_Base+1 ' +
              'Where B_Group=''%s'' And B_Object=''%s''';
      nStr := Format(nStr, [sTable_SerialBase, nListA.Values['Group'],
              nListA.Values['Object']]);
      FDM.ExecuteSQL(nStr);

      nStr := 'Select B_Prefix,B_IDLen,B_Base,B_Date,%s as B_Now From %s ' +
              'Where B_Group=''%s'' And B_Object=''%s''';
      nStr := Format(nStr, [sField_SQLServer_Now, sTable_SerialBase,
              nListA.Values['Group'], nListA.Values['Object']]);
      //xxxxx

      with FDM.QuerySQL(nStr) do
      begin
        if RecordCount < 1 then
        begin
          nOutData := '没有[ %s.%s ]的编码配置.';
          nOutData := Format(nOutData, [nListA.Values['Group'], nListA.Values['Object']]);

          Exit;
        end;

        nP := FieldByName('B_Prefix').AsString;
        nB := FieldByName('B_Base').AsString;
        nInt := FieldByName('B_IDLen').AsInteger;

        if nExtParam = sFlag_Yes then //按日期编码
        begin
          nStr := Date2Str(FieldByName('B_Date').AsDateTime, False);
          //old date

          if (nStr <> Date2Str(FieldByName('B_Now').AsDateTime, False)) and
             (FieldByName('B_Now').AsDateTime > FieldByName('B_Date').AsDateTime) then
          begin
            nStr := 'Update %s Set B_Base=1,B_Date=%s ' +
                    'Where B_Group=''%s'' And B_Object=''%s''';
            nStr := Format(nStr, [sTable_SerialBase, sField_SQLServer_Now,
                    nListA.Values['Group'], nListA.Values['Object']]);
            FDM.ExecuteSQL(nStr);

            nB := '1';
            nStr := Date2Str(FieldByName('B_Now').AsDateTime, False);
            //now date
          end;

          System.Delete(nStr, 1, 2);
          //yymmdd
          nInt := nInt - Length(nP) - Length(nStr) - Length(nB);
          nOutData := nP + nStr + StringOfChar('0', nInt) + nB;
        end else
        begin
          nInt := nInt - Length(nP) - Length(nB);
          nStr := StringOfChar('0', nInt);
          nOutData := nP + nStr + nB;
        end;
      end;

      Result := True;
    except
      raise;
    end;
  finally
    nListA.Free;
  end;
end;

function SaveTruckPoundItem(const nStrBills: String;
  var nOutData:string): Boolean;
var nBills: TLadingBillItems;
  nListA, nListB: TStrings;
  nStr, nSQL: string;
  nNet, nVal: Double;
  nProvide: Boolean;
  nIdx: Integer;
begin
  Result := False;
  AnalyseBillItems(nStrBills, nBills);
  if Length(nBills)<1 then Exit;

  nListA := TStringList.Create;
  nListB := TStringList.Create;
  try
    nListA.Clear;

    FDM.ADOConn.BeginTrans;
    try
      with nBills[0] do
      begin
        nProvide := (FID <> '') and (FID = FZhiKa);
        //是否供应

        if FPoundID = '' then
        begin
          SaveTruck(FTruck);
          //保存车牌号

          nListB.Clear;
          nListB.Values['Group'] := sFlag_BusGroup;
          nListB.Values['Object'] := sFlag_PoundID;

          if not GetSerailID(FPoundID, nListB.Text, sFlag_Yes) then
            raise Exception.Create(FPoundID);
          //xxxxx

          if FPModel = sFlag_PoundLS then
               nStr := sFlag_Other
          else if nProvide then
               nStr := sFlag_Provide
          else nStr := sFlag_NChange;

          nSQL := MakeSQLByStr([
                  SF('P_ID', FPoundID),
                  SF('P_Type', nStr),
                  SF('P_Bill', FZhiKa),
                  SF('P_Order', FCard),
                  SF('P_Truck', FTruck),
                  SF('P_CusID', FCusID),
                  SF('P_CusName', FCusName),
                  SF('P_MID', FStockNo),
                  SF('P_MName', FStockName),
                  SF('P_MType', sFlag_San),
                  SF('P_LimValue',FValue, sfVal),
                  SF('P_PValue', FPData.FValue, sfVal),
                  SF('P_PDate', sField_SQLServer_Now, sfVal),
                  SF('P_PMan', FPData.FOperator),
                  SF('P_FactID', FFactory),
                  SF('P_PStation', FPData.FStation),
                  SF('P_Direction', '进厂'),
                  SF('P_Transport', FTransport),
                  SF('P_PModel', FPModel),
                  SF('P_Status', sFlag_TruckBFP),
                  SF('P_Valid', sFlag_Yes),
                  SF('P_Areaname', FAreaName),
                  SF('P_PrintNum', 1, sfVal),
                  SF('P_KZComment', FKZComment)
                  ], sTable_PoundLog, '', True);
          nListA.Add(nSQL);
        end else if (FPData.FValue<=0) or (FMData.FValue<=0) then
        begin
          nOutData := '请先称重';
          raise Exception.Create(nOutData);
        end;
       
        if (FMData.FValue>0) and (FPData.FValue>0) then
        begin
          if FMData.FValue > FPData.FValue then
          begin
            nVal := FPData.FValue;
            nNet := FMData.FValue - FPData.FValue;
          end else begin
            nVal := FMData.FValue;
            nNet := FPData.FValue - FMData.FValue;
          end;

          if not VerifyTruckPValue(nVal, FTruck, nOutData) then
          begin
            if not QueryDlg(nOutData, sHint) then
            begin
               nOutData := '请检查车辆状态';
               raise Exception.Create(nOutData);
            end;
          end;  

          nVal := 0;
          nStr := 'Select D_CusID,D_Value,D_Type From %s ' +
                  'Where D_Stock=''%s'' And D_Valid=''%s''';
          nStr := Format(nStr, [sTable_Deduct, FStockNo, sFlag_Yes]);

          with FDM.QuerySQL(nStr) do
          if RecordCount > 0 then
          begin
            First;

            while not Eof do
            begin
              if FieldByName('D_CusID').AsString = FCusID then
                Break;
              //客户+物料参数优先

              Next;
            end;

            if Eof then First;
            //使用第一条规则

            //待扣减量
            nStr := FieldByName('D_Type').AsString;

            if nStr = sFlag_DeductFix then
              nVal := FieldByName('D_Value').AsFloat;
            //定值扣减

            if nStr = sFlag_DeductPer then
            begin
              nVal := FieldByName('D_Value').AsFloat;
              nVal := nNet * nVal;
            end; //比例扣减

            if (nVal > 0) and (nNet > nVal) then
            begin
              if FMData.FValue > FPData.FValue then
                   FMData.FValue := (FMData.FValue*1000 - nVal*1000) / 1000
              else FPData.FValue := (FPData.FValue*1000 - nVal*1000) / 1000;
            end;
          end;

          if FNextStatus = sFlag_TruckBFP then
          begin
            nSQL := MakeSQLByStr([
                    SF('P_PValue', FPData.FValue, sfVal),
                    SF('P_PDate', sField_SQLServer_Now, sfVal),
                    SF('P_PMan', FPData.FOperator),
                    SF('P_PStation', FPData.FStation),
                    SF('P_MValue', FMData.FValue, sfVal),
                    SF('P_MDate', DateTime2Str(FMData.FDate)),
                    SF('P_MMan', FMData.FOperator),
                    SF('P_MStation', FMData.FStation),
                    SF('P_Transport', FTransport),
                    SF('P_PDValue', nVal, sfVal),
                    SF('P_KZValue', FKZValue, sfVal),
                    SF('P_KZComment', FKZComment)
                    ], sTable_PoundLog, SF('P_ID', FPoundID), False);
            //称重时,由于皮重大,交换皮毛重数据
            nListA.Add(nSQL);
          end else
          begin
            nSQL := MakeSQLByStr([
                    SF('P_MValue', FMData.FValue, sfVal),
                    SF('P_MDate', sField_SQLServer_Now, sfVal),
                    SF('P_MMan', FMData.FOperator),
                    SF('P_MStation', FMData.FStation),
                    SF('P_Transport', FTransport),
                    SF('P_PDValue', nVal, sfVal),
                    SF('P_KZValue', FKZValue, sfVal),
                    SF('P_KZComment', FKZComment)
                    ], sTable_PoundLog, SF('P_ID', FPoundID), False);
            //xxxxx
            nListA.Add(nSQL);
          end;

        end;

        //----------------------------------------------------------------------
        for nIdx:=0 to nListA.Count-1 do
          FDM.ExecuteSQL(nListA[nIdx]);

        if nProvide
         and ((FPData.FValue>0) and (FMData.FValue>0))
         and (not SyncNC_ME03(nOutData, FPoundID, '')) then
          raise Exception.Create(nOutData);
        //同步供应到NC
        
        FDM.ADOConn.CommitTrans;
        nOutData := FPoundID;
        Result := True;
      end;
    except
      on nErr: Exception do
      begin
        FDM.ADOConn.RollbackTrans;
        nOutData := nErr.Message;
        Exit;
      end;
    end;
  finally
    nListA.Free;
    nListB.Free;
  end;
end;


//Date: 2014-09-18
//Parm: 岗位;交货单列表;已保存交货单列表；
//Desc: 保存nPost岗位上的交货单数据
function SaveLadingBills(const nPost: string; const nStrBills: String;
  var nOutBillID, nErrHint: string): Boolean;
var FListA, FListB, FListC, FListBID: TStrings;
    nSQL, nTmp, nStr, nBID, nPID:string;
    nBills: TLadingBillItems;
    nInt, nIdx, i: Integer;
    nMVal, nVal: Double;
begin
  Result := False;
  AnalyseBillItems(nStrBills, nBills);
  if Length(nBills) < 1 then Exit;

  FListA := TStringList.Create;
  FListB := TStringList.Create;
  FListC := TStringList.Create;
  FListBID := TStringList.Create;
  try
    FListA.Clear;
    FListBID.Clear;

    FDM.ADOConn.BeginTrans;
    //--------------------------------------------------------------------------
    try
      if nPost = sFlag_TruckBFP then //称量皮重
      begin
        nInt := -1;
        for nIdx:=Low(nBills) to High(nBills) do
        if nBills[nIdx].FPoundID = sFlag_Yes then
        begin
          nInt := nIdx;
          Break;
        end;

        if nInt < 0 then
        begin
          nErrHint := '岗位[ %s ]提交的皮重数据为0.';
          nErrHint := Format(nErrHint, ['磅房称皮']);
          raise Exception.Create(nErrHint);
        end;

        if not VerifyTruckPValue(nBills[nIdx].FPData.FValue, nBills[nIdx].FTruck,
          nErrHint) then
        begin
          if not QueryDlg(nErrHint, sHint) then
          begin
             nErrHint := '请检查车辆状态';
             raise Exception.Create(nErrHint);
          end;
        end;

        SaveTruck(nBills[nIdx].FTruck);
        //保存车牌号

        for nIdx:=Low(nBills) to High(nBills) do
        with nBills[nIdx] do
        begin
          FStatus := sFlag_TruckBFP;
          FNextStatus := sFlag_TruckBFM;

          if FBillOrign = sFlag_BillZX then
          begin
            nSQL := MakeSQLByStr([
                    SF('L_Status', FStatus),
                    SF('L_NextStatus', FNextStatus),
                    SF('L_PValue', nBills[nInt].FPData.FValue, sfVal),
                    SF('L_PDate', sField_SQLServer_Now, sfVal),
                    SF('L_PMan', nBills[nInt].FPData.FOperator)
                    ], sTable_Bill, SF('L_ID', FID), False);
            FListA.Add(nSQL);

            nBID := FID;
          end
          else
          begin
            FListC.Clear;
            FListC.Values['Group'] :=sFlag_BusGroup;
            FListC.Values['Object'] := sFlag_BillNo;
            //to get serial no

            if not GetSerailID(nBID, FListC.Text , sFlag_Yes) then
              raise Exception.Create(nBID);
            //xxxxx

            nSQL := MakeSQLByStr([
                    SF('L_ID', nBID),
                    SF('L_Card', FCard),
                    SF('L_ZhiKa', FZhiKa),
                    SF('L_CusID', FCusID),
                    SF('L_CusName', FCusName),
                    SF('L_CusPY', GetPinYinOfStr(FCusName)),

                    SF('L_Project', FMKBillUnit),
                    SF('L_Man', FMKBillMan),
                    SF('L_Date', sField_SQLServer_Now, sfVal),

                    SF('L_Type', FType),
                    SF('L_Seal', FBatchCode),
                    SF('L_StockNo', FStockNo),
                    SF('L_StockName', FStockName),

                    SF('L_Status', FStatus),
                    SF('L_NextStatus', FNextStatus),
                    SF('L_PValue', nBills[nInt].FPData.FValue, sfVal),
                    SF('L_PDate', sField_SQLServer_Now, sfVal),
                    SF('L_Truck', nBills[nInt].FTruck),
                    SF('L_PMan', nBills[nInt].FPData.FOperator)
                    ], sTable_Bill, '', True);
            FListA.Add(nSQL);
          end;

          FListC.Clear;
          FListC.Values['Group'] := sFlag_BusGroup;
          FListC.Values['Object'] := sFlag_PoundID;

          if not GetSerailID(nPID, FListC.Text , sFlag_Yes) then
            raise Exception.Create(nPID);
          //xxxxx

          nSQL := MakeSQLByStr([
                  SF('P_ID', nPID),
                  SF('P_Card', FBillOrign),
                  SF('P_Type', FPType),
                  SF('P_Bill', nBID),
                  SF('P_Order', FCard),
                  SF('P_Truck', FTruck),
                  SF('P_CusID', FCusID),
                  SF('P_CusName', FCusName),
                  SF('P_MID', FStockNo),
                  SF('P_MName', FStockName),
                  SF('P_MType', FType),
                  SF('P_LimValue', FValue, sfVal),
                  SF('P_PValue', nBills[nInt].FPData.FValue, sfVal),
                  SF('P_PDate', sField_SQLServer_Now, sfVal),
                  SF('P_PMan', nBills[nInt].FPData.FOperator),
                  SF('P_FactID', nBills[nInt].FFactory),
                  SF('P_PStation', nBills[nInt].FPData.FStation),
                  SF('P_Direction', '出厂'),
                  SF('P_AreaName', FAreaName),
                  SF('P_Transport', FTransport),
                  SF('P_PModel', FPModel),
                  SF('P_Status', sFlag_TruckBFP),
                  SF('P_Valid', sFlag_Yes),
                  SF('P_OutSeal', FBatchCode),
                  SF('P_KZComment', FKZComment),
                  SF('P_PrintNum', 1, sfVal)
                  ], sTable_PoundLog, '', True);
          FListA.Add(nSQL);

          FListBID.Add(nBID);
        end;
      end else

      //----------------------------------------------------------------------------
      if nPost = sFlag_TruckBFM then //称量毛重
      begin
        nInt := -1;

        for nIdx:=Low(nBills) to High(nBills) do
        if nBills[nIdx].FPoundID = sFlag_Yes then
        begin
          nInt := nIdx;
          Break;
        end;

        if nInt < 0 then
        begin
          nErrHint := '岗位[ %s ]提交的毛重数据为0.';
          nErrHint := Format(nErrHint, ['磅房称毛']);
          raise Exception.Create(nErrHint);
        end;

        nMVal:= 0;
        FListB.Clear;
        FListC.Clear;

        for nIdx:=Low(nBills) to High(nBills) do
        with nBills[nIdx] do
        begin
          FListC.Add(FID);
          nMVal := nMVal + FMData.FValue - FPData.FValue;

          if FPModel <> sFlag_PoundCC then
          begin
            nSQL := 'Select L_ID From %s Where L_ID=''%s'' And L_MValue Is Null';
            nSQL := Format(nSQL, [sTable_Bill, FID]);
            //未称毛重记录

            with FDM.QuerySQL(nSQL) do
            if RecordCount > 0 then
            begin
              First;

              while not Eof do
              begin
                FListB.Add(Fields[0].AsString);
                Next;
              end;
            end;
          end;
        end;

        for nIdx:=Low(nBills) to High(nBills) do
        with nBills[nIdx] do
        begin
          if nBills[nInt].FPModel = sFlag_PoundCC then
          begin
            i:= FListC.IndexOf(FID);
            if i>=0 then FListC.Delete(i);
            Continue;
          end;
          //出厂模式,不更新状态

          i := FListB.IndexOf(FID);
          if i >= 0 then
            FListB.Delete(i);
          //排除本次称重

          if FType = sFlag_San then
               nVal:=FMData.FValue-FPData.FValue
          else nVal:=FValue;
          nMVal := nMVal - nVal;                           

          FBatckrest := 0;
          GetSQLQueryBatchCode(nStr, FStockNo, FBatchCode);
          with FDM.QueryTemp(nStr, True) do
          begin
            if RecordCount<1 then
            begin
              nErrHint := '物料[%s]的批次编码[%s]不存在';
              nErrHint := Format(nErrHint, [FStockName, FBatchCode]);
              raise Exception.Create(nErrHint);
            end;

            FBatckrest := FieldByName('nbatch').AsFloat -
              FieldByName('nlock').AsFloat - FieldByName('nsent').AsFloat
              - GetNCBatchSent(FBatchCode);
          end;

          if FBatckrest < nVal then
          begin
            nErrHint := '物料[%s]的批次编码[%s]超出发货范围，请更新';
            nErrHint := Format(nErrHint, [FStockName, FBatchCode]);
            raise Exception.Create(nErrHint);
          end;

          nSQL := MakeSQLByStr([
                  SF('P_MValue', FMData.FValue, sfVal),
                  SF('P_PValue', FPData.FValue, sfVal),
                  SF('P_MDate', sField_SQLServer_Now, sfVal),
                  SF('P_MMan', nBills[nInt].FMData.FOperator),
                  SF('P_KZValue', 0, sfVal),
                  SF('P_KZComment', FKZComment),
                  SF('P_OutSeal', FBatchCode),
                  SF('P_Transport', FTransport),
                  SF('P_MStation', nBills[nInt].FMData.FStation)
                  ], sTable_PoundLog, SF('P_Bill', FID), False);
          FListA.Add(nSQL);
          //磅表信息

          nSQL := MakeSQLByStr([SF('L_Value', nVal, sfVal),
                  SF('L_Status', sFlag_TruckBFM),
                  SF('L_NextStatus', ''),
                  SF('L_Seal', FBatchCode),
                  SF('L_MValue', FMData.FValue , sfVal),
                  SF('L_PValue', FPData.FValue, sfVal),
                  SF('L_MDate', sField_SQLServer_Now, sfVal),
                  SF('L_MMan', FMData.FOperator)
                  ], sTable_Bill, SF('L_ID', FID), False);
          FListA.Add(nSQL);
          //订单信息

          if FBillOrign = sFlag_BillZX then
          begin
            nSQL := 'Update %s Set B_HasDone=B_HasDone+(%.2f),' +
                    'B_Freeze=B_Freeze-(%.2f) Where B_ID=''%s''';
            nSQL := Format(nSQL, [sTable_Order, nVal, nVal, FZhiKa]);
            FListA.Add(nSQL); //更新订单
          end;  
        end;

        if FListB.Count > 0 then
        begin
          nTmp := AdjustListStrFormat2(FListB, '''', True, ',', False);
          //未过重交货单列表

          nStr := Format('L_ID In (%s)', [nTmp]);
          nSQL := MakeSQLByStr([
                  SF('L_PValue', nMVal, sfVal),
                  SF('L_PDate', sField_SQLServer_Now, sfVal),
                  SF('L_PMan', nBills[nInt].FMData.FOperator)
                  ], sTable_Bill, nStr, False);
          FListA.Add(nSQL);
          //没有称毛重的提货记录的皮重,等于本次的毛重

          nStr := Format('P_Bill In (%s)', [nTmp]);
          nSQL := MakeSQLByStr([
                  SF('P_PValue', nMVal, sfVal),
                  SF('P_PDate', sField_SQLServer_Now, sfVal),
                  SF('P_PMan', nBills[nInt].FMData.FOperator),
                  SF('P_KZValue', 0, sfVal),
                  SF('P_Transport', nBills[nInt].FTransport),
                  SF('P_KZComment', nBills[nInt].FKZComment),
                  SF('P_PStation', nBills[nInt].FMData.FStation)
                  ], sTable_PoundLog, nStr, False);
          FListA.Add(nSQL);
          //没有称毛重的过磅记录的皮重,等于本次的毛重
        end;

        FListBID.Text := FListC.Text;
      end;

      //------------------------------------------------------------------------
      for nIdx:=0 to FListA.Count - 1 do
        FDM.ExecuteSQL(FListA[nIdx]);
      //xxxxx

      if (nPost = sFlag_TruckBFM) and (FListC.Count>0) then
      if not SyncNC_ME25(nErrHint, FListC.Text, '') then
          raise Exception.Create(nErrHint);

      FDM.ADOConn.CommitTrans;

      nOutBillID := FListBID.Text;
      Result := True;
    except
      on E: Exception do
      begin
        FDM.ADOConn.RollbackTrans;
        ShowDlg(E.Message, sHint);
        nErrHint := '保存称重失败';
        Exit;
      end;
    end;
  finally
    FListBID.Clear;
    FListA.Free;
    FListB.Free;
    FListC.Free;
  end;
end;

//Date: 2014-12-16
//Parm: 查询类型[nInData];查询条件[nExtParam]
//Desc: 依据查询条件,构建指定类型订单的SQL查询语句
function GetSQLQueryOrder(var nOutData: string; nInData: string='';
  nExtParam: string=''): Boolean;
var nStr,nType: string;
    nListA: TStrings;
begin
  Result := False;

  if nInData = '101' then           //销售订单
    nType := SF('VBILLTYPE', 'ME25')
  else if nInData = '102' then      //销售申请单
    nType := SF('VBILLTYPE', 'ME25')
  else if nInData = '103' then      //销售订单和申请单
    nType := SF('VBILLTYPE', 'ME25')

  else if nInData = '201' then      //采购订单
    nType := SF('VBILLTYPE', 'ME03')
  else if nInData = '202' then      //采购申请单
    nType := SF('VBILLTYPE', 'ME03')
  else if nInData = '203' then      //采购订单和申请单
       nType := SF('VBILLTYPE', 'ME03')
  else nType := '';

  if nType = '' then
  begin
    nOutData := Format('无效的订单查询类型( %s ).', [nInData]);
    Exit;
  end;

  nOutData := 'select ' +
     'distinct pk_meambill_b as pk_meambill,VBILLCODE,VBILLTYPE,COPERATOR,user_name,' +  //订单表头
     'TMAKETIME,NPLANNUM,cvehicle,vbatchcode,unitname,areaclname,t1.vdef10,' +  //订单表体
     't1.pk_cumandoc,custcode,cmnecode,custname,t_cd.def30,' +                  //客商信息
     //'invcode,invname,invtype ' +                                             //物料
     'vmeaninvcode,vmeaminvname,nmeamflag ' +                                   //
     'from meam_bill t1 ' +
     '  left join sm_user t_su on t_su.cuserid=t1.coperator ' +
     '  left join meam_bill_b t2 on t2.PK_MEAMBILL=t1.PK_MEAMBILL' +
     '  left join Bd_cumandoc t_cd on t_cd.pk_cumandoc=t1.pk_cumandoc' +
     '  left join bd_cubasdoc t_cb on t_cb.pk_cubasdoc=t_cd.pk_cubasdoc' +
     //'  left join Bd_invbasdoc t_ib on t_ib.pk_invbasdoc=t2.PK_INVBASDOC' +
     '  left join meam_invbasedoc t_ib on t_ib.pk_invmandoc=t2.pk_invmandoc' +
     '  left join bd_corp t_cp on t_cp.pk_corp=t1.pk_corp' +
     '  left join bd_areacl t_al on t_al.pk_areacl=t1.vdef1' +
     ' Where ';
  //xxxxx

  Result := True;
  nListA := TStringList.Create;
  try
    nListA.Text := nExtParam;

    if Pos('10', nInData)>0 then   //销售控制发货工厂和库存组织
    begin
      nStr := AdjustListStrFormat(gSysParam.FWareHouseGroup, '''', True, ',');
      if nStr<>'' then
        nOutData := nOutData + '(t2.pk_callbody_from In (' + nStr + ')) And ';
      //库存组织控制

      nStr := AdjustListStrFormat(gSysParam.FWareHouseID, '''', True, ',');
      if nStr<>'' then
        nOutData := nOutData + '(t2.pk_warehouse_from In (' + nStr + ')) And ';
      //仓库控制

      nStr := AdjustListStrFormat(gSysParam.FCorpFrom, '''', True, ',');
      if nStr<>'' then
        nOutData := nOutData + '(t2.pk_corp_from In (' + nStr + ')) And ';
      //销售控制发货工厂
    end else
    if Pos('20', nInData)>0 then //采购控制收货工厂和库存组织
    begin
      nStr := AdjustListStrFormat(gSysParam.FWareHouseGroup, '''', True, ',');
      if nStr<>'' then
        nOutData := nOutData + '(t2.pk_callbody_main In (' + nStr + ')) And ';
      //库存组织控制

      nStr := AdjustListStrFormat(gSysParam.FWareHouseID, '''', True, ',');
      if nStr<>'' then
        nOutData := nOutData + '(t2.pk_warehouse_main In (' + nStr + ')) And ';
      //仓库控制

      nStr := AdjustListStrFormat(gSysParam.FCorpFrom, '''', True, ',');
      if nStr<>'' then
        nOutData := nOutData + '(t2.pk_corp_main In (' + nStr + ')) And ';
      //控制收货工厂
    end;
//
//    nStr := AdjustListStrFormat(gSysParam.FWareHouseGroup, '''', True, ',');
//    if nStr<>'' then
//      nOutData := nOutData + '(t1.pk_callbody In (' + nStr + ')) And ';
//    //库存组织控制
//
//    nStr := AdjustListStrFormat(gSysParam.FWareHouseID, '''', True, ',');
//    if nStr<>'' then
//      nOutData := nOutData + '(t1.pk_warehouse In (' + nStr + ')) And ';
//    //仓库控制
//
//    nStr := AdjustListStrFormat(gSysParam.FCorpFrom, '''', True, ',');
//    if nStr<>'' then
//      nOutData := nOutData + '(t1.pk_corp In (' + nStr + ')) And ';
//    //工厂控制

    nStr := nListA.Values['QueryAll'];
    if nStr = '' then
    begin
      nOutData := nOutData + '(crowstatus=0 And VBILLSTATUS=1 And t1.dr=0) And ';
      //当前有效单据
    end;

    nStr := nListA.Values['BillCode'];
    if nStr <> '' then
    begin
      nOutData := nOutData + Format('VBILLCODE Like ''%%%s%%''', [nStr]);
      Exit; //按单号查询
    end;

    nStr := nListA.Values['MeamKeys'];
    if nStr <> '' then
    begin
      nOutData := nOutData + Format('pk_meambill_b In (%s)', [nStr]);
      Exit; //按单号查询
    end;

    nStr := nListA.Values['NoDate'];
    if nStr = '' then
    begin
      nStr := '(t1.dbilldate>=''%s'' And t1.dbilldate<''%s'')';
      nOutData := nOutData + Format(nStr, [
                    nListA.Values['DateStart'],
                    nListA.Values['DateEnd']]);
      //日期限制

      nOutData := nOutData + ' And ';
    end;

    nOutData := nOutData + ' (' + nType + ') ';
    //单据类型

    nStr := nListA.Values['CustomerID'];
    if nStr <> '' then
    begin
      nOutData := nOutData + Format(' And custcode=''%s''', [nStr]);
      //按客户编号
    end;

    nStr := nListA.Values['Filter'];
    if nStr <> '' then
    begin
      nOutData := nOutData + ' And (' + DecodeBase64(nStr) + ')';
      //查询条件
    end;

    nStr := nListA.Values['Order'];
    if nStr <> '' then
    begin
      nOutData := nOutData + ' Order By ' + nStr;
      //排序条件
    end;
  finally
    gSysLoger.AddLog('查询NC数据:' + nOutData);
    nListA.Free;
  end;
end;
//Date: 2015/4/9
//Parm: 返回查询语句;物料编号
//Desc: 获取NC查询物料编号信息语句
function GetSQLQueryBatchCode(var nOutData: string; nInData: string='';
  nExtParam: string=''):Boolean;
var nStr: string;
begin
  nStr := 'Select  vinvcode,cbatchcode, nbatch, nlock, nsent ' +
    'From meam_batchinv m_inv ' +
    'inner join meam_batchmag m_mag on m_inv.pk_batchmag=m_mag.pk_batchmag ' +
    'Where m_inv.vinvcode=''%s'' and istatus=''1''';

  nOutData := Format(nStr, [nInData]);

  if nExtParam<>'' then
  begin
    nOutData := nOutData + ' And m_mag.cbatchcode=''%s''';
    nOutData := Format(nOutData, [nExtParam]);
  end;

  nStr := AdjustListStrFormat(gSysParam.FDepotID, '''', True, ',');
  if nStr<>'' then
    nOutData := nOutData + ' And (vwarehouse In (' + nStr + '))';
  //库存组织控制

  nStr := AdjustListStrFormat(gSysParam.FCorpFrom, '''', True, ',');
  if nStr<>'' then
    nOutData := nOutData + ' And (pk_corp In (' + nStr + '))';
  //销售控制发货工厂

  gSysLoger.AddLog('查询NC该厂可使用批次号' + nOutData);
  Result := True;
end;


//Date: 2015-01-08
//Parm: 返回信息；；查询条件
//Desc: 依据查询条件调拨订单的SQL查询语句
function GetSQLQueryDispatch(var nOutData: string; nInData: string='';
  nExtParam: string=''): Boolean;
var nStr: string;
    nListA: TStrings;
begin
  nOutData := 'select ' +
     'pk_meambill_b as pk_meambill,VBILLCODE,VBILLTYPE,COPERATOR,user_name,' + //订单表头
     'TMAKETIME,NPLANNUM,cvehicle,vbatchcode,t1.pk_corp_main,unitname,' +      //订单表体
     'invcode,invname,invtype ' +                                              //物料
     'from meam_bill t1 ' +
     '  left join sm_user t_su on t_su.cuserid=t1.coperator ' +
     '  left join meam_bill_b t2 on t2.PK_MEAMBILL=t1.PK_MEAMBILL' +
     '  left join Bd_invbasdoc t_ib on t_ib.pk_invbasdoc=t2.PK_INVBASDOC' +
     '  left join bd_corp t_cp on t_cp.pk_corp=t1.pk_corp_main' +
     ' Where ' ;
  nOutData := nOutData + SF('VBILLTYPE', 'ME09');

  Result := True;

  nListA := TStringList.Create;
  try
    nListA.Text := nExtParam;

    nStr := nListA.Values['BillCode'];
    if nStr <> '' then
    begin
      nOutData := nOutData + Format(' And VBILLCODE Like ''%%%s%%''', [nStr]);
      Exit; //按单号查询
    end;

    nStr := nListA.Values['MeamKeys'];
    if nStr <> '' then
    begin
      nOutData := nOutData + Format(' And pk_meambill_b In (%s)', [nStr]);
      Exit; //按单号查询
    end;

    nStr := nListA.Values['NoDate'];
    if nStr = '' then
    begin
      nStr := ' And (TMAKETIME>=''%s'' And TMAKETIME<''%s'')';
      nOutData := nOutData + Format(nStr, [
                    nListA.Values['DateStart'],
                    nListA.Values['DateEnd']]);
      //日期限制
    end;

    nStr := nListA.Values['QueryAll'];
    if nStr = '' then
    begin
      nOutData := nOutData + ' And (crowstatus=0 And VBILLSTATUS=1)';
      //当前有效单据
    end;

    nStr := nListA.Values['Customer'];
    if nStr <> '' then
    begin
      nOutData := nOutData + Format(' And unitname Like ''%%%s%%''', [nStr]);
      //按客户编号
    end;

    nStr := nListA.Values['Filter'];
    if nStr <> '' then
    begin
      nOutData := nOutData + ' And (' + DecodeBase64(nStr) + ')';
      //查询条件
    end;

    nStr := nListA.Values['Order'];
    if nStr <> '' then
    begin
      nOutData := nOutData + ' Order By ' + nStr;
      //排序条件
    end;
  finally
    nListA.Free;
  end;
end;

//Date: 2014-12-18
//Parm: 输出信息;客户编号;客户名称;
//Desc: 构建模糊查询客户的SQL语句
function GetSQLQueryCustomer(var nOutData: string; nInData: string='';
  nExtParam: string=''): Boolean;
var nStr: string;
begin
  Result := True;
  nOutData := 'Select DISTINCT on (custcode) custcode,custname,' +
      'cmnecode from Bd_cumandoc t1 ' +
      '  left join bd_cubasdoc t2 on t2.pk_cubasdoc=t1.pk_cubasdoc' +
      ' where ';
  //xxxxx

  if nInData <> '' then
  begin
    nStr := '(custcode like ''%%%s%%'')';
    nOutData := nOutData + Format(nStr, [nInData]);
    //客户编号模糊
  end;

  if nExtParam <> '' then
  begin
    nStr := '(custname like ''%%%s%%'')';
    if nInData <> '' then
      nStr := ' or ' + nStr;
    nOutData := nOutData + Format(nStr, [nExtParam]);
    //客户名称模糊
  end;

  nOutData := nOutData + ' Group By custcode,custname,cmnecode';
end;

//Date: 2014-12-24
//Parm: 订单号(多个)[返回信息;订单列表]
//Desc: 获取订单的已发货量
function GetOrderFHValueLocal(var nOutData: string; nInData: string='';
  nExtParam: string=''): Boolean;
var nStr,nSQL,nID,nOrder: string;
    nListA, nListB: TStrings;
    nInt: Integer;
    nVal: Double;
begin
  nSQL := 'select distinct poundb.pk_sourcebill_b norder,sum(COALESCE(poundb.nnet,0)) nnet,' +
     'sum(COALESCE(poundb.nassnum,0)) nassnum from meam_poundbill_b poundb ' +
     '  inner join meam_poundbill poundh on poundb.pk_poundbill = poundh.pk_poundbill' +
     ' where COALESCE(poundb.dr,0)=0' +
     '  and poundh.nstatus = 100' +
     '  and COALESCE(poundh.dr,0)=0' +
     '  and poundh.bnowreturn=''N''' +
     '  and COALESCE(poundh.bbillreturn,''N'')=''N''';
  //nnet:主数量;nassnum:副数量

  nListA := TStringList.Create;
  nListB := TStringList.Create;
  try
    nListA.Text := nInData;
    for nInt:=0 to nListA.Count - 1 do
      nListB.Values[nListA[nInt]] := '0';
    //默认已发数量为0

    nID := AdjustListStrFormat2(nListA, '''', True, ',', False);
    nStr := ' and pk_sourcebill_b in (%s) group by poundb.pk_sourcebill_b';
    nStr := nSQL + Format(nStr, [nID]);
    //执行数
    with FDM.QueryTemp(nStr, True) do
    if RecordCount > 0 then
    begin
      First;

      while not Eof do
      begin
        nOrder := FieldByName('norder').AsString;
        nListB.Values[nOrder] := FieldByName('nnet').AsString;
        //订单已发量

        Next;
      end;
    end;

    nStr := ' and ( poundh.bbillreturn = ''Y'') and pk_sourcebill_b in (%s) ' +
            'group by poundb.pk_sourcebill_b';
    nStr := nSQL + Format(nStr, [nID]);
    //退货量
    with FDM.QueryTemp(nStr, True) do
    if RecordCount > 0 then
    begin
      First;

      while not Eof do
      begin
        nOrder := FieldByName('norder').AsString;
        nStr := nListB.Values[nOrder];

        if not IsNumber(nStr, True) then
          nStr := '0';
        nVal := StrToFloat(nStr);
        //取已发货量

        nVal := nVal - FieldByName('nnet').AsFloat;
        //已发货数=已发货量 - 原单退货量

        nListB.Values[nOrder] := FloatToStr(nVal);
        //订单已发量

        Next;
      end;
    end;

    if nExtParam = sFlag_Yes then
    begin
      nStr := 'Select B_ID,B_Freeze From %s Where B_ID In (%s)';
      nStr := Format(nStr, [sTable_Order, nID]);
      //冻结量

      with FDM.QuerySQL(nStr, False) do
      if RecordCount > 0 then
      begin
        First;

        while not Eof do
        begin
          nOrder := FieldByName('B_ID').AsString;
          nStr := nListB.Values[nOrder];

          if not IsNumber(nStr, True) then
            nStr := '0';
          nVal := StrToFloat(nStr);
          //取已发货量

          nVal := nVal + FieldByName('B_Freeze').AsFloat;
          //已发货数=已发货量 + 冻结量

          nListB.Values[nOrder] := FloatToStr(nVal);
          //订单已发量

          Next;
        end;
      end;
    end;

    nOutData := nListB.Text;
    Result := True;
  finally
    nListA.Free;
    nListB.Free;
  end;
end;

//Date: 2015-01-08
//Parm: 订单号(多个)[FIn.FData]
//Desc: 获取订单的已发货量
function GetOrderGYValueLocal(var nOutData: string; nInData: string='';
  nExtParam: string=''): Boolean;
var nStr,nSQL,nID,nOrder: string;
    nListA, nListB: TStrings;
    nInt: Integer;
begin
  nSQL := 'select distinct poundb.pk_sourcebill_b norder,sum(COALESCE(poundb.nnet,0)) nnet,' +
     'sum(COALESCE(poundb.nassnum,0)) nassnum from meam_poundbill_b poundb ' +
     '  inner join meam_poundbill poundh on poundb.pk_poundbill = poundh.pk_poundbill' +
     ' where COALESCE(poundb.dr,0)=0' +
     '  and poundh.nstatus = 100' +
     '  and COALESCE(poundh.dr,0)=0';
  //nnet:主数量;nassnum:副数量


  nListA := TStringList.Create;
  nListB := TStringList.Create;
  try
    nListA.Text := nInData;
    for nInt:=0 to nListA.Count - 1 do
      nListB.Values[nListA[nInt]] := '0';
    //默认已发数量为0

    nID := AdjustListStrFormat2(nListA, '''', True, ',', False);
    nStr := ' and pk_sourcebill_b in (%s) group by poundb.pk_sourcebill_b';
    nStr := nSQL + Format(nStr, [nID]);
    //执行数

    with FDM.QueryTemp(nStr, True) do
    if RecordCount > 0 then
    begin
      First;

      while not Eof do
      begin
        nOrder := FieldByName('norder').AsString;
        nListB.Values[nOrder] := FieldByName('nnet').AsString;
        //订单已发量

        Next;
      end;
    end;

    nOutData := nListB.Text;
    Result := True;
  finally
    nListA.Free;
    nListB.Free;
  end;
end;

//Date: 2015/4/11
//Parm: 车牌号
//Desc: 车辆是否已进厂
function TruckInFact(nTruck: string):Boolean;
var nStr: string;
begin
  Result := True;
  if nTruck='' then Exit;

  nStr := 'Select P_ID from %s where P_Truck=''%s'' and P_MValue is NULL' +
          ' and P_MDate is NULL and P_PModel<>''%s''';
  nStr := Format(nStr, [sTable_PoundLog, nTruck, sFlag_PoundLS]);
  //xxxxxx

  with FDM.QuerySQL(nStr) do
    if RecordCount > 0 then
    begin
      nStr := '车辆%s已进厂';
      nStr := Format(nStr, [nTruck]);

      ShowDlg(nStr, sHint);
      Exit;
    end;
  //车辆回毛前不能使用

  Result := False;
end;

//Date: 2015/4/11
//Parm: 车牌号
//Desc: 获取车牌号在NC系统中的预置皮重
function GetTruckPValue(nTruck: string):Double;
var nStr: string;
begin
  Result := 0;
  if nTruck='' then Exit;

  nStr := 'Select ndemptyload from meam_vehicle where vmainlicense=''%s'' ' +
          'And dr=0';
  nStr := Format(nStr, [nTruck]);

  with FDM.QueryTemp(nStr, True) do
  begin
    if RecordCount < 1 then Exit;

    Result := Fields[0].AsFloat;
  end;
end;
//Date: 2015/4/12
//Parm: 车牌号
//Desc:  获取车辆的历史皮重平均值
function GetHistoryTruckPValue(nTruck: string): Double;
var nCount: Integer;
    nTWeight: Double;
    nStr: string;
begin
  Result := 0;
  nStr := 'Select Count(1) as NUM, Sum(P_PValue) as TPValue From ' +
          '(Select Top 10 * From %s ' +
          'Where P_MValue>0 and P_PValue>0 and P_Truck=''%s'' ' +
          'Order by P_PDate desc) PL';
  nStr := Format(nStr, [sTable_PoundLog, nTruck]);

  with FDM.QuerySQL(nStr) do
  begin
    if RecordCount<1 then Exit;
    nCount := Fields[0].AsInteger;
    nTWeight := Fields[1].AsFloat;

    if nCount=0 then Exit;
    Result := nTWeight / nCount;
  end;
end;

function VerifyTruckPValue(nPValue: Double; nTruck: string; var nOut: string):Boolean;
var nVal,nLValue: Double;
begin
  Result := True;
  if nPValue<=0 then
  begin
    nOut := '车辆皮重为0，请重新称重';
    Result := False;
    Exit;
  end;

  nLValue := GetHistoryTruckPValue(nTruck);
  if nLValue<=0 then Exit; //首次入厂车辆

  nVal := Abs(nLValue*1000 - nPValue*1000);
  if nVal<gSysParam.FPoundTruckP then Exit;

  Result := False;
  nOut := '空车重量与历史皮重有较大误差' + #13#10
          +'误差量为[%.2f]千克' + #13#10
          +'请确认是否保存?';
  nOut := Format(nOut, [nVal]);
end;

//Desc: 打印提货单
function PrintBillReport(nBill: string; const nAsk: Boolean): Boolean;
var nStr: string;
    nParam: TReportParamItem;
begin
  Result := False;

  if nAsk then
  begin
    nStr := '是否要打印提货单?';
    if not QueryDlg(nStr, sAsk) then Exit;
  end;

  nBill := AdjustListStrFormat(nBill, '''', True, ',', False);
  //添加引号

  nStr := 'Select * From %s b Where L_ID In(%s)';
  nStr := Format(nStr, [sTable_Bill, nBill]);
  //xxxxx

  if FDM.QueryTemp(nStr).RecordCount < 1 then
  begin
    nStr := '编号为[ %s ] 的记录已无效!!';
    nStr := Format(nStr, [nBill]);
    ShowMsg(nStr, sHint); Exit;
  end;

  nStr := gPath + sReportDir + 'LadingBill.fr3';
  if not FDR.LoadReportFile(nStr) then
  begin
    nStr := '无法正确加载报表文件';
    ShowMsg(nStr, sHint); Exit;
  end;

  nParam.FName := 'UserName';
  nParam.FValue := gSysParam.FUserID;
  FDR.AddParamItem(nParam);

  nParam.FName := 'Company';
  nParam.FValue := gSysParam.FHintText;
  FDR.AddParamItem(nParam);

  FDR.Dataset1.DataSet := FDM.SqlTemp;
  FDR.ShowReport;
  Result := FDR.PrintSuccess;
end;

//Date: 2012-4-15
//Parm: 过磅单号;是否询问
//Desc: 打印nPound过磅记录
function PrintPoundReport(const nPound: string; nAsk: Boolean): Boolean;
var nStr: string;
    nParam: TReportParamItem;
begin
  Result := False;

  if nAsk then
  begin
    nStr := '是否要打印过磅单?';
    if not QueryDlg(nStr, sAsk) then Exit;
  end;

  nStr := 'Select * From %s Where P_ID=''%s''';
  nStr := Format(nStr, [sTable_PoundLog, nPound]);

  if FDM.QueryTemp(nStr).RecordCount < 1 then
  begin
    nStr := '称重记录[ %s ] 已无效!!';
    nStr := Format(nStr, [nPound]);
    ShowMsg(nStr, sHint); Exit;
  end;

  nStr := gPath + sReportDir + 'Pound.fr3';
  if not FDR.LoadReportFile(nStr) then
  begin
    nStr := '无法正确加载报表文件';
    ShowMsg(nStr, sHint); Exit;
  end;

  nParam.FName := 'UserName';
  nParam.FValue := gSysParam.FUserID;
  FDR.AddParamItem(nParam);

  nParam.FName := 'Company';
  nParam.FValue := gSysParam.FHintText;
  FDR.AddParamItem(nParam);

  FDR.Dataset1.DataSet := FDM.SqlTemp;
  FDR.ShowReport;
  Result := FDR.PrintSuccess;

  if Result  then
  begin
    nStr := 'Update %s Set P_PrintNum=P_PrintNum+1 Where P_ID=''%s''';
    nStr := Format(nStr, [sTable_PoundLog, nPound]);
    FDM.ExecuteSQL(nStr);
  end;
end;

//Date: 2012-4-15
//Parm: 过磅单号;是否询问
//Desc: 打印销售nPound过磅记录
function PrintSalePoundReport(const nPound: string; nAsk: Boolean): Boolean;
var nStr: string;
    nParam: TReportParamItem;
begin
  Result := False;

  if nAsk then
  begin
    nStr := '是否要打印过磅单?';
    if not QueryDlg(nStr, sAsk) then Exit;
  end;

  nStr := 'Select * From %s sp ' +
          'left join %s sbill on sp.P_Bill=sbill.L_ID ' + //
          'Where P_ID=''%s''';
  nStr := Format(nStr, [sTable_PoundLog, sTable_Bill, nPound]);

  if FDM.QueryTemp(nStr).RecordCount < 1 then
  begin
    nStr := '称重记录[ %s ] 已无效!!';
    nStr := Format(nStr, [nPound]);
    ShowMsg(nStr, sHint); Exit;
  end;

  if FDM.SqlTemp.FieldByName('P_MType').AsString = sFlag_San then
        nStr := gPath + sReportDir + 'SalePound.fr3'
  else  nStr := gPath + sReportDir + 'SaleDaiPound.fr3';
  
  if not FDR.LoadReportFile(nStr) then
  begin
    nStr := '无法正确加载报表文件';
    ShowMsg(nStr, sHint); Exit;
  end;

  nParam.FName := 'UserName';
  nParam.FValue := gSysParam.FUserID;
  FDR.AddParamItem(nParam);

  nParam.FName := 'Company';
  nParam.FValue := gSysParam.FHintText;
  FDR.AddParamItem(nParam);

  FDR.Dataset1.DataSet := FDM.SqlTemp;
  FDR.ShowReport;
  Result := FDR.PrintSuccess;

  if Result  then
  begin
    nStr := 'Update %s Set P_PrintNum=P_PrintNum+1 Where P_ID=''%s''';
    nStr := Format(nStr, [sTable_PoundLog, nPound]);
    FDM.ExecuteSQL(nStr);
  end;
end;
//Date: 2015/4/9
//Parm: 返回信息;采购磅单号;
//Desc: 同步采购订单数据到NC计量榜单表中
function SyncNC_ME03(var nOutData: string; nInData: string='';
  nExtParam: string=''): Boolean;
var nStr,nSQL: string;
    nIdx: Integer;
    nDS: TDataSet;
    nListA: TStrings;
    nBills: TLadingBillItems;
begin
  Result := False;
  nStr := 'Select * From %s Where P_ID=''%s''';
  nStr := Format(nStr, [sTable_PoundLog, nInData]);

  with FDM.QuerySQL(nStr) do
  begin
    if RecordCount < 1 then
    begin
      nOutData := '称重单据[ %s ]信息已丢失.';
      nOutData := Format(nOutData, [nInData]);
      Exit;
    end;

    SetLength(nBills, 1);
    First;

    with nBills[0] do
    begin
      FID      := FieldByName('P_Bill').AsString;
      FZhiKa   := FieldByName('P_Bill').AsString;
      FTruck   := FieldByName('P_Truck').AsString;
      FPoundID := FieldByName('P_ID').AsString;

      if FZhiKa = '' then
      begin
        nOutData := '称重单据[ %s ]信订单号为空.';
        nOutData := Format(nOutData, [nInData]);
        Exit;
      end;

      with FPData do
      begin
        FValue    := FieldByName('P_PValue').AsFloat;
        FDate     := FieldByName('P_PDate').AsDateTime;
        FOperator := FieldByName('P_PMan').AsString;
      end;

      with FMData do
      begin
        FValue    := FieldByName('P_MValue').AsFloat;
        FDate     := FieldByName('P_MDate').AsDateTime;
        FOperator := FieldByName('P_MMan').AsString;
      end;

      FKZValue := FieldByName('P_KZValue').AsFloat;
      FKZComment:= FieldByName('P_KZComment').AsString;
      FPDValue := FieldByName('P_PDValue').AsFloat;

      FValue := Float2Float(FMData.FValue - FPData.FValue - FKZValue,
        cPrecision, False);
      //供应量
    end;
  end;

  //----------------------------------------------------------------------------
  nStr := 'select t1.*,t2.* from meam_bill t1 ' +
          '  left join meam_bill_b t2 on t2.PK_MEAMBILL=t1.PK_MEAMBILL ' +
          'where pk_meambill_b=''%s''';
  nStr := Format(nStr, [nBills[0].FID]);

  nListA := TStringList.Create;
  try
    nDS := FDM.QueryTemp(nStr, True);
    with nDS do
    begin
      if RecordCount < 1 then
      begin
        nOutData := 'NC订单[ %s ]信息已丢失.';
        nOutData := Format(nOutData, [nBills[0].FID]);
        Exit;
      end;

      nListA.Clear;
      nIdx := 0;
      First;

      nSQL := MakeSQLByStr([SF('bbillreturn', 'N'),
              SF('bneedcheckgross', 'N'),
              SF('bneedchecktare', 'N'),
              SF('bnowreturn', 'N'),
              SF('bpackage', 'N'),
              SF('bpushbillstatus', 'N'),
              SF('bsame_ew', 'N'),

              SF('nabatenum', nBills[nIdx].FKZValue, sfVal),
              SF('nclientabatenum', nBills[nIdx].FPDValue, sfVal),
              SF('breturn', FieldByName('breplenishflag').AsString),
              SF('cmainunit', FieldByName('cmainunit').AsString),
              SF('coperatorid', FieldByName('coperator').AsString),

              MakeField(nDS, 'pk_callbody_main', 1, 'cincalbodyid'),
              MakeField(nDS, 'pk_corp_main', 1, 'cincorpid'),
              MakeField(nDS, 'pk_warehouse_main', 1, 'cinwarehouseid'),

              SF('cvehicle', nBills[nIdx].FTruck),
              SF('dbizdate', Date2Str(nBills[nIdx].FPData.FDate)),
              SF('dconfirmdate', Date2Str(nBills[nIdx].FPData.FDate)),
              SF('dconfirmtime', DateTime2Str(nBills[nIdx].FPData.FDate)),
              SF('ddelivmaketime', DateTime2Str(nBills[nIdx].FPData.FDate)),
              SF('dgrossdate', Date2Str(nBills[nIdx].FMData.FDate)),
              SF('dgrosstime', DateTime2Str(nBills[nIdx].FMData.FDate)),
              SF('dlastmoditime', DateTime2Str(nBills[nIdx].FPData.FDate)),
              SF('dmaketime', DateTime2Str(nBills[nIdx].FPData.FDate)),
              SF('dr', 0, sfVal),
              SF('dtaredate', Date2Str(nBills[nIdx].FPData.FDate)),
              SF('dtaretime', DateTime2Str(nBills[nIdx].FPData.FDate)),
              SF('ncreatetype', FieldByName('icreatetype').AsInteger, sfVal),
              SF('ndelivbillprintcount', 1, sfVal),
              SF('ngross', nBills[nIdx].FMData.FValue, sfVal),
              SF('nmeammodel', FieldByName('nmeammodel').AsInteger, sfVal),
              SF('nnet', nBills[nIdx].FValue, sfVal),
              SF('nplannum', FieldByName('nplannum').AsFloat, sfVal),
              SF('nstatus', '100', sfVal),
              SF('ntare', nBills[nIdx].FPData.FValue, sfVal),
              SF('ntareauditstatus', 1, sfVal),
              SF('nweighmodel', '1', sfVal),

              SF('pk_bsmodel', '0001ZA1000000001SIJ7'),
              SF('pk_corp', FieldByName('pk_corp').AsString),

              SF('pk_cumandoc', FieldByName('pk_cumandoc').AsString),
              SF('pk_invbasdoc', FieldByName('pk_invbasdoc').AsString),
              SF('pk_invmandoc', FieldByName('pk_invmandoc').AsString),
              SF('pk_poundbill', nBills[nIdx].FPoundID),
              SF('ts', DateTime2Str(nBills[nIdx].FMData.FDate)),
              SF('vbillcode', nBills[nIdx].FPoundID),
              MakeField(nDS, 'vdef1', 0),
              MakeField(nDS, 'vdef10', 0),
              MakeField(nDS, 'vdef11', 0),
              MakeField(nDS, 'vdef12', 0),
              MakeField(nDS, 'vdef13', 0),
              MakeField(nDS, 'vdef14', 0),
              MakeField(nDS, 'vdef15', 0),
              MakeField(nDS, 'vdef16', 0),
              MakeField(nDS, 'vdef17', 0),
              MakeField(nDS, 'vdef18', 0),
              MakeField(nDS, 'vdef19', 0),
              MakeField(nDS, 'vdef2', 0),
              MakeField(nDS, 'vdef20', 0),
              MakeField(nDS, 'vdef3', 0),
              MakeField(nDS, 'vdef4', 0),
              MakeField(nDS, 'vdef5', 0),
              MakeField(nDS, 'vdef6', 0),
              MakeField(nDS, 'vdef7', 0),
              MakeField(nDS, 'vdef8', 0),
              MakeField(nDS, 'vdef9', 0),
              SF('vsourcebillcode', FieldByName('vbillcode').AsString),
              SF('wayofpoundcorrent', '1')
              ], 'meam_poundbill', '', True);
      nListA.Add(nSQL);

      nSQL := MakeSQLByStr([SF('cassunit', FieldByName('cassunit').AsString),
              SF('dbizdate', Date2Str(nBills[nIdx].FPData.FDate)),
              SF('dr', 0, sfVal),
              SF('nassrate', FieldByName('nassrate').AsFloat, sfVal),
              SF('nassnum', FieldByName('nplanassnum').AsFloat, sfVal),
              SF('nexecnum', FieldByName('nexecnum').AsFloat, sfVal),
              SF('nnet', nBills[nIdx].FValue, sfVal),
              SF('nplannum', FieldByName('nplannum').AsFloat, sfVal),

              SF('pk_poundbill', nBills[nIdx].FPoundID),
              SF('pk_poundbill_b', nBills[nIdx].FPoundID + '_2'),
              SF('pk_sourcebill', FieldByName('pk_meambill').AsString),
              SF('pk_sourcebill_b', FieldByName('pk_meambill_b').AsString),
              SF('ts', DateTime2Str(nBills[nIdx].FMData.FDate)),
              SF('vbatchcode', FieldByName('vbatchcode').AsString),
              MakeField(nDS, 'vdef1', 1),
              MakeField(nDS, 'vdef10', 1),
              MakeField(nDS, 'vdef11', 1),
              MakeField(nDS, 'vdef12', 1),
              MakeField(nDS, 'vdef13', 1),
              MakeField(nDS, 'vdef14', 1),
              MakeField(nDS, 'vdef15', 1),
              MakeField(nDS, 'vdef16', 1),
              MakeField(nDS, 'vdef17', 1),
              MakeField(nDS, 'vdef18', 1),
              MakeField(nDS, 'vdef19', 1),
              MakeField(nDS, 'vdef2', 1),
              MakeField(nDS, 'vdef20', 1),
              MakeField(nDS, 'vdef3', 1),
              MakeField(nDS, 'vdef4', 1),
              MakeField(nDS, 'vdef5', 1),
              MakeField(nDS, 'vdef6', 1),
              MakeField(nDS, 'vdef7', 1),
              MakeField(nDS, 'vdef8', 1),
              MakeField(nDS, 'vdef9', 1),
              SF('vsourcebillcode', FieldByName('vbillcode').AsString)
              ], 'meam_poundbill_b', '', True);
      nListA.Add(nSQL);

      //FDM.ADOConn.BeginTrans;
      try
        for nIdx:=0 to nListA.Count - 1 do
          FDM.ExecuteSQL(nListA[nIdx], True);
        //xxxxx

        nStr := 'Select 1+0';
        FDM.QueryTemp(nStr, False);
        Result := True;
      except
        on E:Exception do
        begin
          //FDM.ADOConn.RollbackTrans;
          nOutData := '同步NC计量榜单错误,描述: ' + E.Message;
          Exit;
        end;
      end;
    end;
  finally
    nListA.Free;
  end;
end;

//Date: 2014-12-29
//Parm: 交货单(多个)[返回信息;同步订单号]
//Desc: 同步交货单发货数据到NC计量榜单表中
function SyncNC_ME25(var nOutData: string; nInData: string='';
  nExtParam: string=''): Boolean;
var nStr,nSQL: string;
    nIdx: Integer;
    nDS: TDataSet;
    nListA, nListC: TStrings;
    nDateMin: TDateTime;
    nBills: TLadingBillItems;
begin
  Result := False;

  nListA := TStringList.Create;
  nListC := TStringList.Create;

  try
    nListA.Text := nInData;
    nStr := AdjustListStrFormat2(nListA, '''', True, ',', False, False);

    nSQL := 'Select L_ID,L_ZhiKa,L_SaleMan,L_Truck,L_Value,L_PValue,L_PDate,' +
            'L_PMan,L_MValue,L_MDate,L_MMan,L_OutFact,L_Date,L_Seal, P_ID,P_Type ' +
            'From %s Left Join %s On P_Bill=L_ID ' +
            'Where L_ID In (%s)';
    nSQL := Format(nSQL, [sTable_Bill, sTable_PoundLog, nStr]);

    with FDM.QuerySQL(nSQL) do
    begin
      if RecordCount < 1 then
      begin
        nOutData := '发货单[ %s ]信息已丢失.';
        nOutData := Format(nOutData, [CombinStr(nListA, ',', False)]);
        Exit;
      end;

      nListC.Clear;
      nListC.Values['Group'] := sFlag_BusGroup;
      nListC.Values['Object'] := sFlag_PoundID;

      SetLength(nBills, RecordCount);
      nIdx := 0;

      nListA.Clear;
      First;

      while not Eof do
      begin
        with nBills[nIdx] do
        begin
          FID         := FieldByName('L_ID').AsString;
          FZhiKa      := FieldByName('L_ZhiKa').AsString;
          FPType       := FieldByName('P_Type').AsString;
          FTruck      := FieldByName('L_Truck').AsString;
          FValue      := FieldByName('L_Value').AsFloat;
          FBatchCode  := FieldByName('L_Seal').AsString;

          if nListA.IndexOf(FZhiKa) < 0 then
            nListA.Add(FZhiKa);
          //订单项

          FPoundID := FieldByName('P_ID').AsString;
          //榜单编号
          if FPoundID = '' then
          begin
            if not GetSerailID(FPoundID, nListC.Text, sFlag_Yes) then
              raise Exception.Create(FPoundID);
          end;

          nDateMin := Str2Date('2000-01-01');
          //最小日期参考

          with FPData do
          begin
            FValue    := FieldByName('L_PValue').AsFloat;
            FDate     := FieldByName('L_PDate').AsDateTime;
            FOperator := FieldByName('L_PMan').AsString;

            if FDate < nDateMin then
              FDate := FieldByName('L_Date').AsDateTime;
            //xxxxx

            if FDate < nDateMin then
              FDate := Date();
            //xxxxx
          end;

          with FMData do
          begin
            FValue    := FieldByName('L_MValue').AsFloat;
            FDate     := FieldByName('L_MDate').AsDateTime;
            FOperator := FieldByName('L_MMan').AsString;

            if FDate < nDateMin then
              FDate := FieldByName('L_OutFact').AsDateTime;
            //xxxxx

            if FDate < nDateMin then
              FDate := Date();
            //xxxxx
          end;
        end;

        Inc(nIdx);
        Next;
      end;
    end;

    //----------------------------------------------------------------------------
    nStr := AdjustListStrFormat2(nListA, '''', True, ',', False, False);
    //订单列表

    nSQL := 'select t1.*,t2.* from meam_bill t1 ' +
            '  left join meam_bill_b t2 on t2.PK_MEAMBILL=t1.PK_MEAMBILL ' +
            'where pk_meambill_b in (%s)';
    nSQL := Format(nSQL, [nStr]);

    nDS := FDM.QueryTemp(nSQL, True);
    with nDS do
    begin
      if RecordCount < 1 then
      begin
        nOutData := '发货单[ %s ]信息已丢失.';
        nOutData := Format(nOutData, [CombinStr(nListA, ',', False)]);
        Exit;
      end;

      nListA.Clear;
      //init sql list

      for nIdx:=Low(nBills) to High(nBills) do
      begin
        First;
        //init cursor

        while not Eof do
        begin
          nStr := FieldByName('pk_meambill_b').AsString;
          if nStr = nBills[nIdx].FZhiKa then Break;
          Next;
        end;

        if Eof then Continue;
        //订单丢失则不予处理

        if nBills[nIdx].FPType = sFlag_Sale then
             nBills[nIdx].FPType := '0001AA10000000009NEY'
        else nBills[nIdx].FPType := '0001ZA1000000001VYRH';
        //业务类型转业务模式

        nSQL := MakeSQLByStr([SF('bbillreturn', 'N'),
                SF('bneedcheckgross', 'N'),
                SF('bneedchecktare', 'N'),
                SF('bnowreturn', 'N'),
                SF('bpackage', 'N'),
                SF('bpushbillstatus', 'N'),
                SF('breturn', 'N'),
                SF('bsame_ew', 'N'),

                SF('cmainunit', FieldByName('cmainunit').AsString),
                SF('coperatorid', FieldByName('coperator').AsString),

                MakeField(nDS, 'pk_corp_from', 1, 'coutcorpid'),
                MakeField(nDS, 'pk_callbody_from', 1, 'coutcalbodyid'),
                MakeField(nDS, 'pk_warehouse_from', 1, 'coutwarehouseid'),
                MakeField(nDS, 'pk_warehouse_main', 0, 'cinwarehouseid'),
                MakeField(nDS, 'pk_callbody_main', 0, 'cincalbodyid'),
                MakeField(nDS, 'pk_corp_main', 0, 'cincorpid'),

                SF('cvehicle', nBills[nIdx].FTruck),
                SF('dbizdate', Date2Str(nBills[nIdx].FMData.FDate)),
                SF('dconfirmdate', Date2Str(nBills[nIdx].FPData.FDate)),
                SF('dconfirmtime', DateTime2Str(nBills[nIdx].FPData.FDate)),
                SF('ddelivmaketime', DateTime2Str(nBills[nIdx].FPData.FDate)),
                SF('dgrossdate', Date2Str(nBills[nIdx].FMData.FDate)),
                SF('dgrosstime', DateTime2Str(nBills[nIdx].FMData.FDate)),
                SF('dlastmoditime', DateTime2Str(nBills[nIdx].FPData.FDate)),
                SF('dmaketime', DateTime2Str(nBills[nIdx].FPData.FDate)),
                SF('dr', 0, sfVal),
                SF('dtaredate', Date2Str(nBills[nIdx].FPData.FDate)),
                SF('dtaretime', DateTime2Str(nBills[nIdx].FPData.FDate)),
                SF('ncreatetype', 1, sfVal),
                SF('ndelivbillprintcount', 1, sfVal),
                SF('ngross', nBills[nIdx].FMData.FValue, sfVal),
                SF('nmeammodel', 0, sfVal),
                SF('nnet', nBills[nIdx].FValue, sfVal),
                SF('nplannum', FieldByName('nplannum').AsFloat, sfVal),
                SF('nstatus', '100', sfVal),
                SF('ntare', nBills[nIdx].FPData.FValue, sfVal),
                SF('ntareauditstatus', 1, sfVal),
                SF('nweighmodel', '0', sfVal),

                SF('pk_bsmodel', nBills[nIdx].FPType),
                //SF('pk_corp', FieldByName('pk_corp').AsString),
                MakeField(nDS, 'pk_corp_from', 1, 'pk_corp'),

                SF('pk_cumandoc', FieldByName('pk_cumandoc').AsString),
                SF('pk_invbasdoc', FieldByName('pk_invbasdoc').AsString),
                SF('pk_invmandoc', FieldByName('pk_invmandoc').AsString),
                SF('pk_poundbill', nBills[nIdx].FPoundID),
                SF('ts', DateTime2Str(nBills[nIdx].FMData.FDate)),
                SF('vbillcode', nBills[nIdx].FPoundID),
                MakeField(nDS, 'vdef1', 0),
                MakeField(nDS, 'vdef10', 0),
                MakeField(nDS, 'vdef11', 0),
                MakeField(nDS, 'vdef12', 0),
                MakeField(nDS, 'vdef13', 0),
                MakeField(nDS, 'vdef14', 0),
                MakeField(nDS, 'vdef15', 0),
                MakeField(nDS, 'vdef16', 0),
                MakeField(nDS, 'vdef17', 0),
                MakeField(nDS, 'vdef18', 0),
                MakeField(nDS, 'vdef19', 0),
                MakeField(nDS, 'vdef2', 0),
                MakeField(nDS, 'vdef20', 0),
                MakeField(nDS, 'vdef3', 0),
                MakeField(nDS, 'vdef4', 0),
                MakeField(nDS, 'vdef5', 0),
                MakeField(nDS, 'vdef6', 0),
                MakeField(nDS, 'vdef7', 0),
                MakeField(nDS, 'vdef8', 0),
                MakeField(nDS, 'vdef9', 0),
                SF('vsourcebillcode', FieldByName('vbillcode').AsString),
                SF('wayofpoundcorrent', '1')
                ], 'meam_poundbill', '', True);
        nListA.Add(nSQL);

        nSQL := MakeSQLByStr([SF('cassunit', FieldByName('cassunit').AsString),
                SF('dbizdate', Date2Str(nBills[nIdx].FMData.FDate)),
                SF('dr', 0, sfVal),
                SF('nassrate', FieldByName('nassrate').AsString, sfVal),
                SF('nconfirmnum', nBills[nIdx].FValue, sfVal),
                SF('ndelivplannum', nBills[nIdx].FValue, sfVal),
                SF('nexecnum', FieldByName('nexecnum').AsFloat, sfVal),
                SF('nnet', nBills[nIdx].FValue, sfVal),
                SF('nplannum', FieldByName('nplannum').AsFloat, sfVal),

                MakeField(nDS, 'pk_corp_from', 1, 'pk_corp'),

                SF('pk_poundbill', nBills[nIdx].FPoundID),
                SF('pk_poundbill_b', nBills[nIdx].FPoundID + '_2'),
                SF('pk_sourcebill', FieldByName('pk_meambill').AsString),
                SF('pk_sourcebill_b', FieldByName('pk_meambill_b').AsString),
                SF('ts', DateTime2Str(nBills[nIdx].FMData.FDate)),
                //SF('vbatchcode', FieldByName('vbatchcode').AsString), //回传老批次
                SF('vbatchcode', nBills[nIdx].FBatchCode), //更新为新选批次号
                MakeField(nDS, 'vdef1', 1),
                MakeField(nDS, 'vdef10', 1),
                MakeField(nDS, 'vdef11', 1),
                MakeField(nDS, 'vdef12', 1),
                MakeField(nDS, 'vdef13', 1),
                MakeField(nDS, 'vdef14', 1),
                MakeField(nDS, 'vdef15', 1),
                MakeField(nDS, 'vdef16', 1),
                MakeField(nDS, 'vdef17', 1),
                MakeField(nDS, 'vdef18', 1),
                MakeField(nDS, 'vdef19', 1),
                MakeField(nDS, 'vdef2', 1),
                MakeField(nDS, 'vdef20', 1),
                MakeField(nDS, 'vdef3', 1),
                MakeField(nDS, 'vdef4', 1),
                MakeField(nDS, 'vdef5', 1),
                MakeField(nDS, 'vdef6', 1),
                MakeField(nDS, 'vdef7', 1),
                MakeField(nDS, 'vdef8', 1),
                MakeField(nDS, 'vdef9', 1),
                SF('vsourcebillcode', FieldByName('vbillcode').AsString)
                ], 'meam_poundbill_b', '', True);
        nListA.Add(nSQL);
      end;

      try
        for nIdx:=0 to nListA.Count - 1 do
          FDM.ExecuteSQL(nListA[nIdx], True);
        //xxxxx

        nStr := 'Select 1+0';
        FDM.QueryTemp(nStr, False);
        Result := True;
      except
        on E:Exception do
        begin
          nOutData := '同步NC计量榜单错误,描述: ' + E.Message;
          Exit;
        end;
      end;
    end;
  finally
    nListA.Free;
    nListC.Free;
  end;
end;
//Date: 2015/4/14
//Parm: 批次号
//Desc: 获取该批次号已发货量
function GetNCBatchSent(nBatch: string): Double;
var nStr,nSQL: string;
    nnetVal, nsumVal: Double;
begin
  nnetVal := 0;
  nsumVal := 0;

  nSQL := 'select distinct sum(COALESCE(poundb.nnet,0)) nnet,' +
     'sum(COALESCE(poundb.nassnum,0)) nassnum from meam_poundbill_b poundb ' +
     '  inner join meam_poundbill poundh on poundb.pk_poundbill = poundh.pk_poundbill' +
     ' where COALESCE(poundb.dr,0)=0' +
     '  and poundh.nstatus = 100' +
     '  and COALESCE(poundh.dr,0)=0' +
     '  and poundh.bnowreturn=''N''' +
     '  and COALESCE(poundh.bbillreturn,''N'')=''N''';
  //nnet:主数量;nassnum:副数量

  nStr := ' and vbatchcode = ''%s''';
  nStr := nSQL + Format(nStr, [nBatch]);
  //执行数
  gSysLoger.AddLog('查询批次已发货量:' + nStr);
  with FDM.QueryTemp(nStr, True) do
  if RecordCount > 0 then
  begin
    nnetVal := Fields[0].AsFloat;
  end;

  nStr := ' and ( poundh.bbillreturn = ''Y'') and vbatchcode = ''%s''';
  nStr := nSQL + Format(nStr, [nBatch]);
  //退货量
  gSysLoger.AddLog('查询批次已退货量:' + nStr);
  with FDM.QueryTemp(nStr, True) do
  if RecordCount > 0 then
  begin
    nsumVal := Fields[0].AsFloat;
  end;

  Result := nnetVal - nsumVal;
end;

//Date: 2014-12-26
//Parm: 订单列表
//Desc: 将nOrders按可用量从小到大排序
procedure SortOrderByValue(var nOrders: TOrderItems);
var i,j,nInt: Integer;
    nItem: TOrderItemInfo;
begin
  nInt := High(nOrders);
  //xxxxx

  for i:=Low(nOrders) to nInt do
   for j:=i+1 to nInt do
    if nOrders[j].FMaxValue < nOrders[i].FMaxValue then
    begin
      nItem := nOrders[i];
      nOrders[i] := nOrders[j];
      nOrders[j] := nItem;
    end;
  //冒泡排序
end;

function VerifyBeforSave(var nOrderItems: TOrderItems;
    nBillData: TStrings=nil): Boolean;
var nIdx,nInt: Integer;
    nVal,nDec: Double;
    nStr, nOutData: string;
    nListB,nListC: TStrings;
begin
  Result := False;

  //TWorkerBusinessCommander.CallMe(cBC_SaveTruckInfo, nTruck, '', @nOut);
  //保存车牌号
  SaveTruck(nBillData.Values['Truck']);

  nListB := TStringList.Create;
  nListC := TStringList.Create;
  try
    //----------------------------------------------------------------------------
    nStr := nBillData.Values['Orders'];
    nListB.Text := PackerDecodeStr(nStr);
    nStr := AdjustListStrFormat2(nListB, '''', True, ',', False, False);

    nListC.Clear;
    nListC.Values['MeamKeys'] := nStr;

    if not GetSQLQueryOrder(nOutData, '103', nListC.Text) then
    begin
      nStr := StringReplace(nListB.Text, #13#10, ',', [rfReplaceAll]);
      nOutData := Format('获取[ %s ]订单信息失败', [nStr]);
      ShowDlg(nOutData, sWarn);
      Exit;
    end;

    with FDM.QueryTemp(nOutData, True), nBillData do
    begin
      if RecordCount < 1 then
      begin
        nStr := StringReplace(nListB.Text, #13#10, ',', [rfReplaceAll]);
        nOutData := Format('订单[ %s ]信息已丢失.', [nStr]);
        ShowDlg(nOutData, sWarn);
        Exit;
      end;

      SetLength(nOrderItems, RecordCount);
      nInt := 0;
      First;

      while not Eof do
      begin
        with nOrderItems[nInt] do
        begin
          FOrders := FieldByName('pk_meambill').AsString;
          FBillID := FieldByName('VBILLCODE').AsString;

          if Values['CusID']='' then
               FCusID := FieldByName('custcode').AsString
          else FCusID := Values['CusID'];

          if Values['CusName']='' then
               FCusName := FieldByName('custname').AsString
          else FCusName := Values['CusName'];

          FCusCode := FieldByName('def30').AsString;
          if FCusCode = '' then FCusCode := '00';

          FStockID := FieldByName('vmeaninvcode').AsString;
          FStockName := FieldByName('vmeaminvname').AsString;
          FStockType := FieldByName('nmeamflag').AsString;
          FMaxValue := FieldByName('NPLANNUM').AsFloat;
          FKDValue := 0;

          FSaleID := '001';
          FSaleMan := FieldByName('VBILLTYPE').AsString;

          FMKBillUnit:= FieldByName('unitname').AsString;
          FMKBillMan:= FieldByName('user_name').AsString;
          FAreaName  := FieldByName('areaclname').AsString;
        end;

        Inc(nInt);
        Next;
      end;
    end;

    //----------------------------------------------------------------------------
    nStr := PackerEncodeStr(nListB.Text);
    //订单列表

    if not GetOrderFHValue(nListB) then
    begin
      nStr := StringReplace(nListB.Text, #13#10, ',', [rfReplaceAll]);
      nOutData := Format('获取[ %s ]订单发货量失败', [nStr]);
      ShowDlg(nOutData, sWarn);
      Exit;
    end;

    for nIdx:=Low(nOrderItems) to High(nOrderItems) do
    begin
      nStr := nListB.Values[nOrderItems[nIdx].FOrders];
      if not IsNumber(nStr, True) then Continue;

      with nOrderItems[nIdx] do
        FMaxValue := FMaxValue - StrToFloat(nStr);
      //可用量 = 计划量 - 已发量
    end;

    SortOrderByValue(nOrderItems);
    //按可用量由小到大排序

    //----------------------------------------------------------------------------
    nStr := nBillData.Values['Value'];
    nVal := Float2Float(StrToFloat(nStr), cPrecision, True);

    for nIdx:=Low(nOrderItems) to High(nOrderItems) do
    begin
      if nVal <= 0 then Break;
      //开单量已处理完毕

      nDec := Float2Float(nOrderItems[nIdx].FMaxValue, cPrecision, False);
      //订单可用量

      if nDec >= nVal then
        nDec := nVal;
      //订单够用则直接扣除开单量

      with nOrderItems[nIdx] do
      begin
        //FMaxValue := Float2Float(FMaxValue, cPrecision, False) - nDec;
        FKDValue := nDec;
      end;

      nVal := Float2Float(nVal - nDec, cPrecision, True);
      //开单剩余量
    end;

    if nVal > 0 then
    begin
      nOutData := '提货量超出订单可用量[ %.2f ]吨,开单失败.';
      nOutData := Format(nOutData, [nVal]);
      ShowDlg(nOutData, sWarn);
      Exit;
    end;

    Result := True;
    //verify done
  finally
    nListB.Free;
    nListC.Free;
  end;  
end;

function SaveBill(var nOutData:string; const nBillData: TStrings=nil): string;
var nStr,nSQL,nOutBill: string;
    nIdx,nInt: Integer;
    nListA: TStrings;
    nOrderItems: TOrderItems;
begin
  Result := '';
  SetLength(nOrderItems, 0);
  if not VerifyBeforSave(nOrderItems, nBillData) then Exit;

  nListA := TStringList.Create;
  try
    FDM.ADOConn.BeginTrans;
    try
      for nIdx:=Low(nOrderItems) to High(nOrderItems) do
      begin
        if nOrderItems[nIdx].FKDValue <= 0 then Continue;
        //无开单量

        nListA.Clear;
        nListA.Values['Group'] :=sFlag_BusGroup;
        nListA.Values['Object'] := sFlag_BillNo;
        //to get serial no

        if not GetSerailID(nOutBill, nListA.Text, sFlag_Yes) then
          raise  Exception.Create(nOutBill);
        //xxxxx

        nOutData := nOutData + nOutBill + ',';
        //combine bill

        nStr := MakeSQLByStr([SF('L_ID', nOutBill),
                SF('L_Card', nOrderItems[nIdx].FBillID),
                SF('L_ZhiKa', nOrderItems[nIdx].FOrders),
                SF('L_CusID', nOrderItems[nIdx].FCusID),
                SF('L_CusName', nOrderItems[nIdx].FCusName),
                SF('L_CusPY', GetPinYinOfStr(nOrderItems[nIdx].FCusName)),
                SF('L_CusCode', nOrderItems[nIdx].FCusCode),
                SF('L_SaleID', nOrderItems[nIdx].FSaleID),
                SF('L_SaleMan', nOrderItems[nIdx].FSaleMan),
                SF('L_Area', nOrderItems[nIdx].FAreaName),

                SF('L_Type', nOrderItems[nIdx].FStockType),
                SF('L_StockNo', nOrderItems[nIdx].FStockID),
                SF('L_StockName', nOrderItems[nIdx].FStockName),
                SF('L_PackStyle', nBillData.Values['Pack']),
                SF('L_Value', nOrderItems[nIdx].FKDValue, sfVal),
                SF('L_Price', 0, sfVal),

                SF('L_Truck', nBillData.Values['Truck']),
                SF('L_Status', sFlag_BillNew),
                SF('L_Lading', nBillData.Values['Lading']),
                SF('L_IsVIP', nBillData.Values['IsVIP']),
                SF('L_Seal', nBillData.Values['Seal']),
                SF('L_Man', gSysParam.FUserID),
                SF('L_Project', nOrderItems[nIdx].FMKBillUnit),
                SF('L_Date', sField_SQLServer_Now, sfVal)
                ], sTable_Bill, '', True);
        FDM.ExecuteSQL(nStr, False);

        if nBillData.Values['Post'] = sFlag_TruckBFM then //散装称重时并单
        begin
          nStr := nBillData.Values['PValue'];
          if not IsNumber(nStr, True) then
            nStr := '0';
          //xxxxx

          nStr := MakeSQLByStr([SF('L_Status', sFlag_TruckBFP),
                  SF('L_NextStatus', sFlag_TruckBFM),
                  SF('L_InTime', sField_SQLServer_Now, sfVal),
                  SF('L_PValue', nStr, sfVal),
                  SF('L_PDate', sField_SQLServer_Now, sfVal),
                  SF('L_PMan', gSysParam.FUserID),
                  SF('L_LadeTime', sField_SQLServer_Now, sfVal), 
                  SF('L_LadeMan', gSysParam.FUserID),
                  SF('L_Card', nBillData.Values['Card'])
                  ], sTable_Bill, SF('L_ID', nOutBill), False);
          FDM.ExecuteSQL(nStr, False);
        end else

        if nBillData.Values['BuDan'] = sFlag_Yes then //补单
        begin
          nStr := MakeSQLByStr([SF('L_Status', sFlag_TruckBFM),
                  SF('L_InTime', sField_SQLServer_Now, sfVal),
                  SF('L_PValue', 0, sfVal),
                  SF('L_PDate', sField_SQLServer_Now, sfVal),
                  SF('L_PMan', gSysParam.FUserID),
                  SF('L_MValue', nOrderItems[nIdx].FKDValue, sfVal),
                  SF('L_MDate', sField_SQLServer_Now, sfVal),
                  SF('L_MMan', gSysParam.FUserID),
                  SF('L_OutFact', sField_SQLServer_Now, sfVal),
                  SF('L_OutMan', gSysParam.FUserID),
                  SF('L_Card', nOrderItems[nIdx].FBillID)
                  ], sTable_Bill, SF('L_ID', nOutBill), False);
          FDM.ExecuteSQL(nStr, False);
        end;

        if nBillData.Values['BuDan'] = sFlag_Yes then //补单
        begin
          nStr := 'Update %s Set B_HasDone=B_HasDone+%.2f Where B_ID=''%s''';
          nStr := Format(nStr, [sTable_Order, nOrderItems[nIdx].FKDValue,
                  nOrderItems[nIdx].FOrders]);
          nInt := FDM.ExecuteSQL(nStr, False);

          if nInt < 1 then
          begin
            nSQL := MakeSQLByStr([
              SF('B_ID', nOrderItems[nIdx].FOrders),
              SF('B_HasDone', nOrderItems[nIdx].FKDValue, sfVal)
              ], sTable_Order, '', True);
            FDM.ExecuteSQL(nStr, False);
          end;
        end else
        begin
          nStr := 'Update %s Set B_Freeze=B_Freeze+%.2f Where B_ID=''%s''';
          nStr := Format(nStr, [sTable_Order, nOrderItems[nIdx].FKDValue,
                  nOrderItems[nIdx].FOrders]);
          nInt := FDM.ExecuteSQL(nStr, False);;

          if nInt < 1 then
          begin
            nStr := MakeSQLByStr([
              SF('B_ID', nOrderItems[nIdx].FOrders),
              SF('B_Freeze', nOrderItems[nIdx].FKDValue, sfVal)
              ], sTable_Order, '', True);
            FDM.ExecuteSQL(nStr, False);;
          end;
        end;
      end;

      nIdx := Length(nOutData);
      if Copy(nOutData, nIdx, 1) = ',' then
        System.Delete(nOutData, nIdx, 1);
      //xxxxx

      FDM.ADOConn.CommitTrans;
      Result := nOutData;
    except
      FDM.ADOConn.RollbackTrans;
      raise;
    end;
  finally
    nListA.Free;
  end;
end;

function DeleteBill(const nBill: string): Boolean;
var nIdx: Integer;
    nHasOut: Boolean;
    nVal: Double;
    nStr,nP,nZK: string;
begin
  Result := False;
  //init

  nStr := 'Select L_ZhiKa,L_Value,L_MDate From %s ' +
          'Where L_ID=''%s''';
  nStr := Format(nStr, [sTable_Bill, nBill]);

  with FDM.QuerySQL(nStr, False) do
  begin
    if RecordCount < 1 then
    begin
      nStr := '交货单[ %s ]已无效.';
      nStr := Format(nStr, [nBill]);
      ShowDlg(nStr, sHint);
      Exit;
    end;

    nHasOut := FieldByName('L_MDate').AsString <> '';
    //已出厂

    if nHasOut then
    begin
      nStr := '交货单[ %s ]已出厂,不允许删除.';
      nStr := Format(nStr, [nBill]);
      ShowDlg(nStr, sHint);
      Exit;
    end;

    nZK  := FieldByName('L_ZhiKa').AsString;
    nVal := FieldByName('L_Value').AsFloat;
  end;

  FDM.ADOConn.BeginTrans;
  try
    //--------------------------------------------------------------------------
    if nHasOut then
    begin
      nStr := 'Update %s Set B_HasDone=B_HasDone-(%.2f) Where B_ID=''%s''';
      nStr := Format(nStr, [sTable_Order, nVal, nZK]);
      FDM.ExecuteSQL(nStr, False);
      //释放发货量
    end else
    begin
      nStr := 'Update %s Set B_Freeze=B_Freeze-(%.2f) Where B_ID=''%s''';
      nStr := Format(nStr, [sTable_Order, nVal, nZK]);
      FDM.ExecuteSQL(nStr, False);
      //释放冻结量
    end;
    
    //--------------------------------------------------------------------------
    nStr := Format('Select * From %s Where 1<>1', [sTable_Bill]);
    //only for fields
    nP := '';

    with FDM.QuerySQL(nStr, False) do
    begin
      for nIdx:=0 to FieldCount - 1 do
       if (Fields[nIdx].DataType <> ftAutoInc) and
          (Pos('L_Del', Fields[nIdx].FieldName) < 1) then
        nP := nP + Fields[nIdx].FieldName + ',';
      //所有字段,不包括删除

      System.Delete(nP, Length(nP), 1);
    end;

    nStr := 'Insert Into $BB($FL,L_DelMan,L_DelDate) ' +
            'Select $FL,''$User'',$Now From $BI Where L_ID=''$ID''';
    nStr := MacroValue(nStr, [MI('$BB', sTable_BillBak),
            MI('$FL', nP), MI('$User', gSysParam.FUserID),
            MI('$Now', sField_SQLServer_Now),
            MI('$BI', sTable_Bill), MI('$ID', nBill)]);
    FDM.ExecuteSQL(nStr, False);

    nStr := 'Delete From %s Where L_ID=''%s''';
    nStr := Format(nStr, [sTable_Bill, nBill]);
    FDM.ExecuteSQL(nStr, False);

    FDM.ADOConn.CommitTrans;
    Result := True;
  except
    FDM.ADOConn.RollbackTrans;
    raise;
  end;
end;

function ChangeLadingTruckNo(const nBill,nTruck: string): Boolean;
var nStr: string;
begin
  Result := False;

  nStr := 'Select L_Truck,L_PDate From %s Where L_ID=''%s''';
  nStr := Format(nStr, [sTable_Bill, nBill]);

  with FDM.QuerySQL(nStr) do
  begin
    if RecordCount <> 1 then
    begin
      nStr := '交货单[ %s ]已无效.';
      nStr := Format(nStr, [nBill]);
      ShowDlg(nStr, sWarn);
      Exit;
    end;

    if Fields[1].AsString <> '' then
    begin
      nStr := '交货单[ %s ]已提货,无法修改车牌号.';
      nStr := Format(nStr, [nBill]);
      ShowDlg(nStr, sWarn);
      Exit;
    end;
  end;

  nStr := 'Update %s Set L_Truck=''%s'' Where L_ID=''%s''';
  nStr := Format(nStr, [sTable_Bill, nTruck, nBill]);
  FDM.ExecuteSQL(nStr);
  //更新修改信息
  Result := True;
end;

function GetSysValidDate: Integer;
var nStr: string;
    nDate: TDate;
    nInt: Integer;
begin
  Result := 0;
  nDate := Date();
  //server now

  nStr := 'Select D_Value,D_ParamB From %s ' +
          'Where D_Name=''%s'' and D_Memo=''%s''';
  nStr := Format(nStr, [sTable_SysDict, sFlag_SysParam, sFlag_ValidDate]);

  with FDM.QuerySQL(nStr, False) do
  if RecordCount > 0 then
  begin
    nStr := 'dmzn_stock_' + Fields[0].AsString;
    nStr := MD5Print(MD5String(nStr));

    if nStr = Fields[1].AsString then
      nDate := Str2Date(Fields[0].AsString);
    //xxxxx
  end;

  nInt := Trunc(nDate - Date());
  //xxxxx

  if nInt <= 0 then
  begin
    nStr := '系统已过期 %d 天,请联系管理员!!';
    nStr := Format(nStr, [-nInt]);
    ShowDlg(nStr, sWarn);
    Exit;
  end;

  if nInt <= 7 then
  begin
    nStr := Format('系统在 %d 天后过期', [nInt]);
    ShowMsg(nStr, sHint);
  end;

  Result := nInt;
end;

function LoadSysDictItem(const nItem: string; const nList: TStrings): TDataSet;
var nStr: string;
begin
  nList.Clear;
  nStr := MacroValue(sQuery_SysDict, [MI('$Table', sTable_SysDict),
                                      MI('$Name', nItem)]);
  Result := FDM.QuerySQL(nStr);

  if Result.RecordCount > 0 then
  with Result do
  begin
    First;

    while not Eof do
    begin
      nList.Add(FieldByName('D_Value').AsString);
      Next;
    end;
  end else Result := nil;
end;

end.
