program dataEntering;
Type
    userData = record
        ID : Integer;
        seed : Boolean;
    End;
var
    a : array of userData;
    i : Integer;
    checkInput : Boolean;
    tempSeed : String;

begin
    try
      for i := 1 to 10 do
      begin
        a[i].ID := 0;
        a[i].seed := false;
      end;
    except
        WriteLn('Initialization error');
    end;
    i := 0;
    repeat
      i := i + 1;
      checkInput := False;
      repeat
        Write('input ID');
        WriteLn(i);
        try
          ReadLn(a[i].ID);
        except
            WriteLn('Data error');
        end;
        WriteLn('seed? [Y/N]');
        try
          ReadLn(tempSeed);
        except
          WriteLn('Data error');
        end;
        case tempSeed of
          'Y' : a[i].seed := True;
          'N' : a[i].seed := False;
        else
          WriteLn('Error');
        end;
      until a[i].ID <> 0;
    until i >= 10;
end.
