uses System.Media,MathUnit;

function translate(start,x:integer):integer;
var
  transp:integer;//транспонирование нот
begin
  start:=start*(1+(x div 12));
  x:=x mod 12;
  write(x,'->');
  case x of
    1:result:=start;
    2:result:=trunc(start*1.0594);
    3:result:=trunc(start*1.1224);
    4:result:=trunc(start*1.1892);
    5:result:=trunc(start*1.2599);
    6:result:=trunc(start*1.3348);
    7:result:=trunc(start*1.4142);
    8:result:=trunc(start*1.4983);
    9:result:=trunc(start*1.5874);
    10:result:=trunc(start*1.6817);
    11:result:=trunc(start*1.7817);
    12:result:=trunc(start*1.8877);
    else
      result:=0;
  end;
end;

procedure played;
var
  x,r,del,d1,i:integer;
  muse:array of integer;
  
  base:array of array [1..100] of integer;
  n:integer;
  
  t,j,nw:integer;
  f:integer;//идет на верх(0) или вниз(1)
  
  t1,t2:file;
  c:char;
  pl:SystemSound;
begin
  x:=random(1,12);
  setlength(muse,200+1000);
  t:=0;

  n:=0;
  setlength(base,n+1);
  n+=1;
  //разница, количество переходов, переходы
  base[n-1][1]:=-2; base[n-1][2]:=4; base[n-1][3]:=-2; base[n-1][4]:=+4; base[n-1][5]:=0;base[n-1][6]:=-4;
  setlength(base,n+1);
  n+=1;
  base[n-1][1]:=5; base[n-1][2]:=2; base[n-1][3]:=+3; base[n-1][4]:=+2;
  setlength(base,n+1);
  n+=1;
  base[n-1][1]:=-5; base[n-1][2]:=2; base[n-1][3]:=-2; base[n-1][4]:=-3;

  muse[0]:=x;
  t:=t+1;
  while(t<=100) do
  begin
    f:=random(0,n-1);
    while((base[f][1]+muse[t-1])<=0)or((muse[t-1]>5)and(base[f][1]>0))do
      f:=random(0,n-1);
    nw:=t;
    for j:=1 to base[f][2] do
    begin
      muse[t]:=muse[t-1]+base[f][2+j];
      t:=t+1;
    end;
    f:=random(0,1);
    if(f=1)then //сделаем вставку
    begin
      x:=random(nw,t-1);
      for r:=0 to n-1 do
      begin
        if(base[r][1]=(muse[x+1]-muse[x]))then
        begin
          for j:=x to t-1 do
            muse[j+base[r][2]]:=muse[j];
          for j:=1 to base[r][2] do
            muse[x+j]:=muse[x+j-1]+base[r][2+j];
          t:=t+base[r][2];
          break;
        end;
      end;
    end;
//    1 4 6->2 8 12 -> 2 5 7 10 12
//    6 4 1->2 8 12->12 10 7 5 2
  end;
  assign(t2,'music.mp3');
  rewrite(t2);
{  pl:=System.Media.SystemSounds.Beep;
  pl.Play();}
  for j:=0 to t-1 do
  begin
    write(muse[j],' ');
    assign(t1,muse[j].ToString()+'.mp3');
    reset(t1);
    while(not(Eof(t1)))do
    begin
      read(t1,c);
      write(t2,c);
    end;
    close(t1);
    x:=translate(440,muse[j]);
    writeln(x);
{    if(j+7>t-1)then
    begin
      if(x<>0)then system.Console.Beep(x,200+40*(j-(t-1-7)))
      else sleep(200);      
    end
    else
      if(x<>0)then system.Console.Beep(x,200)
      else sleep(200);}
  end;
  close(t2);
end;


begin
  played;
end.