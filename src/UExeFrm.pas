unit UExeFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TntForms, UBase;

type
  TExeFrm = class(TFrame)
  protected
    FFileName: WideString;
    FCaption: WideString;
    FEProgram: TEProgram;
    procedure SetCaption(const Value: WideString); virtual;
    procedure SetEProgram(const Value: TEProgram); virtual;
    procedure SetFileName(const Value: WideString); virtual;
    function GetModified: Boolean; virtual;
    procedure SetModified(const Value: Boolean); virtual;
  published
    procedure Clear; virtual; abstract;
    procedure RefreshFont; virtual;
    procedure Run; virtual; abstract;
    procedure Deselect; virtual; abstract;
    procedure SelectRule(C: TEBasLine); virtual; abstract;
    procedure SaveToFile(S: WideString = ''); virtual; abstract;
    procedure LoadFromFile(S: WideString); virtual; abstract;
    procedure Close; virtual; abstract;
    property Modified: Boolean read GetModified write SetModified;
    function SaveDialog: Boolean; virtual; abstract;
    property EProgram: TEProgram read FEProgram write SetEProgram;
    property FileName: WideString read FFileName write SetFileName;
    property Caption: WideString read FCaption write SetCaption;
  end;

var
  ExeFrm: TExeFrm;

implementation

{$R *.DFM}

function TExeFrm.GetModified: Boolean;
begin

end;

procedure TExeFrm.RefreshFont;
begin

end;

procedure TExeFrm.SetCaption(const Value: WideString);
begin
  FCaption := Value;
end;

procedure TExeFrm.SetEProgram(const Value: TEProgram);
begin
  FEProgram := Value;
end;

procedure TExeFrm.SetFileName(const Value: WideString);
begin
  FFileName := Value;
end;

procedure TExeFrm.SetModified(const Value: Boolean);
begin

end;

end.