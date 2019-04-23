{**********************************************************}
{          DSoft Delphi Visual Component Library           }
{                                                          }
{      COLLAPSE PANEL ver 1.1 - Copyright (c) DSoft        }
{                                                          }
{        unit tested : in Delphi 5, 7 and 2006             }
{    unit not tested : in Delphi 4, 6                      }
{                                                          }
{ Disclaimer: This component is freeware so I take no      }
{             responsibility for any problems or losses    }
{             that may occur, use at your own risk         }
{                                                          }
{ This component is freeware, but if you modify anything   }
{ send me the changes. If you modify the component you may }
{ then include your copyright along with the original one. }
{ You are free to distribute this component provided this  }
{ readme file is not modified or removed from the          }
{ distribution.                                            }
{                                                          }
{ This component cannot be used in a commercial            }
{ application without my written approval.                 }
{                                                          }
{ i.e. you cannot include this component in an application }
{ that you are making money from, without my approval.     }
{                                                          }
{ Please feel free to send me any comments                 }
{                                                          }
{ Programmer: Melnikov Evgeny                              }
{   http:\\dsoft1961.narod.ru                              }
{   mailto: dsoft1961@yandex.ru                            }
{                                                          }
{**********************************************************}

unit DSCollPanel;

interface

{$IFDEF VER100} { Borland Delphi 3.0 }
  {$DEFINE D3}
{$ENDIF}
{$IFDEF VER120} { Borland Delphi 4.0 }
  {$DEFINE D3}
  {$DEFINE D4}
{$ENDIF}
{$IFDEF VER130} { Borland Delphi 5.0 }
  {$DEFINE D3}
  {$DEFINE D4}
  {$DEFINE D5}
{$ENDIF}
{$IFDEF VER140} { Borland Delphi 6.0 }
  {$DEFINE D3}
  {$DEFINE D4}
  {$DEFINE D5}
  {$DEFINE D6}
{$ENDIF}
{$IFDEF VER150} { Borland Delphi 7.0 }
  {$DEFINE D3}
  {$DEFINE D4}
  {$DEFINE D5}
  {$DEFINE D6}
  {$DEFINE D7}
{$ENDIF}
{$IFDEF VER180} { Borland Delphi 2006 }
  {$DEFINE D3}
  {$DEFINE D4}
  {$DEFINE D5}
  {$DEFINE D6}
  {$DEFINE D7}
  {$DEFINE D10}
{$ENDIF}

uses
  Windows, Types, Messages, SysUtils, Classes, Controls, StdCtrls, 
  Forms, CommCtrl, ExtCtrls, Graphics;

{$IFDEF D3}
const
  TTM_SETMARGIN		= WM_USER + 26;  // lParam = lprc
  TTM_GETMARGIN		= WM_USER + 27;  // lParam = lprc
  TOOLTIPS_CLASS	= 'tooltips_class32';
{$ENDIF}

