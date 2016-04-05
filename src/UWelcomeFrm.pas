unit UWelcomeFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UExeFrm, OleCtrls, SHDocVw, UBase;

type
  TWelcomeFrm = class(TExeFrm)
  published
    Web: TWebBrowser;
    procedure Run; override;
    procedure Deselect; override;
    procedure SelectRule(C: TEBasLine); override;
    procedure SaveToFile(S: WideString = ''); override;
    procedure LoadFromFile(S: WideString); override;
    procedure Close; override;
    function SaveDialog: Boolean; override;
  end;

var
  WelcomeFrm: TWelcomeFrm;

implementation

{$R *.dfm}

{ TWelcomeFrm }

procedure TWelcomeFrm.Close;
begin

end;

procedure TWelcomeFrm.Deselect;
begin

end;

procedure TWelcomeFrm.LoadFromFile(S: WideString);
begin

end;

procedure TWelcomeFrm.Run;
begin

end;

function TWelcomeFrm.SaveDialog: Boolean;
begin

end;

procedure TWelcomeFrm.SaveToFile(S: WideString);
begin

end;

procedure TWelcomeFrm.SelectRule(C: TEBasLine);
begin

end;

end.
