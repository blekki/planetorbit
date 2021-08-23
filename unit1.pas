unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Menus, ComCtrls, crt;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    GroupBox1: TGroupBox;
    Image1: TImage;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    PageControl1: TPageControl;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioGroup1: TRadioGroup;
    Start: TButton;
    PaintTimer1: TTimer;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TrackBar2: TTrackBar;
    procedure Edit1Change(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure FormClick(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
    procedure PaintTimer1StartTimer(Sender: TObject);

    procedure RadioButton1Change(Sender: TObject);
    procedure RadioButton2Change(Sender: TObject);
    procedure RadioButton3Change(Sender: TObject);

    procedure StartClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PaintTimer1Timer(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure TrackBar2Change(Sender: TObject);
  private

  public

  end;

  //об'єкт планета
  planet = object
    x : real;
    y : real;
    Mass : real;
    Grad : real; //Градусна міра
    vx, vy : real;
    Radius : real;
  end;
  pplanet = ^planet;

  //обю'єкт зірка
  stars = object
    x : integer;
    y : integer;
    Mass : extended;
    Light : extended;
    Radius : extended;
    Temperature : integer;
  end;
  pstars = ^stars;



const
     SM : extended = 1.98855e30;
     SL : extended = 3.846e26;
     SR : longint = 696342;
     ST : integer = 5778;

     StarXY : integer = 200;

     //T : real = 0.1; // 1 second
     T : real = 3600;   //секунда T := 1;

     a : byte = 200;
     b : byte = 200;


var

  Form1: TForm1;

  oldX, oldY : integer;
  Pl : array[1..3] of planet;
  Star : Stars;

  TimeControl : Byte;
  Pos : byte;

  TimeTik : byte;
  speed : byte;

implementation
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
{$R *.lfm}
{ TForm1 }


procedure TForm1.TrackBar2Change(Sender: TObject);
begin
    Pos := TrackBar2.Position;
end;


function Magni(Num : byte): integer;     //Magnification
var Sum : integer;
begin
     Sum := Num + pos;
     if Sum < 10 then
        Sum := 5;

     magni := Sum
end;

function move(Num : real; St : real): real;
var Sum : real;
begin
     if Num < 0 then
       Sum := Num - (10 * Pos)
     else Sum := Num + (10 * Pos);

     Num := Num + St;
     move := Sum;
end;

procedure PlanetOrbit(Pl: pplanet);
var F : extended;
    G: Extended;
    dx, dy : real;
    a : extended;
    ax, ay : real;
    r : extended;

    x,y: Real;

    i : byte;

    moveX, moveY : real;
begin
     for i := 1 to 24 do begin

     x := Pl^.x * 1e9;   //це в метрах
     y := Pl^.y * 1e9;

     dx := -x;
     dy := -y;

     G := 6.67e-11;

     r :=( sqrt(sqr(dx)+sqr(dy)) );// * 10000000 ;
     //F := (G * (Star.Mass * Pl^.Mass) / sqr(r/1.98855e30));
     F := G * ((1.98855e30 * (Pl^.Mass * 1.98855e30)) / sqr(r));
     a := F / (Pl^.Mass * 1.98855e30); //(Star.Mass * 1.98855e30);

     ax := (a * dx / r); // / 10e9;
     ay := (a * dy / r); // / 10e9;

     Pl^.vx := Pl^.vx + ax * T;
     Pl^.vy := Pl^.vy + ay * T;

     x := x + Pl^.vx * T;
     y := y + Pl^.vy * T;

     Pl^.x := x / 1e9;
     Pl^.y := y / 1e9;

     end;
    // Form1.Canvas.Clear;

        //The Sun
         with Form1.Canvas do begin
           Ellipse(Star.x - Magni(5), Star.y - Magni(5), Star.x + Magni(5), Star.y + Magni(5));
         end;

        x := Pl^.x;// + Star.x; //Round(r * cos(Grad)) + 200;
        y := Pl^.y;// + Star.y; //Round(r * sin(Grad)) + 200;

        moveX := x * Pos + Star.x;
        moveY := y * Pos + Star.y;

        //moveX := Pl^.x * Pos + Star.x;
        //moveY := Pl^.y * Pos + Star.y;

          with Form1.Canvas do begin
            //Ellipse(Round(x-2), Round(y-2), Round(x + 2), Round(y + 2));
            Ellipse(Round(moveX-2), Round(moveY-2), Round(moveX + 2), Round(moveY + 2));
          end;

          //Pl.Grad := Pl[i].Grad + 0.01;
          //if Pl[i].Grad >= 360 then
          //Pl[i].Grad := 0.01;
end;


procedure TForm1.FormCreate(Sender: TObject);
begin
     TimeTik := 0;
     speed := 20;
     pos := 1;

    //Pl[1].r := 30;
     Pl[1].Grad := 0.01;
     Pl[1].x := 0;
     Pl[1].y := -150;
     Pl[1].vx := 30000; // 0.000029785;
     //Pl[1].vx := 0.0017871;
     Pl[1].vy := 0;
     //Pl[1].Mass := 1;
     Pl[1].Mass := 0.0000030040482; //в даний момент це маса порівняно з сонцем //* 5.9737e24;
     //Pl[1].Radius := 6371.3; //metr

     Pl[2].Grad := 0.01;
     Pl[2].x := 0;
     Pl[2].y := -98;
     Pl[2].vx := 35000;
     Pl[2].vy := 0;
     Pl[2].Mass := 0.000002403;

     Pl[3].Grad := 0.01;
     Pl[3].x := 0;
     Pl[3].y := -43;
     Pl[3].vx := 56000;
     Pl[3].vy := 0;
     Pl[3].Mass := 0.000000030040482;
end;

procedure TForm1.FormClick(Sender: TObject);
var MyMouse : TMouse;
begin
    Form1.Caption := IntToStr(MyMouse.CursorPos.x) + ' x '+ IntToStr(MyMouse.CursorPos.y);
end;


//Timers
procedure TForm1.PaintTimer1Timer(Sender: TObject);
var i : byte;
begin
     TimeTik := TimeTik + 1;

     if TimeTik = speed then begin
       for i := 1 to 3 do begin
           PlanetOrbit(@Pl[i]);
       end;
     end;

     if TimeTik = speed then
     TimeTik := 0;

end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin

end;

procedure TForm1.PaintTimer1StartTimer(Sender: TObject);
var i : byte;
begin
    for i := 1 to 3 do begin
         PlanetOrbit(@Pl[i]);
     end;
end;

///
procedure TForm1.RadioButton1Change(Sender: TObject);
begin
     speed := 20;
     TimeTik := 0;
end;

procedure TForm1.RadioButton2Change(Sender: TObject);
begin
     speed := 10;
     TimeTik := 0;
end;

procedure TForm1.RadioButton3Change(Sender: TObject);
begin
     speed := 4;
     TimeTik := 0;
end;
///


//EditChange
procedure TForm1.Edit1Change(Sender: TObject);
var M : extended;
begin
    M := StrToFloat(Edit1.Text);
    Star.Mass := M;// * 1.98855e30;

end;

procedure TForm1.Edit2Change(Sender: TObject);
begin
    Star.Temperature := StrToInt(Edit2.Text);
end;


//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

//Button
procedure TForm1.StartClick(Sender: TObject);
var SunMass : extended;
    SunLight : extended;
    SunRadius : extended;
begin
    Star.x := 200;
    Star.y := 200;

     SunMass := SM / SM;
     SunLight := SL / SL;

     Star.Mass := StrToFloat (Edit1.Text);
     Star.Light := (SunLight * sqr(sqr(Star.Mass))) / sqr(sqr(SunMass));

     //створення білого фону
     with form1.Canvas do begin
      brush.Color:=clwhite;
      FillRect(0,0,500,500);
     end;


     SunRadius := SR / SR;
     Star.Radius := (SunRadius * (sqrt(Star.Light) * sqr(6000))) / (sqrt(SunLight) * sqr(Star.Temperature));


       //PaintTimer1.Enabled := false;
       PaintTimer1.Enabled := true;
       //Form1.Invalidate;
       //PlanetOrbit;
end;


procedure TForm1.MenuItem3Click(Sender: TObject);
begin
    PaintTimer1.Enabled := false;
end;

procedure TForm1.MenuItem4Click(Sender: TObject);
begin
    PaintTimer1.Enabled := true;
end;

procedure TForm1.MenuItem6Click(Sender: TObject);
begin
    close;
end;




end.

