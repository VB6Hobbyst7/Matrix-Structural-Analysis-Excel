VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "DenseMatrixOutput"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'@Folder("Model.Matrix.Output")
Option Explicit
Implements IMatrixOutput

Private Const DEFAULT_NUMBER_FORMAT As String = "#0.0000"
Private Const DEFAULT_FILENAME As String = "matrix_output"

Private Sub IMatrixOutput_ToImmediateWindow(ByVal MatrixData As IMatrixStorage, Optional ByVal OutputFormat As String = DEFAULT_NUMBER_FORMAT)

    Dim RowString As String
    RowString = vbNullString
    
    Dim row As Long
    Dim column As Long
    
    For row = 0 To MatrixData.Rows - 1
    
        RowString = Format(CStr(MatrixData.Element(row, 0)), OutputFormat)
    
        For column = 1 To MatrixData.Columns - 1
        
            RowString = RowString & vbTab & Format(CStr(MatrixData.Element(row, column)), OutputFormat)
        
        Next column
        
        Debug.Print RowString
        
    Next row

End Sub

Private Sub IMatrixOutput_ToFile(ByVal MatrixData As IMatrixStorage, Optional ByVal FileName As String = DEFAULT_FILENAME, Optional ByVal OutputFormat As String = DEFAULT_NUMBER_FORMAT)

    On Error GoTo ErrorHandler
    
    Dim FilePath As String
    FilePath = ThisWorkbook.Path & "\" & FileName & ".txt"
    
    Dim FileNumber As Long
    FileNumber = FreeFile
    
    Open FilePath For Output As #FileNumber

    Dim RowString As String
    RowString = vbNullString
    
    Dim row As Long
    Dim column As Long
    
    For row = 0 To MatrixData.Rows - 1
    
        RowString = Format(CStr(MatrixData.Element(row, 0)), OutputFormat)
    
        For column = 1 To MatrixData.Columns - 1
        
            RowString = RowString & vbTab & Format(CStr(MatrixData.Element(row, column)), OutputFormat)
        
        Next column
        
        Print #FileNumber, RowString
        
    Next row
    
SubExit:
    
    Close #FileNumber
    
    Exit Sub
    
ErrorHandler:
    
    MsgBox Prompt:=Err.Number & ": " & Err.Description & vbCrLf & "An error occured while writing to file.", _
           Buttons:=vbInformation, _
           Title:="DenseMatrixOutput.ToFile Error."
    
    Resume SubExit

End Sub

Private Sub IMatrixOutput_ToWorksheet(ByVal MatrixData As IMatrixStorage, ByVal OutputCell As Range, Optional ByVal OutputFormat As String = DEFAULT_NUMBER_FORMAT)

    Dim OutputArray() As Double
    ReDim OutputArray(MatrixData.Rows - 1, MatrixData.Columns - 1)
    
    Dim row As Long
    Dim column As Long
    
    For row = 0 To MatrixData.Rows - 1
        For column = 0 To MatrixData.Columns - 1
            OutputArray(row, column) = MatrixData.Element(row, column)
        Next column
    Next row
    
    With OutputCell
        .Resize(MatrixData.Rows, MatrixData.Columns).NumberFormat = OutputFormat
        .Value2 = OutputArray
    End With

End Sub