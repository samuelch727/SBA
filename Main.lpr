// © 2018 SAMUEL CHAN SZE NOK ALL RIGHTS RESERVED
// Redistribution and use in source and binary forms, with or without
// modification are permitted.
program Main;
uses Crt, md5, math, sysutils;
type
    userData = record
        ID : String;
        seed : Boolean;
        Name : String;
        School : String;
        competitionRecordPosition : Integer;
    End;
    chartData = record
        ID : Integer;
        inGame : Boolean;
    End;
var
    data : array of userData;
    participantArraySize, competitonRecordPointer, totalNumberOfRound, currentRound, numOfFinishedGroup : Integer;
    debugMode, loggedIn, admin, createdChart, programErrorBreak, WinPlat : Boolean;
    competitonRecord : array of chartData;
    version, fileLocation : String;
procedure ClearDebugLog();
    var
        DebugFile : Text;
    begin
        Assign(DebugFile, fileLocation + 'debugLog.txt');
        Rewrite(DebugFile);
        Close(DebugFile);
    end;
procedure debugLog(message : String ; level : Integer = 3 ; errorCode : String = ''); //Level 1: Fatal Error, Level 2: Warnning, Level 3: Debug
    var
        DebugFile : Text;
    begin
        Assign(DebugFile, fileLocation + 'debugLog.txt');
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
        if level = 1 then 
            begin
                TextColor(Red);
                Writeln('Oops. I have detected an error in my program. Try restart me :(');
                Writeln('Please also contact administrator');
                if errorCode <> '' then writeln('error code: ' + errorCode);
                if WinPlat then TextColor(White) else TextColor(Black);
                Delay(500);
                Write('Exiting Program');
                Write('.');
                Delay(200);
                Write('.');
                Delay(200);
                Write('.');
                Delay(100);
                Halt(1);
                programErrorBreak := True;
            end;
        if debugMode then
            begin
                case level of
                    1 : begin
                        TextColor(Red);
                        Write('Fatal Error: ');
                        WriteLn(message);
                        if WinPlat then TextColor(White) else TextColor(Black);
                    end;
                    2 : begin
                        TextColor(Yellow);
                        Write('Warnning: ');
                        WriteLn(message);
                        if WinPlat then TextColor(White) else TextColor(Black);
                    end;
                    3 : begin
                        TextColor(Green);
                        Write('Debug:');
                        WriteLn(message);
                        if WinPlat then TextColor(White) else TextColor(Black);
                    end;
                end;
            end;
    end;
procedure debugPrintDataID();
    var
        loop : Integer;
    begin
        for loop := 0 to participantArraySize - 1 do debugLog('data[' + IntToStr(loop) + '].ID = ' + data[loop].ID);
        for loop := 0 to Length(competitonRecord) - 1 do debugLog('competitionRecord[' + IntToStr(loop) + '].ID = ' + IntToStr(competitonRecord[loop].ID) + 'inGame = ' + BoolToStr(competitonRecord[loop].inGame));
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
            Assign(keyFile, fileLocation + 'encryption.key');
            Reset(keyFile);
            ReadLn(keyFile, key);
            Close(keyFile);
        except
            debugLog('Fail to load key file', 1);         // Handle unexpected error
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
            Assign(keyFile, fileLocation + 'encryption.key');
            Reset(keyFile);
            ReadLn(keyFile, key);
            Close(keyFile);
        except
            debugLog('error when decryption', 1, 'KEY ERROR');
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
            debugLog('Key Error', 1, 'KEY ERROR');
        end;
        debugLog('decryption successful', 3);
        dataDecryption := encryptedMessage;
    end;
procedure quickSortParticipant(start, ending : Integer ; accrodingTo : Integer = 3); // 1 = Name, 2 = School, 3 = ID, 4 = seed
    var
        pivot, wall, loop : Integer;
        temp : userData;
    begin
        wall := start;
        pivot := ending;
        if start < ending then
            begin
                debugLog('quicksort started', 3);
                for loop := start to ending - 1 do
                    begin
                        if accrodingTo = 1 then
                            begin
                                if data[pivot].Name > data[loop].Name then
                                    begin
                                    debugLog('quicksort change position', 3);
                                    temp := data[loop];
                                    data[loop] := data[wall];
                                    data[wall] := temp;
                                    wall := wall + 1;
                                    end;
                            end;
                        if accrodingTo = 2 then
                            begin
                                if data[pivot].School > data[loop].School then
                                    begin
                                    debugLog('quicksort change position', 3);
                                    temp := data[loop];
                                    data[loop] := data[wall];
                                    data[wall] := temp;
                                    wall := wall + 1;
                                    end;
                            end;
                        if accrodingTo = 3 then
                            begin
                                if StrToInt(data[pivot].ID) > StrToInt(data[loop].ID) then
                                    begin
                                    debugLog('quicksort change position', 3);
                                    temp := data[loop];
                                    data[loop] := data[wall];
                                    data[wall] := temp;
                                    wall := wall + 1;
                                    end;
                            end;
                        if accrodingTo = 4 then
                            begin
                                if data[pivot].seed < data[loop].seed then
                                    begin
                                    debugLog('quicksort change position', 3);
                                    temp := data[loop];
                                    data[loop] := data[wall];
                                    data[wall] := temp;
                                    wall := wall + 1;
                                    end;
                            end;
                    end;
                temp := data[pivot];
                data[pivot] := data[wall];
                data[wall] := temp;
                debugPrintDataID;
                quickSortParticipant(start, wall - 1, accrodingTo);
                quickSortParticipant(wall + 1, ending, accrodingTo);
            end;
    end;
procedure quickSortParallelArray(start, ending : Integer ; targetArray, prallelArray : Array of Integer); 
    var
        pivot, wall, loop, debugLoop, temp : Integer;
    begin
        wall := start;
        pivot := ending;
        if start < ending then
            begin
                debugLog('quicksort for other array started', 3);
                for loop := start to ending - 1 do
                    begin
                        if targetArray[pivot] < targetArray[loop] then
                            begin
                            debugLog('quicksort change position', 3);
                            temp := targetArray[loop];
                            targetArray[loop] := targetArray[wall];
                            targetArray[wall] := temp;
                            temp := prallelArray[loop];
                            prallelArray[loop] := targetArray[wall];
                            prallelArray[wall] := temp;
                            wall := wall + 1;
                            end;
                    end;
                temp := targetArray[pivot];
                targetArray[pivot] := targetArray[wall];
                targetArray[wall] := temp;
                temp := prallelArray[pivot];
                prallelArray[pivot] := prallelArray[wall];
                prallelArray[wall] := temp;
                debugLog('wall = ' + IntToStr(wall));
                for debugLoop := 0 to Length(targetArray) - 1 do debugLog('inputarray[' + IntToStr(debugLoop) + '] = ' + IntToStr(targetArray[debugLoop]));
                if wall - 1 > start then quickSortParallelArray(start, wall - 1, targetArray, prallelArray);
                if ending > wall + 1 then quickSortParallelArray(wall + 1, ending, targetArray, prallelArray);
            end;
            debugLog('quicksort complete');
    end;
