unit UPlFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, TntComCtrls, UBase, UExeFrm, UGrammar, StdCtrls, TntStdCtrls;

type
  TPlFrm = class(TFrame)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TntMemo1: TTntMemo;
    procedure ListView1SelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
  private
    FMode: TProgType;
    FOnChanged: TNotifyEvent;
    FLine: TEBasLine;
    procedure SetOnChanged(const Value: TNotifyEvent);
  public
    FAdvFrame: TExeFrm;
    property OnChanged: TNotifyEvent read FOnChanged write SetOnChanged;
    procedure SelectMode(M: TProgType);
    procedure Clear;
    property Line: TEBasLine read FLine;
    procedure Select(C: TEBasLine);
  published
    ListView1: TTntListView;
  end;

implementation

uses UMainForm;

{$R *.dfm}

procedure TPlFrm.Clear;
begin
  ListView1.Clear;
end;

procedure TPlFrm.ListView1SelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  if ListView1.Selected = nil then
    FLine := nil
  else
    FLine := TEBasLine(ListView1.Selected.Data);
  FOnChanged(Self);
end;

procedure TPlFrm.Select(C: TEBasLine);
var
  I: Integer;
  D: TEBasLine;
begin
  if C = nil then
    ListView1.Selected := nil
  else
    for I := 0 to ListView1.Items.Count - 1 do
    begin
      D := TEBasLine(ListView1.Items[I].Data);
      if (D <> nil) and (C = D) then
      begin
        ListView1.Selected := ListView1.Items[I];
        exit;
      end;
    end;
end;

procedure TPlFrm.SelectMode(M: TProgType);
const
  d = 50;
begin
  if FMode = M then
    exit;

  FMode := M;
  case M of
    ptGrammar:
    begin
      TabSheet1.Caption := 'Programmed Grammar';
      ListView1.Columns.Clear;
      with ListView1.Columns.Add do
      begin
        Caption := 'ID';
        Width := 30;
      end;
      with ListView1.Columns.Add do
      begin
        Caption := 'Rule';
        Width := 100;
      end;
      with ListView1.Columns.Add do
      begin
        Caption := gsig;
        Width := 80;
      end;
      with ListView1.Columns.Add do
      begin
        Caption := gfi;
        Width := 80;
      end;
    end;
    
    ptTuring:
    begin
      TabSheet1.Caption := 'Turing Machine';
      ListView1.Columns.Clear;
      with ListView1.Columns.Add do
      begin
        Caption := 'State';
        Width := d;
      end;
      with ListView1.Columns.Add do
      begin
        Caption := 'Read';
        Width := d;
      end;
      with ListView1.Columns.Add do
      begin
        Caption := 'Write';
        Width := d;
      end;
      with ListView1.Columns.Add do
      begin
        Caption := 'Step';
        Width := d;
      end;
      with ListView1.Columns.Add do
      begin
        Caption := 'New State';
        Width := d;
      end;
    end;
    ptPushDown, ptEPushDown:
    begin
      TabSheet1.Caption := 'PDA';
      ListView1.Columns.Clear;
      with ListView1.Columns.Add do
      begin
        Caption := 'State';
        Width := d;
      end;
      with ListView1.Columns.Add do
      begin
        Caption := 'Read';
        Width := d;
      end;
      with ListView1.Columns.Add do
      begin
        Caption := 'Pop';
        Width := d;
      end;
      with ListView1.Columns.Add do
      begin
        Caption := 'Push';
        Width := d;
      end;
      with ListView1.Columns.Add do
      begin
        Caption := 'New State';
        Width := d;
      end;
    end;
  end;
end;

procedure TPlFrm.SetOnChanged(const Value: TNotifyEvent);
begin
  FOnChanged := Value;
end;

end.

