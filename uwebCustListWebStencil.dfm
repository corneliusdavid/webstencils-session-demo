object f: Tf
  OnCreate = WebModuleCreate
  Actions = <
    item
      Default = True
      MethodType = mtGet
      Name = 'DefaultHandler'
      PathInfo = '/'
      Producer = wspIndex
    end
    item
      MethodType = mtPost
      Name = 'waLoginVerify'
      PathInfo = '/login'
      OnAction = webCustListWebStencilwaLoginVerifyAction
    end
    item
      MethodType = mtGet
      Name = 'waListCustomers'
      PathInfo = '/custlist'
      OnAction = webCustListWebStencilwaListCustomersAction
    end
    item
      MethodType = mtGet
      Name = 'waEditCustomer'
      PathInfo = '/custedit'
      OnAction = webCustListWebStencilwaEditCustomerAction
    end
    item
      MethodType = mtGet
      Name = 'waLoginFailed'
      PathInfo = '/inavlid_user'
      Producer = wspLoginFailed
    end
    item
      MethodType = mtGet
      Name = 'waLogin'
      PathInfo = '/login'
      Producer = wspLogin
    end
    item
      Name = 'waUnauthorized'
      PathInfo = '/unauthorized'
      Producer = wspAccessDenied
    end>
  Height = 692
  Width = 945
  PixelsPerInch = 144
  object wspIndex: TWebStencilsProcessor
    Engine = wsEngineCustList
    InputFileName = 'html/index-wStencils.html'
    UserLoggedIn = True
    Left = 156
    Top = 156
  end
  object wsEngineCustList: TWebStencilsEngine
    PathTemplates = <>
    OnError = wsEngineCustListError
    Left = 96
    Top = 48
  end
  object wspLoginFailed: TWebStencilsProcessor
    Engine = wsEngineCustList
    InputFileName = 'html/loginfailed-wStencils.html'
    Left = 148
    Top = 364
  end
  object wspCustList: TWebStencilsProcessor
    Engine = wsEngineCustList
    InputFileName = 'html\custlist-wStencils.html'
    UserLoggedIn = True
    Left = 312
    Top = 328
  end
  object wspAccessDenied: TWebStencilsProcessor
    Engine = wsEngineCustList
    InputFileName = 'html/accessdenied-wStencils.html'
    Left = 152
    Top = 468
  end
  object wspCustEdit: TWebStencilsProcessor
    Engine = wsEngineCustList
    InputFileName = 'html\custedit-wStencils.html'
    Left = 304
    Top = 408
  end
  object WebAuthorizer: TWebAuthorizer
    UnauthorizedURL = '/unauthorized'
    Zones = <
      item
        PathInfo = '/custlist'
      end
      item
        PathInfo = '/'
        Kind = zkFree
      end>
    Left = 620
    Top = 180
  end
  object WebFormsAuthenticator1: TWebFormsAuthenticator
    LoginURL = '/login'
    FailedURL = '/invalid_user'
    HomeURL = '/'
    Left = 620
    Top = 288
  end
  object WebSessionMgr: TWebSessionManager
    Scope = ssUser
    OnCreated = WebSessionMgrCreated
    OnAcquire = WebSessionMgrAcquire
    Left = 616
    Top = 64
  end
  object wspLogin: TWebStencilsProcessor
    Engine = wsEngineCustList
    InputFileName = 'html/login-wStencils.html'
    UserLoggedIn = True
    Left = 164
    Top = 244
  end
end
