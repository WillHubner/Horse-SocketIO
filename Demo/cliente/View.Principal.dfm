object Principal: TPrincipal
  Left = 0
  Top = 0
  Caption = 'Principal'
  ClientHeight = 373
  ClientWidth = 599
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 21
  object edSocketName: TEdit
    Left = 8
    Top = 8
    Width = 502
    Height = 29
    TabOrder = 0
    Text = 'socket_name'
  end
  object Button1: TButton
    Left = 516
    Top = 8
    Width = 75
    Height = 29
    Caption = 'Connect'
    TabOrder = 1
    OnClick = Button1Click
  end
  object memLog: TMemo
    Left = 8
    Top = 43
    Width = 583
    Height = 322
    TabOrder = 2
  end
end