type

  TDSCollapsePanel	= class;

  TColorPanel = class(TPersistent)
  private
    fActiveHeaderColor	: TColor;
    fInactiveHeaderColor: TColor;
    fActiveBorderColor	: TColor;
    fInactiveBorderColor: TColor;
    fOnChange		: TNotifyEvent;
    procedure SetColor(Index : Integer; const Value : TColor);
  public
    constructor Create; virtual;
    property OnChange		 : TNotifyEvent read fOnChange write fOnChange;
  published
    property ActiveHeaderColor	 : TColor index 0 read fActiveHeaderColor   write SetColor default $CF9030;
    property InactiveHeaderColor : TColor index 1 read fInactiveHeaderColor write SetColor default $F0CAA6;
    property ActiveBorderColor	 : TColor index 2 read fActiveBorderColor   write SetColor default clGreen;
    property InactiveBorderColor : TColor index 3 read fInactiveBorderColor write SetColor default clRed;
  end;
  
  TDSCollapsePanel = class(TCustomPanel)
  private
    { Private declarations }
    ti : TToolInfo;
    fAlign : TAlign;
    fColorPanel : TColorPanel;
    fHint		: String;
    fBorderColor	: Boolean;
    fExpanded : Boolean;
    fExpanding		: Boolean;
    fShowHint		: Boolean;
    fNCRect		: TRect;
    fSrcBitmap		: TBitmap;
    fBorderWidth, 
    fExpandedHeight,
    fExpandedWidth,
    fMinExpandedHeight,
    fMinExpandedWidth,
    fStep		: Integer;
    fOnCollapseChanging,
    fOnCollapseChanged : TNotifyEvent;
    function  GetMinWidth: Integer;
    function  GetMinHeight: Integer;
    procedure SetAlign(const Value: TAlign);
    procedure SetHint(const Value: String);
    procedure SetShowHint(const Value: Boolean);
    procedure SetStep(const Value: Integer);
    procedure SetHeaderImage(Value: TBitmap);
    procedure SetBorderColor(const Value : Boolean);
    procedure SetBorderWidth(const Value : Integer);
    procedure DoColorPanelChange(Sender: TObject);

    {Messages}
    procedure WMNCCalcSize(var Message: TWMNCCalcSize); message WM_NCCALCSIZE; 
    procedure WMNCPaint(var Message: TWMNCPaint); message WM_NCPAINT; 
    procedure WMSetCursor(var Message: TWMSetCursor); message WM_SETCURSOR; 
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure WMNCHitTest(var Message: TWMNCHitTest); message WM_NCHITTEST; 
    procedure WMNCLButtonDown(var Message: TWMNCLButtonDown); message WM_NCLBUTTONDOWN; 
    procedure WMNCLButtonDblClk(var Message: TWMNCLButtonDblClk); message WM_NCLBUTTONDBLCLK;
    procedure CMEnter(var Message: TCMGotFocus); message CM_ENTER;
    procedure CMExit(var Message: TCMExit);   message CM_EXIT;
    procedure SetExpanded(const Value: Boolean);
  protected
    { Protected declarations }
    procedure Loaded; override;
    function  CreateToolTip : THandle;
    procedure ShowToolTip(St : PWideChar);
    function  GetNCArea(Pt : TPoint) : TPoint;
    procedure RedrawBorder;
    procedure RedrawHeader;
    procedure RedrawNCImage;
    procedure CollapseButtonClick(Sender: TObject);
    procedure GlyphChanged(Sender: TObject);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Expanded : Boolean read fExpanded write SetExpanded;
    property Canvas;
  published
    { Published declarations }
    property Align : TAlign      read  fAlign write SetAlign default alNone;
    property BorderColor : Boolean     read fBorderColor   write SetBorderColor default True;
    property BorderWidth : Integer     read fBorderWidth   write SetBorderWidth default 2;
    property ColorPanel  : TColorPanel read fColorPanel    write fColorPanel;
    property Hint	 : String      read fHint          write SetHint;
    property ShowHint : Boolean     read fShowHint      write SetShowHint default False;
    property Step	 : Integer     read fStep          write SetStep default 8;
    property MinExpandedHeight : Integer     read fMinExpandedHeight   write fMinExpandedHeight;
    property MinExpandedWidth : Integer     read fMinExpandedWidth   write fMinExpandedWidth; 
    property OnCollapseChanging : TNotifyEvent read fOnCollapseChanging write fOnCollapseChanging;
    property OnCollapseChanged : TNotifyEvent read fOnCollapseChanged write fOnCollapseChanged;
{$IFDEF D5}
    property Anchors;
    property AutoSize;
    property BiDiMode;
    property Color;
    property Constraints;
    property UseDockManager default True;
    property DockSite;
    property DragKind;
    property DragMode;
    property ParentBiDiMode;
    property OnCanResize;
    property OnConstrainedResize;
    property OnContextPopup;
    property OnDockDrop;
    property OnDockOver;
    property OnEndDock;
    property OnGetSiteInfo;
    property OnStartDock;
    property OnUnDock;
{$ENDIF}
//    property BorderStyle;
    property Caption;
    property Ctl3D;
    property DragCursor;
    property Enabled;
    property FullRepaint;
    property Font;
    property Locked;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnStartDrag;
    property TabOrder;
    property TabStop;
    property Visible;
  end;

procedure Register;

implementation

{$R glyphs_dscollpnl.res}

var  
  hToolTip	: THandle;
  hHook		: THandle;

