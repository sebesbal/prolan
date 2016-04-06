object PrefDlg: TPrefDlg
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Options'
  ClientHeight = 438
  ClientWidth = 486
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  DesignSize = (
    486
    438)
  PixelsPerInch = 120
  TextHeight = 16
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 486
    Height = 393
    ActivePage = TabSheet2
    Align = alTop
    OwnerDraw = True
    TabOrder = 3
    OnDrawTab = PageControl1DrawTab
    object Korlatok: TTabSheet
      Caption = 'General'
      ImageIndex = 1
      ExplicitLeft = 8
      ExplicitTop = 32
      object Bevel1: TBevel
        Left = 13
        Top = 96
        Width = 441
        Height = 9
        Shape = bsTopLine
      end
      object GroupBox1: TGroupBox
        Left = 5
        Top = 159
        Width = 470
        Height = 73
        Caption = 'Tree view'
        TabOrder = 0
        object edTreeLim: TLabeledEdit
          Left = 372
          Top = 23
          Width = 79
          Height = 24
          EditLabel.Width = 57
          EditLabel.Height = 16
          EditLabel.Caption = 'Max. size'
          LabelPosition = lpLeft
          TabOrder = 0
        end
      end
      object GroupBox6: TGroupBox
        Left = 3
        Top = 16
        Width = 470
        Height = 137
        Caption = 'List view'
        TabOrder = 1
        object CheckBox1: TCheckBox
          Left = 10
          Top = 52
          Width = 255
          Height = 24
          Caption = 'Avoid exit if there is other choice.'
          TabOrder = 0
        end
        object CheckBox2: TCheckBox
          Left = 10
          Top = 24
          Width = 407
          Height = 18
          Caption = 'Hide the step if there is no choice (hide deterministic steps).'
          TabOrder = 1
        end
        object edAniTime: TLabeledEdit
          Left = 184
          Top = 88
          Width = 81
          Height = 24
          EditLabel.Width = 165
          EditLabel.Height = 16
          EditLabel.Caption = 'Duration of one step (ms):'
          LabelPosition = lpLeft
          TabOrder = 2
        end
        object edListLim: TLabeledEdit
          Left = 368
          Top = 88
          Width = 81
          Height = 24
          EditLabel.Width = 57
          EditLabel.Height = 16
          EditLabel.Caption = 'Max. size'
          LabelPosition = lpLeft
          TabOrder = 3
        end
      end
      object GroupBox2: TGroupBox
        Left = 3
        Top = 238
        Width = 472
        Height = 64
        Caption = 'Language view'
        TabOrder = 2
        object edTime: TLabeledEdit
          Left = 178
          Top = 24
          Width = 89
          Height = 24
          EditLabel.Width = 94
          EditLabel.Height = 16
          EditLabel.Caption = 'Time limit (ms):'
          LabelPosition = lpLeft
          TabOrder = 0
        end
        object edDb: TLabeledEdit
          Left = 372
          Top = 24
          Width = 79
          Height = 24
          EditLabel.Width = 57
          EditLabel.Height = 16
          EditLabel.Caption = 'Max. size'
          LabelPosition = lpLeft
          TabOrder = 1
        end
      end
      object edLength: TLabeledEdit
        Left = 375
        Top = 319
        Width = 77
        Height = 24
        EditLabel.Width = 185
        EditLabel.Height = 16
        EditLabel.Caption = 'Max. lenght of sentential form'
        LabelPosition = lpLeft
        TabOrder = 3
      end
    end
    object TabSheet1: TTabSheet
      Caption = 'Grammars'
      Highlighted = True
      object rgList: TRadioGroup
        Left = 13
        Top = 40
        Width = 144
        Height = 84
        Caption = 'List'
        Items.Strings = (
          'Leftmost'
          'Rightmost'
          'Random')
        TabOrder = 0
      end
      object rgLang: TRadioGroup
        Left = 311
        Top = 40
        Width = 143
        Height = 84
        Caption = 'Language'
        Items.Strings = (
          'Leftmost'
          'Rightmost'
          'All')
        TabOrder = 1
      end
      object rgTree: TRadioGroup
        Left = 163
        Top = 40
        Width = 142
        Height = 84
        Caption = 'Tree'
        Items.Strings = (
          'Leftmost'
          'Rightmost'
          'All')
        TabOrder = 2
      end
      object StaticText1: TStaticText
        Left = 13
        Top = 15
        Width = 140
        Height = 19
        AutoSize = False
        Caption = 'Type of derivation'
        TabOrder = 3
      end
      object StaticText5: TStaticText
        Left = 21
        Top = 145
        Width = 396
        Height = 62
        AutoSize = False
        Caption = 
          'Hint: Language generation is much faster with the Leftmost (or R' +
          'ightmost) option. You can force this setting from code with "#pr' +
          'agma leftmost".'
        TabOrder = 4
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'T-machine, PDA'
      ImageIndex = 3
      ExplicitLeft = 0
      ExplicitTop = 32
      object edDbInput: TLabeledEdit
        Left = 189
        Top = 104
        Width = 114
        Height = 24
        EditLabel.Width = 103
        EditLabel.Height = 16
        EditLabel.Caption = 'Max input length'
        LabelPosition = lpLeft
        TabOrder = 0
      end
      object edKonfp: TLabeledEdit
        Left = 189
        Top = 136
        Width = 114
        Height = 24
        EditLabel.Width = 95
        EditLabel.Height = 16
        EditLabel.Caption = 'Max step count'
        LabelPosition = lpLeft
        TabOrder = 1
      end
      object StaticText4: TStaticText
        Left = 15
        Top = 18
        Width = 422
        Height = 55
        AutoSize = False
        Caption = 
          'For a Turing Machine or PDA the application generates all possib' +
          'le inputs with the chosen maximal length, and tries to accept th' +
          'is input within the chosen maximal step count.'
        TabOrder = 2
      end
    end
    object Konyvt: TTabSheet
      Caption = 'Libraries'
      ImageIndex = 2
      DesignSize = (
        478
        362)
      object ListBox1: TListBox
        Left = 0
        Top = 0
        Width = 473
        Height = 288
        Anchors = [akLeft, akTop, akRight, akBottom]
        ItemHeight = 16
        TabOrder = 0
        OnClick = ListBox1Click
      end
      object Panel3: TPanel
        Left = 0
        Top = 295
        Width = 473
        Height = 27
        Anchors = [akLeft, akRight, akBottom]
        BevelOuter = bvNone
        TabOrder = 1
        DesignSize = (
          473
          27)
        object SpeedButton1: TSpeedButton
          Left = 446
          Top = 1
          Width = 26
          Height = 25
          Anchors = [akTop, akRight]
          Caption = '...'
          OnClick = SpeedButton1Click
        end
        object Edit1: TEdit
          Left = 2
          Top = 2
          Width = 437
          Height = 24
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 0
        end
      end
      object Button4: TButton
        Left = 386
        Top = 328
        Width = 86
        Height = 29
        Anchors = [akTop, akRight]
        Caption = 'Add'
        TabOrder = 2
        OnClick = Button4Click
      end
      object btnDel: TButton
        Left = 294
        Top = 328
        Width = 85
        Height = 29
        Anchors = [akTop, akRight]
        Caption = 'Delete'
        TabOrder = 3
        OnClick = btnDelClick
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Styles'
      ImageIndex = 4
      object GroupBox3: TGroupBox
        Left = 3
        Top = 3
        Width = 470
        Height = 62
        Caption = 'Window'
        TabOrder = 0
        object TntLabel1: TTntLabel
          Left = 128
          Top = 29
          Width = 55
          Height = 16
          Caption = 'S '#8594' Aab'
        end
        object Button5: TButton
          Left = 16
          Top = 22
          Width = 89
          Height = 28
          Caption = 'Font...'
          TabOrder = 0
          OnClick = Button5Click
        end
      end
      object GroupBox4: TGroupBox
        Left = 3
        Top = 72
        Width = 470
        Height = 62
        Caption = 'Editor'
        TabOrder = 1
        object TntLabel2: TTntLabel
          Left = 128
          Top = 29
          Width = 69
          Height = 16
          Caption = 'if (a) Z = a;'
        end
        object Button6: TButton
          Left = 16
          Top = 22
          Width = 89
          Height = 28
          Caption = 'Font...'
          TabOrder = 0
          OnClick = Button6Click
        end
      end
      object GroupBox5: TGroupBox
        Left = 3
        Top = 141
        Width = 470
        Height = 61
        Caption = 'Animation'
        TabOrder = 2
        object TntLabel3: TTntLabel
          Left = 128
          Top = 18
          Width = 157
          Height = 35
          Caption = 'aaaABaaCa'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -30
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Button7: TButton
          Left = 16
          Top = 22
          Width = 89
          Height = 28
          Caption = 'Font...'
          TabOrder = 0
          OnClick = Button7Click
        end
      end
    end
  end
  object Button1: TButton
    Left = 298
    Top = 400
    Width = 86
    Height = 29
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 391
    Top = 400
    Width = 86
    Height = 29
    Anchors = [akRight, akBottom]
    Caption = 'Cancel'
    TabOrder = 1
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 71
    Top = 400
    Width = 86
    Height = 29
    Anchors = [akRight, akBottom]
    Caption = 'Help'
    TabOrder = 0
    Visible = False
  end
  object FileOpenDialog1: TFileOpenDialog
    FavoriteLinks = <>
    FileTypes = <>
    Options = [fdoPickFolders, fdoPathMustExist]
    Left = 336
    Top = 240
  end
  object FontDialog1: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Left = 344
    Top = 144
  end
  object FontDialog2: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Left = 344
    Top = 176
  end
  object FontDialog3: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Left = 344
    Top = 208
  end
end
