program loadData;
uses
    Sysutils;
Type
    userData = record
        ID : String;
        seed : Boolean;
        school : String;
    End;
var
    dataFile : TextFile;
    a : String;
    i, counter, numCompetitors : Integer;
    data : array of userData;
begin
    WriteLn('Program Start');
    Writeln('Loading Data');
    Assign(dataFile, '/Users/samuel/Documents/SelfProgramming/SBA/Programming/File/Competitors.epd'); //encypted player data
    Reset(dataFile);
    i := 0;
    counter := 1;
    while not Eof(dataFile) do
      begin
        Readln(dataFile, a);
        counter := counter + 1;
      end;
    numCompetitors := counter div 4;
    WriteLn(numCompetitors);
    SetLength(data, numCompetitors);                          // Set the length of array, which stores player information
    repeat
      i := i + 1;
      ReadLn(dataFile, data[i].school);
      ReadLn(dataFile, data[i].ID);
      ReadLn(dataFile, a);
      if a = 'True' then
        data[i].seed := True
      else
        data[i].seed := False;
      ReadLn(dataFile, a);
    until eof(dataFile);
    Close(dataFile);
    WriteLn(Length(data));
end.
