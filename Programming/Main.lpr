program Main;
uses Crt;
type
    userData = record
        ID : String;
        seed : Boolean;
        Name : String;
        School : String;
    End;
var
    data : array of userData;
    arraySize : Integer;
    test : TextFile;
    temp : String;
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
        temp, temp1, temp2, temp3 : String;
    begin
        arraySize := arraySize + 1;
        try
            begin
              SetLength(data, arraySize);
            end;
        except
            begin
                TextColor(Red);
                WriteLn('Initialization Error');
                TextColor(Black);
            end;
        end;
        Write('input ID');
        try
            Readln(data[arraySize].ID);
        except
            TextColor(Red);
            WriteLn('Invaild Data');
            TextColor(Black);
        end;
        WriteLn(dataEncryption(data[arraySize].ID));
        Write('input Name');
        try
            Readln(data[arraySize].Name);
        except
            TextColor(Red);
            WriteLn('Invaild Data');
            TextColor(Black);
        end;
        temp2 := (data[arraySize].Name);
        Write('input School');
        try
            Readln(data[arraySize].School);
        except
            TextColor(Red);
            WriteLn('Invaild Data');
            TextColor(Black);
        end;
        inputSuccess := False;
        repeat
        temp3 := (data[arraySize].School);
        WriteLn('Seed? [Y/N]');
        ReadLn(temp);
        inputSuccess := True;
        case temp of
            'Y' : data[arraySize].seed := True;
            'N' : data[arraySize].seed := True;
        else
            begin
                TextColor(Red);
                WriteLn('Invaild Data');
                TextColor(Black);
                inputSuccess := False
            end;
        end;
        until inputSuccess;
        Assign(sourceFile, '/Users/samuel/Documents/SelfProgramming/SBA/Programming/File/Competitors.txt');
        Append(sourceFile);
        WriteLn(sourceFile, temp1);
        WriteLn(sourceFile, temp2);
        WriteLn(sourceFile, temp3);
        WriteLn(sourceFile, data[arraySize].seed);
        Close(sourceFile);
    end;

begin
    ClrScr;
    addUserData;
    Writeln('test positive');
end.
