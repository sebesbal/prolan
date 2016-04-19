object CardForm: TCardForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'About Prolan'
  ClientHeight = 131
  ClientWidth = 294
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    294
    131)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 18
    Top = 100
    Width = 99
    Height = 17
    Cursor = crHandPoint
    Anchors = [akLeft, akBottom]
    Caption = 'sebesbal@gmail.com'
    Color = clBlue
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsUnderline]
    ParentColor = False
    ParentFont = False
    OnClick = Label1Click
    ExplicitTop = 143
  end
  object Memo1: TMemo
    Left = 8
    Top = 8
    Width = 274
    Height = 81
    BevelInner = bvNone
    BevelOuter = bvNone
    BorderStyle = bsNone
    Lines.Strings = (
      'Check out the examples and tutorials in the sample '
      'folder! To use Prolan without coding open '
      '"Form - ..." files.'
      ''
      'Created by Sebesty'#233'n Bal'#225'zs'
      'ELTE IK, 2010. Budapest')
    ReadOnly = True
    TabOrder = 1
  end
  object Button1: TButton
    Left = 213
    Top = 99
    Width = 75
    Height = 26
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    TabOrder = 0
    OnClick = Button1Click
    ExplicitTop = 37
  end
end
