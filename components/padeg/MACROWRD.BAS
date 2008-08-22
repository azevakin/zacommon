' Макросы склонения фамилий, имен и отчеств
' Copyright (c) 2001 Gennady Pokatashkin e-mail: pgl@gsu.unibel.by
'                    Sergey Plahov e-mail: S.Plahov@vaz.ru


Option Explicit

' Функция склонения ФИО с автоматическим определением пола по отчеству
' Параметры: pFIO    - фамилия, имя, отчество
'            nPadeg  - падеж (допустимые значения: 1..6)
'            pResult - буфер результата
'            nLen    - длина результата
' Значение:  0 - успешное завершение
'           -1 - недопустимое значение падежа
'           -3 - результат не помещается в буфере
Private Declare Function GetPadeg Lib "Padeg.dll" Alias "GetFIOPadegFSAS" _
  (ByVal pFIO As String, ByVal nPadeg As Long, ByVal pResult As String, ByRef nLen As Long) As Integer

' Функция восстановления именительного падежа
' Параметры: pFIO    - фамилия, имя, отчество
'            pResult - буфер результата
'            nLen    - размер буфера (после преобразования - длина результата)
' Значение:  0 - успешное завершение (всегда)
Private Declare Function GetNominativePadeg Lib "Padeg.dll" _
  (ByVal pFIO As String, ByVal pResult As String, ByRef nLen As Long) As Integer

' Функция преобразования cFIO в падеж nPadeg
Public Function MakePadeg(ByVal cFIO As String, ByVal nPadeg As Long) As String
Dim tmpS As String
Dim nLen As Long
Dim RetVal As Integer
  If Len(cFIO) = 1 Then Exit Function
  nLen = 255
  tmpS = String(nLen, 0)
  RetVal = GetPadeg(cFIO, nPadeg, tmpS, nLen)
  If RetVal = -1 Then MsgBox "Недопустимое значение падежа - " & "(" & nPadeg & ")", , "Склонение ФИО"
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


' Макросы преобразования выделенного ФИО в соответствующий падеж

Public Sub Именительный()
  Selection.TypeText (Nominative(Selection))
End Sub

Public Sub Родительный()
  Selection.TypeText (MakePadeg(Selection, 2))
End Sub

Public Sub Дательный()
  Selection.TypeText (MakePadeg(Selection, 3))
End Sub

Public Sub Винительный()
  Selection.TypeText (MakePadeg(Selection, 4))
End Sub

Public Sub Творительный()
  Selection.TypeText (MakePadeg(Selection, 5))
End Sub

Public Sub Предложный()
  Selection.TypeText (MakePadeg(Selection, 6))
End Sub
