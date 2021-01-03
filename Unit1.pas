unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Objects, FMX.Media, FMX.Ani, System.ImageList,
  FMX.ImgList,System.IOUtils;

type
  TForm1 = class(TForm)
    Image1: TImage;
    Button1: TButton;
    MediaPlayer1: TMediaPlayer;
    Rectangle1: TRectangle;
    Label1: TLabel;
    FloatAnimation1: TFloatAnimation;
    Rectangle2: TRectangle;
    Label2: TLabel;
    Label5: TLabel;
    Label3: TLabel;
    Label6: TLabel;
    Label4: TLabel;
    Label7: TLabel;
    Button2: TButton;
    Image2: TImage;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
    blnMuzika:Boolean;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

uses unit2;

procedure TForm1.Button1Click(Sender: TObject);
begin
  form2:=TForm2.Create(nil);
  if Form2.FDConnection1.Connected then
    form2.Show
  else
    FreeAndNil(form2);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  if blnMuzika then
  begin
    MediaPlayer1.Stop;
    blnMuzika:=false;
  end else begin
    MediaPlayer1.Play;
    blnMuzika:=true;
  end;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  MediaPlayer1.FileName:=TPath.Combine(TPath.GetDocumentsPath, 'your eyes.mp3');  { Internal }  
end;

end.
