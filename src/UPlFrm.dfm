object PlFrm: TPlFrm
  Left = 0
  Top = 0
  Width = 444
  Height = 285
  ParentShowHint = False
  ShowHint = True
  TabOrder = 0
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 444
    Height = 285
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Programmed grammar'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object ListView1: TTntListView
        Left = 0
        Top = 0
        Width = 436
        Height = 254
        Align = alClient
        BevelEdges = [beTop]
        BevelOuter = bvNone
        BevelKind = bkSoft
        BorderStyle = bsNone
        Columns = <
          item
            Caption = 'ID'
            Width = 30
          end
          item
            Caption = 'Rule'
            Width = 100
          end
          item
            Caption = #963
            Width = 80
          end
          item
            Caption = #966
            Width = 80
          end>
        GridLines = True
        HideSelection = False
        ReadOnly = True
        RowSelect = True
        TabOrder = 0
        ViewStyle = vsReport
        OnSelectItem = ListView1SelectItem
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Definition'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object TntMemo1: TTntMemo
        Left = 0
        Top = 0
        Width = 436
        Height = 254
        Align = alClient
        BevelInner = bvNone
        BevelOuter = bvNone
        BorderStyle = bsNone
        TabOrder = 0
      end
    end
  end
end
