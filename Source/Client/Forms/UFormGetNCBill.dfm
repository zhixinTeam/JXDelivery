inherited fFormNCBill: TfFormNCBill
  Left = 345
  Top = 105
  ClientHeight = 440
  ClientWidth = 529
  Position = poDesktopCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 529
    Height = 440
    inherited BtnOK: TButton
      Left = 383
      Top = 407
      Caption = #30830#23450
      TabOrder = 3
    end
    inherited BtnExit: TButton
      Left = 453
      Top = 407
      TabOrder = 4
    end
    object ListInfo: TcxMCListBox [2]
      Left = 23
      Top = 36
      Width = 338
      Height = 116
      Delimiter = ','
      HeaderSections = <
        item
          Text = #20449#24687#39033
          Width = 85
        end
        item
          AutoSize = True
          Text = #20449#24687#20869#23481
          Width = 249
        end>
      ParentFont = False
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 0
    end
    object EditID: TcxButtonEdit [3]
      Left = 81
      Top = 157
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditIDPropertiesButtonClick
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.ButtonStyle = btsHotFlat
      TabOrder = 1
      OnKeyPress = OnCtrlKeyPress
      Width = 320
    end
    object ListDetail: TcxListView [4]
      Left = 23
      Top = 227
      Width = 355
      Height = 154
      Checkboxes = True
      Columns = <
        item
          Caption = #35746#21333#32534#21495
          Width = 90
        end
        item
          Caption = #35746#21333#31867#22411
          Width = 80
        end
        item
          Caption = #23458#25143#21517#31216
          Width = 100
        end
        item
          Caption = #29289#26009#21517#31216
          Width = 100
        end
        item
          Caption = #35746#21333#37327
          Width = 100
        end>
      HideSelection = False
      ParentFont = False
      ReadOnly = True
      RowSelect = True
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 2
      ViewStyle = vsReport
      OnSelectItem = ListDetailSelectItem
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        Caption = '1.'#20449#24687#23637#31034
        object dxLayout1Item7: TdxLayoutItem
          AutoAligns = [aaHorizontal]
          Control = ListInfo
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item8: TdxLayoutItem
          AutoAligns = [aaVertical]
          Caption = #35746#21333#32534#21495':'
          Control = EditID
          ControlOptions.ShowBorder = False
        end
      end
      object dxGroup2: TdxLayoutGroup [1]
        AutoAligns = [aaHorizontal]
        AlignVert = avClient
        Caption = '2.'#36873#25321#35746#21333
        object dxLayout1Item3: TdxLayoutItem
          AutoAligns = [aaHorizontal]
          AlignVert = avClient
          Control = ListDetail
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end
