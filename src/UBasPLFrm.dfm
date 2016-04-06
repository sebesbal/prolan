object BasPLFrame: TBasPLFrame
  Left = 0
  Top = 0
  Width = 445
  Height = 351
  TabOrder = 0
  OnResize = TntFrameResize
  object TntSplitter1: TTntSplitter
    Left = 0
    Top = 259
    Width = 445
    Height = 3
    Cursor = crVSplit
    Align = alBottom
    ExplicitTop = 50
    ExplicitWidth = 212
  end
  object sg: TTntNiceGrid
    Left = 0
    Top = 50
    Width = 445
    Height = 209
    Align = alClient
    FixedCols = 0
    FixedRows = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected, goColSizing, goEditing, goTabs, goAlwaysShowEditor]
    PopupMenu = PopupMenu1
    TabOrder = 0
    OnKeyDown = sgKeyDown
    OnKeyPress = sgKeyPress
    ColWidths = (
      35
      50
      80
      100
      100)
  end
  object def: TTntNiceGrid
    Left = 0
    Top = 0
    Width = 445
    Height = 50
    Align = alTop
    ColCount = 3
    FixedCols = 0
    RowCount = 2
    FixedRows = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected, goColSizing, goEditing, goTabs, goAlwaysShowEditor]
    TabOrder = 1
    OnKeyDown = defKeyDown
    ColWidths = (
      101
      108
      129)
  end
  object TntMemo1: TTntMemo
    Left = 0
    Top = 262
    Width = 445
    Height = 89
    Align = alBottom
    Lines.Strings = (
      'Description:')
    TabOrder = 2
    OnChange = TntMemo1Change
  end
  object PopupMenu1: TPopupMenu
    Left = 144
    Top = 184
    object SorBeszrs1: TMenuItem
      Action = ActionInsertLine
    end
    object SorTrls1: TMenuItem
      Action = ActionDelLine
    end
  end
  object ActionList1: TActionList
    Left = 184
    Top = 184
    object ActionInsertLine: TAction
      Caption = 'Sor Besz'#250'r'#225's'
      ShortCut = 16457
      OnExecute = ActionInsertLineExecute
    end
    object ActionDelLine: TAction
      Caption = 'Sor T'#246'rl'#233's'
      ShortCut = 16460
      OnExecute = ActionDelLineExecute
    end
  end
end
