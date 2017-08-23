{*******************************************************************************
  作者: dmzn@163.com 2012-03-31
  描述: 称重查询
*******************************************************************************}
unit UFramePoundQuery;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFrameNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, cxContainer, Menus, dxLayoutControl,
  cxCheckBox, cxMaskEdit, cxButtonEdit, cxTextEdit, ADODB, cxLabel,
  UBitmapPanel, cxSplitter, cxGridLevel, cxClasses, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  ComCtrls, ToolWin, UFormCtrl;

type
  TfFramePoundQuery = class(TfFrameNormal)
    cxTextEdit1: TcxTextEdit;
    dxLayout1Item1: TdxLayoutItem;
    EditTruck: TcxButtonEdit;
    dxLayout1Item2: TdxLayoutItem;
    EditCus: TcxButtonEdit;
    dxLayout1Item3: TdxLayoutItem;
    cxTextEdit2: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    cxTextEdit3: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    EditDate: TcxButtonEdit;
    dxLayout1Item6: TdxLayoutItem;
    cxTextEdit4: TcxTextEdit;
    dxLayout1Item7: TdxLayoutItem;
    PMenu1: TPopupMenu;
    N3: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    Check1: TcxCheckBox;
    dxLayout1Item8: TdxLayoutItem;
    N4: TMenuItem;
    N5: TMenuItem;
    EditPID: TcxButtonEdit;
    dxLayout1Item9: TdxLayoutItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N6: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    N12: TMenuItem;
    N14: TMenuItem;
    N15: TMenuItem;
    N16: TMenuItem;
    N17: TMenuItem;
    N18: TMenuItem;
    procedure EditDatePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure EditTruckPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure N3Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure PMenu1Popup(Sender: TObject);
    procedure Check1Click(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
    procedure BtnEditClick(Sender: TObject);
    procedure N10Click(Sender: TObject);
    procedure N11Click(Sender: TObject);
    procedure N12Click(Sender: TObject);
    procedure N16Click(Sender: TObject);
    procedure N17Click(Sender: TObject);
    procedure N18Click(Sender: TObject);
  private
    { Private declarations }
  protected
    FStart,FEnd: TDate;
    FTimeS,FTimeE: TDate;
    //时间区间
    FJBWhere: string;
    //交班查询
    FShadowWeight: Double;
    //影子重量
    procedure OnCreateFrame; override;
    procedure OnDestroyFrame; override;
    procedure AfterInitFormData; override;
    function InitFormDataSQL(const nWhere: string): string; override;
    {*查询SQL*}
  public
    { Public declarations }
    class function FrameID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  ShellAPI, ULibFun, UMgrControl, UDataModule, UFormDateFilter, UFormInputbox,
  UFormWait, USysConst, USysDB, UBusinessConst, UFormBase, USysPopedom;

class function TfFramePoundQuery.FrameID: integer;
begin
  Result := cFI_FramePoundQuery;
end;

procedure TfFramePoundQuery.OnCreateFrame;
begin
  inherited;
  FTimeS := Str2DateTime(Date2Str(Now) + ' 00:00:00');
  FTimeE := Str2DateTime(Date2Str(Now) + ' 00:00:00');

  FJBWhere := '';
  InitDateRange(Name, FStart, FEnd);
end;

procedure TfFramePoundQuery.OnDestroyFrame;
begin
  SaveDateRange(Name, FStart, FEnd);
  inherited;
end;

function TfFramePoundQuery.InitFormDataSQL(const nWhere: string): string;
var nStr: string;
begin
  EditDate.Text := Format('%s 至 %s', [Date2Str(FStart), Date2Str(FEnd)]);

  Result := 'Select pl.*,(P_MValue-P_PValue-P_KZValue) As P_NetWeight,' +
            'ABS((P_MValue-P_PValue-P_KZValue)-P_LimValue) As P_Wucha From $PL pl';
  //xxxxx

  if FJBWhere = '' then
  begin
    Result := Result + ' Where ((P_PDate >=''$S'' and P_PDate<''$E'') or ' +
              '(P_MDate >=''$S'' and P_MDate<''$E'')) ';
  end else
  begin
    Result := Result + ' Where (' + FJBWhere + ')';
  end;

  if Check1.Checked then
       Result := MacroValue(Result, [MI('$PL', sTable_PoundBak)])
  else Result := MacroValue(Result, [MI('$PL', sTable_PoundLog)]);

  Result := MacroValue(Result, [MI('$S', Date2Str(FStart)),
            MI('$E', Date2Str(FEnd+1))]);
  //xxxxx

  if nWhere <> '' then
    Result := Result + ' And (' + nWhere + ')';
  //xxxxx

  if not gPopedomManager.HasPopedom(PopedomItem, sPopedom_FullReport) then
  begin
    if FShadowWeight < 0 then
    begin
      FShadowWeight := 0;
      nStr := 'Select D_Value From %s Where D_Name=''%s'' And D_Memo=''%s''';
      nStr := Format(nStr, [sTable_SysDict, sFlag_SysParam, sFlag_ShadowWeight]);

      with FDM.QueryTemp(nStr) do
      if RecordCount > 0 then
      begin
        FShadowWeight := Fields[0].AsFloat;
      end;
    end;

    if FShadowWeight > 0 then
    begin
      nStr := ' And (P_MValue-P_PValue-P_KZValue)<%f';
      Result := Result +  Format(nStr, [FShadowWeight]);
    end;
  end;
end;

procedure TfFramePoundQuery.AfterInitFormData;
begin
  FJBWhere := '';
end;

//Desc: 日期筛选
procedure TfFramePoundQuery.EditDatePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if ShowDateFilterForm(FStart, FEnd) then InitFormData(FWhere);
end;

//Desc: 执行查询
procedure TfFramePoundQuery.EditTruckPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if Sender = EditPID then
  begin
    EditPID.Text := Trim(EditPID.Text);
    if EditPID.Text = '' then Exit;

    if Length(EditPID.Text) <= 3 then
    begin
      FWhere := 'P_ID like ''%%%s%%''';
      FWhere := Format(FWhere, [EditPID.Text]);
    end else
    begin
      FWhere := '';
      FJBWhere := 'P_ID like ''%%%s%%''';
      FJBWhere := Format(FJBWhere, [EditPID.Text]);
    end;
    InitFormData(FWhere);
  end else

  if Sender = EditTruck then
  begin
    EditTruck.Text := Trim(EditTruck.Text);
    if EditTruck.Text = '' then Exit;

    FWhere := 'P_Truck like ''%%%s%%''';
    FWhere := Format(FWhere, [EditTruck.Text]);
    InitFormData(FWhere);
  end else

  if Sender = EditCus then
  begin
    EditCus.Text := Trim(EditCus.Text);
    if EditCus.Text = '' then Exit;

    FWhere := 'P_CusName like ''%%%s%%''';
    FWhere := Format(FWhere, [EditCus.Text]);
    InitFormData(FWhere);
  end;
end;

procedure TfFramePoundQuery.Check1Click(Sender: TObject);
begin
  BtnRefresh.Click;
end;

//------------------------------------------------------------------------------
//Desc: 权限控制
procedure TfFramePoundQuery.PMenu1Popup(Sender: TObject);
begin
  N3.Enabled := BtnPrint.Enabled and (not Check1.Checked);
  N9.Visible := BtnEdit.Enabled;
  N10.Visible := BtnEdit.Enabled;
  N11.Visible := BtnEdit.Enabled;
  N12.Visible := BtnEdit.Enabled;
end;

//Desc: 打印磅单
procedure TfFramePoundQuery.N3Click(Sender: TObject);
var nStr: string;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    if SQLQuery.FieldByName('P_PValue').AsFloat = 0 then
    begin
      ShowMsg('请先称量皮重', sHint); Exit;
    end;

    nStr := SQLQuery.FieldByName('P_ID').AsString;

    if SQLQuery.FieldByName('P_Type').AsString=sFlag_Sale then
         PrintSalePoundReport(nStr, False)
    else PrintPoundReport(nStr, False);
  end
end;

//Desc: 时间段查询
procedure TfFramePoundQuery.N2Click(Sender: TObject);
begin
  if ShowDateFilterForm(FTimeS, FTimeE, True) then
  try
    case TComponent(Sender).Tag of
     10: FJBWhere := 'P_PDate>=''$S'' And P_PDate<''$E''';
     20: FJBWhere := 'P_MDate>=''$S'' And P_MDate<''$E''';
     30: FJBWhere := '(P_PDate>=''$S'' And P_PDate<''$E'') Or ' +
                     '(P_MDate>=''$S'' And P_MDate<''$E'')';
     //xxxxx
    end;

    FJBWhere := MacroValue(FJBWhere, [MI('$S', DateTime2Str(FTimeS)),
                MI('$E', DateTime2Str(FTimeE))]);
    InitFormData('');
  finally
    FJBWhere := '';
  end;
end;

//Desc: 删除榜单
procedure TfFramePoundQuery.BtnDelClick(Sender: TObject);
var nIdx: Integer;
    nStr,nID,nP: string;
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('请选择要删除的记录', sHint);
    Exit;
  end;

  nID := SQLQuery.FieldByName('P_ID').AsString;
  nStr := Format('确定要删除编号为[ %s ]的过磅单吗?', [nID]);
  if not QueryDlg(nStr, sAsk) then Exit;

  nStr := Format('Select * From %s Where 1<>1', [sTable_PoundLog]);
  //only for fields
  nP := '';

  with FDM.QueryTemp(nStr) do
  begin
    for nIdx:=0 to FieldCount - 1 do
    if (Fields[nIdx].DataType <> ftAutoInc) and
       (Pos('P_Del', Fields[nIdx].FieldName) < 1) then
      nP := nP + Fields[nIdx].FieldName + ',';
    //所有字段,不包括删除
    System.Delete(nP, Length(nP), 1);
  end;

  FDM.ADOConn.BeginTrans;
  try
    nStr := 'Insert Into $PB($FL,P_DelMan,P_DelDate) ' +
            'Select $FL,''$User'',$Now From $PL Where P_ID=''$ID''';
    nStr := MacroValue(nStr, [MI('$PB', sTable_PoundBak),
            MI('$FL', nP), MI('$User', gSysParam.FUserID),
            MI('$Now', sField_SQLServer_Now),
            MI('$PL', sTable_PoundLog), MI('$ID', nID)]);
    FDM.ExecuteSQL(nStr);
    
    nStr := 'Delete From %s Where P_ID=''%s''';
    nStr := Format(nStr, [sTable_PoundLog, nID]);
    FDM.ExecuteSQL(nStr);

    FDM.ADOConn.CommitTrans;
    InitFormData(FWhere);
    ShowMsg('删除完毕', sHint);
  except
    FDM.ADOConn.RollbackTrans;
    ShowMsg('删除失败', sError);
  end;
end;

procedure TfFramePoundQuery.BtnEditClick(Sender: TObject);
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('请选择需要修改的称重记录', sHint);
    Exit;
  end;


end;

procedure TfFramePoundQuery.N10Click(Sender: TObject);
var nSQL,nStr,nBID,nPID,nPType,nTruck: string;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    if (SQLQuery.FieldByName('P_MValue').AsFloat>0) and
      (SQLQuery.FieldByName('P_PValue').AsFloat>0)
    then
    begin
      ShowDlg('禁止修改已完成订单', sWarn);
      Exit;
    end;

    nStr := SQLQuery.FieldByName('P_Truck').AsString;
    nTruck := nStr;
    if not ShowInputBox('请输入新的车牌号码:', '修改', nTruck, 15) then Exit;

    if (nTruck = '') or (nStr = nTruck) then Exit;
    //无效或一致

    nPID := SQLQuery.FieldByName('P_ID').AsString;
    nBID := SQLQuery.FieldByName('P_Bill').AsString;
    nPType:=SQLQuery.FieldByName('P_Type').AsString;

    FDM.ADOConn.BeginTrans;
    try
      nSQL := MakeSQLByStr([SF('P_Truck', nTruck)
                ], sTable_PoundLog, SF('P_ID', nPID), False);
      FDM.ExecuteSQL(nSQL);

      if nPType <> sFlag_Provide then
      begin
        nSQL := MakeSQLByStr([SF('L_Truck', nTruck)
                ], sTable_Bill, SF('L_ID', nBID), False);
        FDM.ExecuteSQL(nSQL);
      end;

      nStr := Format('修改称重车牌号,磅单号:%s 原车牌:%s 新车牌:%s', [
              nPID, nStr, nTruck]);
      FDM.WriteSysLog(sFlag_PoundLogItem, sFlag_PoundLogItem, nStr);

      FDM.ADOConn.CommitTrans;
      InitFormData(FWhere);
      ShowMsg('车牌号修改成功', sHint);
    except
      FDM.ADOConn.RollbackTrans;
      ShowMsg('车牌号修改失败', sError);
    end;
  end;
end;

procedure TfFramePoundQuery.N11Click(Sender: TObject);
var nSQL,nStr,nBID,nPID,nPType,nStock: string;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nPID    := SQLQuery.FieldByName('P_ID').AsString;
    nBID    := SQLQuery.FieldByName('P_Bill').AsString;
    nPType  := SQLQuery.FieldByName('P_Type').AsString;
    nStock  := SQLQuery.FieldByName('P_MName').AsString;

    if (nPType = sFlag_NChange) or (nPType = sFlag_Other) then
    begin
      if not ShowInputBox('请输入新的物料名称:', '修改', nStr, 15) then Exit;
    end else Exit;

    if (nStr='') or (nStr=nStock) then Exit;

    FDM.ADOConn.BeginTrans;
    try
      nSQL := MakeSQLByStr([SF('P_MName', nStr)
                ], sTable_PoundLog, SF('P_ID', nPID), False);
      FDM.ExecuteSQL(nSQL);

      nStr := Format('修改称重物料名称,磅单号:%s 原物料名:%s 新物料名:%s', [
              nPID, nStock, nStr]);
      FDM.WriteSysLog(sFlag_PoundLogItem, sFlag_PoundLogItem, nStr);

      FDM.ADOConn.CommitTrans;
      InitFormData(FWhere);
      ShowMsg('物料名称修改成功', sHint);
    except
      FDM.ADOConn.RollbackTrans;
      ShowMsg('物料名称修改失败', sError);
    end;
  end;
end;

procedure TfFramePoundQuery.N12Click(Sender: TObject);
var nStr, nSQL, nPID, nPType, nCusName: string;
begin
  inherited;
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nPID    := SQLQuery.FieldByName('P_ID').AsString;
    nPType  := SQLQuery.FieldByName('P_Type').AsString;
    nCusName  := SQLQuery.FieldByName('P_CusName').AsString;

    if (nPType = sFlag_NChange) or (nPType = sFlag_Other) then
    begin
      if not ShowInputBox('请输入新的客户名称:', '修改', nStr, 15) then Exit;
    end else Exit;

    if (nStr='') or (nStr=nCusName) then Exit;

    FDM.ADOConn.BeginTrans;
    try
      nSQL := MakeSQLByStr([SF('P_CusName', nStr)
                ], sTable_PoundLog, SF('P_ID', nPID), False);
      FDM.ExecuteSQL(nSQL);

      nStr := Format('修改称重物料名称,磅单号:%s 原客户名:%s 新客户名:%s', [
              nPID, nCusName, nStr]);
      FDM.WriteSysLog(sFlag_PoundLogItem, sFlag_PoundLogItem, nStr);

      FDM.ADOConn.CommitTrans;
      InitFormData(FWhere);
      ShowMsg('客户名称修改成功', sHint);
    except
      FDM.ADOConn.RollbackTrans;
      ShowMsg('客户名称修改失败', sError);
    end;
  end;
end;

//发货统计
procedure TfFramePoundQuery.N16Click(Sender: TObject);
begin
  inherited;
  //
  if ShowDateFilterForm(FTimeS, FTimeE, True) then
  try
    FJBWhere := '(P_MDate>=''%s'' And P_MDate<''%s'' And P_Type=''%s'')';
    FJBWhere := Format(FJBWhere, [DateTime2Str(FTimeS), DateTime2Str(FTimeE),
                sFlag_Sale]);
    InitFormData('');
  finally
    FJBWhere := '';
  end;
end;

//收货统计
procedure TfFramePoundQuery.N17Click(Sender: TObject);
begin
  inherited;
  //
  if ShowDateFilterForm(FTimeS, FTimeE, True) then
  try
    FJBWhere := '(P_PDate>=''%s'' And P_PDate<''%s'' And P_Type=''%s'' And ' +
                'P_MDate Is Not Null)';
    FJBWhere := Format(FJBWhere, [DateTime2Str(FTimeS), DateTime2Str(FTimeE),
                sFlag_Provide]);
    InitFormData('');
  finally
    FJBWhere := '';
  end;
end;

//倒料统计
procedure TfFramePoundQuery.N18Click(Sender: TObject);
begin
  inherited;
  //
  if ShowDateFilterForm(FTimeS, FTimeE, True) then
  try
    FJBWhere := '(P_PDate>=''%s'' And P_PDate<''%s'' And P_Type=''%s'' And ' +
                'P_MDate Is Not Null)';
    FJBWhere := Format(FJBWhere, [DateTime2Str(FTimeS), DateTime2Str(FTimeE),
                sFlag_NChange]);
    InitFormData('');
  finally
    FJBWhere := '';
  end;
end;

initialization
  gControlManager.RegCtrl(TfFramePoundQuery, TfFramePoundQuery.FrameID);
end.
