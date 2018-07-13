program Main;
uses Crt;
var
    a : String;
    myfile : Text;
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


begin
    ClrScr;
    WriteLn('enter message');
    try
        ReadLn(a);
    except
        WriteLn('invalid message');
    end;
    Write('encrypted message: ');
    a := dataEncryption(a);
    Assign(myfile, '/Users/samuel/Documents/SelfProgramming/SBA/Programming/File/Competitors.epd');
    Rewrite(myfile);
    WriteLn(myfile, a);
    Close(myfile);
    WriteLn(a);
    Write('decrypted message: ');
    Writeln(dataDecryption(a));
end.