function SearchForUser(Name : String = ''; ID : String = ''; School : String = '' ; var SearchResult : array of Integer) : Integer;
    var
        lengthOfArray, middle, top, bottom, temp, kmpLoop, kmpTargetLoop, kmpTempForTargetPointer, kmpCounter, tempForCheckResultExist : Integer;
        found, resultExist : Boolean;
        KMP, matchCount: array of Integer;
    begin
        Name := LowerCase(Name);
        School := LowerCase(School);
        lengthOfArray := -1;
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
                if found then
                    begin
                        lengthOfArray := lengthOfArray + 1;
                        SetLength(matchCount, lengthOfArray + 1);
                        matchCount[lengthOfArray] := 1;
                        SearchResult[lengthOfArray] := middle;
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
                        if LowerCase(data[temp].Name[kmpLoop]) = Name[kmpTargetLoop + 1] then
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
                            resultExist := False;
                            for tempForCheckResultExist := 0 to Length(matchCount) - 1 do
                                begin
                                    if temp = SearchResult[tempForCheckResultExist] then
                                        begin
                                            resultExist := True;
                                            matchCount[tempForCheckResultExist] := matchCount[tempForCheckResultExist] + 1;
                                            Break;
                                        end;
                                end;
                            if not resultExist then
                                begin
                                    debugLog('kmp search : Found Target, saving to array', 3);
                                    lengthOfArray := lengthOfArray + 1;
                                    SetLength(matchCount, lengthOfArray + 1);
                                    matchCount[lengthOfArray] := 1;
                                    SearchResult[lengthOfArray] := temp;
                                    debugLog('kmp save complete', 3);
                                end;
                        end;
                until temp + 1 = participantArraySize;
                debugLog('searchForUser: search name complete');
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
                        if LowerCase(data[temp].School[kmpLoop]) = School[kmpTargetLoop + 1] then
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
                            resultExist := False;
                            for tempForCheckResultExist := 0 to Length(matchCount) - 1 do
                                begin
                                    if temp = SearchResult[tempForCheckResultExist] then
                                        begin
                                            resultExist := True;
                                            matchCount[tempForCheckResultExist] := matchCount[tempForCheckResultExist] + 1;
                                            Break;
                                        end;
                                end;
                            if not resultExist then
                                begin
                                    debugLog('kmp search : Found Target, saving to array', 3);
                                    lengthOfArray := lengthOfArray + 1;
                                    SetLength(matchCount, lengthOfArray + 1);
                                    matchCount[lengthOfArray] := 1;
                                    SearchResult[lengthOfArray] := temp;
                                    debugLog('kmp save complete', 3);
                                end;
                        end;
                until temp + 1 = participantArraySize;
            end;
        debugLog('search complete, number of result = ' + IntToStr(lengthOfArray), 3);
        if lengthOfArray > 0 then
            begin
                debugLog('Checking mathcing count');
                debugLog('Lenght of SearchResult : ' + IntToStr(Length(SearchResult)));
                try
                  quickSortParallelArray(0, Length(matchCount) - 1, matchCount, SearchResult);
                except
                  debugLog('Searching check matching: i dont know why it fail... ', 2);
                end;
                debugLog('quicksort done');
                lengthOfArray := 0;
                debugLog('Start loop');
                while matchCount[lengthOfArray] = matchCount[0] do
                    begin
                        lengthOfArray := lengthOfArray + 1;
                        debugLog('looping: ' + IntToStr(lengthOfArray));
                    end;
                lengthOfArray := lengthOfArray - 1;
            end;
        SearchForUser := lengthOfArray;
        debugLog('searching complete');
        debugPrintDataID;
    end;
procedure inputDataToFile();
    var
        sourceFile : Text;
        seedText, ID, Name, School, location : String;
        loop: Integer;
        Seed : Boolean;
    begin
        Assign(sourceFile, fileLocation + 'Competitors.epd');
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
                debugLog('inputDataToFile: Id encryption successful');
                Name := dataEncryption(Name);
                debugLog('inputDataToFile: Name encryption successful');
                School := dataEncryption(School);
                debugLog('inputDataToFile: School encryption successful');
                location := dataEncryption(IntToStr(data[loop].competitionRecordPosition));
                debugLog('inputDataToFile: competitionRecordPosition encryption successful');
                seedText := dataEncryption(seedText);
                debugLog('inputDataToFile: seed encryption successful');
                Assign(sourceFile, fileLocation + 'Competitors.epd');
                Append(sourceFile);
                WriteLn(sourceFile, ID);
                WriteLn(sourceFile, Name);
                WriteLn(sourceFile, School);
                WriteLn(sourceFile, seedText);
                WriteLn(sourceFile, location);
                Close(sourceFile);
            end;
    end;
function numberOfParticipant() : Integer;
    var
        sourceFile : Text;
        temp : String;
    begin
        debugLog('numberOfParticipant: Counting Participators', 3);
        Assign(sourceFile, fileLocation + 'Competitors.epd');
        Reset(sourceFile);
        numberOfParticipant := 0;
        participantArraySize := 0;
        while not Eof(sourceFile) do
            begin
                participantArraySize := participantArraySize + 1;
                ReadLn(sourceFile, temp);
                ReadLn(sourceFile, temp);
                ReadLn(sourceFile, temp);
                ReadLn(sourceFile, temp);
                ReadLn(sourceFile, temp);
            end;
        debugLog('numberOfParticipant: number of competitors: ' + IntToStr(participantArraySize));
        Close(sourceFile);
    end;
procedure LoadParticipant();
    var
        sourceFile : Text;
        temp, temp2 : String;
        loop : Integer;
    begin
        debugLog('LoadParticipant: Start Load Participant Data', 3);
        Assign(sourceFile, fileLocation + 'Competitors.epd');
        try
            Reset(sourceFile);
            if eof(sourceFile) then debugLog('Loaded File', 3);
        except
            debugLog('LoadParticipant: No Competitors.epd found, creating one', 2);
            Rewrite(sourceFile);
        end;
        Close(sourceFile);
        Reset(sourceFile);
        numberOfParticipant();
        SetLength(data, participantArraySize);
        loop := -1;
        debugLog('Array Length Set', 3);
        while not Eof(sourceFile) do
            begin
                debugLog('LoadParticipant: Loading Data', 3);
                loop := loop + 1;
                ReadLn(sourceFile, temp);
                data[loop].ID := dataDecryption(temp);
                debugLog('LoadParticipant: Loaded ID', 3);
                ReadLn(sourceFile, temp);
                data[loop].Name := dataDecryption(temp);
                debugLog('LoadParticipant: Loaded Name', 3);
                ReadLn(sourceFile, temp);
                data[loop].School := dataDecryption(temp);
                debugLog('LoadParticipant: Loaded School', 3);
                ReadLn(sourceFile, temp2);
                temp2 := dataDecryption(temp2);
                debugLog('LoadParticipant: Loaded location', 3);
                ReadLn(sourceFile, temp);
                data[loop].competitionRecordPosition := StrToInt(dataDecryption(temp));
                if temp2 = 'True' then
                    data[loop].seed := True
                else
                    data[loop].seed := False;
                debugLog('LoadParticipant: Loaded Seed', 3);
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
            debugLog('ValidateParticipantData: search error', 1);
        end;
        if numberOfReseult >= 1 then Result := False else Result := True;
    end;
procedure loadUserName(var usrData : array of String);
    var
        sourceFile : Text;
        numberOfUser : Integer;
        temp : String;
    begin
        debugLog('loadUserName: Loading User File', 3);
        Assign(sourceFile, fileLocation + 'user.epd');
        Reset(sourceFile);
        numberOfUser := -1;
        while not Eof(sourceFile) do
            begin
                numberOfUser := numberOfUser + 1;
                    begin
                        ReadLn(sourceFile, usrData[numberOfUser]);
                        ReadLn(sourceFile, temp);
                        ReadLn(sourceFile, temp);
                    end;
            end;
        Close(sourceFile);
        debugLog('loadUserName: execute success');
    end;
