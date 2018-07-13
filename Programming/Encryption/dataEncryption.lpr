program dataEncryption;
uses Crt, SysUtils;
var
    keyFile : Text;
    key, temp, encryptedMessage, decryptedMessage : String;
    encryptedFile : Text;
    keyLength, counter, i, counter2 : Integer;
begin
    ClrScr;
    Assign(keyFile, '/Users/samuel/Documents/SelfProgramming/SBA/Programming/File/encryption.key');
    Reset(keyFile);
    ReadLn(keyFile, key);
    Close(keyFile);
    keyLength := Length(key);
    counter := 1;
    counter2 := 1;
    ReadLn(temp);
    for i := 1 to Length(temp) do
        begin
            encryptedMessage := encryptedMessage + chr((ord(temp[i]) + Ord(key[counter])));
            counter := (counter mod keyLength) + 1;
        end;
    WriteLn(encryptedMessage);
    for i := 1 to Length(temp) do
      begin
        decryptedMessage := decryptedMessage + chr((Ord(encryptedMessage[i]) - Ord(key[counter2])));
        counter2 := (counter2 mod keyLength) + 1;
      end;
    WriteLn(decryptedMessage);
end.