procedure BltTransparent(DstDC: HDC;
			 DstX, DstY, DstW, DstH: Integer;
			 SrcDC: HDC;
			 SrcX, SrcY, SrcW, SrcH: Integer;
			 TransparentColor: TColorRef);
var
  Color		: TColorRef;
  bmAndBack,
  bmAndObject,
  bmAndMem,
  bmSave	: HBitmap;
  bmBackOld,
  bmObjectOld,
  bmMemOld,
  bmSaveOld	: HBitmap;
  MemDC,
  BackDC,
  ObjectDC,
  SaveDC	: HDC;
begin
  SetStretchBltMode(DstDC, STRETCH_DELETESCANS);

  BackDC   := CreateCompatibleDC(DstDC);
  ObjectDC := CreateCompatibleDC(DstDC);
  MemDC    := CreateCompatibleDC(DstDC);
  SaveDC   := CreateCompatibleDC(DstDC);

  bmAndObject := CreateBitmap(SrcW, SrcH, 1, 1, nil);
  bmAndBack   := CreateBitmap(SrcW, SrcH, 1, 1, nil);
  bmAndMem    := CreateCompatibleBitmap(DstDC, DstW, DstH);
  bmSave      := CreateCompatibleBitmap(DstDC, SrcW, SrcH);

  bmBackOld   := SelectObject(BackDC, bmAndBack);
  bmObjectOld := SelectObject(ObjectDC, bmAndObject);
  bmMemOld    := SelectObject(MemDC, bmAndMem);
  bmSaveOld   := SelectObject(SaveDC, bmSave);

  SetMapMode(SrcDC, GetMapMode(DstDC));
  SetMapMode(SaveDC, GetMapMode(DstDC));

  BitBlt(SaveDC, 0, 0, SrcW, SrcH, SrcDC, SrcX, SrcY, SRCCOPY);
  Color := SetBkColor(SaveDC, TransparentColor or $02000000);
  BitBlt(ObjectDC, 0, 0, SrcW, SrcH, SaveDC, 0, 0, SRCCOPY);
  SetBkColor(SaveDC, Color);
  BitBlt(BackDC, 0, 0, SrcW, SrcH, ObjectDC, 0, 0, NOTSRCCOPY);
  BitBlt(MemDC, 0, 0, DstW, DstH, DstDC, DstX, DstY, SRCCOPY);
  StretchBlt(MemDC, 0, 0, DstW, DstH, ObjectDC, 0, 0, SrcW, SrcH, SRCAND);
  BitBlt(SaveDC, 0, 0, SrcW, SrcH, BackDC, 0, 0, SRCAND);
  StretchBlt(MemDC, 0, 0, DstW, DstH, SaveDC, 0, 0, SrcW, SrcH, SRCPAINT);
  BitBlt(DstDC, DstX, DstY, DstW, DstH, MemDC, 0, 0, SRCCOPY);

  DeleteObject(SelectObject(BackDC, bmBackOld));
  DeleteObject(SelectObject(ObjectDC, bmObjectOld));
  DeleteObject(SelectObject(MemDC, bmMemOld));
  DeleteObject(SelectObject(SaveDC, bmSaveOld));

  DeleteDC(MemDC);
  DeleteDC(BackDC);
  DeleteDC(ObjectDC);
  DeleteDC(SaveDC);
end;

//---------------------------------------------------------

function HookProc(nCode, wParam, lParam : Integer): Integer; stdcall;
var
  I	: Integer;
begin
  I := PMsg(lParam)^.message;
  if (nCode >= 0) and ((I = WM_MOUSEMOVE) or
		       (I = WM_NCMOUSEMOVE) or
		       (I = WM_NCLBUTTONDOWN) or
		       (I = WM_LBUTTONUP) or
		       (I = WM_RBUTTONUP) or
		       (I = WM_RBUTTONDOWN)) then
    SendMessage(hToolTip, TTM_RELAYEVENT, 0, lParam);
  Result := CallNextHookEx(hHook, nCode, wParam, lParam);
end;

//---------------------------------------------------------

procedure RecalcNCArea(const Ctl: TWinControl);
begin
  if Ctl.HandleAllocated then
    SetWindowPos(Ctl.Handle, 0, 0, 0, 0, 0, 
		 SWP_FRAMECHANGED or SWP_NOACTIVATE or 
		 SWP_NOMOVE or SWP_NOSIZE or SWP_NOZORDER);
