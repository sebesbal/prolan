object PrefDlg: TPrefDlg
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Be'#225'll'#237't'#225'sok'
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
    ActivePage = Korlatok
    Align = alTop
    OwnerDraw = True
    TabOrder = 3
    OnDrawTab = PageControl1DrawTab
    object Korlatok: TTabSheet
      Caption = #193'ltal'#225'nos'
      ImageIndex = 1
      object Bevel1: TBevel
        Left = 13
        Top = 88
        Width = 441
        Height = 9
        Shape = bsTopLine
      end
      object StaticText3: TStaticText
        Left = 18
        Top = 39
        Width = 441
        Height = 35
        AutoSize = False
        Caption = 
          'A lista n'#233'zetben elrejti a determinisztikus l'#233'p'#233'seket. Csak az e' +
          'ls'#337' '#233's utols'#243' l'#233'p'#233's marad meg, valamint azok, melyekben van v'#225'la' +
          'szt'#225'si lehet'#337's'#233'g.'
        TabOrder = 0
      end
      object CheckBox2: TCheckBox
        Left = 18
        Top = 13
        Width = 217
        Height = 13
        Caption = 'Determinisztikus l'#233'p'#233'sek elrejt'#233'se'
        TabOrder = 1
      end
      object GroupBox1: TGroupBox
        Left = 3
        Top = 144
        Width = 470
        Height = 213
        Caption = 'Fels'#337' korl'#225'tok'
        TabOrder = 2
        object GroupBox2: TGroupBox
          Left = 15
          Top = 126
          Width = 441
          Height = 64
          Caption = 'Nyelv n'#233'zet'
          TabOrder = 0
          object edTime: TLabeledEdit
            Left = 88
            Top = 24
            Width = 114
            Height = 24
            EditLabel.Width = 79
            EditLabel.Height = 16
            EditLabel.Caption = 'Id'#337'limit (ms):'
            LabelPosition = lpLeft
            TabOrder = 0
          end
          object edDb: TLabeledEdit
            Left = 307
            Top = 24
            Width = 115
            Height = 24
            EditLabel.Width = 90
            EditLabel.Height = 16
            EditLabel.Caption = 'Tal'#225'latok (db):'
            LabelPosition = lpLeft
            TabOrder = 1
          end
        end
        object edLength: TLabeledEdit
          Left = 322
          Top = 31
          Width = 115
          Height = 24
          EditLabel.Width = 294
          EditLabel.Height = 16
          EditLabel.Caption = 'Mondatforma, verem, szalag maxim'#225'lis hossza:'
          LabelPosition = lpLeft
          TabOrder = 1
        end
        object edListLim: TLabeledEdit
          Left = 322
          Top = 63
          Width = 115
          Height = 24
          EditLabel.Width = 176
          EditLabel.Height = 16
          EditLabel.Caption = 'Lista n'#233'zet, l'#233'p'#233'ssz'#225'm (db):'
          LabelPosition = lpLeft
          TabOrder = 2
        end
        object edTreeLim: TLabeledEdit
          Left = 322
          Top = 95
          Width = 115
          Height = 24
          EditLabel.Width = 159
          EditLabel.Height = 16
          EditLabel.Caption = 'Fa n'#233'zet, elemsz'#225'm (db):'
          LabelPosition = lpLeft
          TabOrder = 3
        end
      end
      object edAniTime: TLabeledEdit
        Left = 326
        Top = 112
        Width = 114
        Height = 24
        EditLabel.Width = 230
        EditLabel.Height = 16
        EditLabel.Caption = 'Anim'#225'c'#243', egy l'#233'p'#233's id'#337'tartama (ms):'
        LabelPosition = lpLeft
        TabOrder = 3
      end
    end
    object TabSheet1: TTabSheet
      Caption = 'Programozott nyelvtan'
      Highlighted = True
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Bevel2: TBevel
        Left = 13
        Top = 215
        Width = 441
        Height = 9
        Shape = bsTopLine
      end
      object CheckBox1: TCheckBox
        Left = 13
        Top = 224
        Width = 144
        Height = 19
        Caption = 'Zs'#225'kutc'#225'k elker'#252'l'#233'se'
        TabOrder = 0
      end
      object rgList: TRadioGroup
        Left = 13
        Top = 90
        Width = 217
        Height = 44
        Caption = 'Lista'
        Columns = 3
        Items.Strings = (
          'Legbal'
          'Legjobb'
          'V'#233'letlen')
        TabOrder = 1
      end
      object rgLang: TRadioGroup
        Left = 237
        Top = 40
        Width = 217
        Height = 43
        Caption = 'Nyelv'
        Columns = 3
        Items.Strings = (
          'Legbal'
          'Legjobb'
          'Mind')
        TabOrder = 2
      end
      object rgTree: TRadioGroup
        Left = 13
        Top = 40
        Width = 217
        Height = 43
        Caption = 'Fa'
        Columns = 3
        Items.Strings = (
          'Legbal'
          'Legjobb'
          'Mind')
        TabOrder = 3
      end
      object StaticText1: TStaticText
        Left = 13
        Top = 15
        Width = 441
        Height = 19
        AutoSize = False
        Caption = 'Nyelvtani szab'#225'ly bal oldal'#225't melyik poz'#237'ci'#243'ra illessze?'
        TabOrder = 4
      end
      object StaticText2: TStaticText
        Left = 13
        Top = 250
        Width = 441
        Height = 39
        AutoSize = False
        Caption = 
          'Elker'#252'li azokat a konfigur'#225'ci'#243'kat, melyekb'#337'l egyetlen l'#233'p'#233's tehe' +
          't'#337', '#233's az elutas'#237't'#243' '#225'llapotba vezet.'
        TabOrder = 5
      end
      object StaticText5: TStaticText
        Left = 13
        Top = 145
        Width = 441
        Height = 62
        AutoSize = False
        Caption = 
          'Tipp: A Nyelv n'#233'zetben a Legbal (ill. Legjobb) opci'#243' haszn'#225'lat'#225'v' +
          'al jelent'#337's teljes'#237'tm'#233'nyn'#246'veked'#233's '#233'rhet'#337' el.'#13#10'Ezt megadhatjuk pl' +
          '. a #pragma leftmost utas'#237't'#225'ssal is.'
        TabOrder = 6
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'T-g'#233'p, VA'
      ImageIndex = 3
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object edDbInput: TLabeledEdit
        Left = 189
        Top = 104
        Width = 114
        Height = 22
        EditLabel.Width = 108
        EditLabel.Height = 16
        EditLabel.Caption = 'Bemenet hossza:'
        LabelPosition = lpLeft
        TabOrder = 0
      end
      object edKonfp: TLabeledEdit
        Left = 189
        Top = 136
        Width = 114
        Height = 22
        EditLabel.Width = 180
        EditLabel.Height = 16
        EditLabel.Caption = 'Konfigur'#225'ci'#243' / bemenet (db):'
        LabelPosition = lpLeft
        TabOrder = 1
      end
      object StaticText4: TStaticText
        Left = 15
        Top = 18
        Width = 422
        Height = 79
        AutoSize = False
        Caption = 
          'T-g'#233'p '#233's veremautomata eset'#233'n a program k'#252'l'#246'nb'#246'z'#337' bemenetekre fu' +
          'ttatja le az automat'#225't, '#233's vizsg'#225'lja hogy termin'#225'l-e. Al'#225'bb mega' +
          'dhat'#243' a vizsg'#225'lt bemenetek maxim'#225'lis hossza (_-t'#243'l k'#252'l'#246'nb'#246'z'#337' kar' +
          'akterek sz'#225'ma), valamint hogy egy bemenetre legfeljebb h'#225'ny konf' +
          'igur'#225'ci'#243't vizsg'#225'ljon:'
        TabOrder = 2
      end
    end
    object Konyvt: TTabSheet
      Caption = 'K'#246'nyvt'#225'rak'
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      DesignSize = (
        478
        362)
      object ListBox1: TListBox
        Left = 0
        Top = 0
        Width = 473
        Height = 288
        Anchors = [akLeft, akTop, akRight, akBottom]
        ItemHeight = 14
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
          Height = 22
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
      Caption = 'St'#237'lusok'
      ImageIndex = 4
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object GroupBox3: TGroupBox
        Left = 3
        Top = 3
        Width = 470
        Height = 62
        Caption = 'Ablak'
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
          Caption = 'Bet'#369't'#237'pus...'
          TabOrder = 0
          OnClick = Button5Click
        end
      end
      object GroupBox4: TGroupBox
        Left = 3
        Top = 72
        Width = 470
        Height = 62
        Caption = 'K'#243'dszerkeszt'#337
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
          Caption = 'Bet'#369't'#237'pus...'
          TabOrder = 0
          OnClick = Button6Click
        end
      end
      object GroupBox5: TGroupBox
        Left = 3
        Top = 141
        Width = 470
        Height = 61
        Caption = 'Anim'#225'ci'#243
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
          Caption = 'Bet'#369't'#237'pus...'
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
