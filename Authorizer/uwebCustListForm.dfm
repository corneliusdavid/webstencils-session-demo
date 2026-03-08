object webCustListWebStencil: TwebCustListWebStencil
  OnCreate = WebModuleCreate
  Actions = <
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
    end>
  Height = 416
  Width = 455
  object wsEngineCustList: TWebStencilsEngine
    Dispatcher = WebFileDispatcher
    PathTemplates = <>
    RootDirectory = '/html'
    OnError = wsEngineCustListError
    Left = 256
    Top = 32
  end
  object WebSessionMgr: TWebSessionManager
    Left = 331
    Top = 75
  end
  object WebFormsAuthenticator: TWebFormsAuthenticator
    LoginURL = '/login'
    FailedURL = '/loginfailed'
    HomeURL = '/'
    LogoutURL = '/logout'
    OnAuthenticate = WebFormsAuthenticatorAuthenticate
    Left = 336
    Top = 149
  end
  object WebAuthorizer: TWebAuthorizer
    UnauthorizedURL = '/notallowed'
    Zones = <
      item
        PathInfo = '/'
        Kind = zkFree
      end
      item
        PathInfo = '/custlist'
      end
      item
        PathInfo = '/custedit'
        Roles = 'viewer,editor'
      end
      item
        PathInfo = '/emplist'
        Roles = 'manager'
      end>
    OnAuthorize = WebAuthorizerAuthorize
    Left = 336
    Top = 224
  end
  object wspCustList: TWebStencilsProcessor
    Engine = wsEngineCustList
    InputFileName = 'html/custlist.html'
    UserRoles = 'viewer,editor,manager'
    Left = 96
    Top = 211
  end
  object wspCustEdit: TWebStencilsProcessor
    Engine = wsEngineCustList
    InputFileName = 'html/custedit.html'
    UserRoles = 'editor,manager'
    Left = 99
    Top = 278
  end
  object WebFileDispatcher: TWebFileDispatcher
    WebFileExtensions = <
      item
        MimeType = 'text/css'
        Extensions = 'css'
      end
      item
        MimeType = 'text/html'
        Extensions = 'html;htm'
      end
      item
        MimeType = 'application/javascript'
        Extensions = 'js'
      end
      item
        MimeType = 'image/jpeg'
        Extensions = 'jpeg;jpg'
      end
      item
        MimeType = 'image/png'
        Extensions = 'png'
      end>
    WebDirectories = <
      item
        DirectoryAction = dirInclude
        DirectoryMask = '*'
      end
      item
        DirectoryAction = dirExclude
        DirectoryMask = '\html\*'
      end>
    RootDirectory = 'html'
    VirtualPath = '/'
    DefaultFile = 'index.html'
    Left = 320
    Top = 312
  end
end
