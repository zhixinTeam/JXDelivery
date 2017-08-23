{*******************************************************************************
  作者: dmzn@163.com 2014-09-01
  描述: 开提货单
*******************************************************************************}
unit UFormBill;

{$I Link.Inc}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFormNormal, UBusinessConst, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, ComCtrls, cxMaskEdit,
  cxDropDownEdit, cxListView, cxTextEdit, cxMCListBox, dxLayoutControl,
  StdCtrls, cxButtonEdit, cxGraphics;

type
  TfFormBill = class(TfFormNormal)
    dxLayout1Item3: TdxLayoutItem;
    ListInfo: TcxMCListBox;
    EditTruck: TcxTextEdit;
    dxLayout1Item9: TdxLayoutItem;
    EditLading: TcxComboBox;
    dxLayout1Item12: TdxLayoutItem;
    EditFQ: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    dxLayout1Item6: TdxLayoutItem;
    EditType: TcxComboBox;
    dxLayout1Group3: TdxLayoutGroup;
    EditValue: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    dxLayout1Group4: TdxLayoutGroup;
    dxLayout1Item7: TdxLayoutItem;
    EditPack: TcxComboBox;
    dxLayout1Group2: TdxLayoutGroup;
    dxLayout1Group5: TdxLayoutGroup;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnOKClick(Sender: TObject);
    procedure EditLadingKeyPress(Sender: TObject; var Key: Char);
  protected
    { Protected declarations }
    FBuDanFlag: string;
    //补单标记
    FBills: string;
    //交货单号
    FOrder: TOrderItemInfo;
    //订单信息
    FListA,FListB: TStrings;
    //列表对象
    procedure LoadFormData(const nOrders: string);
    //载入数据
    function SetVipTruck(nTruck: String): Boolean;
    //VIP车道设置
    function GetStockPackStyle(const nStockID: string): string;
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
    function OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean; override;
  end;

implementation

{$R *.dfm}
uses
  ULibFun, IniFiles, UMgrControl, UAdjustForm, UFormBase, UBusinessPacker,
  UDataModule, USysPopedom, USysDB, USysGrid, USysConst;

class function TfFormBill.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nStr: string;
    nBool: Boolean;
    nP: PFormCommandParam;