end;

//---------------------------------------------------------
//  TColorssPanel
//---------------------------------------------------------

constructor TColorPanel.Create;
begin
  inherited Create;

  fActiveHeaderColor	:= $CF9030;
  fInactiveHeaderColor	:= $F0CAA6;
  fActiveBorderColor	:= clGreen;
  fInactiveBorderColor	:= clRed;
end;

procedure TColorPanel.SetColor(Index : Integer; const Value: TColor);
begin
  case Index of
    0 : fActiveHeaderColor   := Value;
    1 : fInactiveHeaderColor := Value;
    2 : fActiveBorderColor   := Value;
    3 : fInactiveBorderColor := Value;
  end;
  if Assigned(fOnChange) then fOnChange(Self);
end;

//---------------------------------------------------------
//  TDSCollapsePanel
//---------------------------------------------------------

constructor TDSCollapsePanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Caption := '';
//  ControlStyle := ControlStyle + [csAcceptsControls, csOpaque];
  ControlStyle := ControlStyle + [csAcceptsControls, csCaptureMouse, csClickEvents,
		   csSetCaption, csOpaque, csDoubleClicks, csReplicatable]; 

  fColorPanel := TColorPanel.Create;
  fSrcBitmap := TBitmap.Create;
  hToolTip := CreateToolTip;
  if hHook = 0 then
    hHook := SetWindowsHookEx(WH_GETMESSAGE, @HookProc, 0, GetCurrentThreadID);
  
  {Width			:= 150;
  Height		:= 270;
  inherited Align	:= alNone;
  Color			:= clBtnFace;
  fHint			:= '';
  fShowHint		:= False;}
  fBorderWidth		:= 2;
  BevelInner		:= bvNone;
  BevelOuter		:= bvNone;
  //ParentColor		:= True;
  fExpandedHeight := Height;
  fExpandedWidth	:= Width; 
  fStep := 8;
  fExpanded := True;
  fExpanding := False;
  fBorderColor := True;
  TabStop		:= True;
  SetHeaderImage(NIL);
  fColorPanel.OnChange := DoColorPanelChange;
  fSrcBitmap.OnChange	:= GlyphChanged;
end;

destructor TDSCollapsePanel.Destroy;
begin
  if hHook <> 0 then 
    UnhookWindowsHookEx(hHook);
  hHook := 0;
  fSrcBitmap.OnChange := NIL;
  FreeAndNil(fSrcBitmap);
  fColorPanel.OnChange := NIL;
  FreeAndNil(fColorPanel);
  inherited Destroy;
end;

procedure TDSCollapsePanel.Loaded;
begin
  inherited Loaded;
  invalidate;
end;

procedure TDSCollapsePanel.DoColorPanelChange(Sender: TObject);
begin
  RedrawBorder;
  RedrawHeader;
end;

function TDSCollapsePanel.CreateToolTip : THandle;
var
  aRect	: TRect;
begin
  Result := CreateWindow(TOOLTIPS_CLASS, nil, TTS_ALWAYSTIP,
			Integer(CW_USEDEFAULT),
			Integer(CW_USEDEFAULT),
			Integer(CW_USEDEFAULT),
			Integer(CW_USEDEFAULT),
			0, 0, hInstance, NIL);
  if Result <> 0 then
  begin
    ti.cbSize	:= SizeOf(TToolInfo);
    ti.uFlags	:= TTF_SUBCLASS;
    ti.hwnd	:= 0;
    //if not (csDesigning in ComponentState) then
    ti.hwnd	:= Result;
    ti.hinst	:= hInstance;
    ti.uId	:= 0;
    SendMessage(Result, TTM_GETMARGIN, 0, Integer(@aRect));
    SetRect(aRect, aRect.Left, aRect.Top, aRect.Right + 2, aRect.Bottom);
    SendMessage(Result, TTM_SETMARGIN, 0, Integer(@aRect));
  end;
end;

procedure TDSCollapsePanel.ShowToolTip(St : PWideChar);
var
  aRect,
  bRect	: TRect;
