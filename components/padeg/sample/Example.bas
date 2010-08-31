' Пример обращения к функциям DLL GetFIOPadegFSAS и GetNominativePadeg
' Обращение к другим функциям выполняется аналогично

Option Explicit

' Функция склонения ФИО с автоматическим определением пола по отчеству
' Параметры: pFIO    - фамилия, имя, отчество
'            nPadeg  - падеж (допустимые значения: 1..6)
'            pResult - буфер результата
'            nLen    - размер буфера (после преобразования - длина результата)
' Значение:  0 - успешное завершение
'           -1 - недопустимое значение падежа
'           -3 - результат не поместился в буфере

Private Declare Function GetPadeg Lib "Padeg.dll" Alias "GetFIOPadegFSAS" _
  (ByVal pFIO As String, ByVal nPadeg As Long, ByVal pResult As String, _
   ByRef nLen As Long) As Integer

' Функция восстановления именительного падежа
' Параметры: pFIO    - фамилия, имя, отчество
'            pResult - буфер результата
'            nLen    - размер буфера (после преобразования - длина результата)
' Значение:  0 - успешное завершение
'           -3 - результат не поместился в буфере

Private Declare Function GetNominativePadeg Lib "Padeg.dll" _
  (ByVal pFIO As String, ByVal pResult As String, ByRef nLen As Long) As Integer

' Функция преобразования cFIO в падеж nPadeg
Public Function MakePadeg(ByVal cFIO As String, ByVal nPadeg As Long) As String
Dim tmpS As String
Dim nLen As Long
Dim RetVal As Integer
  nLen = 255
  tmpS = String(nLen, 0)
  RetVal = GetPadeg(cFIO, nPadeg, tmpS, nLen)
  If RetVal = -1 Then MsgBox "Недопустимое значение падежа - " & _
                             "(" & nPadeg & ")", , "Склонение ФИО"
  MakePadeg = Mid(tmpS, 1, nLen)
End Function

' Функция восстановления именительного падежа
Public Function Nominative(ByVal cFIO As String) As String
Dim tmpS As String
Dim nLen As Long
Dim RetVal As Integer
  nLen = 255
  tmpS = String(nLen, 0)
  RetVal = GetNominativePadeg(cFIO, tmpS, nLen)
  Nominative = Mid(tmpS, 1, nLen)
End Function

' Функция восстановления именительного падежа с использованием локальной базы ФИО
' Параметры: cFIO      - ФИО в произвольном падеже
'            TableNmae - имя таблицы, содержащей ФИО
'            Exact     - признак того, что ФИО есть в базе         
Public Function NominativeByBase(ByVal cFIO As String, TableName As String, _
                                 Exact As Boolean) As String
Dim sqlStr As String, Mask As String, tmpS As String
Dim rst As Recordset, i As Integer, nLen As Integer
Dim LocalFIO As String

  tmpS = Mid(cFIO, 1, InStr(cFIO, " ") - 1)     ' выделим фамилию
  If Len(tmpS) > 4 Then nLen = Len(tmpS) - 4 _
                   Else nLen = 1
  Mask = Mid(tmpS, 1, nLen) & "*"               ' определим маску ФИО для запроса
  
  ' пусть имеется таблица с полями "Фамилия", "Имя" и "Отчество"
  ' для конкретной таблицы необходимо отредактировать имена полей
  sqlStr = "SELECT Фамилия, Имя, Отчество FROM [" & TableName & "] " & _
           "WHERE (Фамилия Like '" & Mask & "');"
  
  Set rst = CurrentDb.OpenRecordset(sqlStr)
  If rst.RecordCount > 0 Then rst.MoveFirst
  
  Exact = False                       ' ФИО в базе данных нет
  While Not rst.EOF                   ' для всех ФИО из запроса к базе
    ' сформируем локальное ФИО
    LocalFIO = rst!Фамилия & " " & rst!Имя & " " & rst!Отчество
    For i = 1 To 6
      tmpS = MakePadeg(LocalFIO, i)   ' выполним склонение локального ФИО во все падежи
      If tmpS = cFIO Then             ' сравним с исходным
        NominativeByBase = LocalFIO   ' результат склонения совпал
        Exact = True                  ' ФИО есть в базе данных
        rst.Close
        Exit Function
      End If
    Next i
    rst.MoveNext
  Wend
  rst.Close
  ' если попали сюда, значит: 1. в базе не нашлось подходящего ФИО
  '                           2. ФИО для восстановления задано с ошибкой
  '                           3. ФИО из базы склоняется с ошибкой
  ' в этом случае определяем им. падеж функцией DLL (возможна ошибка восстановления)
  NominativeByBase = Nominative(cFIO) 
End Function
