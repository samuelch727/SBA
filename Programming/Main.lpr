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
    debugMode, logedIn, admin : Boolean;
procedure debugLog(message : String ; level : Integer); //Level 1: Fatal Error, Level 2: Warnning, Level 3: Debug
    begin
        if debugMode then
            begin
                case level of
                    1 : begin
                        TextColor(Red);
                        Write('Fatal Error, Level 1');
                        WriteLn(message);
                        TextColor(Black);
                    end;
                    2 : begin
                        TextColor(Red);
                        Write('Warnning, Level 2');
                        WriteLn(message);
                        TextColor(Black);
                    end;
                    3 : begin
                        TextColor(Green);
                        Write('Debug:');
                        WriteLn(message);
                        TextColor(Black);
                end;
            end;
        end;
    end;
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
procedure inputDataToFile(ID : String; Name : String; School : String; Seed : Boolean);
    var
        sourceFile : Text;
        seedText : String;
    begin
        if Seed then
            seedText := 'True'
        else
            seedText := 'False';
        ID := dataEncryption(ID);
        Name := dataEncryption(Name);
        School := dataEncryption(School);
        seedText := dataEncryption(seedText);
        Assign(sourceFile, '/Users/samuel/Documents/SelfProgramming/SBA/Programming/File/Competitors.epd');
        Append(sourceFile);
        WriteLn(sourceFile, ID);
        WriteLn(sourceFile, Name);
        WriteLn(sourceFile, School);
        WriteLn(sourceFile, seedText);
        Close(sourceFile);
    end;
procedure addUserData();
    var
        inputSuccess : Boolean;
        temp, temp1, temp2, temp3 : String;
        temp4 : Boolean;
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
        data[arraySize].ID := '';
        data[arraySize].School := '';
        Write('input ID');
        try
            Readln(temp1);
        except
            TextColor(Red);
            WriteLn('Invaild Data');
            TextColor(Black);
        end;
        Write('input Name');
        try
            Readln(temp2);
        except
            TextColor(Red);
            WriteLn('Invaild Data');
            TextColor(Black);
        end;
        Write('input School');
        try
            Readln(temp3);
        except
            TextColor(Red);
            WriteLn('Invaild Data');
            TextColor(Black);
        end;
        inputSuccess := False;
        repeat
        WriteLn('Seed? [Y/N]');
        ReadLn(temp);
        inputSuccess := True;
        case temp of
            'Y' : temp4 := True;
            'N' : temp4 := False;
        else
            begin
                TextColor(Red);
                WriteLn('Invaild Data');
                TextColor(Black);
                inputSuccess := False
            end;
        end;
        until inputSuccess;
        inputDataToFile(temp1, temp2, temp3, temp4);
    end;
procedure loadUserName(var usrData : array of String);
    var
        sourceFile : Text;
        numberOfUser : Integer;
        temp : String;
    begin
        Assign(sourceFile, '/Users/samuel/Documents/SelfProgramming/SBA/Programming/File/user.epd');
        Reset(sourceFile);
        numberOfUser := 0;
        while not Eof(sourceFile) do
            begin
                numberOfUser := numberOfUser + 1;
                try
                    begin
                        ReadLn(sourceFile, temp);
                        usrData[numberOfUser] := dataDecryption(temp);
                        ReadLn(sourceFile, temp);
                        ReadLn(sourceFile, temp);
                    end;
                except
                    debugLog('Error: Cant Read File', 1);
                end;
            end;
        Close(sourceFile);
    end;
function numberOfUser() : Integer;
    var
        sourceFile : Text;
        temp : String;
    begin
        Assign(sourceFile, '/Users/samuel/Documents/SelfProgramming/SBA/Programming/File/user.epd');
        Reset(sourceFile);
        numberOfUser := 0;
        while not Eof(sourceFile) do
            begin
              numberOfUser := numberOfUser + 1;
              ReadLn(sourceFile, temp);
              ReadLn(sourceFile, temp);
              ReadLn(sourceFile, temp);
            end;
    end;
