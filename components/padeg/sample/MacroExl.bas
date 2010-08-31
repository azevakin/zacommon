' Пример обращения к функциям DLL GetFIOPadegFSAS и GetNominativePadeg
' Обращение к другим функциям выполняется аналогично
' Copyright (c) 2001 Gennady Pokatashkin e-mail: pgl@tut.by
'                    Sergey Plahov e-mail: S.Plahov@vaz.ru

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
  (ByVal pFIO As String, ByVal nPadeg As Long, ByVal pResult As String, ByRef nLen As Long) As Integer

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


' Макросы преобразования ФИО в активной ячейке в соответствующий падеж

Public Sub Именительный()
  Cells(ActiveCell.Row, ActiveCell.Column) = Nominative(ActiveCell)
End Sub

Public Sub Родительный()
  Cells(ActiveCell.Row, ActiveCell.Column) = MakePadeg(ActiveCell, 2)
End Sub

Public Sub Дательный()
  Cells(ActiveCell.Row, ActiveCell.Column) = MakePadeg(ActiveCell, 3)
End Sub

Public Sub Винительный()
  Cells(ActiveCell.Row, ActiveCell.Column) = MakePadeg(ActiveCell, 4)
End Sub

Public Sub Творительный()
  Cells(ActiveCell.Row, ActiveCell.Column) = MakePadeg(ActiveCell, 5)
End Sub

Public Sub Предложный()
  Cells(ActiveCell.Row, ActiveCell.Column) = MakePadeg(ActiveCell, 6)
End Sub
