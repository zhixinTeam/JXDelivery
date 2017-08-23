inherited fFormBill: TfFormBill
  Left = 419
  Top = 428
  ClientHeight = 371
  ClientWidth = 409
  Position = poDesktopCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 409
    Height = 371
    inherited BtnOK: TButton
      Left = 263
      Top = 338
      Caption = #24320#21333
      TabOrder = 7
    end
    inherited BtnExit: TButton
      Left = 333
      Top = 338
      TabOrder = 8
    end
    object ListInfo: TcxMCListBox [2]
      Left = 23
      Top = 36
      Width = 373
      Height = 165
      HeaderSections = <
        item
          Text = #20449#24687#39033
          Width = 74
        end
        item
          AutoSize = True
          Text = #20449#24687#20869#23481
          Width = 295
        end>
      ParentFont = False
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 0
    end
    object EditTruck: TcxTextEdit [3]
      Left = 81
      Top = 281
      ParentFont = False
      Properties.MaxLength = 15
      TabOrder = 5
      OnKeyPress = EditLadingKeyPress
      Width = 115
    end
    object EditLading: TcxComboBox [4]
      Left = 81
      Top = 206
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.ItemHeight = 18
      Properties.Items.Strings = (
        'T=T'#12289#33258#25552
        'S=S'#12289#36865#36135
        'X=X'#12289#36816#21368)
      TabOrder = 1
      OnKeyPress = EditLadingKeyPress
      Width = 125
    end
    object EditFQ: TcxTextEdit [5]
      Left = 254
      Top = 256
      ParentFont = False
      Properties.MaxLength = 100
      TabOrder = 4
      Width = 120
    end
    object EditType: TcxComboBox [6]
      Left = 81
      Top = 231
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.ItemHeight = 18
      Properties.Items.Strings = (
        'C=C'#12289#26222#36890
        'Z=Z'#12289#26632#21488
        'V=V'#12289'VIP'
        'S=S'#12289#33337#36816)
      TabOrder = 2
      OnKeyPress = EditLadingKeyPress
      Width = 120
    end
    object EditValue: TcxTextEdit [7]
      Left = 265
      Top = 281
      ParentFont = False
      TabOrder = 6
      OnKeyPress = EditLadingKeyPress
      Width = 121
    end
    object EditPack: TcxComboBox [8]
      Left = 81
      Top = 256
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.ItemHeight = 18
      Properties.Items.Strings = (
        'C=C'#12289#26222#36890
        'Z=Z'#12289#32440#34955
        'T=T'#12289#28034#33180#34955
        'R=R'#12289#26089#24378#22411)
      TabOrder = 3
      OnKeyPress = EditLadingKeyPress
      Width = 110
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        object dxLayout1Item3: TdxLayoutItem
          Control = ListInfo
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Group3: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          ShowBorder = False
          object dxLayout1Group5: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            ShowBorder = False
            object dxLayout1Item12: TdxLayoutItem
              AutoAligns = [aaVertical]
              AlignHorz = ahClient
              Caption = #25552#36135#26041#24335':'
              Control = EditLading
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item6: TdxLayoutItem
              AutoAligns = [aaVertical]
              AlignHorz = ahClient
              Caption = #25552#36135#36890#36947':'
              Control = EditType
              ControlOptions.ShowBorder = False
            end
          end
          object dxLayout1Group2: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxLayout1Item7: TdxLayoutItem
              Caption = #21253#35013#31867#22411':'
              Control = EditPack
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item5: TdxLayoutItem
              AutoAligns = [aaVertical]
              AlignHorz = ahClient
              Caption = #25209#27425#32534#21495':'
              Control = EditFQ
              ControlOptions.ShowBorder = False
            end
          end
        end
        object dxLayout1Group4: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item9: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Caption = #25552#36135#36710#36742':'
            Control = EditTruck
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item4: TdxLayoutItem
            Caption = #25552#36135#37327'('#21544'):'
            Control = EditValue
            ControlOptions.ShowBorder = False
          end
        end
      end
    end
  end
end