function numberOfUser() : Integer;
    var
        sourceFile : Text;
        temp : String;
    begin
        AssignFile(sourceFile, fileLocation + 'user.epd');
        try
        reset(sourceFile);
        if not eof(sourceFile) then debugLog('numberOfUser: Load file successful');
        except
            debugLog('numberOfUser: user.epd missing, creating one.' , 2);
            Rewrite(sourceFile);
        end;
        Close(sourceFile);
        reset(sourceFile);
        debugLog('numberOfUser: reset success');
        numberOfUser := 0;
        try
        while not Eof(sourceFile) do
            begin
              numberOfUser := numberOfUser + 1;
              ReadLn(sourceFile, temp);
              ReadLn(sourceFile, temp);
              ReadLn(sourceFile, temp);
            end;
        except
          debugLog('numberOfUser: user.epd not found');
        end;
        Close(sourceFile);
        debugLog('numberOfUser: have ' + IntToStr(numberOfUser) + ' user');
        debugLog('numberOfUser: execute success');
    end;
function checkUserExist(usrName : String):Boolean; //Return true if user does exist
    var
        userName : array of String;
        tempForLoop : Integer;
    begin
        checkUserExist := False;
        SetLength(userName, numberOfUser + 1);
        loadUserName(userName);
        debugLog('checkUserExist: checking',3);
        if numberOfUser <= 0 then Exit;
        for tempForLoop := 0 to numberOfUser do
            begin
                debugLog('checkUserExist: checking user ' + IntToStr(tempForLoop));
                if usrName = dataDecryption(userName[tempForLoop]) then
                    begin
                        checkUserExist := True;
                        Exit;
                    end;
            end;
    end;
procedure creatAccount(isAdmin, ask : Boolean; fixedUserName : String = '');
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
                        if WinPlat then TextColor(White) else TextColor(Black);
                        inputSuccess := False
                    end;
                end;
                until inputSuccess;
            end;
        debugLog('loading File', 3);
        repeat
            if fixedUserName <> '' then userName := fixedUserName else
                begin
                    WriteLn('Enter username');
                    ReadLn(userName);
                end;
            debugLog('username entered', 3);
            temp := checkUserExist(userName);
            if temp then
                WriteLn('User Already Exist');
        until not temp;
        Assign(acFile, fileLocation + 'user.epd');
        Append(acFile);
        WriteLn(acFile, dataEncryption(userName));
        debugLog('User Name Saved', 3);
        repeat
            WriteLn('Enter password');
            ReadLn(password);
            WriteLn('ReEnter Password');
            ReadLn(valiPassword);
            debugLog('Password Entered', 3);
            if not (password = valiPassword) then
                begin
                    TextColor(Red);
                    WriteLn('Both Password Are Not The Same. Please Reenter');
                    if WinPlat then TextColor(White) else TextColor(Black);
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
procedure addParticipantData();
    var
        inputSuccess : Boolean;
        temp, temp1, temp2, temp3 : String;
        temp4, validInput : Boolean;
        tempForLoop : Integer;
    begin
        debugLog('Loading for adding participant', 3);
        debugLog('append array success', 3);
        Str(participantArraySize + 1, temp1);        
        WriteLn('input Name:');
        validInput := True;
        repeat
            try
                Readln(temp2);
                if temp2 = '' then validInput := False;
            except
                TextColor(Red);
                WriteLn('Invaild Data');
                if WinPlat then TextColor(White) else TextColor(Black);
                validInput := False;
            end;
        until validInput;
        WriteLn('input School:');
        validInput := True;
        repeat
            try
                Readln(temp3);
                if temp3 = '' then validInput := False;
            except
                TextColor(Red);
                WriteLn('Invaild Data');
                if WinPlat then TextColor(White) else TextColor(Black);
                validInput := False;
            end;
        until validInput;
        inputSuccess := False;
        tempForLoop := 0;
        temp4 := False;
        if participantArraySize > 1 then 
            begin
                quickSortParticipant(0, participantArraySize - 1, 4);
                debugPrintDataID;
                while data[tempForLoop].seed do tempForLoop := tempForLoop + 1; 
            end;
        debugPrintDataID;
        debugLog('Number of seed : ' + IntToStr(tempForLoop));
        if tempForLoop < 4 then
            begin
                repeat
                    WriteLn('Seed? [Y/N]');
                    ReadLn(temp);
                    inputSuccess := True;
                    case LowerCase(temp) of
                        'y' : temp4 := True;
                        'n' : temp4 := False;
                    else
                        begin
                            TextColor(Red);
                            WriteLn('Invaild Data');
                            if WinPlat then TextColor(White) else TextColor(Black);
                            inputSuccess := False
                        end;
                    end;
                until inputSuccess;
            end;
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
                data[participantArraySize -1].competitionRecordPosition := -1;
                quickSortParticipant(0, participantArraySize - 1);
                inputDataToFile();
                debugLog('add participant successful');
                // creatAccount(False, False, temp2); Function in dev.
            end else 
            begin
                TextColor(Red);
                WriteLn('This school already have 2 participant.');
                if WinPlat then TextColor(White) else TextColor(Black);
            end;
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
        Assign(acFile, fileLocation + 'user.epd');
        Reset(acFile);
        debugLog('Checking Ac', 3);
        repeat
            ReadLn(acFile, fileUserName);
            ReadLn(acFile, filePassword);
            ReadLn(acFile, isAdmin);
            isAdmin := dataDecryption(isAdmin);
        until (fileUserName = UserName) or Eof(acFile);
        if fileUserName <> UserName then
            begin
                writeln('Username or Password incorrect');
                debugLog('login fail, username incorrect', 2)
            end
        else if Password <> filePassword then
            begin
                writeln('Username or Password incorrect');
                debugLog('login fail, password incorrect', 2)
            end
            else begin
              loggedIn := True;
              if isAdmin = 'True' then admin := True;
              debugLog('loged in', 3);
            end;
        Close(acFile);
    end;
procedure logOut();
    begin
      loggedIn := False;
      admin := False;
    end;
procedure showParticipant();
    var
        temp : Integer;
    begin
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
procedure resetCompetitionRecordFile();
    var
        competitionRecordFile : Text;
    begin
        Assign(competitionRecordFile, fileLocation + 'competitionRecord.epd');
        Rewrite(competitionRecordFile);
        Close(competitionRecordFile);
    end;
procedure loadCompetitionRecord(round : Integer);
    var
        competitionRecordFile : Text;
        tempForLoop, tempForLoop2 : Integer;
        fileText : String;
    begin
        Assign(competitionRecordFile, fileLocation + 'competitionRecord.epd');
        Reset(competitionRecordFile);
        for tempForLoop := 0 to totalNumberOfRound - round do
            begin
                for tempForLoop2 := 0 to Length(competitonRecord) - 1 do
                    begin
                        ReadLn(competitionRecordFile, fileText);
                        TryStrToBool(dataDecryption(fileText), competitonRecord[tempForLoop2].inGame);
                    end;
            end;
        Close(competitionRecordFile);
    end;
procedure saveCompetitionRecord();
    var
        competitionRecordFile : Text;
        tempForLoop : Integer;
    begin
        Assign(competitionRecordFile, fileLocation + 'competitionRecord.epd');
        Append(competitionRecordFile);
        for tempForLoop := 0 to Length(competitonRecord) - 1 do
            begin
                WriteLn(competitionRecordFile, dataEncryption(BoolToStr(competitonRecord[tempForLoop].inGame)));
            end;
        Close(competitionRecordFile);
    end;
