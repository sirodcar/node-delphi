unit TestV8Engine;
{

  Delphi DUnit Test Case
  ----------------------
  This unit contains a skeleton test case class generated by the Test Case Wizard.
  Modify the generated code to correctly setup and call the methods from the unit 
  being tested.

}

interface

uses
  TestFramework, V8Interface, Contnrs, ActiveX, SysUtils, Generics.Collections, RTTI,
  Windows, ObjComAuto, Variants, Classes, syncObjs, V8Engine, V8API, types, ScriptInterface,
  IOUtils, TypInfo, SampleClasses, Math;

type

  TTestGlobalNamespace = class
  private
    FEng: TJSEngine;
    FSys: TJSSystemNamespace;
    FHelper: TSomeObjectHelper;
    FChildHelper: TSomeChildHelper;
    function GetSystem: TJSSystemNamespace;
  public
    constructor Create(Eng: TJSEngine);
    destructor Destroy; override;
    property system: TJSSystemNamespace read GetSystem;
    [TGCAttr]
    function NewVectorList: TVectorList;
    [TGCAttr]
    function NewVector(x: double = 0; y: double = 0; z: double = 0): TVector3; overload;
    [TGCAttr]
    function NewVector(): TVector3; overload;
    [TGCAttr]
    function NewCallBackClass: TCallBackClass;
    [TGCAttr]
    function NewSomeObject: TSomeObject;
    [TGCAttr]
    function NewSomeChild: TSomeChild;
    [TGCAttr]
    function NewAttrObject: TSomeAttrObject;
    function Multiplicate(arg1, arg2: double; arg3: double = 1.0): double;
    function VLength(vec: TVector3): double;
  end;

  // Test methods for class TJSEngine

  TestTJSEngine = class(TTestCase)
  strict private
    FJSEngine: TJSEngine;
    FGlobal: TTestGlobalNamespace;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestHelper;
    procedure TestRecords;
    procedure TestCallBack;
    procedure TestAttributes;
  end;

implementation

procedure TestTJSEngine.SetUp;
begin
  Math.SetExceptionMask([exInvalidOp, exDenormalized, exZeroDivide, exOverflow,
        exUnderflow, exPrecision]);
  FJSEngine := TJSEngine.Create;
  FGlobal := TTestGlobalNamespace.Create(FJSEngine);
  FJSEngine.AddGlobal(FGlobal);
end;

procedure TestTJSEngine.TearDown;
begin
  FJSEngine.Free;
  FJSEngine := nil;
end;

procedure TestTJSEngine.TestAttributes;
var
  ReturnValue: string;
begin
  ReturnValue := FJSEngine.RunFile('..\scripts\TestAttributes.js', ParamStr(0));
  FJSEngine.Log.Add('<<ReturnCode>> ' + ReturnValue);
  FJSEngine.Log.SaveToFile('TestAttributes.log');
  Assert(ReturnValue <> '0', FJSEngine.Log.Text);
end;

procedure TestTJSEngine.TestCallBack;
var
  ReturnValue: string;
begin
  ReturnValue := FJSEngine.RunFile('..\scripts\TestCallBack.js', ParamStr(0));
  FJSEngine.Log.Add('<<ReturnCode>> ' + ReturnValue);
  FJSEngine.Log.SaveToFile('TestCallBack.log');
  Assert(ReturnValue = '0', FJSEngine.Log.Text);
end;

procedure TestTJSEngine.TestHelper;
var
  ReturnValue: string;
begin
  ReturnValue := FJSEngine.RunFile('..\scripts\TestHelper.js', ParamStr(0));
  FJSEngine.Log.Add('<<ReturnCode>> ' + ReturnValue);
  FJSEngine.Log.SaveToFile('TestHelper.log');
  Assert(ReturnValue = '0', FJSEngine.Log.Text);
end;

procedure TestTJSEngine.TestRecords;
var
  ReturnValue: string;
begin
  ReturnValue := FJSEngine.RunFile('..\scripts\TestRecords.js', ParamStr(0));
  FJSEngine.Log.Add('<<ReturnCode>> ' + ReturnValue);
  FJSEngine.Log.SaveToFile('TestRecords.log');
  Assert(ReturnValue = '0', FJSEngine.Log.Text);
end;

{ TTestGlobalNamespace }

constructor TTestGlobalNamespace.Create(Eng: TJSEngine);
begin
  FEng := Eng;
  FHelper := TSomeObjectHelper.Create;
  FChildHelper := TSomeChildHelper.Create;
  FEng.RegisterHelper(TSomeObject, FHelper);
  FEng.RegisterHelper(TSomeChild, FChildHelper);
  FSys := Eng.GetSystem;
end;

destructor TTestGlobalNamespace.Destroy;
begin
  FreeAndNil(FHelper);
  FreeAndNil(FChildHelper);
end;

function TTestGlobalNamespace.GetSystem: TJSSystemNamespace;
begin
  Result := FSys;
end;

function TTestGlobalNamespace.Multiplicate(arg1, arg2, arg3: double): double;
begin
  Result := arg1 * arg2 * arg3;
end;

function TTestGlobalNamespace.NewAttrObject: TSomeAttrObject;
begin
  Result := TSomeAttrObject.Create;
end;

function TTestGlobalNamespace.NewCallBackClass: TCallBackClass;
begin
  Result := TCallBackClass.Create;
end;

function TTestGlobalNamespace.NewSomeChild: TSomeChild;
begin
  Result := TSomeChild.Create;
end;

function TTestGlobalNamespace.NewSomeObject: TSomeObject;
begin
  Result := TSomeObject.Create;
end;

function TTestGlobalNamespace.NewVector(x, y, z: double): TVector3;
begin
  Result := TVector3.Create(x, y, z);
end;

function TTestGlobalNamespace.NewVector: TVector3;
begin
  Result := TVector3.Create(0, 0, 0);
end;

function TTestGlobalNamespace.NewVectorList: TVectorList;
begin
  Result := TVectorList.Create;
end;

function TTestGlobalNamespace.VLength(vec: TVector3): double;
begin
  Result := vec.Length;
end;

initialization
  // Register any test cases with the test runner
  RegisterTest(TestTJSEngine.Suite);
end.

