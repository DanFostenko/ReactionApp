unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.StdCtrls, DateUtils,
  Vcl.Imaging.pngimage;

type
  TForm1 = class(TForm)
    edt1: TEdit;
    btn1: TButton;
    btn2: TButton;
    trckbr1: TTrackBar;
    img1: TImage;
    img2: TImage;
    procedure btn1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure trckbr1Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  timeStart, timeFinish, timeFinishCalibr: TDateTime;
  pxlStart,pxlFinish: Integer;
  delay: Byte;

implementation

{$R *.dfm}

procedure TForm1.btn1Click(Sender: TObject);
var i: Integer;
begin
  pxlStart := 28+28;
  pxlFinish := 480+84;
  if btn1.Caption = 'Start' then
    begin
      btn1.Caption := 'Stop';
      timeStart:= Now;
      for i := pxlStart to pxlFinish do
      begin
        img2.Left := i;
        Sleep(delay);
        Application.ProcessMessages;
        if btn1.Caption = 'Start' then
        begin
          timeFinish := DateUtils.MilliSecondsBetween(Now,timeStart);
          Break;
        end;
      end;
      edt1.Text:=IntToStr(i - 301-55)+ ' pxls;'+ FloatToStr(timeFinish)+ ' ms;'+ FloatToStr(timeFinish - timeFinishCalibr)+ ' ms';
    end
    else
      btn1.Caption := 'Start';
end;

procedure TForm1.FormActivate(Sender: TObject);
var i: Integer;
begin
  delay := 11 - trckbr1.Position;
  btn1.Enabled := False;
  edt1.Text := 'Calibration in progress';
  pxlStart := 28+28;
  pxlFinish := 300+55;
  timeStart := Now;
  for i := pxlStart to pxlFinish do
  begin
    img2.Left := i;
    Sleep(delay);
    Application.ProcessMessages;
    if btn1.Caption = 'Start' then
    begin
      // do nothing
    end;
    timeFinishCalibr := DateUtils.MilliSecondsBetween(Now,timeStart);
  end;
  edt1.Text := 'Calibration done';
  edt1.Text :=IntToStr(i - 301-55)+ ' points;'+ FloatToStr(timeFinishCalibr)+ ' ms';
  btn1.Enabled := True;
  img2.Left:= pxlStart;
  Application.ProcessMessages;
end;

procedure TForm1.trckbr1Change(Sender: TObject);
begin
btn1.Enabled := False;
delay := (11 - trckbr1.Position)*10;
edt1.Text := 'Speed=' + IntToStr(trckbr1.Position) + '.Calibrate plz';
end;

end.