procedure resetCurrentCompetitionFile();
    var
        competitionRecordFile : Text;
    begin
        Assign(competitionRecordFile, fileLocation + 'currentCompetition.epd');
        Rewrite(competitionRecordFile);
        Close(competitionRecordFile);
    end;
procedure loadCurrentCompetition();
    var
        competitionRecordFile : Text;
        tempForLoop : Integer;
        fileText : String;
    begin
        Assign(competitionRecordFile, fileLocation + 'currentCompetition.epd');
        Reset(competitionRecordFile);
        for tempForLoop := 0 to Length(competitonRecord) - 1 do
            begin
                ReadLn(competitionRecordFile, fileText);
                TryStrToBool(dataDecryption(fileText), competitonRecord[tempForLoop].inGame);
            end;
        Close(competitionRecordFile);
    end;
procedure saveCurrentCompetition();
    var
        competitionRecordFile : Text;
        tempForLoop : Integer;
    begin
        Assign(competitionRecordFile, fileLocation + 'currentCompetition.epd');
        Rewrite(competitionRecordFile);
        for tempForLoop := 0 to Length(competitonRecord) - 1 do
            begin
                WriteLn(competitionRecordFile, dataEncryption(BoolToStr(competitonRecord[tempForLoop].inGame)));
            end;
        Close(competitionRecordFile);
    end;
procedure createChart(start, ending ,noOfSeed ,noOfPlayer : Integer; inputArray : array of Integer);
    var 
        tempForLoop, wall, passInArrayPointer, tempPointer, tempForCheckSchool, leftPlayer, tempForDebug : Integer;
        passInArray : array of Integer;
        sameSchool : Boolean;
    begin
        for tempForDebug := 0 to Length(inputArray) - 1 do debugLog('createChart: inputArray[' + IntToStr(tempForDebug) + '] = ' + IntToStr(inputArray[tempForDebug]));
        debugLog('createChart: start: ' + IntToStr(start));
        debugLog('createChart: ending: ' + IntToStr(ending));
        debugLog('createChart: player need to handle: ' + IntToStr(noOfPlayer));
        SetLength(passInArray, ending - start + 1);
        debugLog('createChart: array Lenght: ' + IntToStr(Length(passInArray)));
        for tempForLoop := 0 to Length(passInArray) - 1 do passInArray[tempForLoop] := -1;
        debugLog('createChart: arrat init success');
        tempForLoop := start;
        passInArrayPointer := 0;
        wall := Length(passInArray) div 2;
        tempPointer := 0;
        debugLog('createChart: wall set, value: ' + IntToStr(wall));
        debugLog('createChart: number of seed need to handle: ' + IntToStr(noOfSeed));
        while tempForLoop < (noOfSeed + start) do
            begin
                debugLog('createChart: handling seed ' + IntToStr(tempForLoop));
                passInArray[passInArrayPointer] := inputArray[tempForLoop];
                tempForLoop := tempForLoop + 1;
                passInArrayPointer := (passInArrayPointer + wall + (passInArrayPointer div wall)) mod Length(passInArray);
            end;
        quickSortParticipant(0, participantArraySize - 1, 3);
        while tempForLoop < (noOfPlayer + start) do
            begin
                debugLog('createChart: handling: ' + IntToStr(tempForLoop));
                debugLog('createChart: current pointer: ' + IntToStr(passInArrayPointer));
                if passInArrayPointer >= wall then
                    begin
                        debugLog('createChart: pointer on right side');
                        tempForCheckSchool := wall;
                        sameSchool := False;
                        while (passInArray[tempForCheckSchool] <> -1) and (tempForCheckSchool < Length(passInArray)) do
                            begin
                                if length(competitonRecord) = (ending - start + 1) then break;
                                debugLog('createChart: check same school: checking: '  + IntToStr(tempForCheckSchool));
                                if data[passInArray[tempForCheckSchool]].School = data[inputArray[tempForLoop]].School then
                                    begin
                                        sameSchool := True;
                                        Break
                                    end;
                                tempForCheckSchool := tempForCheckSchool + 1;
                            end;
                        if sameSchool then 
                            begin
                                debugLog('createChart: same school detected');
                                passInArrayPointer := 0;
                                tempPointer := 0;
                                while passInArray[passInArrayPointer] <> -1 do 
                                    begin
                                        tempPointer := tempPointer + 1;
                                        passInArrayPointer := tempPointer;
                                        debugLog(IntToStr(passInArrayPointer));
                                    end;
                                passInArray[passInArrayPointer] := inputArray[tempForLoop];
                                passInArrayPointer := (passInArrayPointer + wall + (passInArrayPointer div wall) - 2) mod Length(passInArray);
                            end
                        else
                            begin
                                debugLog('createChart: same school not detected');
                                while passInArray[passInArrayPointer] <> -1 do 
                                    begin
                                        passInArrayPointer := (passInArrayPointer + 1) mod Length(passInArray);
                                        debugLog(IntToStr(passInArrayPointer));
                                    end;
                                passInArray[passInArrayPointer] := inputArray[tempForLoop];
                                passInArrayPointer := (passInArrayPointer + wall + (passInArrayPointer div wall)) mod Length(passInArray);
                            end;
                    end
                else
                    begin
                        debugLog('createChart: pointer on left side');
                        tempForCheckSchool := 0;
                        sameSchool := False;
                        while (passInArray[tempForCheckSchool] <> -1) and (tempForCheckSchool < wall) do
                            begin
                                if length(competitonRecord) = (ending - start + 1) then break;
                                debugLog('createChart: check same school: checking: '  + IntToStr(tempForCheckSchool));
                                if data[passInArray[tempForCheckSchool]].School = data[inputArray[tempForLoop]].School then
                                    begin
                                        sameSchool := True;
                                        Break
                                    end;
                                tempForCheckSchool := tempForCheckSchool + 1;
                            end;
                        if sameSchool then 
                            begin
                                debugLog('createChart: same school detected');
                                debugLog('createChart: original pointer: ' + IntToStr(passInArrayPointer));
                                passInArrayPointer := wall;
                                debugLog('createChart: current pointer: ' + IntToStr(passInArrayPointer));
                                tempPointer := wall;
                                while passInArray[passInArrayPointer] <> -1 do 
                                    begin
                                        tempPointer := tempPointer + 1;
                                        passInArrayPointer := tempPointer;
                                        debugLog(IntToStr(passInArrayPointer));
                                    end;
                                passInArray[passInArrayPointer] := inputArray[tempForLoop];
                                passInArrayPointer := (passInArrayPointer + wall + (passInArrayPointer div wall) - 2) mod Length(passInArray);
                            end
                        else
                            begin
                                debugLog('createChart: same school not detected');
                                while passInArray[passInArrayPointer] <> -1 do 
                                    begin
                                        passInArrayPointer := (passInArrayPointer + 1) mod Length(passInArray);
                                        debugLog(IntToStr(passInArrayPointer));
                                    end;
                                passInArray[passInArrayPointer] := inputArray[tempForLoop];
                                passInArrayPointer := (passInArrayPointer + wall + (passInArrayPointer div wall)) mod Length(passInArray);
                            end;
                    end;
                for tempForDebug := 0 to Length(passInArray) - 1 do debugLog('createChart: passInArray[' + IntToStr(tempForDebug) + '] = ' + IntToStr(passInArray[tempForDebug]));
                tempForLoop := tempForLoop + 1;
            end;
        leftPlayer := 0;
        while passInArray[leftPlayer] <> -1 do 
            begin
                if leftPlayer = wall then Break;
                leftPlayer := leftPlayer + 1;
            end;
        debugLog('createChart: leftPlayer : ' + IntToStr(leftPlayer));
        if ending - start > 1 then
            begin
                debugLog('createChart: not smallest group, looping');
                createChart(0, wall - 1, noOfSeed - noOfSeed div 2, leftPlayer, passInArray);
                createChart(wall, Length(passInArray) - 1, noOfSeed div 2, noOfPlayer - leftPlayer, passInArray);
            end
        else 
            begin
                passInArrayPointer := 0;
                for passInArrayPointer := 0 to 1 do 
                    begin
                        debugLog('createChart: adding ' + IntToStr(passInArray[passInArrayPointer]) + ' to competitionRecord[' + IntToStr(competitonRecordPointer) + ']');
                        competitonRecord[competitonRecordPointer].ID := passInArray[passInArrayPointer];
                        if passInArray[passInArrayPointer] <> -1 then competitonRecord[competitonRecordPointer].inGame := True;
                        competitonRecordPointer := competitonRecordPointer + 1;
                    end;
                debugLog('createChart: smallest group, imported, array now is in size of: ' + IntToStr(competitonRecordPointer));
                for wall := 0 to competitonRecordPointer - 1 do debugLog('debug array: competitionRecord.ID[' + IntToStr(wall) + '] = ' + IntToStr(competitonRecord[wall].ID));
            end;
    end;
