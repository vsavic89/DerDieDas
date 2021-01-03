unit Unit2;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.FMXUI.Wait, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FMX.Media,
  System.IOUtils, FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteDef,
  FireDAC.Comp.UI, FireDAC.Phys.SQLite, System.ImageList, FMX.ImgList;

type
  TForm2 = class(TForm)
    GroupBox1: TGroupBox;
    Button1: TButton;
    RoundRect1: TRoundRect;
    Button5: TButton;
    Button4: TButton;
    Button3: TButton;
    Button2: TButton;
    Rectangle1: TRectangle;
    Rectangle2: TRectangle;
    Label1: TLabel;
    Rectangle3: TRectangle;
    Label2: TLabel;
    Rectangle4: TRectangle;
    Text1: TText;
    Label3: TLabel;
    FDConnection1: TFDConnection;
    FDQuery1: TFDQuery;
    MediaPlayer1: TMediaPlayer;
    Timer1: TTimer;
    FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    lblPrevod: TLabel;
    Button6: TButton;
    Image1: TImage;
    Image2: TImage;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
  private
    { Private declarations }
    intUkupnoReci,intBrPitanja,intBrTacnihOdgovora:integer;
    dblUspesnost:double;
    strRec:string;
    blnMute:Boolean;
    procedure UzmiRec();
    procedure Izracunaj(strClan:string);
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.fmx}

uses math;

procedure Tform2.UzmiRec();
var i:integer;
begin
  i := RandomRange(1,intUkupnoReci);
  with FDQuery1 do
  begin
    close;
    sql.Clear;
    sql.Add('select rec from reci where id=:I');
    ParamByName('I').Value := i;
    Open();
  end;
  if FDQuery1.RecordCount>0 then
  begin
    Text1.Text := FDQuery1.FieldByName('rec').AsString;
    strRec := FDQuery1.FieldByName('rec').AsString;
  end;
end;

procedure TForm2.Button1Click(Sender: TObject);
begin
  close;
end;

procedure TForm2.Button2Click(Sender: TObject);
begin
    lblPrevod.Text := EmptyStr;
    label2.Text := 'Skor: 0/0 (0%)';
    intBrPitanja:=0;
    intBrTacnihOdgovora:=0;
    UzmiRec;
end;

procedure TForm2.Button3Click(Sender: TObject);
begin
  Izracunaj('der');
end;

procedure TForm2.Button4Click(Sender: TObject);
begin
  Izracunaj('das');
end;

procedure TForm2.Button5Click(Sender: TObject);
begin
  Izracunaj('die');
end;

procedure TForm2.Button6Click(Sender: TObject);
begin
  if blnMute then
  begin
    blnMute:=false;
    Image2.Visible:=false;
    Image1.Visible:=true;    
  end else begin
    blnMute := true;
    Image1.Visible:=false;
    Image2.Visible:=true;    
  end;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  blnMute:=false;
  FDConnection1.DriverName := 'SQLite';
  FDConnection1.Params.Add('StringFormat=Unicode');
  FDConnection1.Params.Add('Database='+TPath.Combine(TPath.GetDocumentsPath, 'reci.db'));  { Internal }
  try
    FDConnection1.Connected:=true;
  except on E:Exception do
    ShowMessage('Ne mogu da se konektujem na bazu podataka!'+#13+#10+e.Message);
  end;
end;

procedure TForm2.FormShow(Sender: TObject);
begin
  intBrPitanja:=0;
  intBrTacnihOdgovora:=0;
  dblUspesnost:=0;
  with FDQuery1 do
  begin
    close;
    sql.Clear;
    sql.Add('select count(*) BS from reci');
    Open();
  end;
  Label1.Text := 'Ukupno imenica: '+FDQuery1.FieldByName('BS').AsString;
  intUkupnoReci:=FDQuery1.FieldByName('BS').AsInteger;
  label2.Text := 'Skor: 0/0 (0%)';
  UzmiRec();
end;

procedure TForm2.Izracunaj(strClan:string);
var i:integer;
begin
  Button3.Enabled := false;
  button4.Enabled := false;
  button5.Enabled := false;
  with FDQuery1 do
  begin
    close;
    sql.Clear;
    sql.Add('select * from reci where trim(clan)=="'+strclan+'" and trim(rec)="'+Text1.Text+'"');
    Open();
  end;
  if FDQuery1.RecordCount>0 then
  begin
    Text1.Text := strClan+' '+Text1.Text;
    lblPrevod.Text := 'превод: '+FDQuery1.FieldByName('srpski').AsWideString;
    intBrTacnihOdgovora:=intBrTacnihOdgovora+1;
    Label3.Text := 'TAČAN ODGOVOR!';
    label3.TextSettings.FontColor := TAlphaColorRec.Blue;
    if not blnMute then
    begin
      i:=RandomRange(1,15);
      MediaPlayer1.FileName:=TPath.Combine(TPath.GetDocumentsPath, inttostr(i)+'.mp3');  { Internal }
      MediaPlayer1.Play;
    end;
  end else begin
    Label3.Text := 'NETAČAN ODGOVOR!';
    label3.TextSettings.FontColor := TAlphaColorRec.Red;
    if not blnMute then
    begin
      i:=RandomRange(100,113);
      MediaPlayer1.FileName:=TPath.Combine(TPath.GetDocumentsPath, inttostr(i)+'.mp3');  { Internal }
      MediaPlayer1.Play;
    end;
  end;
  intBrPitanja:=intBrPitanja+1;
  dblUspesnost := roundto((intBrTacnihOdgovora/intBrPitanja)*100,-2);
  label2.Text := 'Skor: '+IntToStr(intBrTacnihOdgovora)+'/'+inttostr(intBrPitanja)+' ('+floattostr(dbluspesnost)+'%)';
  Application.ProcessMessages;  
  if (intBrTacnihOdgovora = 10) and (intBrPitanja = 10) then
    ShowMessage('Gut gemacht!'+#13#10+'Liebe Jelena I., '+#13#10+'möchtest du mit mir nach dem Deutschkurs ins Cafe gehen? '+#13#10+'Dort können wir einen Kaffee trinken und viel sprechen. Was denkst du? :)');
  Sleep(3000);
  UzmiRec;
  Button3.Enabled := true;
  button4.Enabled := true;
  button5.Enabled := true;
  Label3.Text := EmptyStr;
  lblPrevod.Text := EmptyStr;
end;

procedure TForm2.Timer1Timer(Sender: TObject);
begin
  timer1.Enabled:=false;  
end;

end.
