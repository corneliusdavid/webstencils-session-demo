object webCustListWebStencil: TwebCustListWebStencil
  OnCreate = WebModuleCreate
  Actions = <>
  Height = 416
  Width = 373
  object wsEngineCustList: TWebStencilsEngine
    Dispatcher = WebFileDispatcher
    PathTemplates = <>
    RootDirectory = '/html'
    OnError = wsEngineCustListError
    Left = 112
    Top = 40
  end
  object WebSessionMgr: TWebSessionManager
    Left = 187
    Top = 83
  end
  object WebFormsAuthenticator: TWebFormsAuthenticator
    LoginURL = '/login'
    FailedURL = '/loginfailed'
    HomeURL = '/'
    LogoutURL = '/logout'
    OnAuthenticate = WebFormsAuthenticatorAuthenticate
    Left = 192
    Top = 157
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
    Left = 192
    Top = 232
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
    BeforeDispatch = WebFileDispatcherBeforeDispatch
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
    Left = 176
    Top = 320
  end
end
