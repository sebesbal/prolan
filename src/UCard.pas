unit UCard;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TCardForm = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    Label1: TLabel;
    procedure Label1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CardForm: TCardForm;

implementation
  uses SHELLAPI;

{$R *.dfm}

procedure TCardForm.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure TCardForm.Label1Click(Sender: TObject);
begin
  ShellExecute(Application.Handle,
             PChar('open'),
             PChar('mailto:prolan.elte@gmail.com'),
             PChar(0),
             nil,
             SW_NORMAL);
end;

end.
