{*******************************************************************************
  作者: dmzn@163.com 2015-01-22
  描述: 选择NC客户或物料
*******************************************************************************}
unit UFormGetNCStock;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormNormal, cxGraphics, cxContainer, cxEdit, cxTextEdit,
  cxMaskEdit, cxDropDownEdit, dxLayoutControl, StdCtrls, cxControls,
  ComCtrls, cxListView, cxButtonEdit, cxLabel, cxLookAndFeels,
  cxLookAndFeelPainters;

type
  TfFormGetNCStock = class(TfFormNormal)
    EditCus: TcxButtonEdit;
    dxLayout1Item5: TdxLayoutItem;
    ListQuery: TcxListView;
    dxLayout1Item6: TdxLayoutItem;
    cxLabel1: TcxLabel;
    dxLayout1Item7: TdxLayoutItem;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnOKClick(Sender: TObject);
    procedure ListQueryKeyPress(Sender: TObject; var Key: Char);
    procedure EditCIDPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure ListQueryDblClick(Sender: TObject);
  private
    { Private declarations }
    FID,FName: string;
    //结果信息
    FQueryType: string;
    //查询类型
    function QueryData: Boolean;
    //查询数据
    procedure GetResult;
    //获取结果  
    procedure InitFormData(const nID: string);
    //初始化数据
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

implementation

{$R *.dfm}

uses
  IniFiles, ULibFun, UMgrControl, UFormCtrl, UFormBase, USysGrid, USysDB,
  USysConst, UDataModule;

class function TfFormGetNCStock.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP: PFormCommandParam;
begin
  Result := nil;
  if Assigned(nParam) then
       nP := nParam
  else Exit;

  with TfFormGetNCStock.Create(Application) do
  begin
    FQueryType := nP.FParamA;
    if FQueryType = '1' then
    begin
      Caption := '选择客户';
      dxLayout1Item5.Caption := '客户名称';
    end else
    begin
      Caption := '选择物料';
      dxLayout1Item5.Caption := '物料名称';
    end;

    InitFormData(nP.FParamB);
    //初始化数据

    nP.FCommand := cCmd_ModalResult;
    nP.FParamA := ShowModal;

    if nP.FParamA = mrOK then
    begin
      nP.FParamB := FID;
      nP.FParamC := FName;
    end;
    Free;
  end;
end;

class function TfFormGetNCStock.FormID: integer;
begin
  Result := cFI_FormGetNCStock;
end;

procedure TfFormGetNCStock.FormCreate(Sender: TObject);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    LoadFormConfig(Self, nIni);
    LoadcxListViewConfig(Name, ListQuery, nIni);
  finally
    nIni.Free;
  end;
end;

procedure TfFormGetNCStock.FormClose(Sender: TObject;
  var Action: TCloseAction);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    SaveFormConfig(Self, nIni);
    SavecxListViewConfig(Name, ListQuery, nIni);
  finally
    nIni.Free;
  end;
end;

//------------------------------------------------------------------------------
//Desc: 初始化界面数据
procedure TfFormGetNCStock.InitFormData(const nID: string);
begin
  if nID <> '' then
  begin
    EditCus.Text := nID;
    if QueryData then ActiveControl := ListQuery;
  end else ActiveControl := EditCus;
end;

//------------------------------------------------------------------------------
//Date: 2015-01-22
//Desc: 按指定类型查询
function TfFormGetNCStock.QueryData: Boolean;
var nStr: string;
begin
  Result := False;
  ListQuery.Items.Clear;

  if FQueryType = '1' then
  begin
    nStr := 'select DISTINCT on (custcode) custcode,custname from Bd_cumandoc t1' +
            '  left join bd_cubasdoc t2 on t2.pk_cubasdoc=t1.pk_cubasdoc ' +
            'where custname like ''%%%s%%'' ' +
            'Group By custcode,custname';
    nStr := Format(nStr, [EditCus.Text]);
  end else
  begin
    nStr := 'select DISTINCT on (invcode) invcode,invname from meam_bill_b t1' +
            ' left join meam_bill t2 on t2.PK_MEAMBILL=t1.PK_MEAMBILL' +
            ' left join Bd_invbasdoc t_i on t_i.pk_invbasdoc=t1.PK_INVBASDOC ' +
            'where VBILLTYPE=''ME03'' and invname like ''%%%s%%'' ' +
            'group by invcode,invname';
    nStr := Format(nStr, [EditCus.Text]);
  end;

  with FDM.QueryTemp(nStr, True) do
  if RecordCount > 0 then
  begin
    First;

    while not Eof do
    with ListQuery.Items.Add do
    begin
      if FQueryType = '1' then
      begin
        Caption := FieldByName('custcode').AsString;
        SubItems.Add(FieldByName('custname').AsString);
      end else
      begin
        Caption := FieldByName('invcode').AsString;
        SubItems.Add(FieldByName('invname').AsString);
      end;

      ImageIndex := cItemIconIndex;
      Next;
    end;

    ListQuery.ItemIndex := 0;
    Result := True;
  end;
end;

procedure TfFormGetNCStock.EditCIDPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  EditCus.Text := Trim(EditCus.Text);
  if (EditCus.Text <> '') and QueryData then ListQuery.SetFocus;
end;

//Desc: 获取结果
procedure TfFormGetNCStock.GetResult;
begin
  with ListQuery.Selected do
  begin
    FID := Caption;
    FName := SubItems[0];
  end;
end;

procedure TfFormGetNCStock.ListQueryKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    if ListQuery.ItemIndex > -1 then
    begin
      GetResult;
      ModalResult := mrOk;
    end;
  end;
end;

procedure TfFormGetNCStock.ListQueryDblClick(Sender: TObject);
begin
  if ListQuery.ItemIndex > -1 then
  begin
    GetResult;
    ModalResult := mrOk;
  end;
end;

procedure TfFormGetNCStock.BtnOKClick(Sender: TObject);
begin
  if ListQuery.ItemIndex > -1 then
  begin
    GetResult;
    ModalResult := mrOk;
  end else ShowMsg('请在查询结果中选择', sHint);
end;

initialization
  gControlManager.RegCtrl(TfFormGetNCStock, TfFormGetNCStock.FormID);
end.