begin
  if (hToolTip = 0) or isRectEmpty(fNCRect) then
    Exit;

  if (fShowHint) then
  begin
    Windows.GetWindowRect(Handle, aRect);
    Windows.GetClientRect(Handle, bRect);
    case fAlign of
      alNone, alRight:
      begin
        dec(aRect.Right, bRect.Right);
      end;
      alTop:
      begin
        inc(aRect.Top, bRect.Bottom)
      end;
      alBottom:
      begin
        dec(aRect.Bottom, bRect.Top);
      end;
      alLeft:
      begin
        inc(aRect.Left, bRect.Right)
      end;
    end;

    MapWindowPoints(0, Handle, aRect, 2);
    aRect.Bottom := aRect.Top + fSrcBitmap.Height + BorderWidth + 1;

    ti.lpszText	:= St;
    ti.rect	:= aRect;

    SendMessage(hToolTip, TTM_ADDTOOL, 0, Integer(@ti));
  end;  
end;

function TDSCollapsePanel.GetNCArea(Pt : TPoint) : TPoint;
begin
  Result := ScreenToClient(Pt);
  case fAlign of
    alNone, alRight:
      inc(Result.x, (fNCRect.Right - fNCRect.Left) + BorderWidth + 2);
    alLeft: inc(Result.x, BorderWidth);
    alTop: inc(Result.y, fSrcBitmap.Height-BorderWidth);
    alBottom: inc(Result.y, fSrcBitmap.Height); 
  end;
end;

procedure TDSCollapsePanel.RedrawBorder;
var
  DC	 : HDC;
  I	 : Integer;
  aRect  : TRect;
  aColor : TColor;
  Brush	 : HBRUSH;
begin
  aColor := fColorPanel.fActiveBorderColor;
  if not fExpanded then
    aColor := fColorPanel.fInactiveBorderColor;

  if not BorderColor then
    aColor := Self.Color;
    
  DC := GetWindowDC(Handle);
  GetWindowRect(Handle, aRect);
  OffsetRect(aRect, -aRect.Left, -aRect.Top);
  try
    Brush := CreateSolidBrush(ColorToRGB(aColor));
    try
      for I := 1 to BorderWidth do
      begin
        FrameRect(DC, aRect, Brush);
        InflateRect(aRect, -1, -1);
      end;
    finally
      DeleteObject(Brush);
    end;  
  finally
    ReleaseDC(Handle, DC);
  end;
end;

procedure TDSCollapsePanel.RedrawHeader;
var
  DC	 : HDC;
  aRect  : TRect;
  aColor : TColor;
  Brush	 : HBRUSH;
begin
  aColor := 0;
  if (Focused or fExpanded) then
    aColor := fColorPanel.fActiveHeaderColor
  else //if (not Focused and not (csDesigning in ComponentState)) or (not fExpanded) then
    aColor := fColorPanel.fInactiveHeaderColor;

  DC := GetWindowDC(Handle);
  GetWindowRect(Handle, fNCRect);
  OffsetRect(fNCRect, -fNCRect.Left, -fNCRect.Top);
  Windows.GetClientRect(Handle, aRect);
  case fAlign of
    alNone, alRight:
    begin
      dec(fNCRect.Right, aRect.Right + BorderWidth * 2);
      dec(fNCRect.Bottom, BorderWidth * 2);
    end; 
    alLeft:
    begin
      dec(fNCRect.Right, BorderWidth * 2);
      inc(fNCRect.Left, aRect.Right);
      dec(fNCRect.Bottom, BorderWidth * 2);
    end;
    alTop:
    begin
      dec(fNCRect.Bottom, BorderWidth * 2);
      inc(fNCRect.Top, aRect.Bottom);
      dec(fNCRect.Right, BorderWidth * 2);
    end;
    alBottom:
    begin
      dec(fNCRect.Right, BorderWidth * 2);
      dec(fNCRect.Bottom, aRect.Bottom + BorderWidth * 2);
    end;
  end;

  OffsetRect(fNCRect, BorderWidth, BorderWidth);
  try
    Brush := CreateSolidBrush(ColorToRGB(aColor));
    try
      DrawEdge(DC, fNCRect, BDR_SUNKENOUTER, BF_RECT);
      InflateRect(fNCRect, -1, -1);
      FillRect(DC, fNCRect, Brush);
    finally
      DeleteObject(Brush);
    end;  
  finally
    ReleaseDC(Handle, DC);
  end;
  RedrawNCImage;