procedure startCreatingChart();
    var
        passInArray : Array of Integer;
        tempForLoop, passInNoSeed : Integer;
    begin
        competitonRecordPointer := 0;
        createdChart := True;
        debugLog('Chart gen: Start init');
        SetLength(competitonRecord, ceil(power(2, ceil(log2(participantArraySize)))));
        totalNumberOfRound := ceil(log2(participantArraySize));
        currentRound := totalNumberOfRound;
        debugLog('Number of round = ' + IntToStr(totalNumberOfRound));
        debugLog('Chart gen: create output array success');
        SetLength(passInArray, Length(competitonRecord));
        for tempForLoop := 0 to Length(passInArray) - 1 do passInArray[tempForLoop] := -1;
        for tempForLoop := 0 to Length(competitonRecord) - 1 do competitonRecord[tempForLoop].ID := -1;
        for tempForLoop := 0 to Length(competitonRecord) - 1 do competitonRecord[tempForLoop].inGame := False;
        debugLog('Chart gen: passIn array set lenght and init success, lenght set to: ' + IntToStr(Length(passInArray)));
        quickSortParticipant(0, participantArraySize - 1, 4);
        debugLog('Chart gen: quickSort success');
        debugPrintDataID;
        for tempForLoop := 0 to Length(data) - 1 do
            begin
                debugLog('looping: ' + IntToStr(tempForLoop));
                passInArray[tempForLoop] := StrToInt(data[tempForLoop].ID) - 1;
            end;
        debugLog('Chart gen: imported raw data to passIn array');
        passInNoSeed := 0;
        while data[passInNoSeed].seed do passInNoSeed := passInNoSeed + 1;
        debugLog('Chart gen: counted number of seed as: ' + IntToStr(passInNoSeed));
        debugLog('Chart gen: creating chart');
        try
            createChart(0, Length(passInArray) - 1, passInNoSeed, tempForLoop + 1, passInArray);
        except
            debugLog('Chart gen: gen chart error', 1);
        end;
        debugLog('Chart gen: creat chart successfully');
    end;

procedure ShowChart(print : Boolean = True);
    var
        temp, wall, groupSize, groupPointer, tempForLoop, nextPointer, printPaticipent, currentParticipant, loopingRound : Integer;
        validation : String;
        correctInput, startNextRound : Boolean;   
    begin
        if Length(data) < 4 then
            begin
                debugLog('Cant generate chart, competitors not enough');
                WriteLn('Cant generate chart, competitors not enough');
            end
        else
            begin
                if not createdChart then
                    begin
                        if not admin then 
                            begin
                                WriteLn('Invalid Input (Permission Denied)');
                                exit;
                            end;
                        TextColor(Red);
                        WriteLn('Notice: After creating the chart, you can not add participant anymore.');
                        WriteLn('Are you sure to continue? [Y/N]');
                        if WinPlat then TextColor(White) else TextColor(Black);
                        repeat
                            ReadLn(validation);
                            correctInput := True;
                            case LowerCase(validation) of 
                                'y' : ;
                                'n' : exit;
                            else
                                correctInput := False;
                                WriteLn('Invalid Choice');
                            end;
                        until correctInput;
                    WriteLn('loading...');
                    end;
                        if not createdChart then 
                            begin
                                startCreatingChart;
                                saveCurrentCompetition();
                            end;
                        quickSortParticipant(0, Length(data) - 1, 3);
                        debugPrintDataID;
                        loopingRound := totalNumberOfRound + 1;
                        repeat
                            if loopingRound = 1 then Break;
                            numOfFinishedGroup := 0;
                            nextPointer := 0;
                            loopingRound := loopingRound - 1;
                            if (loopingRound > currentRound) and (currentRound <> 0) then loadCompetitionRecord(loopingRound);
                            if ((loopingRound = currentRound) and (currentRound <> 0)) and (currentRound <> totalNumberOfRound) then loadCurrentCompetition;
                            debugLog('ShowChart: load success');
                            debugPrintDataID;
                            startNextRound := False;
                            if print then WriteLn;
                            if print then WriteLn('----------------------Round ' + IntToStr(totalNumberOfRound - loopingRound + 1) + '---------------------------');
                            if print then WriteLn;
                            wall := Length(competitonRecord);
                            for tempForLoop := 1 to loopingRound do wall := wall div 2;
                            debugLog('ShowChart: wall = ' + IntToStr(wall));
                            groupSize := ceil(power(2, totalNumberOfRound - loopingRound + 1));
                            debugLog('ShowChart: groupSize = ' + IntToStr(groupSize));
                            groupPointer := groupSize - 1;
                            debugLog('ShowChart: currentRound: ' + IntToStr(loopingRound));
                            debugLog('ShowChart: ' + IntToStr(totalNumberOfRound - loopingRound + 1));
                            for temp := 0 to Length(competitonRecord) div Round(power(2,(totalNumberOfRound - loopingRound))) -1 do
                                begin
                                    debugLog('ShowChart: groupPointer: ' + IntToStr(groupPointer));
                                    debugLog('ShowChart: compair: ' + IntToStr(temp));
                                    while groupPointer < nextPointer do
                                        begin
                                            groupPointer := groupPointer + groupSize;
                                            wall := wall + groupSize;
                                        end;
                                    debugLog('finish loop');
                                    if loopingRound <> totalNumberOfRound then loadCompetitionRecord(loopingRound + 1);
                                    if nextPointer < wall then
                                        begin
                                            debugLog('ShowChart: nextPointer smaller then wall. nextPointer = ' + IntToStr(nextPointer) + ' wall = ' + IntToStr(wall) + ' groupPointer = ' + IntToStr(groupPointer));
                                            for tempForLoop := nextPointer to wall - 1 do
                                                begin
                                                    printPaticipent := tempForLoop;
                                                    if competitonRecord[printPaticipent].inGame then break;
                                                end;
                                        end
                                    else
                                        begin
                                            debugLog('ShowChart: nextPointer bigger then wall. nextPointer = ' + IntToStr(nextPointer) + ' wall = ' + IntToStr(wall) + ' groupPointer = ' + IntToStr(groupPointer));
                                            for tempForLoop := wall to groupPointer do
                                                begin
                                                    printPaticipent := tempForLoop;
                                                    debugPrintDataID;
                                                    debugLog('ShowChart: Checking participant ID ' + IntToStr(competitonRecord[printPaticipent].ID) + ' is in game or not.');
                                                    if competitonRecord[printPaticipent].inGame then break;
                                                end;
                                            debugLog('found participant, participant ID = ' + IntToStr(competitonRecord[printPaticipent].ID));
                                        end;
                                    currentParticipant := printPaticipent;
                                    if competitonRecord[printPaticipent].ID <> -1 then
                                        begin
                                            Write(data[competitonRecord[printPaticipent].ID].Name);
                                            if data[competitonRecord[printPaticipent].ID].Seed then Write('*');
                                            if print then WriteLn('(' + data[competitonRecord[printPaticipent].ID].School + ')' :10);
                                        end
                                    else
                                        if print then Writeln('Bye');
                                    if loopingRound <> totalNumberOfRound then loadCurrentCompetition;
                                    if not Odd(temp) then
                                        begin
                                            Write('V.S');
                                            Write('|-' : 20);
                                            for tempForLoop := wall to groupPointer do
                                                begin
                                                    printPaticipent := tempForLoop;
                                                    if competitonRecord[printPaticipent].inGame then break;
                                                end;
                                                debugLog('found opp, participant ID = ' + IntToStr(competitonRecord[printPaticipent].ID));
                                                debugPrintDataID;
                                            if not (competitonRecord[currentParticipant].inGame = competitonRecord[printPaticipent].inGame) then
                                            begin
                                                numOfFinishedGroup := numOfFinishedGroup + 1;
                                                if competitonRecord[currentParticipant].inGame then
                                                    begin
                                                        if competitonRecord[currentParticipant].ID <> -1 then 
                                                        begin
                                                            Write(data[competitonRecord[currentParticipant].ID].Name);
                                                            if data[competitonRecord[currentParticipant].ID].Seed then Write('*');
                                                            Write('(' + data[competitonRecord[currentParticipant].ID].School + ')' :10);
                                                        end
                                                        else Write('bye');  
                                                    end
                                                else
                                                    begin
                                                        if competitonRecord[printPaticipent].ID <> -1 then 
                                                        begin
                                                            Write(data[competitonRecord[printPaticipent].ID].Name);
                                                            if data[competitonRecord[printPaticipent].ID].Seed then Write('*');
                                                            Write('(' + data[competitonRecord[printPaticipent].ID].School + ')' :10);
                                                        end
                                                        else Write('bye');  
                                                    end
                                            end;
                                            if print then WriteLn();
                                        end
                                    else
                                        begin
                                            if print then Writeln();
                                            if print and WinPlat then ReadLn
                                        end;
                                    if nextPointer < wall then nextPointer := wall else nextPointer := groupPointer + 1;
                                    if (numOfFinishedGroup = (Length(competitonRecord) div (2 * (totalNumberOfRound - loopingRound + 1)))) or (currentRound < loopingRound) then startNextRound := True else startNextRound := False;
                                    debugLog('ShowChart: nextPointer: ' + IntToStr(nextPointer));
                                end;
                        until (not startNextRound);
                        if loopingRound < currentRound then 
                        begin
                            currentRound := loopingRound;
                            saveCompetitionRecord();
                            for tempForLoop := 0 to Length(competitonRecord) - 1 do
                                begin
                                    if competitonRecord[tempForLoop].ID = -1 then competitonRecord[tempForLoop].inGame := False;
                                end;
                        end;
        end;
    end;