function checkUserExist(usrName : String):Boolean; //Return false if user does exist
    var
        userName : array of String;
        numberOfUser, tempForLoop : Integer;
        temp : String;
    begin
        checkUserExist := True;
        SetLength(userName, numberOfUser);
        loadUserName(userName);
        for tempForLoop := 1 to numberOfUser do
            begin
                if  userName[tempForLoop] = usrName then
                    checkUserExist := False;
            end;  
    end;
procedure creatAccount(isAdmin : Boolean);
    var
        acFile : Text;
        userName, password, valiPassword, tempInput : String;
        temp, inputSuccess: Boolean;
    begin
        if not isAdmin then
            begin
                inputSuccess := False;
                repeat
                WriteLn('Create Admin Account? [Y/N]');
                ReadLn(tempInput);
                inputSuccess := True;
                case tempInput of
                    'Y' : isAdmin := True;
                    'N' : isAdmin := False;
                else
                    begin
                        TextColor(Red);
                        WriteLn('Invaild Data');
                        TextColor(Black);
                        inputSuccess := False
                    end;
                end;
                until inputSuccess;
            end;
        Assign(acFile, '/Users/samuel/Documents/SelfProgramming/SBA/Programming/File/user.epd');
        Append(acFile);
        repeat
            ReadLn(userName);
            temp := checkUserExist(userName);
            if not checkUserExist(userName) then
                WriteLn('User Already Exist');
        until temp;
        WriteLn(acFile, dataEncryption(userName));
        debugLog('User Name Saved', 3);
        WriteLn('password');
        repeat
            ReadLn(password);
            ReadLn(valiPassword);
            if not (password = valiPassword) then
                begin
                    TextColor(Red);
                    WriteLn('Both Password Are Not The Same. Please Reenter');
                    TextColor(Black);
                end;
        until password = valiPassword;
        writeln(acFile, dataEncryption(password));
        debugLog('User Password Saved' ,3);
        if isAdmin then
            WriteLn(acFile, dataEncryption('True'))
        else
            WriteLn(acFile, dataEncryption('False'));
        Close(acFile);
    end;

procedure logIn();
    var
        acFile : Text;
        UserName, fileUserName, Password, filePassword, isAdmin : String;
    begin
        WriteLn('Enter User Name');
        Readln(UserName);
        WriteLn('Enter Password');
        ReadLn(Password);
        Assign(acFile,'/Users/samuel/Documents/SelfProgramming/SBA/Programming/File/user.epd');
        Reset(acFile);
        debugLog('Checking Ac', 3);
        repeat
            ReadLn(acFile, fileUserName);
            fileUserName := dataDecryption(fileUserName);
            // WriteLn(fileUserName);
            ReadLn(acFile, filePassword);
            filePassword := dataDecryption(filePassword);
            ReadLn(acFile, isAdmin);
        until (fileUserName = UserName) or Eof(acFile);
        isAdmin := dataDecryption(isAdmin);
        if fileUserName <> fileUserName then
            writeln('Username  incorrect')
        else if Password <> filePassword then
            writeln('Username or Password incorrect')
            else begin
              logedIn := True;
              WriteLn(logedIn);
              if isAdmin = 'True' then admin := True;
            end;
        debugLog('loged in', 3);
    end;
procedure menu();
    var
        choice : Integer;
    begin
        repeat
            ClrScr;
            WriteLn('1. Login AC');
            WriteLn('2. View Competiton Chart');
            if logedIn then WriteLn ('3. Enter Data');
            if admin then WriteLn('4. Add Account');
            WriteLn('9. Quit');
            Writeln;
            Write('Your Choice: ');
            try
                ReadLn(choice);
            except
                WriteLn('Invalid choice');
            end;
            debugLog('choice ok', 3);
            case choice of
                1 : logIn();
                2 : WriteLn('working on it 🙇🏻‍');
                3 : if logedIn then addUserData else WriteLn('Invalid choice');
                4 : if admin then creatAccount(False) else WriteLn('Invalid choice');
                9 : Break;
            else
                begin
                    WriteLn('Invalid choice');
                    menu;
                end;
            end;
        until choice = 9;
    end;
begin
    logedIn := False;
    admin := False;
    debugMode := False;
    if numberOfUser = 0 then creatAccount(True);
    menu();
end.