end;

procedure TDSCollapsePanel.RedrawNCImage;
var
  DC	 : HDC;
  fTransparentColor	: TColor;
begin
  fTransparentColor := fSrcBitmap.TransparentColor;
  DC := GetWindowDC(Handle);
  try
    case fAlign of
      alNone, alRight, alLeft:
        BltTransparent(DC, fNCRect.Left, fNCRect.Top, fSrcBitmap.Width, fSrcBitmap.Height,
        fSrcBitmap.Canvas.Handle, 0, 0, fSrcBitmap.Width, fSrcBitmap.Height, fTransparentColor);
     { alTop:
      BltTransparent(DC, fNCRect.Right - fSrcBitmap.Width, fNCRect.Top, fSrcBitmap.Width, fSrcBitmap.Height,
        fSrcBitmap.Canvas.Handle, 0, 0, fSrcBitmap.Width, fSrcBitmap.Height, fTransparentColor); }
      alTop, alBottom:
      BltTransparent(DC, fNCRect.Right - fSrcBitmap.Width, fNCRect.Top, fSrcBitmap.Width, fSrcBitmap.Height,
        fSrcBitmap.Canvas.Handle, 0, 0, fSrcBitmap.Width, fSrcBitmap.Height, fTransparentColor);
    end;

  finally
    ReleaseDC(Handle, DC);
  end;
end;

procedure TDSCollapsePanel.WMNCCalcSize(var Message: TWMNCCalcSize);
begin 
  inherited;
  with Message.CalcSize_Params^ do
  begin
    InflateRect(rgrc[0], -BorderWidth, -BorderWidth);
    if (fSrcBitmap <> NIL) then
    begin
      case fAlign of
        alNone, alRight:
        begin
	        inc(rgrc[0].Left, fSrcBitmap.Width + 2);
        end;
        alLeft:
        begin
          dec(rgrc[0].Right, fSrcBitmap.Width + 2);
        end;
        alTop:
        begin
          dec(rgrc[0].Bottom, fSrcBitmap.Height + 2);
        end;
        alBottom:
        begin
          inc(rgrc[0].Top, fSrcBitmap.Height + 2);
        end;
      end;
    end;
  end;
end; 

procedure TDSCollapsePanel.WMNCPaint(var Message: TWMNCPaint); 
begin 
  inherited; 
  RedrawBorder;
  RedrawHeader;
end;
  
procedure TDSCollapsePanel.WMSetCursor(var Message: TWMSetCursor); 
var
  P	: TPoint;
  aRect	: TRect;
begin 
  inherited;
  if (Message.HitTest <> HTCLOSE) then
    Exit;
  GetCursorPos(P);
  P := GetNCArea(P);
  aRect := fNCRect;
  case fAlign of
    alNone, 
    alLeft,
    alRight: aRect.Bottom := fSrcBitmap.Height + fNCRect.Top;
    alTop:
    begin
      aRect.Top := aRect.Bottom - fSrcBitmap.Height;
      aRect.Left := aRect.Right - fSrcBitmap.Width;
    end;
    alBottom:
    begin
      aRect.Bottom := aRect.Top + fSrcBitmap.Height;
      aRect.Left := aRect.Right - fSrcBitmap.Width;
    end;
  end;

  if PtInRect(aRect, P) then
    SetCursor(Screen.Cursors[crHandPoint])
  else 
    SetCursor(Screen.Cursors[crDefault]);
end;

procedure TDSCollapsePanel.WMSize(var Message: TWMSize);
var
  MinHeight, MinWidth : Integer;
begin
  MinWidth := GetMinWidth;
  MinHeight := GetMinHeight;
  if fExpanded and ((csDesigning in ComponentState) or (not fExpanding)) then
  begin
    fExpandedWidth := Width;
    fExpandedHeight := Height;
  end;

  if fExpanded then
  begin
    inherited;
      if Height < MinHeight then
         Height := MinHeight;
      if Width < MinWidth then
        Width := MinWidth;
  end;
  SendMessage(Handle, WM_NCPAINT, 0, 0); 
