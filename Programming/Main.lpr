program Main;
uses Crt, md5;
type
    userData = record
        ID : String;
        seed : Boolean;
        Name : String;
        School : String;
    End;
var
    data : array of userData;
    participantArraySize : Integer;
    debugMode, logedIn, admin : Boolean;
procedure ClearDebugLog();
    var
        DebugFile : Text;
    begin
        Assign(DebugFile, '/Users/samuel/Documents/SelfProgramming/SBA/Programming/File/debugLog.txt');
        Rewrite(DebugFile);
        Close(DebugFile);
    end;
procedure debugLog(message : String ; level : Integer); //Level 1: Fatal Error, Level 2: Warnning, Level 3: Debug
    var
        DebugFile : Text;
    begin
        if level = 1 then 
            begin
                TextColor(Red);
                Writeln('Oops. I have detected an error in my program. Try restart me :(');
                Writeln('Please also contact administrator');
                TextColor(Black);
            end;
        if debugMode then
            begin
                case level of
                    1 : begin
                        TextColor(Red);
                        Write('Fatal Error: ');
                        WriteLn(message);
                        TextColor(Black);
                    end;
                    2 : begin
                        TextColor(Yellow);
                        Write('Warnning: ');
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
        Assign(DebugFile, '/Users/samuel/Documents/SelfProgramming/SBA/Programming/File/debugLog.txt');
        Append(DebugFile);
        case level of
            1 : begin
                Write(DebugFile, 'Fatal Error, Level 1: ');
                WriteLn(DebugFile, message);
            end;
            2 : begin
                Write(DebugFile, 'Warnning, Level 2: ');
                WriteLn(DebugFile, message);
            end;
            3 : begin
                Write(DebugFile, 'Debug: ');
                WriteLn(DebugFile, message);
            end;
        end;
        Close(DebugFile);
    end;
function passwordEncryption(password : String):String;
    begin
        passwordEncryption := MD5Print(MD5String(password));
    end;
function dataEncryption(data : String):String;
    var 
        keyFile : Text;                                 // File that stored the encryption key 
        key, encryptedMessage: String;                  // Store the key and message for encrption
        keyLength, counter, i: Integer;                 // keyLength: store the length of the key  counter: For loop process of encryption key  i: For loop process of encryption message
    begin
        // Load File
        try
            debugLog('Started Data Encryption', 3);
            Assign(keyFile, '/Users/samuel/Documents/SelfProgramming/SBA/Programming/File/encryption.key');
            Reset(keyFile);
            ReadLn(keyFile, key);
            Close(keyFile);
        except
            debugLog('Fail to load key file', 1);
            WriteLn('Error when encryption');         // Handle unexpected error
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
        debugLog('Enncryption Successful',3);
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
            debugLog('Decryption Started', 3);
            Assign(keyFile, '/Users/samuel/Documents/SelfProgramming/SBA/Programming/File/encryption.key');
            Reset(keyFile);
            ReadLn(keyFile, key);
            Close(keyFile);
        except
            debugLog('error when decryption', 1);
            writeln('Error when decryption');         // Handle unexpected error
        end;
        try
            keyLength := Length(key);
            counter := 1;
            // Encrpytion
            for i := 1 to Length(data) do
                begin
                    encryptedMessage := encryptedMessage + chr((ord(data[i]) - Ord(key[counter])));
                    counter := (counter mod keyLength) + 1;
                end;
            // Return encrypted message
        except
            debugLog('Key Error', 1);
        end;
        debugLog('decryption successful', 3);
        dataDecryption := encryptedMessage;
    end;