function SearchMenu2(var passInArray : Array of Integer) : Integer;
    var
        ID, Name, School : String;
        temp, temp2 : Integer;
    begin
        for temp2 := 1 to Length(passInArray) - 1 do
            begin
                passInArray[temp2] := -1;
            end;
        writeln('Leave it blank if you dont know');
        write('ID : ');
        ReadLn(ID);
        Write('Name : ');
        ReadLn(Name);
        Write('School : ');
        ReadLn(School);
        temp2 := SearchForUser(Name, ID, School, passInArray);
        SearchMenu2 := temp2;
        debugLog('Search complete', 3);
        if temp2 = -1 then WriteLn('No player founded');
        debugLog('searchMenu2: number of result: ' + IntToStr(temp2));
        for temp := 0 to temp2 do
            begin
                Write(' ID: ');
                Write(data[passInArray[temp]].ID :8);
                Write(' Name: ');
                Write(data[passInArray[temp]].Name :8);
                Write(' School: ');
                Write(data[passInArray[temp]].School :8);
                Write(' Seed: ');
                WriteLn(data[passInArray[temp]].seed :8);
            end;
    end;
procedure DeleteCompetitor();
    var
        serachResultArray : Array of Integer;
        searchResultNumber, targetID, tempForLoop : Integer;
        correctInput, confirmInput : Boolean;
        confirmInputText : String;
    begin
        SetLength(serachResultArray, participantArraySize);
        searchResultNumber := SearchMenu2(serachResultArray);
        debugLog('DeleteCompetitor: search result number = ' + IntToStr(searchResultNumber));
        if searchResultNumber >= 0 then
            begin
                if searchResultNumber = 0 then targetID := serachResultArray[0]
                else
                    begin
                        Write('Please enter the ID of the correct participant: ');
                        repeat
                            correctInput := True;
                            ReadLn(targetID);
                            if (targetID < 0) or (targetID >= participantArraySize) then
                                begin
                                    WriteLn('Input error!');
                                    Write('Please enter the ID of the correct participant: ');
                                end;  
                        until correctInput;
                        targetID := targetID - 1;
                    end;
                repeat
                    Write('Are You Sure To Delete This Participant? [Y/N] : ');
                    correctInput := True;
                    ReadLn(confirmInputText);
                    confirmInput := False;
                    case LowerCase(confirmInputText) of
                        'y' : confirmInput := True;
                        'n' : exit;
                    else
                        correctInput := False;
                        WriteLn('Invalid input');
                    end;
                until correctInput;
                quickSortParticipant(0, participantArraySize - 1);
                if confirmInput then
                    begin
                        debugLog('DeleteCompetitor: start deleting competitor ID: ' + IntToStr(targetID));
                        if targetID <> participantArraySize then 
                            begin
                                for tempForLoop := targetID + 1 to participantArraySize - 1 do
                                begin
                                    data[tempForLoop - 1] := data[tempForLoop];
                                    data[tempForLoop - 1].ID := IntToStr(tempForLoop);
                                end;
                            end;
                        participantArraySize := participantArraySize - 1;
                        SetLength(data, participantArraySize);
                        debugLog('delete user success');
                        writeln('Deleted user');
                        inputDataToFile;
                    end;
            end
            else WriteLn('No Competitor Found');
    end;
