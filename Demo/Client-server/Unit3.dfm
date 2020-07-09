object fPrincipal: TfPrincipal
  Left = 0
  Top = 0
  Caption = 'Cliente'
  ClientHeight = 547
  ClientWidth = 742
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 21
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 64
    Height = 30
    Caption = 'Cliente'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
  end
  object Button1: TButton
    Left = 659
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Connect'
    TabOrder = 0
    OnClick = Button1Click
  end
  object memLog: TMemo
    Left = 8
    Top = 119
    Width = 726
    Height = 418
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Consolas'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
  end
  object Edit1: TEdit
    Left = 8
    Top = 84
    Width = 645
    Height = 29
    TabOrder = 2
  end
  object Button2: TButton
    Left = 659
    Top = 84
    Width = 75
    Height = 29
    Caption = 'Send'
    TabOrder = 3
    OnClick = Button2Click
  end
  object Edit2: TEdit
    Left = 8
    Top = 44
    Width = 513
    Height = 29
    TabOrder = 4
    Text = 'socket_name'
  end
end
