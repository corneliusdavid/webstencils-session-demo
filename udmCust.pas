unit udmCust;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs, FireDAC.VCLUI.Wait, FireDAC.Phys.SQLiteWrapper.Stat,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.Client, Data.DB, FireDAC.Comp.DataSet;

type
  TEmployeeRole = (erNone, erAdmin, erEditor, erViewer);

  TdmCust = class(TDataModule)
    FDConnChinook: TFDConnection;
    FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink;
    qryUserVerify: TFDQuery;
    qryCustCount: TFDQuery;
    qryCustCountCustCount: TLargeintField;
    qryCustomers: TFDQuery;
    qryCustDetails: TFDQuery;
    qryUserVerifyFirstName: TWideStringField;
    qryUserVerifyLastName: TWideStringField;
    qryUserVerifyTitle: TWideStringField;
    qryUserVerifyEmployeeId: TFDAutoIncField;
    qryCustomersCustomerId: TIntegerField;
    qryCustomersFirstName: TWideStringField;
    qryCustomersLastName: TWideStringField;
    qryCustomersCompany: TWideStringField;
    qryCustomersInvCount: TLargeintField;
    qryCustomersTotalInvoices: TFloatField;
    qryCustDetailsCustomerId: TIntegerField;
    qryCustDetailsFirstName: TWideStringField;
    qryCustDetailsLastName: TWideStringField;
    qryCustDetailsCompany: TWideStringField;
    qryCustDetailsAddress: TWideStringField;
    qryCustDetailsCity: TWideStringField;
    qryCustDetailsState: TWideStringField;
    qryCustDetailsCountry: TWideStringField;
    qryCustDetailsPostalCode: TWideStringField;
    qryCustDetailsPhone: TWideStringField;
    qryCustDetailsEmail: TWideStringField;
    qryCustomersIsBusiness: TBooleanField;
    procedure qryCustomersCalcFields(DataSet: TDataSet);
    procedure DataModuleCreate(Sender: TObject);
  private
    FEmpFirstName: string;
    FEmpLastName: string;
    FEmpTitle: string;
    FEmpRole: TEmployeeRole;
  public
    function LoginCheck(const Username, Password: string): Boolean;
    procedure ClearLogin;
    function CustCount: Integer;
    procedure OpenCustDetails(const CustID: Integer);
    procedure CloseCustDetails;
    property EmployeeFirstName: string read FEmpFirstName write FEmpFirstName;
    property EmployeeLastName: string read FEmpLastName write FEmpLastName;
    property EmployeeTitle: string read FEmpTitle write FEmpTitle;
    property EmployeeRole: TEmployeeRole read FEmpRole write FEmpRole;
  end;

var
  dmCust: TdmCust;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

uses
  IOUtils;

{ TdmCust }

function TdmCust.CustCount: Integer;
begin
  qryCustCount.Open;
  Result := qryCustCountCustCount.AsInteger;
  qryCustCount.Close;
end;

procedure TdmCust.DataModuleCreate(Sender: TObject);
begin
  ClearLogin;
  FDConnChinook.Params.Database := TPath.Combine(ExtractFilePath(ParamStr(0)), 'chinook.db');
end;

procedure TdmCust.ClearLogin;
begin
  FEmpFirstName := EmptyStr;
  FEmpLastName  := EmptyStr;
  FEmpTitle     := EmptyStr;
  FEmpRole      := erNone;
end;

function TdmCust.LoginCheck(const Username, Password: string): Boolean;
begin
  ClearLogin;

  qryUserVerify.ParamByName('FName').AsString := UpperCase(Username);
  qryUserVerify.ParamByName('Password').AsString := Password;
  qryUserVerify.Open;
  Result := qryUserVerify.RecordCount > 0;

  if Result then begin
    FEmpFirstName := qryUserVerifyFirstName.AsString;
    FEmpLastName  := qryUserVerifyLastName.AsString;
    FEmpTitle     := qryUserVerifyTitle.AsString;

    if FEmpTitle.Contains('Manager', True) then
      FEmpRole := erAdmin
    else
      // require "IT" to be all caps to help prevent catching "it" as part of other words
      FEmpRole := if FEmpTitle.Contains('IT', False) then erEditor else erViewer;
  end;

  qryUserVerify.Close;
end;

procedure TdmCust.OpenCustDetails(const CustID: Integer);
begin
  qryCustDetails.ParamByName('CustID').AsInteger := CustID;
  qryCustDetails.Open;
end;

procedure TdmCust.qryCustomersCalcFields(DataSet: TDataSet);
begin
  qryCustomersIsBusiness.AsBoolean := qryCustomersCompany.AsString.Length > 0;
end;

procedure TdmCust.CloseCustDetails;
begin
  qryCustDetails.Close;
end;

end.