procedure quickSortParticipant(start, ending : Integer ; accrodingTo : Integer = 2); // 1 = Name, 2 = School, 3 = ID
    var
        privot, wall, loop : Integer;
        temp : String;
        temp2 : Boolean;
    begin
        wall := start;
        privot := ending;
        if start < ending then
            begin
                debugLog('quicksort started', 3);
                for loop := start to ending - 1 do
                    begin
                        if accrodingTo = 1 then
                            begin
                                if data[privot].Name > data[loop].Name then
                                    begin
                                    debugLog('quicksort change position', 3);
                                    temp := data[loop].School;
                                    data[loop].School := data[wall].School;
                                    data[wall].School := temp;
                                    temp := data[loop].Name;
                                    data[loop].Name := data[wall].Name;
                                    data[wall].Name := temp;
                                    temp := data[loop].ID;
                                    data[loop].ID := data[wall].ID;
                                    data[wall].ID := temp;
                                    temp2 := data[loop].seed;
                                    data[loop].seed := data[wall].seed;
                                    data[wall].seed := temp2;
                                    wall := wall + 1;
                                    end;
                            end;
                        if accrodingTo = 2 then
                            begin
                                if data[privot].School > data[loop].School then
                                    begin
                                    debugLog('quicksort change position', 3);
                                    temp := data[loop].School;
                                    data[loop].School := data[wall].School;
                                    data[wall].School := temp;
                                    temp := data[loop].Name;
                                    data[loop].Name := data[wall].Name;
                                    data[wall].Name := temp;
                                    temp := data[loop].ID;
                                    data[loop].ID := data[wall].ID;
                                    data[wall].ID := temp;
                                    temp2 := data[loop].seed;
                                    data[loop].seed := data[wall].seed;
                                    data[wall].seed := temp2;
                                    wall := wall + 1;
                                    end;
                            end;
                        if accrodingTo = 3 then
                            begin
                                if data[privot].ID > data[loop].ID then
                                    begin
                                    debugLog('quicksort change position', 3);
                                    temp := data[loop].School;
                                    data[loop].School := data[wall].School;
                                    data[wall].School := temp;
                                    temp := data[loop].Name;
                                    data[loop].Name := data[wall].Name;
                                    data[wall].Name := temp;
                                    temp := data[loop].ID;
                                    data[loop].ID := data[wall].ID;
                                    data[wall].ID := temp;
                                    temp2 := data[loop].seed;
                                    data[loop].seed := data[wall].seed;
                                    data[wall].seed := temp2;
                                    wall := wall + 1;
                                    end;
                            end;
                    end;
                temp := data[privot].School;
                data[privot].School := data[wall].School;
                data[wall].School := temp;
                temp := data[privot].Name;
                data[privot].Name := data[wall].Name;
                data[wall].Name := temp;
                temp := data[privot].ID;
                data[privot].ID := data[wall].ID;
                data[wall].ID := temp;
                temp2 := data[privot].seed;
                data[privot].seed := data[wall].seed;
                data[wall].seed := temp2;
                quickSortParticipant(start, wall - 1, accrodingTo);
                quickSortParticipant(wall + 1, ending, accrodingTo);
            end;
    end;