end;

procedure TDSCollapsePanel.WMNCHitTest(var Message: TWMNCHitTest); 
var
  aRect : TRect;
  P	: TPoint;
begin
  inherited;
  with Message do
  begin
    P := GetNCArea(SmallPointToPoint(Pos));
    if PtInRect(fNCRect, P) then
    begin
      aRect := fNCRect;
      case fAlign of
        alNone, 
        alLeft,
        alRight: aRect.Bottom := fSrcBitmap.Height + aRect.Top;
        alTop:
        begin
          aRect.Top := fNCRect.Bottom - fSrcBitmap.Height;
          aRect.Left := fNCRect.Right - fSrcBitmap.Width;
        end;
        alBottom:
        begin
          dec(aRect.Top, fSrcBitmap.Height);
          aRect.Left := fNCRect.Right - fSrcBitmap.Width;
        end;
      end;

      if PtInRect(aRect, P) then
	      Result := HTCLOSE
      else
	      Result := HTCAPTION;
    end;  
  end;
end;

procedure TDSCollapsePanel.WMNCLButtonDown(var Message: TWMNCLButtonDown); 
begin
  if not IsIconic(Handle) then
  begin
    if (Message.HitTest = HTCAPTION) then
    begin
      if not Focused then
	      SetFocus;
    end
    else if (Message.HitTest = HTCLOSE) and not (csDesigning in ComponentState) then
      CollapseButtonClick(Self);
  end;
end;

procedure TDSCollapsePanel.WMNCLButtonDblClk(var Message: TWMNCLButtonDblClk);
begin
  if (Message.HitTest = HTCAPTION) and not IsIconic(Handle) and not (csDesigning in ComponentState) and CanFocus then
    CollapseButtonClick(Self);
end;

procedure TDSCollapsePanel.CMEnter(var Message: TCMGotFocus);
begin
  RedrawHeader;
  inherited;
end;

procedure TDSCollapsePanel.CMExit(var Message: TCMExit);
begin
  RedrawHeader;
  inherited;
end;

procedure TDSCollapsePanel.CollapseButtonClick(Sender: TObject);
begin
  Expanded := not Expanded;
end;

procedure TDSCollapsePanel.SetAlign(const Value: TAlign);
begin
  if not (Value in [alNone, alLeft, alRight, alTop, alBottom]) or (fAlign = Value) then
    Exit;
  fAlign := Value;
  if not fExpanded then
  begin
    Visible := False;
    CollapseButtonClick(Self);
    Visible := True;
  end else 
    SetHeaderImage(nil);
  RecalcNCArea(Self);
  ShowToolTip(@fHint[1]);
  inherited Align := Value;
end;

procedure TDSCollapsePanel.SetHint(const Value: String);
begin
  if Value <> fHint then
  begin
    fHint := Value;
    if (fHint <> '') and (fShowHint) then
      ShowToolTip(@fHint[1]);
  end;
end;

procedure TDSCollapsePanel.SetShowHint(const Value: Boolean);
begin
  if Value <> fShowHint then
  begin
    fShowHint := Value;
    if (fHint <> '') and (fShowHint) then
      ShowToolTip(@fHint[1]);
  end;
end;

procedure TDSCollapsePanel.SetBorderColor(const Value: Boolean);
begin
  if Value = fBorderColor then Exit;
  fBorderColor := Value;
  RedrawBorder;
end;

procedure TDSCollapsePanel.SetBorderWidth(const Value: Integer);
begin
  if Value <> fBorderWidth then
  begin
    fBorderWidth := Value;
    if fBorderWidth < 0 then fBorderWidth := 0;
    if not Expanded then
      CollapseButtonClick(Self);
    RecalcNCArea(Self);
    RedrawHeader;
  end;  
end;