procedure EditCompetitorName();
    var
        serachResultArray : Array of Integer;
        searchResultNumber, targetID : Integer;
        newName : String;
        correctInput : Boolean;
    begin
        SetLength(serachResultArray, participantArraySize);
        searchResultNumber := SearchMenu2(serachResultArray);
        debugLog('DeleteCompetitor: search result number = ' + IntToStr(searchResultNumber));
        if searchResultNumber >= 0 then
            begin
                if searchResultNumber = 0 then targetID := serachResultArray[0]
                else
                    begin
                        Write('Please enter the ID of the correct participant: ');
                        repeat
                            correctInput := True;
                            try
                                ReadLn(targetID);
                            except
                                debugLog('EditCompetitorName: invalid input of targetID');
                                WriteLn('invalid input');
                            end;
                            if (targetID < 0) or (targetID >= participantArraySize) then
                                begin
                                    WriteLn('invalid input!');
                                    Write('Please enter the ID of the correct participant: ');
                                end;  
                        until correctInput;
                        targetID := targetID - 1;
                    end;
                WriteLn('Enter new name for this participant: ');
                ReadLn(newName);
                data[targetID].Name := newName;
                inputDataToFile;
                WriteLn('Competitor Name Changed');
            end
        else WriteLn('No Competitor Found');
    end;
procedure EditCompetitorSeed();
    var
        serachResultArray : Array of Integer;
        searchResultNumber, targetID, numberOfSeed : Integer;
        newSeed : String;
        correctInput, newSeedStat : Boolean;
    begin
        quickSortParticipant(0, participantArraySize - 1, 4);
        numberOfSeed := 0;
        while data[numberOfSeed].seed do numberOfSeed := numberOfSeed + 1;
        quickSortParticipant(0, participantArraySize - 1);
        SetLength(serachResultArray, participantArraySize);
        searchResultNumber := SearchMenu2(serachResultArray);
        debugLog('DeleteCompetitor: search result number = ' + IntToStr(searchResultNumber));
        if searchResultNumber >= 0 then
            begin
                if searchResultNumber = 0 then targetID := serachResultArray[0]
                else
                    begin
                        Write('Please enter the ID of the correct participant: ');
                        repeat
                            correctInput := True;
                            try
                                ReadLn(targetID);
                            except
                                debugLog('EditCompetitorName: invalid input of targetID');
                                WriteLn('invalid input');
                            end;
                            if (targetID < 0) or (targetID >= participantArraySize) then
                                begin
                                    WriteLn('invalid input!');
                                    Write('Please enter the ID of the correct participant: ');
                                end;  
                        until correctInput;
                        targetID := targetID - 1;
                    end;
                repeat
                    WriteLn('Enter new seed for this participant[Y/N] : ');
                    correctInput := True;
                    ReadLn(newSeed);
                    case LowerCase(newSeed) of
                        'y' : newSeedStat := True;
                        'n' : newSeedStat := False;
                    else
                        WriteLn('invalid input');
                        correctInput := False;
                    end;
                until correctInput;
                if (newSeedStat = True) and (numberOfSeed >= 4) then
                    begin
                        TextColor(Red);
                        Writeln('Number of seed already reaches maximum number.');
                        if WinPlat then TextColor(White) else TextColor(Black);
                        Exit;
                    end;
                data[targetID].seed := newSeedStat;
                inputDataToFile;
                WriteLn('Competitor Seed Changed');
            end
        else WriteLn('No Competitor Found');
    end;
procedure EditCompetitorSchool();
    var
        serachResultArray : Array of Integer;
        searchResultNumber, targetID : Integer;
        newSchool : String;
        correctInput : Boolean;
    begin
        SetLength(serachResultArray, participantArraySize);
        searchResultNumber := SearchMenu2(serachResultArray);
        debugLog('DeleteCompetitor: search result number = ' + IntToStr(searchResultNumber));
        if searchResultNumber >= 0 then
            begin
                if searchResultNumber = 0 then targetID := serachResultArray[0]
                else
                    begin
                        Write('Please enter the ID of the correct participant: ');
                        repeat
                            correctInput := True;
                            try
                                ReadLn(targetID);
                            except
                                debugLog('EditCompetitorName: invalid input of targetID');
                                WriteLn('invalid input');
                            end;
                            if (targetID < 0) or (targetID >= participantArraySize) then
                                begin
                                    WriteLn('invalid input!');
                                    Write('Please enter the ID of the correct participant: ');
                                end;  
                        until correctInput;
                        targetID := targetID - 1;
                    end;
                WriteLn('Please enter the new school name : ');
                ReadLn(newSchool);
                searchResultNumber := SearchForUser('', '', newSchool, serachResultArray);
                if searchResultNumber >= 1 then
                    begin
                        TextColor(Red);
                        WriteLn('This school already have 2 participant.');
                        if WinPlat then TextColor(White) else TextColor(Black);
                        Exit;
                    end;
                data[targetID].School := newSchool;
                inputDataToFile;
                WriteLn('Competitor School Changed');
                
            end
        else WriteLn('No Competitor Found');
    end;