function SearchForUser(Name : String = ''; ID : String = ''; School : String = '' ; var SearchResult : array of Integer) : Integer;
    var
        legnthOfArray, middle, top, bottom, temp, kmpLoop, kmpTargetLoop, kmpTempForTargetPointer, kmpCounter : Integer;
        found, same : Boolean;
        KMP, output: array of Integer;
    begin
        legnthOfArray := -1;
        bottom := 0;
        top := participantArraySize - 1;
        found := False;
        quickSortParticipant(0, participantArraySize - 1);
        //Search By ID
        if ID <> '' then
            begin
                try
                    quickSortParticipant(0, participantArraySize - 1, 3);
                except
                    debugLog('quick sort error', 3);
                end;
                repeat
                    middle := (top + bottom) div 2;
                    if ID > data[middle].ID then bottom := middle + 1
                    else if ID < data[middle].ID then top := middle - 1
                    else found := True;
                until found or (bottom > top);
                writeln(top);
                writeln(bottom);
                WriteLn(found);
                if found then
                    begin
                        legnthOfArray := legnthOfArray + 1;
                        SearchResult[legnthOfArray] := middle;
                    end;
            end;
        if Name <> '' then
            begin
                debugLog('searching for : ' + Name, 3);
                temp := -1;
                debugLog('kmp for name started', 3);
                repeat
                    temp := temp + 1;
                    SetLength(KMP, Length(data[temp].Name) + 1);
                    kmpTargetLoop := 1;
                    kmpTempForTargetPointer := 0;
                    KMP[1] := 0;
                    repeat
                        debugLog('kmp looping', 3);
                        kmpTargetLoop := kmpTargetLoop + 1;
                        if Name[kmpTargetLoop] = Name[kmpTempForTargetPointer] then
                            begin
                                kmpTempForTargetPointer := kmpTempForTargetPointer + 1;
                                KMP[kmpTargetLoop] := kmpTempForTargetPointer;
                                debugLog('kmp found same text', 3);
                            end
                        else 
                            begin
                                debugLog('kmp target not found, resetting', 3);
                                kmpTempForTargetPointer := 0;
                                KMP[kmpTargetLoop] := 0;
                            end;
                    until kmpTargetLoop >= Length(Name);
                    kmpLoop := 0;
                    kmpTargetLoop := 0;
                    kmpCounter := 0;
                    repeat
                        kmpLoop := kmpLoop + 1;
                        if data[temp].Name[kmpLoop] = Name[kmpTargetLoop + 1] then
                            begin
                                kmpTargetLoop := kmpTargetLoop + 1;
                                kmpCounter := kmpCounter + 1;
                            end
                        else
                            begin
                                kmpCounter := 0;
                                kmpTargetLoop := KMP[kmpTargetLoop];
                            end;
                    until (kmpCounter = Length(Name)) or (kmpLoop = Length(data[temp].Name));
                    debugLog('kmp check complete', 3);
                    if (kmpCounter = Length(Name)) then
                        begin
                            debugLog('kmp search : Found Target, saving to array', 3);
                            legnthOfArray := legnthOfArray + 1;
                            SearchResult[legnthOfArray] := temp;
                            debugLog('kmp save complete', 3);
                        end;
                until temp + 1 = participantArraySize;
            end;
        if School <> '' then
            begin
                temp := -1;
                debugLog('kmp for school started', 3);
                repeat
                    temp := temp + 1;
                    SetLength(KMP, Length(data[temp].School) + 1);
                    kmpTargetLoop := 1;
                    kmpTempForTargetPointer := 0;
                    KMP[1] := 0;
                    repeat
                        debugLog('kmp looping', 3);
                        kmpTargetLoop := kmpTargetLoop + 1;
                        if School[kmpTargetLoop] = School[kmpTempForTargetPointer] then
                            begin
                                kmpTempForTargetPointer := kmpTempForTargetPointer + 1;
                                KMP[kmpTargetLoop] := kmpTempForTargetPointer;
                                debugLog('kmp found same text', 3);
                            end
                        else 
                            begin
                                debugLog('kmp target not found, resetting', 3);
                                kmpTempForTargetPointer := 0;
                                KMP[kmpTargetLoop] := 0;
                            end;
                    until kmpTargetLoop = Length(School);
                    debugLog('KMP: check repeat word complete', 3);
                    kmpLoop := 0;
                    kmpTargetLoop := 0;
                    kmpCounter := 0;
                    debugLog('kmp search target: ' + School, 3);
                    debugLog('kmp searching in string: ' + data[temp].School, 3);
                    repeat
                        kmpLoop := kmpLoop + 1;
                        debugLog(data[temp].School[kmpLoop], 3);
                        debugLog(School[kmpTargetLoop + 1], 3);
                        if data[temp].School[kmpLoop] = School[kmpTargetLoop + 1] then
                            begin
                                kmpTargetLoop := kmpTargetLoop + 1;
                                kmpCounter := kmpCounter + 1;
                            end
                        else
                            begin
                                kmpCounter := 0;
                                kmpTargetLoop := KMP[kmpTargetLoop];
                            end;
                    until (kmpCounter = Length(School)) or (kmpLoop = Length(data[temp].School));
                    debugLog('kmp check complete', 3);
                    if (kmpCounter = Length(School)) then
                        begin
                            debugLog('kmp search : Found Target, saving to array', 3);
                            legnthOfArray := legnthOfArray + 1;
                            SearchResult[legnthOfArray] := temp;
                            debugLog('kmp save complete', 3);
                        end;
                until temp + 1 = participantArraySize;
            end;
        debugLog('search complete', 3);
        SearchForUser := legnthOfArray;
    end;