procedure TDSCollapsePanel.SetExpanded(const Value: Boolean);
begin
  if fExpanded = Value then
     exit;
  fExpanded := Value;
  if assigned(fOnCollapseChanging) then
    fOnCollapseChanging(self);

  if fAlign in [alTop, alBottom]  then
  begin
    if not fExpanded then
    begin
      // Expanded, do Collapse
      fExpanding := True;
      repeat
        if Height - fStep <= (fNCRect.Bottom - fNCRect.Top + 2) + BorderWidth + 2 then
        begin
          Height := (fNCRect.Bottom - fNCRect.Top + 2) + BorderWidth + 2;
          Break;
        end
        else
        Height := Height - fStep;
      until Height <= (fNCRect.Bottom - fNCRect.Top + 2) + BorderWidth + 2;

      Height := (fNCRect.Bottom - fNCRect.Top + 2) + BorderWidth + 2;       
      //Invalidate;
      fExpanding := False;
    end
    else
    begin
      // Collapsed, do expand
      fExpanding := True;
      repeat
        if Height + fStep >= fExpandedHeight then
        begin
          Height := fExpandedHeight;
          Break;
        end
        else
          Height := Height + fStep;
        //Refresh;
      until Height = fExpandedHeight;

      //Invalidate;
      fExpanding := False;
    end;
  end else
  begin
    if not fExpanded then
    begin
      // Expanded, do collapse
      fExpanding := True;
      repeat
        if Width - fStep <= (fNCRect.Right - fNCRect.Left + 2) + BorderWidth + 2 then
        begin
          Width := (fNCRect.Right - fNCRect.Left + 2) + BorderWidth + 2;
          Break;
        end
        else
        Width := Width - fStep;
      until Width <= (fNCRect.Right - fNCRect.Left + 2) + BorderWidth + 2;

      Width := (fNCRect.Right - fNCRect.Left + 2) + BorderWidth + 2;
      //Invalidate;
      fExpanding := False;
    end
    else
    begin
      // Collapsed, do expand
      fExpanding := True;
      repeat
        if Width + fStep >= fExpandedWidth then
        begin
          Width := fExpandedWidth;
          Break;
        end
        else
          Width := Width + fStep;
        Refresh;
      until Width = fExpandedWidth;
      fExpanding := False;
    end;
  end;
  Invalidate;       
  SetHeaderImage(nil);
  if Align = alClient then
    NotifyControls(WM_SIZE);
  if assigned(fOnCollapseChanged) then
    fOnCollapseChanged(self);
end;

function TDSCollapsePanel.GetMinHeight: Integer;
begin
  Result := fNCRect.Bottom - fNCRect.Top + fBorderWidth * 2;
end;

function TDSCollapsePanel.GetMinWidth: Integer;
begin
  Result := fNCRect.Right - fNCRect.Left + fBorderWidth * 2;
end;

procedure TDSCollapsePanel.SetStep(const Value: Integer);
begin
  if (Value <> fStep) then
    if (Value > 0) then
      fStep := Value
    else
      fStep := 1;
end;

procedure TDSCollapsePanel.SetHeaderImage(Value: TBitmap);
begin
  if Value <> NIL then
    fSrcBitmap.Assign(Value)
  else
  case fAlign of
    alNone,alRight:
    begin
      if fExpanded then
        fSrcBitmap.Handle := LoadBitmap(hInstance, 'DS_REXPANDED')
      else
        fSrcBitmap.Handle := LoadBitmap(hInstance, 'DS_RCOLAPCED');
    end;
    alTop:
    begin
      if fExpanded then
        fSrcBitmap.Handle := LoadBitmap(hInstance, 'DS_TEXPANDED')
      else
        fSrcBitmap.Handle := LoadBitmap(hInstance, 'DS_TCOLAPCED');
    end;
    alBottom:
    begin
      if fExpanded then
        fSrcBitmap.Handle := LoadBitmap(hInstance, 'DS_BEXPANDED')
      else
        fSrcBitmap.Handle := LoadBitmap(hInstance, 'DS_BCOLAPCED');
    end;
    alLeft:
    begin
      if fExpanded then
        fSrcBitmap.Handle := LoadBitmap(hInstance, 'DS_LEXPANDED')
      else
        fSrcBitmap.Handle := LoadBitmap(hInstance, 'DS_LCOLAPCED');
    end;
  end;
end;

procedure TDSCollapsePanel.GlyphChanged(Sender : TObject);
begin
  RecalcNCArea(Self);
end;

procedure Register;
begin
  RegisterComponents('CollapsePanel', [TDSCollapsePanel]);
end;

end.
