object CardForm: TCardForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'About Prolan'
  ClientHeight = 90
  ClientWidth = 384
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    384
    90)
  PixelsPerInch = 120
  TextHeight = 17
  object Label1: TLabel
    Left = 24
    Top = 55
    Width = 136
    Height = 18
    Cursor = crHandPoint
    Caption = 'sebesbal@gmail.com'
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
    Width = 359
    Height = 39
    BevelInner = bvNone
    BevelOuter = bvNone
    BorderStyle = bsNone
    Lines.Strings = (
      'Created by Sebesty'#233'n Bal'#225'zs'
      'ELTE IK, 2010. Budapest')
    ReadOnly = True
    TabOrder = 1
  end
  object Button1: TButton
    Left = 278
    Top = 49
    Width = 98
    Height = 33
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    TabOrder = 0
    OnClick = Button1Click
    ExplicitTop = 274
  end
end
