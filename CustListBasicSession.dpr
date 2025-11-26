program CustListBasicSession;
{$APPTYPE GUI}

uses
  Vcl.Forms,
  Web.WebReq,
  ufrmCustListBasic in 'ufrmCustListBasic.pas' {frmWebStencilsBasicDemo},
  uwebCustListBasic in 'uwebCustListBasic.pas' {webCustListBasic: TWebModule},
  uLogging in 'uLogging.pas',
  udmCust in 'udmCust.pas' {dmCust: TDataModule};

{$R *.res}

begin
  if WebRequestHandler <> nil then
    WebRequestHandler.WebModuleClass := WebModuleClass;
  Application.Initialize;
  Application.CreateForm(TfrmWebStencilsBasicDemo, frmWebStencilsBasicDemo);
  Application.CreateForm(TdmCust, dmCust);
  Application.Run;
end.