begin
  Result := nil;
  if GetSysValidDate < 1 then Exit;

  if not Assigned(nParam) then
  begin
    nStr := '';
    New(nP);
    FillChar(nP^, SizeOf(TFormCommandParam), #0);
  end else
  begin
    nP := nParam;
    nStr := nP.FParamA;
    //订单数据
  end;

  if nStr = '' then
  try
    nP.FParamC := sFlag_Sale;
    CreateBaseFormItem(cFI_FormGetOrder, nPopedom, nP);
    if (nP.FCommand <> cCmd_ModalResult) or (nP.FParamA <> mrOK) then Exit;
    nStr := nP.FParamB;
  finally
    if not Assigned(nParam) then Dispose(nP);
  end;

  with TfFormBill.Create(Application) do
  try
    Caption := '开交货单';
    nBool := not gPopedomManager.HasPopedom(nPopedom, sPopedom_Edit);
    EditLading.Properties.ReadOnly := nBool;

    if nPopedom = 'MAIN_D04' then //补单
         FBuDanFlag := sFlag_Yes
    else FBuDanFlag := sFlag_No;

    FBills := '';
    LoadFormData(nStr);
    //init ui

    if Assigned(nParam) then
    with PFormCommandParam(nParam)^ do
    begin
      FCommand := cCmd_ModalResult;
      FParamA := ShowModal;

      if FParamA = mrOK then
           FParamB := FBills
      else FParamB := '';
    end else ShowModal;
  finally
    Free;
  end;
end;

class function TfFormBill.FormID: integer;
begin
  Result := cFI_FormMakeBill;
end;

procedure TfFormBill.FormCreate(Sender: TObject);
var nStr: string;
    nIni: TIniFile;
begin
  FListA := TStringList.Create;
  FListB := TStringList.Create;

  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    nStr := nIni.ReadString(Name, 'FQLabel', '');
    if nStr <> '' then
      dxLayout1Item5.Caption := nStr;
    //xxxxx

    LoadMCListBoxConfig(Name, ListInfo, nIni);
  finally
    nIni.Free;
  end;

  AdjustCtrlData(Self);
end;

procedure TfFormBill.FormClose(Sender: TObject; var Action: TCloseAction);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    SaveMCListBoxConfig(Name, ListInfo, nIni);
  finally
    nIni.Free;
  end;

  ReleaseCtrlData(Self);
  FListA.Free;
  FListB.Free;
end;

//Desc: 回车键
procedure TfFormBill.EditLadingKeyPress(Sender: TObject; var Key: Char);
var nP: TFormCommandParam;
begin
  if Key = Char(VK_RETURN) then
  begin
    Key := #0;

    if Sender = EditLading then
      ActiveControl := EditTruck else
    if Sender = EditValue then
         ActiveControl := BtnOK
    else Perform(WM_NEXTDLGCTL, 0, 0);
  end;

  if (Sender = EditTruck) and (Key = Char(VK_SPACE)) then
  begin
    Key := #0;
    nP.FParamA := EditTruck.Text;
    CreateBaseFormItem(cFI_FormGetTruck, '', @nP);

    if (nP.FCommand = cCmd_ModalResult) and(nP.FParamA = mrOk) then
    begin
      EditTruck.Text := nP.FParamB;
      SetVipTruck(EditTruck.Text);
    end;

    EditTruck.SelectAll;
  end;
end;

//------------------------------------------------------------------------------
//Desc: 载入界面数据
procedure TfFormBill.LoadFormData(const nOrders: string);
begin
  AnalyzeOrderInfo(nOrders, FOrder);
  LoadOrderInfo(FOrder, ListInfo);
  ActiveControl := EditTruck;

  EditFQ.Text := FOrder.FBatchCode;
  //xxxxx

  EditTruck.Text := FOrder.FTruck;
  EditValue.Text := Format('%.2f', [FOrder.FValue]);

  SetCtrlData(EditPack, GetStockPackStyle(FOrder.FStockID));
  //包装类型

  SetVipTruck(FOrder.FTruck);
end;

function TfFormBill.OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean;
var nVal: Double;
begin
  Result := True;

  if Sender = EditTruck then
  begin
    Result := Length(EditTruck.Text) > 2;
    nHint := '车牌号长度应大于2位';
  end else

  if Sender = EditLading then
  begin
    Result := EditLading.ItemIndex > -1;
    nHint := '请选择有效的提货方式';
  end else

  if Sender = EditPack then
  begin
    Result := EditPack.Text <> '';
    nHint := '请选择有效的包装类型';
  end;

  if Sender = EditValue then
  begin
    Result := IsNumber(EditValue.Text, True) and (StrToFloat(EditValue.Text)>0);
    nHint := '请填写有效的办理量';
    if not Result then Exit;

    nVal := StrToFloat(EditValue.Text);
    Result := FloatRelation(nVal, FOrder.FValue, rtLE);
    nHint := '已超过可提货量';
  end;
end;

//Desc: 保存
procedure TfFormBill.BtnOKClick(Sender: TObject);
var //nPrint: Boolean;
    nOutErr: string;
    nList: TStrings;
begin
  if not IsDataValid then Exit;
  //check valid

  nList := TStringList.Create;
  try
    //LoadSysDictItem(sFlag_PrintBill, nList);
    //需打印品种
    //nPrint := nList.IndexOf(FOrder.FStockID) >= 0;

    with nList do
    begin
      Clear;
      Values['Orders'] := PackerEncodeStr(FOrder.FOrders);
      Values['Value'] := EditValue.Text;
      Values['Truck'] := EditTruck.Text;
      Values['Lading'] := GetCtrlData(EditLading);
      Values['IsVIP'] := GetCtrlData(EditType);
      Values['Pack'] := GetCtrlData(EditPack);
      Values['Seal'] := EditFQ.Text;
      Values['BuDan'] := FBuDanFlag;

      Values['CusID'] := FOrder.FCusID;
      Values['CusName'] := FOrder.FCusName;
    end;

    FBills := SaveBill(nOutErr, nList);
    //call mit bus
    if FBills = '' then Exit;
  finally
    nList.Free;
  end;

  //if nPrint then
  PrintBillReport(FBills, True);
  //print report

  ModalResult := mrOk;
  ShowMsg('提货单保存成功', sHint);
end;


function TfFormBill.SetVipTruck(nTruck: String): Boolean;
var nStr, nVip: string;
begin
  nStr := 'Select T_VIPTruck From %s Where T_Truck=''%s''';
  nStr := Format(nStr, [sTable_Truck, Trim(nTruck)]);

  nVip := '';
  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    nVip := Fields[0].AsString;

    if nVip <> '' then
      SetCtrlData(EditType, nVip);
  end;

  Result := nVip = sFlag_TypeVIP;
end;

function TfFormBill.GetStockPackStyle(const nStockID: string): string;
var nStr: string;
begin
  nStr := 'Select D_ParamC From %s Where (D_Name=''StockItem''' +
          ' and D_ParamB=''%s'')';
  nStr := Format(nStr, [sTable_SysDict, Trim(nStockID)]);

  Result := '';
  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
     Result := Fields[0].AsString;

  if Result = '' then Result := 'C';
end;  

initialization
  gControlManager.RegCtrl(TfFormBill, TfFormBill.FormID);
end.
