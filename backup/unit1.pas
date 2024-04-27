unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  LCLtype, StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    img: TImage;
    Label1: TLabel;
    Label2: TLabel;
    score: TLabel;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Label2Click(Sender: TObject);
    procedure scoreClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    food, direction: TPoint;
    snake: array of TPoint;
    oppositeKey : Word ;
    poin : integer;
    procedure ResetFood;
    procedure SetPixel(x, y: integer; pixelcolor: TColor);
  public

  end;

const
  SizeX = 20;
  SizeY = 15;
  DrawNicerSnake = true;

var
  Form1: TForm1;
  BackColor, SnakeColor, FoodColor: TColor;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  Randomize;

  BackColor:=rgbToColor(50, 50, 100);
  FoodColor:=rgbToColor(255, 0, 0);
  SnakeColor:=rgbToColor(255, 255, 255);

  setlength(snake, 1);
  snake[0]:=point(SizeX div 2, SizeY div 2);
  direction:=point(1, 0);
  with img.Picture.Bitmap do begin
    SetSize(SizeX, SizeY);
    Canvas.Brush.Color:=BackColor;
    Canvas.FillRect(0, 0, SizeX, SizeY);
  end;
  ResetFood;
  oppositeKey:=VK_RIGHT;
  img.Align:=alClient;
end;


procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Timer1.Enabled then
  if key <> oppositeKey then
  begin
    if      key=vk_left  then
    begin
         direction:=point(-1 , 0);
         oppositeKey:=VK_RIGHT;
    end
    else if key=vk_right then
    begin
         direction:=point( 1 , 0);
         oppositeKey:=VK_LEFT;
    end

    else if key=vk_down  then
    begin
         direction:=point( 0 , 1);
         oppositeKey:=VK_UP;
    end
    else if key=vk_up    then
    begin
       direction:=point( 0 ,-1);
       oppositeKey:=VK_DOWN;
    end
  end

end;

procedure TForm1.Label2Click(Sender: TObject);
begin
  timer1.Enabled:= not Timer1.Enabled;
  Label1.Caption:= 'Snake Game';
  Randomize;

  BackColor:=rgbToColor(50, 50, 100);
  FoodColor:=rgbToColor(255, 0, 0);
  SnakeColor:=rgbToColor(255, 255, 255);

  setlength(snake, 1);
  snake[0]:=point(SizeX div 2, SizeY div 2);
  direction:=point(1, 0);
  with img.Picture.Bitmap do begin
    SetSize(SizeX, SizeY);
    Canvas.Brush.Color:=BackColor;
    Canvas.FillRect(0, 0, SizeX, SizeY);
  end;
  ResetFood;
  oppositeKey:=VK_RIGHT;
  img.Align:=alClient;
end;

procedure TForm1.scoreClick(Sender: TObject);
begin

end;

procedure TForm1.Timer1Timer(Sender: TObject);
var i, oldLength, c: integer;
begin
  SetPixel(snake[high(snake)].x, snake[high(snake)].y, BackColor); // Erase tail
  for i:=high(snake) downto 1 do begin
    snake[i]:=snake[i-1];
  end;

  snake[0].x:=snake[0].x+direction.x;
  snake[0].y:=snake[0].y+direction.y;

  if snake[0].x < 0 then begin
     snake[0].x:=0 ;
     Label1.Caption:= 'Game Over';
     timer1.Enabled:=false;
  end
  else if snake[0].x > sizeX-1 then begin
     snake[0].x:=sizeX-1;
     Label1.Caption:= 'Game Over';
     Label2.Caption:= 'Restart';
     timer1.Enabled:=false;
  end ;
  if snake[0].y < 0 then begin
     snake[0].y:=0 ;
     Label1.Caption:= 'Game Over';
     Label2.Caption:= 'Restart';
     timer1.Enabled:=false;
  end
  else if snake[0].y > sizeY-1 then begin

     snake[0].y:=sizeY-1;
     Label1.Caption:= 'Game Over';
     Label2.Caption:= 'Restart';
     timer1.Enabled:=false;

  end  ;
  if (snake[0].x = food.x) and (snake[0].y = food.y) then begin
    oldLength:=length(snake);
    setlength(snake, oldLength+2);
    poin := poin +1;
    for i:=oldLength to high(snake) do begin
      snake[i]:=snake[oldLength-1];
      score.Caption:='Score : '+ IntToStr(poin);
    end;
    ResetFood;
  end;

  for i := Length(snake)-2 downto 2 do begin
    if (snake[0].x = snake[i].x) and (snake[0].y = snake[i].y) then begin
      timer1.Enabled:=false;
      Label1.Caption:= 'Game Over';
      Label2.Caption:= 'Restart';
      snake[0].x := snake[i].x ;
      snake[0].y := snake[i].y ;
    end;
  end;
  SetPixel(snake[0].x, snake[0].y, SnakeColor); // Snake head

  if DrawNicerSnake then begin
    for i:=high(snake) downto 0 do begin
      c:=255-trunc(i/length(snake)*200);
      SetPixel(snake[i].x, snake[i].y, rgbToColor(c, c, 128));
    end;
  end;
end;

procedure TForm1.ResetFood;
begin
  food.x:=random(SizeX);
  food.y:=random(SizeY);
  // Todo: Check that food isn't placed on tail...


  SetPixel(food.x, food.y, FoodColor);
end;

procedure TForm1.SetPixel(x, y: integer; pixelcolor: TColor);
begin
  img.Picture.Bitmap.Canvas.Pixels[x, y]:=pixelcolor;
end;

end.

