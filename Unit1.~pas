unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdHTTP, IdCoder, IdCoder3to4, IdCoderMIME, IdMultipartFormData,
  TencentAIHelper;

type
  TForm1 = class(TForm)
    idhtp1: TIdHTTP;
    btn1: TButton;
    idcdrm1: TIdDecoderMIME;
    btn2: TButton;
    mmo1: TMemo;
    idncdrm1: TIdEncoderMIME;
    btn3: TButton;
    procedure btn1Click(Sender: TObject);
    function ImageToBuffer(AImgFile: string): string;
    procedure BufferToImage(ABuffer: string; ASaveName: string);
    procedure btn2Click(Sender: TObject);
    procedure btn3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.btn1Click(Sender: TObject);
var
  datalist: TStringList;
  result: string;
  code: TIdDecoderMIME;
  postForm: TIdMultiPartFormDataStream;
begin
  datalist := TStringList.Create;
  datalist.Add('pid=' + IntToStr(555));
  datalist.Add('type=asdfasdf');
  postForm := TIdMultiPartFormDataStream.Create;
  postForm.AddFormField('pid', '666');
  postForm.AddFile('filefieldname1', 'd:\110.png', 'text/plain');
  postForm.AddFile('filefieldname2', 'd:\110.png', 'text/plain');
  result := idhtp1.Post('http://localhost:9999/Handler1.ashx', postForm);
  mmo1.Text := result;
end;

function TForm1.ImageToBuffer(AImgFile: string): string;
var
  MyFileStream: TFileStream;
  EncoderMIME: TIdEncoderMIME;
begin
  result := '';
  if FileExists(AImgFile) then
  begin
    EncoderMIME := TIdEncoderMIME.Create(nil);
    try
      MyFileStream := TFileStream.Create(AImgFile, fmOpenRead);
      try
        SetLength(result, MyFileStream.Size);
        MyFileStream.Read(result[1], MyFileStream.Size);
        result := EncoderMIME.EncodeString(result);
      finally
        MyFileStream.Free;
      end;
    finally
      EncoderMIME.Free;
    end;
  end;
end;

procedure TForm1.BufferToImage(ABuffer: string; ASaveName: string);
var
  MyFileStream: TMemoryStream;
  DecoderMIME: TIdDecoderMIME;
begin
  if FileExists(ASaveName) then
    DeleteFile(ASaveName);
  try
    if Trim(ABuffer) = '' then
      Exit;
    DecoderMIME := TIdDecoderMIME.Create(nil);
    try
      MyFileStream := TMemoryStream.Create;
      try
        ABuffer := DecoderMIME.DecodeToString(ABuffer);
        MyFileStream.Write(ABuffer[1], length(ABuffer));
        MyFileStream.SaveToFile(ASaveName);
      finally
        MyFileStream.Free;
      end;
    finally
      DecoderMIME.Free;
    end;
  except
    on E: Exception do
    begin
      ASaveName := '';
    end;
  end;
end;

procedure TForm1.btn2Click(Sender: TObject);
var
  aaa: TIdMultiPartFormDataStream;
begin
  aaa := TIdMultiPartFormDataStream.Create;

  mmo1.Text := ImageToBuffer('d:\110.png');

end;

procedure TForm1.btn3Click(Sender: TObject);
var
  helper: TTencentAIManager;
  data: TTencentAIUploadData;
begin
  data := TTencentAIUploadData.Create;
  helper := TTencentAIManager.Create;
  helper.imgLocalRootPath := '';
  helper.imgServerRootPath := '';
  data.StudyId := 'dfasdf';
  data.StudyType := '\\192.1658.1.1\';
  SetLength(data.Images, 1);
  data.Images[0] := helper.MakeUploadImage('1231', 'D:\110.png');  
  helper.MSendAIData(data);
end;

end.

