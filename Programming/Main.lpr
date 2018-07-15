program Main;
uses Crt;
type
    userData = record
        ID : Integer;
        seed : Boolean;
        Name : String;
        School : String;
    End;
var
    data : array of userData;
    arraySize : Integer;
function dataEncryption(data : String):String;
    var 
        keyFile : Text;                                 // File that stored the encryption key 
        key, encryptedMessage: String;                  // Store the key and message for encrption
        keyLength, counter, i: Integer;                 // keyLength: store the length of the key  counter: For loop process of encryption key  i: For loop process of encryption message
    begin
        // Load File
        try
          Assign(keyFile, '/Users/samuel/Documents/SelfProgramming/SBA/Programming/File/encryption.key');
          Reset(keyFile);
          ReadLn(keyFile, key);
          Close(keyFile);
        except
          writeln('Error: Cant read key file');         // Handle unexpected error
        end;
        keyLength := Length(key);
        counter := 1;
        // Encrpytion
        for i := 1 to Length(data) do
            begin
                encryptedMessage := encryptedMessage + chr((ord(data[i]) + Ord(key[counter])));
                counter := (counter mod keyLength) + 1;
            end;
        // Return encrypted message
        dataEncryption := encryptedMessage;
    end;

function dataDecryption(data : String):String;
    var
        keyFile : Text;                                 // File that stored the decryption key 
        key, encryptedMessage: String;                  // Store the key and message for decryption
        keyLength, counter, i: Integer;                 // keyLength: store the length of the key  counter: For loop process of decryption key  i: For loop process of decryption message
    begin
        // Load File
        try
          Assign(keyFile, '/Users/samuel/Documents/SelfProgramming/SBA/Programming/File/encryption.key');
          Reset(keyFile);
          ReadLn(keyFile, key);
          Close(keyFile);
        except
          writeln('Error: Cant read key file');         // Handle unexpected error
        end;
        keyLength := Length(key);
        counter := 1;
        // Encrpytion
        for i := 1 to Length(data) do
            begin
                encryptedMessage := encryptedMessage + chr((ord(data[i]) - Ord(key[counter])));
                counter := (counter mod keyLength) + 1;
            end;
        // Return encrypted message
        dataDecryption := encryptedMessage;
    end;
procedure addUserData();
    var
        sourceFile : Text;
        inputSuccess : Boolean;
        temp : String;
    begin
        arraySize := arraySize + 1;
        try
            begin
              Assign(sourceFile, '/Users/samuel/Documents/SelfProgramming/SBA/Programming/File/Competitors.epd');
              SetLength(data, arraySize);
            end;
        except
            begin
                TextColor(Red);
                WriteLn('Initialization Error');
                TextColor(Black);
            end;
        end;
        Append(sourceFile);
        inputSuccess := False;
        repeat
            Write('input ID');
            try
                try
                  Readln(data[arraySize].ID);
                except
                    TextColor(Red);
                    WriteLn('Invaild Data');
                    TextColor(Black);
                end;
            finally
                inputSuccess := True;
            end;
            WriteLn(sourceFile, data[arraySize].ID);
        until inputSuccess;
        inputSuccess := False;
        repeat
            Write('Name');
            try
                try
                  Readln(data[arraySize].Name);
                except
                    TextColor(Red);
                    WriteLn('Invaild Data');
                    TextColor(Black);
                end;
            finally
                inputSuccess := True;
            end;
            WriteLn(sourceFile, data[arraySize].Name);
        until inputSuccess;
        inputSuccess := False;
        repeat
            Write('School');
            try
                try
                  Readln(data[arraySize].School);
                except
                    TextColor(Red);
                    WriteLn('Invaild Data');
                    TextColor(Black);
                end;
            finally
                inputSuccess := True;
            end;
            WriteLn(sourceFile, data[arraySize].School);
        until inputSuccess;
        inputSuccess := False;
        repeat
            Write('seed? [Y/N]');
            try
                try
                  ReadLn(temp);
                except
                    TextColor(Red);
                    WriteLn('Invaild Data');
                    TextColor(Black);
                end;
            finally
                inputSuccess := True;
            end;
            case temp of
                'Y' : data[arraySize].seed := True;
                'N' : data[arraySize].seed := False;
            else
                TextColor(Red);
                WriteLn('Invaild Data');
                TextColor(Black);
            end;
            WriteLn(sourceFile, data[arraySize].seed);
        until inputSuccess;
    end;

begin
    ClrScr;
    addUserData;
end.

