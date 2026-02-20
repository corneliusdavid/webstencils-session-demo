object dmCust: TdmCust
  OnCreate = DataModuleCreate
  Height = 683
  Width = 911
  PixelsPerInch = 168
  object FDConnChinook: TFDConnection
    Params.Strings = (
      'ConnectionDef=WebStencils Session Demo')
    ConnectedStoredUsage = [auDesignTime]
    Connected = True
    LoginPrompt = False
    Left = 238
    Top = 182
  end
  object FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink
    Left = 252
    Top = 308
  end
  object qryUserVerify: TFDQuery
    ActiveStoredUsage = [auDesignTime]
    Connection = FDConnChinook
    SQL.Strings = (
      'SELECT FirstName, LastName, Title, EmployeeID'
      'FROM Employee'
      'WHERE Upper(FirstName) = Upper(:FName)'
      '  AND :Password = EmployeeId || LastName;')
    Left = 420
    Top = 98
    ParamData = <
      item
        Name = 'FNAME'
        DataType = ftString
        ParamType = ptInput
        Value = 'andrew'
      end
      item
        Name = 'PASSWORD'
        DataType = ftString
        ParamType = ptInput
        Value = '1Adams'
      end>
    object qryUserVerifyFirstName: TWideStringField
      FieldName = 'FirstName'
      Origin = 'FirstName'
      Required = True
    end
    object qryUserVerifyLastName: TWideStringField
      FieldName = 'LastName'
      Origin = 'LastName'
      Required = True
    end
    object qryUserVerifyTitle: TWideStringField
      FieldName = 'Title'
      Origin = 'Title'
      Size = 30
    end
    object qryUserVerifyEmployeeId: TFDAutoIncField
      FieldName = 'EmployeeId'
      Origin = 'EmployeeId'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = False
    end
  end
  object qryCustCount: TFDQuery
    ActiveStoredUsage = [auDesignTime]
    Active = True
    Connection = FDConnChinook
    SQL.Strings = (
      'select count(1) as CustCount from customer')
    Left = 448
    Top = 378
    object qryCustCountCustCount: TLargeintField
      AutoGenerateValue = arDefault
      FieldName = 'CustCount'
      Origin = 'CustCount'
      ProviderFlags = []
      ReadOnly = True
    end
  end
  object qryCustomers: TFDQuery
    Active = True
    OnCalcFields = qryCustomersCalcFields
    Connection = FDConnChinook
    SQL.Strings = (
      'SELECT c.CustomerId, c.FirstName, c.LastName, c.Company, '
      '  COUNT(i.InvoiceId) AS InvCount, SUM(i.Total) AS TotalInvoices'
      'FROM customer c'
      'JOIN invoice i ON c.CustomerId = i.CustomerId '
      'GROUP BY c.CustomerId '
      'ORDER BY c.LastName'
      ' ')
    Left = 448
    Top = 238
    object qryCustomersCustomerId: TIntegerField
      FieldName = 'CustomerId'
      Origin = 'CustomerId'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object qryCustomersFirstName: TWideStringField
      FieldName = 'FirstName'
      Origin = 'FirstName'
      Required = True
      Size = 40
    end
    object qryCustomersLastName: TWideStringField
      FieldName = 'LastName'
      Origin = 'LastName'
      Required = True
    end
    object qryCustomersCompany: TWideStringField
      FieldName = 'Company'
      Origin = 'Company'
      Size = 80
    end
    object qryCustomersInvCount: TLargeintField
      AutoGenerateValue = arDefault
      FieldName = 'InvCount'
      Origin = 'InvCount'
      ProviderFlags = []
      ReadOnly = True
    end
    object qryCustomersTotalInvoices: TFloatField
      AutoGenerateValue = arDefault
      FieldName = 'TotalInvoices'
      Origin = 'TotalInvoices'
      ProviderFlags = []
      ReadOnly = True
    end
    object qryCustomersIsBusiness: TBooleanField
      FieldKind = fkCalculated
      FieldName = 'IsBusiness'
      Calculated = True
    end
  end
  object qryCustDetails: TFDQuery
    ActiveStoredUsage = [auDesignTime]
    Active = True
    Connection = FDConnChinook
    SQL.Strings = (
      'SELECT CustomerId, FirstName, LastName, Company,'
      '  Address, City, [State], Country, PostalCode, Phone, Email'
      'FROM Customer'
      'WHERE CustomerId = :CustID')
    Left = 574
    Top = 280
    ParamData = <
      item
        Name = 'CUSTID'
        DataType = ftInteger
        ParamType = ptInput
        Value = 3
      end>
    object qryCustDetailsCustomerId: TIntegerField
      FieldName = 'CustomerId'
      Origin = 'CustomerId'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object qryCustDetailsFirstName: TWideStringField
      FieldName = 'FirstName'
      Origin = 'FirstName'
      Required = True
      Size = 40
    end
    object qryCustDetailsLastName: TWideStringField
      FieldName = 'LastName'
      Origin = 'LastName'
      Required = True
    end
    object qryCustDetailsCompany: TWideStringField
      FieldName = 'Company'
      Origin = 'Company'
      Size = 80
    end
    object qryCustDetailsAddress: TWideStringField
      FieldName = 'Address'
      Origin = 'Address'
      Size = 70
    end
    object qryCustDetailsCity: TWideStringField
      FieldName = 'City'
      Origin = 'City'
      Size = 40
    end
    object qryCustDetailsState: TWideStringField
      FieldName = 'State'
      Origin = 'State'
      Size = 40
    end
    object qryCustDetailsCountry: TWideStringField
      FieldName = 'Country'
      Origin = 'Country'
      Size = 40
    end
    object qryCustDetailsPostalCode: TWideStringField
      FieldName = 'PostalCode'
      Origin = 'PostalCode'
      Size = 10
    end
    object qryCustDetailsPhone: TWideStringField
      FieldName = 'Phone'
      Origin = 'Phone'
      Size = 24
    end
    object qryCustDetailsEmail: TWideStringField
      FieldName = 'Email'
      Origin = 'Email'
      Required = True
      Size = 60
    end
  end
end
