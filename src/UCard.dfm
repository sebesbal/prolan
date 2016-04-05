object CardForm: TCardForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'N'#233'vjegy'
  ClientHeight = 98
  ClientWidth = 311
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    311
    98)
  PixelsPerInch = 120
  TextHeight = 17
  object Label1: TLabel
    Left = 21
    Top = 61
    Width = 161
    Height = 18
    Cursor = crHandPoint
    Caption = 'bsebestyen@freemail.hu'
    Color = clBlue
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = [fsUnderline]
    ParentColor = False
    ParentFont = False
    OnClick = Label1Click
  end
  object Memo1: TMemo
    Left = 10
    Top = 10
    Width = 232
    Height = 44
    BevelInner = bvNone
    BevelOuter = bvNone
    BorderStyle = bsNone
    Lines.Strings = (
      'K'#233'sz'#237'tette: Sebesty'#233'n Bal'#225'zs'
      'ELTE IK, 2010. Budapest')
    ReadOnly = True
    TabOrder = 1
  end
  object Button1: TButton
    Left = 203
    Top = 55
    Width = 98
    Height = 33
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    TabOrder = 0
    OnClick = Button1Click
  end
end
