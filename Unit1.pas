unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdHTTP, IdCoder, IdCoder3to4, IdCoderMIME, IdMultipartFormData,
  TencentAIHelper, DB, ADODB, ExtCtrls;

type
  TForm1 = class(TForm)
    idhtp1: TIdHTTP;
    idcdrm1: TIdDecoderMIME;
    mmo1: TMemo;
    idncdrm1: TIdEncoderMIME;
    con1: TADOConnection;
    btn4: TButton;
    lbledtpatid: TLabeledEdit;
    lbledtimageId: TLabeledEdit;
    lbledtDBase: TLabeledEdit;
    lbledtimgLocalRootPath: TLabeledEdit;
    lbledtimgServerRootPath: TLabeledEdit;
    procedure btn3Click(Sender: TObject);
    procedure btn4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.btn3Click(Sender: TObject);
var
  helper: TTencentAIManager;
  data: TTencentAIUploadData;
begin
  data := TTencentAIUploadData.Create;
  helper := TTencentAIManager.Create;
  helper.imgLocalRootPath := '';
  helper.imgServerRootPath := '';
  data.DbType := 'WJ'; 
  data.StudyType := '1';
  data.StudyName := '气管镜';
  data.PatientId := '1';
  data.PatId := '111';
  data.PatientName := '张三';
  data.PatientGender := '1';
  data.PatientBirthday := '1999-11-11 22:22:22';
  data.StudyDate := '1999-11-11';
  SetLength(data.Images, 1);
  data.Images[0] := helper.MakeUploadImage('1231', 'D:\110.png');
  helper.MSendAIData(data);
end;

procedure TForm1.btn4Click(Sender: TObject);
var
  helper: TTencentAIManager;
  imgids: TArrayImageId;
begin
  helper := TTencentAIManager.Create;
  helper.imgLocalRootPath := lbledtimgLocalRootPath.Text;
  helper.imgServerRootPath := lbledtimgServerRootPath.Text;
  SetLength(imgids, 1);
  imgids[0] := lbledtimageId.Text;
  con1.ConnectionString := lbledtDBase.Text;
  helper.MSendAIDataFromDb(con1, '1231', imgids);
end;

end.

