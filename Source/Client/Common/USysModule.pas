{*******************************************************************************
  作者: dmzn@163.com 2009-6-25
  描述: 单元模块

  备注: 由于模块有自注册能力,只要Uses一下即可.
*******************************************************************************}
unit USysModule;

interface

uses
  UFrameLog, UFrameSysLog, UFormIncInfo, UFormBackupSQL, UFormRestoreSQL,
  UFormPassword, UFramePoundManual, UFramePoundQuery, UFormGetNCBill,
  UFormGetTruck, UFormGetCustom, UFormGetZhiKa, UFrameDeduct, UFormDeduct,
  UFrameAuthorize, UFormAuthorize, UFormGetNCStock, UFramePMaterails,
  UFormPMaterails,UFramePProvider, UFormPProvider,UFormGetNCBatch,
  UFrameReqSale, UFrameReqProvide, UFrameReqDispatch, UFrameBill, UFormBill,
  UFramePTransport, UFormPTransport, UFormOptions;

procedure InitSystemObject;
procedure RunSystemObject;
procedure FreeSystemObject;

implementation

uses
  SysUtils, USysLoger, USysConst, USysMAC, USysDB, UDataModule;

//Desc: 初始化系统对象
procedure InitSystemObject;
begin
  if not Assigned(gSysLoger) then
    gSysLoger := TSysLoger.Create(gPath + sLogDir);
  //system loger
end;

//Desc: 运行系统对象
procedure RunSystemObject;
var nStr, nPB:string;
begin
  with gSysParam do
  begin
    FLocalMAC   := MakeActionID_MAC;
    GetLocalIPConfig(FLocalName, FLocalIP);
  end;

  nStr := 'Select W_Factory,W_Serial From %s ' +
          'Where W_MAC=''%s'' And W_Valid=''%s''';
  nStr := Format(nStr, [sTable_WorkePC, gSysParam.FLocalMAC, sFlag_Yes]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    gSysParam.FFactNum := Fields[0].AsString;
    gSysParam.FSerialID := Fields[1].AsString;
  end;

  //----------------------------------------------------------------------------
  with gSysParam do
  begin
    FPoundDaiZ := 0;
    FPoundDaiF := 0;
    FPoundSanF := 0;
    FPoundPZ := 0;
    FPoundPF := 0;
    FPoundTruckP:= 50000;
    FDaiWCStop := False;
    FDaiPercent := False;
  end;

  nStr := 'Select D_Value,D_Memo From %s Where D_Name=''%s''';
  nStr := Format(nStr, [sTable_SysDict, sFlag_PoundWuCha]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    First;

    while not Eof do
    begin
      nStr := Fields[1].AsString;
      if nStr = sFlag_PDaiWuChaZ then
        gSysParam.FPoundDaiZ := Fields[0].AsFloat;
      //xxxxx

      if nStr = sFlag_PDaiWuChaF then
        gSysParam.FPoundDaiF := Fields[0].AsFloat;
      //xxxxx

      if nStr = sFlag_PDaiPercent then
        gSysParam.FDaiPercent := Fields[0].AsString = sFlag_Yes;
      //xxxxx

      if nStr = sFlag_PDaiWuChaStop then
        gSysParam.FDaiWCStop := Fields[0].AsString = sFlag_Yes;
      //xxxxx

      if nStr = sFlag_PSanWuChaF then
        gSysParam.FPoundSanF := Fields[0].AsFloat;
      //xxxxx

      if nStr = sFlag_PoundPWuChaZ then
        gSysParam.FPoundPZ := Fields[0].AsFloat;
      //xxxxx

      if nStr = sFlag_PoundPWuChaF then
        gSysParam.FPoundPF := Fields[0].AsFloat;
      //xxxxx

      if nStr = sFlag_PTruckPWuCha then
        gSysParam.FPoundTruckP := Fields[0].AsFloat;
      Next;
    end;

    with gSysParam do
    begin
      FPoundDaiZ_1 := FPoundDaiZ;
      FPoundDaiF_1 := FPoundDaiF;
      //backup wucha value
    end;
  end;

  //----------------------------------------------------------------------------
  with gSysParam do
  begin
    FDepotID := '';
    FCorpFrom := '';
    FWareHouseID:= '';
    FWareHouseGroup:='';
  end;

  nStr := 'Select D_Value,D_Memo,D_ParamB From %s Where D_Name=''%s''';
  nStr := Format(nStr, [sTable_SysDict, sFlag_OrderInFact]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    First;

    while not Eof do
    begin
      nStr := Fields[1].AsString;
      nPB  := Fields[2].AsString;

      if nPB = gSysParam.FFactNum then
      begin
        if (nStr = sFlag_InFact) then
          gSysParam.FCorpFrom := Fields[0].AsString;
        //xxxxx

        if nStr = sFlag_InWHouse then
          gSysParam.FWareHouseGroup := Fields[0].AsString;
        //xxxxx

        if nStr = sFlag_InWHID then
          gSysParam.FWareHouseID := Fields[0].AsString;
        //xxxxx

        if nStr = sFlag_InDepot then
          gSysParam.FDepotID := Fields[0].AsString;
        //xxxxx
      end;

      Next;
    end;
  end;
end;

//Desc: 释放系统对象
procedure FreeSystemObject;
begin
  FreeAndNil(gSysLoger);
end;

end.
