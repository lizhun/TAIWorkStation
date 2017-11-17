unit TencentAIHelper;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdHTTP, IdCoder, IdCoder3to4, IdCoderMIME, IdMultipartFormData, IniFiles,
  ADODB;

type
  TTencentAIUploadImage = class
    imageId: string;
   // Url: string;
   // DescPosition: string;
    Content: string;
    filePath: string;
  end;

type
  TArrayTTencentAIUploadImage = array of TTencentAIUploadImage;

type
  TArrayImageId = array of string;

type
  TencentAIFrontUrl = (UploadDataUrl, GetAIResultUrl, UploadReportUrl);

type
  TTencentAIUploadData = class
    DbType: string;   //这个是程序内部使用，如WJ CJ ZXJ XZJ
    StudyId: string;
    StudyType: string;
    StudyDate: TDateTime;
    StudyName: string;
    PatientId: string;
    PatientName: string;
    PatientGender: string;
    PatientBirthday: string;
    Images: TArrayTTencentAIUploadImage;
  end;

type
  TTencentAIManager = class
  private
    _OnBeforeSend: TNotifyEvent;
    function _GetWebSVRUrl(urlType: TencentAIFrontUrl): string;
    function _GetAIDataFromDb(con: TADOConnection; patId: string; imageIds: TArrayImageId): TTencentAIUploadData;
    function _ImageToBuffer(AImgFile: string): string;
  public
    ImgLocalRootPath: string;
    ImgServerRootPath: string;
    function MSendAIDataFromDb(con: TADOConnection; patId: string; imageIds: TArrayImageId): string;
    function MSendAIData(data: TTencentAIUploadData): string;
    property OnBeforeSend: TNotifyEvent read _OnBeforeSend write _OnBeforeSend;
    function MakeUploadImage(imageId: string; filePath: string): TTencentAIUploadImage;
  end;

implementation

function TTencentAIManager.MSendAIDataFromDb(con: TADOConnection; patId: string; imageIds: TArrayImageId): string;
var
  aaa: string;
  data: TTencentAIUploadData;
  res: string;
begin
  data := _GetAIDataFromDb(con, patId, imageIds);
  res := MSendAIData(data);
  Result := res;
end;

function TTencentAIManager.MSendAIData(data: TTencentAIUploadData): string;
var
  postForm: TIdMultiPartFormDataStream;
  http: TIdHTTP;
  i, ilen: Integer;
  res: string;
begin
  postForm := TIdMultiPartFormDataStream.Create;
  http := TIdHTTP.Create(nil);
  postForm.AddFormField('StudyId', data.StudyId);
  postForm.AddFormField('StudyType', data.StudyType);
  postForm.AddFormField('StudyName', data.StudyName);
  postForm.AddFormField('PatientId', data.PatientId);
  postForm.AddFormField('PatientName', data.PatientName);
  postForm.AddFormField('PatientGender', data.PatientGender);
  postForm.AddFormField('PatientBirthday', data.PatientBirthday);
  postForm.AddFormField('StudyDate', FloatToStr(data.StudyDate));
  ilen := Length(data.Images);
  for i := 0 to ilen - 1 do
  begin
    postForm.AddFormField('img_' + data.Images[i].imageId + '_content', _ImageToBuffer(ImgLocalRootPath + data.Images[i].filePath));
    postForm.AddFormField('img_' + data.Images[i].imageId + '_url', ImgServerRootPath + data.Images[i].filePath);
  end;
  if Assigned(OnBeforeSend) then
  begin
    OnBeforeSend(Self);
  end;
  res := http.Post(_GetWebSVRUrl(UploadDataUrl), postForm);
  FreeAndNil(http);
  FreeAndNil(postForm);
  Result := res;
end;

function TTencentAIManager._GetAIDataFromDb(con: TADOConnection; patId: string; imageIds: TArrayImageId): TTencentAIUploadData;
var
  data: TTencentAIUploadData;
  query: TADOQuery;
  i, len: Integer;
begin
  data := TTencentAIUploadData.Create;
  query := TADOQuery.Create(nil);
  query.Connection := con;
  query.SQL.Text := 'select m.DbType,m.StudyId,m.StudyType, m.StudyDate,m.StudyName,m.PatientId,m.PatientName,' +
  'm.PatientGender, m.PatientBirthday,i.imageId,i.imgfile from V_TencentAIUpload m ' +
  'inner join V_TencentAIUploadDetail i on m.patid=i.pid where m.patid=:patid and i.imageid in (';
  len := Length(imageIds);
  for i := 0 to len - 1 do
  begin
    if i <> (len - 1) then
    begin
      query.SQL.Text := query.SQL.Text + ':img' + imageIds[i] + ',';
    end
    else
    begin
      query.SQL.Text := query.SQL.Text + ':img' + imageIds[i];
    end;
  end;
  query.SQL.Text := query.SQL.Text + ')';
  query.Parameters.ParamByName('patid').value := patId;
  for i := 0 to len - 1 do
  begin
    query.Parameters.ParamByName('img' + imageIds[i]).value := imageIds[i];
  end;
  query.Prepared := True;
  query.Open;
  query.First;
  data.DbType := query.FieldByName('DbType').AsString;
  data.StudyId := query.FieldByName('StudyId').AsString;
  data.StudyType := query.FieldByName('StudyType').AsString;
  data.StudyDate := query.FieldByName('StudyDate').AsDateTime;
  data.StudyName := query.FieldByName('StudyName').AsString;
  data.PatientId := query.FieldByName('PatientId').AsString;
  data.PatientName := query.FieldByName('PatientName').AsString;
  data.PatientGender := query.FieldByName('PatientGender').AsString;
  data.PatientBirthday := query.FieldByName('PatientBirthday').AsString;
  SetLength(data.Images, query.RecordCount);
  i := 0;
  while not query.Eof do
  begin
    data.Images[i] := MakeUploadImage(query.FieldByName('imageId').AsString, query.FieldByName('imgfile').AsString);
    i := i + 1;
    query.Next;
  end;
  query.Close;
  FreeAndNil(query);
  Result := data;
end;

function TTencentAIManager.MakeUploadImage(imageId: string; filePath: string): TTencentAIUploadImage;
var
  data: TTencentAIUploadImage;
begin
  data := TTencentAIUploadImage.Create;
  data.imageId := imageId;
  data.filePath := filePath;
  if (data.filePath <> '') then
  begin
    data.Content := _ImageToBuffer(ImgLocalRootPath + filePath);
  end;
  Result := data;
end;

function TTencentAIManager._GetWebSVRUrl(urlType: TencentAIFrontUrl): string;
var
  myinifile: TIniFile;
  gwebsvrurl: string;
begin

  if FileExists('TencentAIConfig.ini') then
  begin
    myinifile := Tinifile.create(getcurrentdir + '\TencentAIConfig.ini');
    case urlType of
      UploadDataUrl:
        begin
          gwebsvrurl := myinifile.readstring('Service', 'UploadDataUrl', '');
        end;

      GetAIResultUrl:
        begin
          gwebsvrurl := myinifile.readstring('Service', 'GetAIResultUrl', '');
        end;
      UploadReportUrl:
        begin
          gwebsvrurl := myinifile.readstring('Service', 'UploadReportUrl', '');
        end;

    end;

    FreeAndNil(myinifile);
  end
  else
  begin
    gwebsvrurl := 'http://localhost:9999/Handler1.ashx';
  end;

  Result := gwebsvrurl;
end;

function TTencentAIManager._ImageToBuffer(AImgFile: string): string;
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

end.

