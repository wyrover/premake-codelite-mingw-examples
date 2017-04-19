'------------------------------------------------ 
' \file format_source.vbs
' \brief 格式化代码
'
' 使用Astyle.exe格式化代码
'
' \author wangyang
' \date 2015/04/10
' \version 1.0
'------------------------------------------------ 

Const COM_FSO           = "Scripting.FileSystemObject"
Const COM_SHELL         = "WScript.Shell"

Dim config
Set config = CreateObject("Scripting.Dictionary")
config("AStyle")		= ".\src_tools\AStyle.exe --style=linux --s4 --p --H --U --f --v --w --c --xe --xL --xW"
'------------------------------------------------
' FSO
Const ForReading = 1
Const ForWriting = 2
Const ForAppending = 8
'------------------------------------------------
' CScriptRun
Sub CScriptRun 
    Dim Args
    Dim Arg
    If LCase(Right(WScript.FullName,11)) = "wscript.exe" Then
        Args = Array("cmd.exe /k CScript.exe ", """" & WScript.ScriptFullName & """" )
            For Each Arg In WScript.Arguments
            ReDim Preserve Args(UBound(Args)+1)
            Args(UBound(Args)) = """" & Arg & """"
        Next
        WScript.Quit CreateObject("WScript.Shell").Run(Join(Args), 1, True)
    End If
End Sub

'------------------------------------------------
' 打印字符串
Sub Echo(message)
    WScript.Echo message
End Sub


'------------------------------------------------
' 路径末尾添加\
Function DisposePath(sPath)
    On Error Resume Next
    
    If Right(sPath, 1) = "\" Then
        DisposePath = sPath
    Else
        DisposePath = sPath & "\"
    End If
    
    DisposePath = Trim(DisposePath)
End Function 

'------------------------------------------------
' 获取文件路径
Function GetFilePath(filename)
    Dim FSO
    Set FSO = CreateObject(COM_FSO)
    GetFilePath = DisposePath(FSO.GetParentFolderName(filename))
End Function 


'------------------------------------------------
' 获取文件绝对路径
Function GetAbsolutePathName(filename)
    Dim FSO, file
    Set FSO = CreateObject(COM_FSO)
    Set file = FSO.GetFile(filename)
    GetAbsolutePathName = FSO.GetAbsolutePathName(file)
End Function

'------------------------------------------------
' 获取文件名
Function GetFileName(filename)
    Dim FSO, file
    Set FSO = CreateObject(COM_FSO)
    Set file = FSO.GetFile(filename)
    GetFileName = FSO.GetFileName(file)
End Function

'------------------------------------------------
' 获取基本文件名
Function GetBaseName(filename)
    Dim FSO, file
    Set FSO = CreateObject(COM_FSO)
    Set file = FSO.GetFile(filename)
    GetBaseName = FSO.GetBaseName(file)
End Function


Function ExecAStyle(filename)
    Dim objShell, objExec, astyle, arrStr
    Set objShell = CreateObject(COM_SHELL)
    astyle = config("AStyle") 
    Set objExec = objShell.Exec(astyle & " """ & filename & """")
    ExecPHP = objExec.StdOut.ReadAll
End Function


Sub EachFiles(dir, pattern, method)
    Dim FSO, re
    Set FSO = CreateObject(COM_FSO)
    Set root = FSO.GetFolder(dir)
    Set re = new RegExp
    re.Pattern    = pattern
    re.IgnoreCase = True
    
    Call EachSubFolder(root, re, method)
    
    Set FSO = Nothing
    Set re = Nothing
End Sub

Sub EachSubFolder(root, re, method)
    Dim subfolder, file, script
    
    For Each file In root.Files
        If re.Test(file.Name) Then
            Call method(file.Path)            
        End If
    Next
    
    For Each subfolder In root.SubFolders
        Call EachSubFolder(subfolder, re, method)    
    Next
End Sub

Function format_source(filename)
    'Echo filename
    '--out-implib=\&quot;../../bin/x86/codelite/gmake-examples/DevCppDLL.lib\&quot;;
    Call ReplaceFileContent(filename, "--out-implib=\\&quot\;(.*?)\\&quot\;", "--out-implib=$1", 1) 
End Function


Function ReplaceFileContent(filepath, pattern, text, is_utf8)
	Set objFSO = CreateObject("Scripting.FileSystemObject")
	Set objFile = objFSO.GetFile(filepath)
	Dim objStream

	' Valid Charset values for ADODB.Stream
    Const CdoBIG5        = "big5"
    Const CdoEUC_JP      = "euc-jp"
    Const CdoEUC_KR      = "euc-kr"
    Const CdoGB2312      = "gb2312"
    Const CdoISO_2022_JP = "iso-2022-jp"
    Const CdoISO_2022_KR = "iso-2022-kr"
    Const CdoISO_8859_1  = "iso-8859-1"
    Const CdoISO_8859_2  = "iso-8859-2"
    Const CdoISO_8859_3  = "iso-8859-3"
    Const CdoISO_8859_4  = "iso-8859-4"
    Const CdoISO_8859_5  = "iso-8859-5"
    Const CdoISO_8859_6  = "iso-8859-6"
    Const CdoISO_8859_7  = "iso-8859-7"
    Const CdoISO_8859_8  = "iso-8859-8"
    Const CdoISO_8859_9  = "iso-8859-9"
    Const cdoKOI8_R      = "koi8-r"
    Const cdoShift_JIS   = "shift-jis"
    Const CdoUS_ASCII    = "us-ascii"
    Const CdoUTF_7       = "utf-7"
    Const CdoUTF_8       = "utf-8"

    ' ADODB.Stream file I/O constants
    Const adTypeBinary          = 1
    Const adTypeText            = 2
    Const adSaveCreateNotExist  = 1
    Const adSaveCreateOverWrite = 2


	If objFile.Size > 0 Then
		
		If is_utf8 = 1 Then			
			Set objStream = CreateObject( "ADODB.Stream" )
			objStream.Open
			objStream.Type = adTypeText
			objStream.Position = 0
			objStream.Charset = CdoUTF_8
			objStream.LoadFromFile filepath
			strContents = objstream.ReadText			
			objStream.Close
			Set objStream = Nothing
		Else
			Set objReadFile = objFSO.OpenTextFile(filepath, 1)
			strContents = objReadFile.ReadAll
			objReadFile.Close		
		End If
	End If

	Dim re
	Set re = new RegExp
	re.IgnoreCase = False
	re.Global = True
	re.MultiLine = True
	re.Pattern = pattern
	strContents = re.replace(strContents, text)

	're.Pattern="^Public\s+Const\s+APP_VERSION.*""$"
	'strContents = re.replace(strContents,"Public Const APP_VERSION = ""Version: " & appversion & """")

	Set re = Nothing	
	
	If is_utf8 = 1 Then
		Set objStream = CreateObject( "ADODB.Stream" )
		objStream.Open
		objStream.Type = adTypeText
		objStream.Position = 0
		objStream.Charset = CdoUTF_8
		objStream.WriteText = strContents
		objStream.SaveToFile filepath, adSaveCreateOverWrite
		objStream.Close
		Set objStream = Nothing
	Else
		Set objWriteFile = objFSO.OpenTextFile(filepath, 2, False)
		objWriteFile.Write(strContents)		
		objWriteFile.Close	
	End If
End Function

	


CScriptRun


Call Main

Sub Main()
    Set callback_function = GetRef("format_source")
    Call EachFiles("build\codelite", "\.(?:project)$", callback_function)
End Sub
	



