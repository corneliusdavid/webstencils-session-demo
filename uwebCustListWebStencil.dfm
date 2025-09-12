object webCustListWebStencil: TwebCustListWebStencil
  OnCreate = WebModuleCreate
  Actions = <
    item
      Default = True
      MethodType = mtGet
      Name = 'DefaultHandler'
      PathInfo = '/'
      OnAction = webCustListWebStencilDefaultHandlerAction
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
    end>
  Height = 461
  Width = 630
  object wspIndex: TWebStencilsProcessor
    Engine = wsEngineCustList
    InputFileName = 'html\index-wStencils.html'
    UserLoggedIn = True
    Left = 104
    Top = 104
  end
  object wsEngineCustList: TWebStencilsEngine
    PathTemplates = <>
    OnError = wsEngineCustListError
    Left = 64
    Top = 32
  end
  object wspLoginFailed: TWebStencilsProcessor
    Engine = wsEngineCustList
    InputFileName = 'html\loginfailed-wStencils.html'
    Left = 104
    Top = 168
  end
  object wspCustList: TWebStencilsProcessor
    Engine = wsEngineCustList
    InputFileName = 'html\custlist-wStencils.html'
    UserLoggedIn = True
    Left = 208
    Top = 128
  end
  object wspAccessDenied: TWebStencilsProcessor
    Engine = wsEngineCustList
    InputFileName = 'accessdenied-wStencils.html'
    Left = 112
    Top = 232
  end
  object wspCustEdit: TWebStencilsProcessor
    Engine = wsEngineCustList
    InputFileName = 'html\custedit-wStencils.html'
    Left = 208
    Top = 192
  end
  object WebAuthorizer1: TWebAuthorizer
    Zones = <
      item
        PathInfo = '/custlist'
        Kind = zkFree
      end>
    Left = 408
    Top = 136
  end
  object WebSessionManager1: TWebSessionManager
    Scope = ssUserAndIP
    Timeout = 60
    Left = 408
    Top = 224
  end
  object WebFormsAuthenticator1: TWebFormsAuthenticator
    LoginURL = '/login'
    HomeURL = '/custlist'
    Left = 408
    Top = 288
  end
end