procedure inputDataToFile();
    var
        sourceFile : Text;
        seedText, ID, Name, School : String;
        loop : Integer;
        Seed : Boolean;
    begin
        Assign(sourceFile, '/Users/samuel/Documents/SelfProgramming/SBA/Programming/File/Competitors.epd');
        Rewrite(sourceFile);
        Close(sourceFile);
        for loop := 0 to participantArraySize - 1 do
            begin
                ID := data[loop].ID;
                School := data[loop].School;
                Name := data[loop].Name;
                Seed := data[loop].seed;
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
    end;
function numberOfParticipant() : Integer;
    var
        sourceFile : Text;
        temp : String;
    begin
        Assign(sourceFile, '/Users/samuel/Documents/SelfProgramming/SBA/Programming/File/Competitors.epd');
        Reset(sourceFile);
        participantArraySize := 0;
        while not Eof(sourceFile) do
            begin
                debugLog('Counting Participators', 3);
                participantArraySize := participantArraySize + 1;
                ReadLn(sourceFile, temp);
                ReadLn(sourceFile, temp);
                ReadLn(sourceFile, temp);
                ReadLn(sourceFile, temp);
            end;
        Close(sourceFile);
    end;
procedure LoadParticipant();
    var
        sourceFile : Text;
        temp : String;
        loop : Integer;
    begin
        debugLog('Start Load Participant Data', 3);
        Assign(sourceFile, '/Users/samuel/Documents/SelfProgramming/SBA/Programming/File/Competitors.epd');
        Reset(sourceFile);
        debugLog('Loaded File', 3);
        numberOfParticipant();
        SetLength(data, participantArraySize);
        loop := -1;
        debugLog('Array Length Set', 3);
        while not Eof(sourceFile) do
            begin
                debugLog('Loading Data', 3);
                loop := loop + 1;
                ReadLn(sourceFile, temp);
                data[loop].ID := dataDecryption(temp);
                debugLog('Loaded ID', 3);
                ReadLn(sourceFile, temp);
                data[loop].Name := dataDecryption(temp);
                debugLog('Loaded Name', 3);
                ReadLn(sourceFile, temp);
                data[loop].School := dataDecryption(temp);
                debugLog('Loaded School', 3);
                ReadLn(sourceFile, temp);
                temp := dataDecryption(temp);
                if temp = 'True' then
                    data[loop].seed := True
                else
                    data[loop].seed := False;
                debugLog('Loaded Seed', 3);
            end;
        Close(sourceFile);
    end;

function ValidateParticipantData(userSchool : String) : Boolean;
    var
        tempArray : Array of Integer;
        numberOfReseult : Integer;
    begin
        debugLog('Validating Participant', 3);
        SetLength(tempArray, participantArraySize);
        try
            if participantArraySize > 0 then numberOfReseult := SearchForUser('','', userSchool, tempArray);
        except
            debugLog('search error', 1);
        end;
        if numberOfReseult >= 1 then Result := False else Result := True;
    end;