procedure CompetitorManagementMenu();
    var
        choice : Integer;
        inputCorrect : Boolean;
    begin
        ClrScr;
        repeat
            Writeln('1. Change Competitor Name');
            WriteLn('2. Change Competitor School');
            WriteLn('3. Change Competitor Seed Status');
            Writeln('4. Delete Competitor');
            Writeln('5. Add Competitor');
            Writeln('9. Back To Main Screen');
            WriteLn;
            Write('Your Choice: ');
            inputCorrect := True;
            try
                ReadLn(choice);
            except
                WriteLn('invalid input!');
                inputCorrect := False;
            end;
            ClrScr;
            case choice of
                1 : EditCompetitorName;
                2 : EditCompetitorSchool;
                3 : EditCompetitorSeed;
                4 : DeleteCompetitor;
                5 : addParticipantData;
                9 : exit; 
            else
                inputCorrect := False;
                WriteLn('invalid input!');
            end;
        until inputCorrect;
        TextColor(Green);
        if choice <> 9 then WriteLn('press enter to continue');
        if WinPlat then TextColor(White) else TextColor(Black);
        if choice <> 9 then ReadLn;
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
        if temp2 = -1 then WriteLn('No Player Found');
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
procedure addCompetitonResult();
    var
        ID, Name, School, input : String;
        tempArray : Array of Integer;
        temp2, temp, targetParticipant, findTargetParticipantGroup, sameGroupParticipant, wall, tempForLoop, groupSize, groupPointer : Integer;
        inputOfContinue, inputCorrect, inputResult : Boolean;
    begin
        if Round(power(2, currentRound - 1)) = numOfFinishedGroup then ShowChart(False);
        if not createdChart then exit;
        WriteLn('Loading...');
        ClrScr;
        debugLog('currentRound = ' + IntToStr(currentRound));
        if (currentRound = 1) and (numOfFinishedGroup <> 0) then
            begin
                WriteLn('Already have winner!');
                exit;
            end;
        wall := Length(competitonRecord);
        for tempForLoop := 1 to currentRound do wall := wall div 2;
        debugLog('addCompetitionResult: wall = ' + IntToStr(wall));
        groupSize := ceil(power(2, ceil(log2(Length(competitonRecord))) - currentRound + 1));
        debugLog('addCompetitionResult: groupSize = ' + IntToStr(groupSize));
        groupPointer := groupSize - 1;
        WriteLn('Please enter the following information of the participants: ');
        writeln('Leave it blank if you dont know');
        write('ID : ');
        ReadLn(ID);
        Write('Name : ');
        ReadLn(Name);
        Write('School : ');
        ReadLn(School);
        SetLength(tempArray, participantArraySize);
        temp2 := SearchForUser(Name, ID, School, tempArray);
        debugLog('addCompetitionResult: Search complete');
        if temp2 < 0 then
        begin
            writeln('No User Found.');
            exit;
        end;
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
        if temp2 > 0 then
            begin
                debugLog('addCompetitionResult: multiple search result');
                Write('Please enter the ID of the correct participant: '); 
                repeat
                    inputCorrect := True;
                    Readln(targetParticipant);
                    if (targetParticipant < 1) or (targetParticipant > Length(data)) then
                    begin
                        inputCorrect := False;
                        WriteLn('invalid input!');
                    end;
                until inputCorrect;
                targetParticipant := targetParticipant - 1;
                quickSortParticipant(0,participantArraySize - 1, 3);
                Write(' ID: ');
                Write(data[targetParticipant].ID :8);
                Write(' Name: ');
                Write(data[targetParticipant].Name :8);
                Write(' School: ');
                Write(data[targetParticipant].School :8);
                Write(' Seed: ');
                WriteLn(data[targetParticipant].seed :8);
            end else targetParticipant := StrToInt(data[tempArray[0]].ID) - 1;
        debugLog('target id = ' + IntToStr(targetParticipant));
        for findTargetParticipantGroup := 0 to Length(competitonRecord) - 1 do
            begin
                debugLog('competitonRecord[' + IntToStr(findTargetParticipantGroup) + '].ID = ' + IntToStr(competitonRecord[findTargetParticipantGroup].ID));
                if competitonRecord[findTargetParticipantGroup].ID = targetParticipant then Break;
            end;
        debugLog('addCompetitionResult: Traget group is ' + IntToStr(findTargetParticipantGroup));
        while groupPointer < findTargetParticipantGroup do
            begin
                groupPointer := groupPointer + groupSize;
                wall := wall + groupSize;
            end;
        debugLog('addCompetitionResult: groupPointer = ' + IntToStr(groupPointer));
        debugLog('addCompetitionResult: wall = ' + IntToStr(wall));
        if findTargetParticipantGroup < wall then
            begin
                debugLog('target is smaller than wall');
                for tempForLoop := wall to groupPointer do 
                    begin
                        sameGroupParticipant := tempForLoop;
                        if competitonRecord[sameGroupParticipant].inGame then Break;
                    end;
            end
        else
            begin
                debugLog('target is larger than wall');
                debugLog('loopFrom: ' + IntToStr(groupPointer - groupSize + 1) + ' to: ' + IntToStr(wall-1));
                for tempForLoop := groupPointer - groupSize + 1 to wall - 1 do
                begin
                    sameGroupParticipant := tempForLoop;
                    if competitonRecord[sameGroupParticipant].inGame then Break;
                end;
            end;
        debugLog('addCompetitionResult: Same group particiapnt is ' + IntToStr(sameGroupParticipant));
        if competitonRecord[sameGroupParticipant].inGame <> competitonRecord[findTargetParticipantGroup].inGame then
            begin
                repeat
                inputCorrect := True;
                WriteLn('This participant already have the latest record. Are you sure to overwrite it?(If the participant leave the game, please overwrite.)[Y/N]');
                ReadLn(input);
                case LowerCase(input) of 
                    'y' : inputOfContinue := True;
                    'n' : inputOfContinue := False;
                else
                    WriteLn('Invalid input!');
                    inputCorrect := False;
                end;
                until inputCorrect;
            end else inputOfContinue := True;
        if not inputOfContinue then exit;
        repeat
            inputCorrect := True;
            WriteLn('Does this participant win the previous game? [Y/N] ');
            ReadLn(input);
            case LowerCase(input) of 
                'y' : inputResult := True;
                'n' : inputResult := False;
            else
                WriteLn('Invalid input!');
                inputCorrect := False;
            end;
        until inputCorrect;
        competitonRecord[sameGroupParticipant].inGame := not inputResult;
        competitonRecord[findTargetParticipantGroup].inGame := inputResult;
        saveCurrentCompetition();
        if competitonRecord[sameGroupParticipant].inGame <> competitonRecord[findTargetParticipantGroup].inGame then numOfFinishedGroup := numOfFinishedGroup + 1;
        Writeln('Input Success');
        debugPrintDataID;
        saveCurrentCompetition;
    end;
procedure aboutProgram();
    begin
        writeln('This program is developed by Samuel Chan Sze Nok.');
        writeln('This is an open source project, you may download the code from here: https://github.com/samuelch727/SBA');
        writeln('If you find any bug, plese report to me through the above link.');
        WriteLn('Status: In development');
        Writeln('Version: ' + version);
        WriteLn('COPYRIGHT 2018-2019 SAMUEL CHAN SZE NOK ALL RIGHTS RESERVED');
        WriteLn
    end;
procedure Mainmenu();
    var
        choice : Integer;
        temp : String;
    begin
        repeat
            ClrScr;
            temp := '';
            if debugMode then WriteLn('In debug mode');
            if loggedIn then WriteLn('1. Logout AC') else WriteLn('1. Login AC');
            WriteLn('2. View Competitors');
            if loggedIn then WriteLn ('3. Manage Competitor');
            if admin then WriteLn('4. Add Account');
            WriteLn('5. Search for user');
            if admin or createdChart then WriteLn('6. Create / View chart');
            if admin then WriteLn('7. Enter result');
            WriteLn('8. About Program');
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
            ClrScr;
            case choice of
                1 : if loggedIn then logOut else logIn;
                2 : showParticipant();
                3 : if loggedIn then CompetitorManagementMenu else WriteLn('Invalid choice');
                4 : if admin then creatAccount(False, True) else WriteLn('Invalid choice');
                5 : SearchMenu();
                6 : ShowChart;
                7 : if admin then addCompetitonResult else WriteLn('Invalid choice');
                8 : aboutProgram;
                9 : begin debugLog('Program ended', 3); Break; end;
                3223 : debugMode := not debugMode;
            else
                begin
                    TextColor(Red);
                    debugLog('User Entered Invalid Option in Mainmenu', 2);
                    WriteLn('Invalid choice');
                end;
            end;
            if programErrorBreak then exit;
            TextColor(Green);
            if choice <> 3 then WriteLn('press enter to continue');
            if WinPlat then TextColor(White) else TextColor(Black);
            if choice <> 3 then ReadLn;
        until choice = 9;
    end;

begin
    programErrorBreak := False;
    WinPlat := False;
    fileLocation := ParamStr(0);
    if WinPlat then Delete(fileLocation, Length(fileLocation) - 7, 8) else Delete(fileLocation, Length(fileLocation) - 3, 4);
    if WinPlat then fileLocation := fileLocation + 'File\' else fileLocation := fileLocation + '/File/';
    Write('file location: ');
    WriteLn(fileLocation);
    If not DirectoryExists(fileLocation) then
        if CreateDir(fileLocation) then debugLog('Create dir success') else debugLog('Fail to create dir', 1);
    ClearDebugLog;
    debugMode := True;
    debugLog('Start initalization');
    debugMode := False;
    resetCompetitionRecordFile;
    resetCurrentCompetitionFile;
    totalNumberOfRound := 0;
    currentRound := 0;
    createdChart := False;
    version := '1.2.1-Alpha';
    try
        LoadParticipant;
    except
        debugLog('Initalization: File corruption detected', 1, 'FILE CORRUPTION');
    end;
    try
        quickSortParticipant(0, participantArraySize - 1);
    except
        debugLog('quick sort error', 1);
    end;
    debugPrintDataID;
    loggedIn := False;
    admin := False;
    if numberOfUser = 0 then 
        begin
            debugLog('No user account found, creating account');
            Writeln('No user account found! Please create one.');
            creatAccount(True, False);
        end;
    try
    Mainmenu();
    except
        debugLog('Unknow error', 1, '001');
    end;
end.
