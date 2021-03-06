program lab1;

{$APPTYPE CONSOLE}

uses
  SysUtils;

const N = 1000;
type
    TRec = record
       num:integer;
       str:string[12];
       F:boolean;
    end;
    TM = array[1..N] of TRec;
    TField = (num,str);
    TShel = function(var r1,r2:TRec):Boolean;
var
  M:TM;
  NeedStr:string;
  NeedInt:integer;
  NeedIntStr:string;



function strShell(var r1,r2:TRec):Boolean;
begin
  Result := r1.str > r2.str;
end;

function intShell(var r1,r2:TRec):Boolean;
begin
  Result := r1.num > r2.num;
end;

procedure generateArray(const N:integer;var M:TM);
var
  i:integer;
begin
  for i:=1 to N do
  begin
    with M[i] do
    begin
      num:=Random(200)+1;
      str:='My_test_' + IntToStr(i);
      f:=false;
    end;
  end;
end;

procedure writeArray(const N:integer;const M:TM; name:string; step:integer = 0);
var
  i:integer;
  outfile: TextFile;
begin
  Writeln('Step ' + IntToStr(step) + '. Written to file "' + name + '"');
  AssignFile(outfile, 'OutFiles/' + name);
  Rewrite(outfile);
  write(outfile, 'Field 1':16);
  write(outfile, 'Field 2':16);
  writeln(outfile, 'Field 3':16);
  for i:=1 to N do
  begin
    with M[i] do
    begin
      write(outfile, num:16);
      write(outfile, str:16);
      writeln(outfile, f:16);
    end;
  end;
  CloseFile(outfile);
end;

procedure ShellSort(const Size: integer; var SA: TM; mode:TShel);
var t,k,i,j,m:integer;
tmp:TRec;
begin
  t := Trunc(Ln(Size) / Ln(2)) - 1;
  for i:=1 to t do
  begin
    k:= (1 shl (t+1-i)) - 1;
    for j:=(k + 1) to Size do
    begin
      tmp:=SA[j];
      m:=j-k;
      While((m>=1) and (mode(SA[m], tmp))) do
      begin
        SA[M+k] := SA[m];
        m:=m-k;
      end;
      SA[m+k] := tmp;
    end;
  end;
end;

procedure stringBinSearch(const N:Integer;var M:TM; const el:string);
var
  left, right, middle:integer;
  search:integer;
begin
  left:=1;
  right:=N;
  search:=-1;
  while (left <= right) do
  begin
    middle := (left + right) div 2;
    M[middle].f := true;
    if ((M[middle].str) = el) then
    begin
      search:= middle;
      left := right + 1; // Exit of cycle
    end
    else
    begin
      if (M[middle].str > el) then
        right := middle - 1
      else
        left := middle +1;
    end;
  end;
  if (search = -1) then
    writeln('Not found',#10#13)
  else
    Writeln('Element index: ' + IntToStr(search),#10#13)
end;

procedure intBinSearch(const N:Integer;var M:TM; const el:Integer);
var
  left, right, middle:integer;
  search:integer;
  tmpind:integer;
begin
  left:=1;
  right:=N;
  search:=-1;
  while (left <= right) do
  begin
    middle := (left + right) div 2;
    M[middle].f := true;
    if ((M[middle].num) = el) then
    begin
      search:= middle;
      left := right + 1; // Exit of cycle
    end
    else
    begin
      if (M[middle].num > el) then
        right := middle - 1
      else
        left := middle +1;
    end;
  end;
  if (search = -1) then
    writeln('Not found')
  else
  begin
    tmpind := search;
    while(M[tmpind].num = el) do
    begin
      Dec(tmpind);
    end;
    M[tmpind].f := true;
    inc(tmpind);
    while(M[tmpind].num = el) do
    begin
      M[tmpind].f := true;
      Write(m[tmpind].num:5);
      Write(m[tmpind].str:16);
      writeln(m[tmpind].f:8);
      inc(tmpind);
    end;
  end;
end;

function numOfTrue(const N:integer; var M:TM):Integer;
var
  i:integer;
begin
  Result:=0;
  for i:= 1 to N do
  begin
    if(M[i].F = True) then
      Inc(Result);
  end;
end;

procedure NulledFlag(const N:integer; var M:TM);
var
  i:Integer;
begin
  for i:=1 to N do
  begin
    M[i].F := false;
  end;
end;

begin
  generateArray(N,M);                    // Step 1
  writeArray(N,M, 'initialArr.txt', 2);  // Step 2
  ShellSort(N,M, strShell);              // Step 3
  writeArray(N,M, 'sortField2.txt', 4);  // Step 4
  Writeln(#10#13, 'Enter the string for the binary search');
  readln(NeedStr);                       // Step 5
  stringBinSearch(N,M, NeedStr);         //
  writeArray(N,M, 'SearchField2.txt',6); // Step 6
  Writeln(#10#13, 'Field with "true" : ', numOfTrue(N,M),#10#13);
  NulledFlag(N,M);                       // Step 7
  ShellSort(N,M,intShell);               // Step 8
  writeArray(N,M, 'sortField1.txt',9);   // Step 9
  Writeln(#10#13, 'Enter the int value for the binary search');
  Readln(NeedIntStr);
  val(NeedIntStr, NeedInt, NeedInt);       // Step 10
  if (NeedInt <> 0) then
    intBinSearch(N,M,NeedInt)             //
  else
    writeln('Incorrect input');
  writeArray(N,M, 'SearchField1.txt',11);// Step 11
  Writeln(#10#13, 'Field with "true" : ', numOfTrue(N,M),#10#13);

  Writeln('Press enter to end the program');
  Readln;
end.