procedure addParticipantData();
    var
        inputSuccess : Boolean;
        temp, temp1, temp2, temp3 : String;
        temp4 : Boolean;
    begin
        debugLog('Loading for adding participant', 3);
        debugLog('append array success', 3);
        Str(participantArraySize + 1, temp1);        
        WriteLn('input Name:');
        try
            Readln(temp2);
        except
            TextColor(Red);
            WriteLn('Invaild Data');
            TextColor(Black);
        end;
        WriteLn('input School:');
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
        if ValidateParticipantData(temp3) then
            begin
                try
                    begin
                    participantArraySize := participantArraySize + 1;
                    SetLength(data, participantArraySize);
                    end;
                except
                    begin
                        debugLog('append array fail', 1);
                    end;
                end;
                data[participantArraySize -1].ID := temp1;
                data[participantArraySize -1].Name := temp2;
                data[participantArraySize -1].School := temp3;
                data[participantArraySize -1].seed := temp4;
                quickSortParticipant(0, participantArraySize - 1);
                inputDataToFile();
            end else WriteLn('This school already have 2 participant.');
    end;
procedure loadUserName(var usrData : array of String);
    var
        sourceFile : Text;
        numberOfUser : Integer;
        temp : String;
    begin
        debugLog('Loading User File', 3);
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
        Close(sourceFile);
    end;
function checkUserExist(usrName : String):Boolean; //Return false if user does exist
    var
        userName : array of String;
        tempForLoop : Integer;
        temp : String;
    begin
        checkUserExist := True;
        debugLog('checking',3);
        SetLength(userName, numberOfUser);
        debugLog('checking',3);
        loadUserName(userName);
        for tempForLoop := 1 to numberOfUser do
            begin
                if  userName[tempForLoop] = usrName then
                    checkUserExist := False;
            end;  
    end;
procedure creatAccount(isAdmin, ask : Boolean);
    var
        acFile : Text;
        userName, password, valiPassword, tempInput : String;
        temp, inputSuccess: Boolean;
    begin
        debugLog('Start Create AC', 3);
        if ask then
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
        debugLog('loading File', 3);
        Assign(acFile, '/Users/samuel/Documents/SelfProgramming/SBA/Programming/File/user.epd');
        Append(acFile);
        repeat
            WriteLn('Enter username');
            ReadLn(userName);
            debugLog('username entered', 3);
            temp := checkUserExist(userName);
            if not checkUserExist(userName) then
                WriteLn('User Already Exist');
        until temp;
        WriteLn(acFile, dataEncryption(userName));
        debugLog('User Name Saved', 3);
        WriteLn('Enter password');
        repeat
            ReadLn(password);
            WriteLn('ReEnter Password');
            ReadLn(valiPassword);
            debugLog('Password Entered', 3);
            if not (password = valiPassword) then
                begin
                    TextColor(Red);
                    WriteLn('Both Password Are Not The Same. Please Reenter');
                    TextColor(Black);
                end;
        until password = valiPassword;
        debugLog('Password Validation Success', 3);
        writeln(acFile, passwordEncryption(password));
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
        UserName := dataEncryption(UserName);
        Password := passwordEncryption(Password);
        debugLog(Password, 3);
        Assign(acFile,'/Users/samuel/Documents/SelfProgramming/SBA/Programming/File/user.epd');
        Reset(acFile);
        debugLog('Checking Ac', 3);
        repeat
            ReadLn(acFile, fileUserName);
            ReadLn(acFile, filePassword);
            ReadLn(acFile, isAdmin);
            isAdmin := dataDecryption(isAdmin);
        until (fileUserName = UserName) or Eof(acFile);
        isAdmin := dataDecryption(isAdmin);
        if fileUserName <> UserName then
            begin
                writeln('Username  incorrect');
            end
        else if Password <> filePassword then
            begin
                writeln('Username or Password incorrect');
                debugLog('login fail, username/password incorrect', 2)
            end
            else begin
              logedIn := True;
              if isAdmin = 'True' then admin := True;
              debugLog('loged in', 3);
            end;
        Close(acFile);
    end;
