unit TestAnimate;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Buttons, StdCtrls;

type
  TForm1 = class(TForm)
    Timer1: TTimer;
    SpeedButton1: TSpeedButton;
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation
uses
  UAniString;

{$R *.dfm}

procedure TForm1.SpeedButton1Click(Sender: TObject);
var
  L: TLanAnimation;
//  S: TAniString;
begin
//  S := TAniString.Create;
//  S.Canvas := Canvas;
//  S.Font.Assign(Canvas.Font);
//  S.StartPos := Point(0,0);
//  S.EndPos := Point(100, 100);
//  S.StartColor := clBlack;
//  S.EndColor := clRed;
//  S.Text := 'A';
//  S.StartTimer;

  L := TLanAnimation.Create(Self);
  L.Parent := Self;
  L.Top := 0;
  L.Left := 0;
  L.Width := 200;
  L.Height := 200;
  L.Text := 'almabanankorte';
  L.First := 5;
  L.Last := 9;
  L.NewString := 'citrom';
  L.Interval := 10;
  L.Time := 800;
  L.Font.Size := 12;
  L.Color := clWhite;
  L.Start;
end;

end.