procedure logOut();
    begin
      logedIn := False;
      admin := False;
    end;
procedure ChangePassword();
    begin
        
    end;
procedure showParticipant();
    var
        temp : Integer;
    begin
        // try
        //     LoadParticipant();
        // except
        //     debugLog('show participant data: load data error', 1);
        // end;
        quickSortParticipant(0, participantArraySize - 1, 3);
        debugLog('show participant data: sort success', 3);
        for temp := 0 to (participantArraySize - 1) do
            begin
                Write(' ID: ');
                Write(data[temp].ID :8);
                Write(' Name: ');
                Write(data[temp].Name :8);
                Write(' School: ');
                Write(data[temp].School :8);
                Write(' Seed: ');
                WriteLn(data[temp].seed :8);
            end;
    end;
procedure AccountManagementMenu();
    var
        choice : Integer;
        temp : String;
    begin
        ClrScr;
        Writeln('1. Change Password');
        Writeln('2. Change Username');
        Writeln('3. Delete Account');
        Writeln('9. Back To Main Screen');
    end;
procedure SearchMenu();
    var
        ID, Name, School : String;
        temp, temp2 : Integer;
        tempArray : Array of Integer;
    begin
        for temp2 := 1 to Length(tempArray) - 1 do
            begin
                tempArray[temp2] := -1;
            end;
        writeln('Leave it blank if you dont know');
        write('ID : ');
        ReadLn(ID);
        Write('Name : ');
        ReadLn(Name);
        Write('School : ');
        ReadLn(School);
        SetLength(tempArray, participantArraySize);
        temp2 := SearchForUser(Name, ID, School, tempArray);
        debugLog('Search complete', 3);
        for temp := 0 to temp2 do
            begin
                Write(' ID: ');
                Write(data[tempArray[temp]].ID :8);
                Write(' Name: ');
                Write(data[tempArray[temp]].Name :8);
                Write(' School: ');
                Write(data[tempArray[temp]].School :8);
                Write(' Seed: ');
                WriteLn(data[tempArray[temp]].seed :8);
            end;
    end;
procedure Mainmenu();
    var
        choice : Integer;
        temp : String;
    begin
        repeat
            ClrScr;
            temp := '';
            if logedIn then WriteLn('1. Logout AC') else WriteLn('1. Login AC');
            WriteLn('2. View Competitors');
            if logedIn then WriteLn ('3. Enter Data');
            if admin then WriteLn('4. Add Account');
            WriteLn('5. Search for user (Under testing🙇🏻‍)');
            WriteLn('9. Quit');
            Writeln;
            Write('Your Choice: ');
            try
                ReadLn(choice);
            except
            end;
            debugLog('Choice entered', 3);
            Str(choice, temp);
            debugLog('User Choice : ' + temp, 3);
            case choice of
                1 : if logedIn then logOut else logIn;
                2 : showParticipant();
                3 : if logedIn then addParticipantData else WriteLn('Invalid choice');
                4 : if admin then creatAccount(False, True) else WriteLn('Invalid choice');
                5 : SearchMenu();
                9 : begin debugLog('Program ended', 3); Break; end;
            else
                begin
                    TextColor(Red);
                    debugLog('User Entered Invalid Option in Mainmenu', 2);
                    WriteLn('Invalid choice');
                end;
            end;
            TextColor(Green);
            WriteLn('press enter to continue');
            TextColor(Black);
            ReadLn;
        until choice = 9;
    end;
begin
    ClearDebugLog;
    debugMode := False;
    LoadParticipant;
    try
        quickSortParticipant(0, participantArraySize - 1);
    except
        debugLog('quick sort error', 1);
    end;
    logedIn := False;
    admin := False;
    // addParticipantData;
    if numberOfUser = 0 then creatAccount(True, False);
    Mainmenu();
end.

