// This code was generated by the Gardens Point Parser Generator
// Copyright (c) Wayne Kelly, John Gough, QUT 2005-2014
// (see accompanying GPPGcopyright.rtf)

// GPPG version 1.5.2
// Machine:  VDI-VL17-074
// DateTime: 12/04/2017 6:03:56 PM
// UserName: n9768653
// Input file <parser.y - 12/04/2017 6:03:52 PM>

// options: lines gplex

using System;
using System.Collections.Generic;
using System.CodeDom.Compiler;
using System.Globalization;
using System.Text;
using QUT.Gppg;

namespace IFN660_Java_ECMAScript
{
public enum Tokens {error=128,EOF=129,NUMBER=130,IDENTIFIER=131,ABSTRACT=132,
    CONTINUE=133,FOR=134,NEW=135,SWITCH=136,ASSERT=137,DEFAULT=138,
    IF=139,PACKAGE=140,SYNCHRONIZED=141,BOOLEAN=142,DO=143,GOTO=144,
    PRIVATE=145,THIS=146,BREAK=147,DOUBLE=148,IMPLEMENTS=149,PROTECTED=150,
    THROW=151,BYTE=152,ELSE=153,IMPORT=154,PUBLIC=155,THROWS=156,
    CASE=157,ENUM=158,INSTANCEOF=159,RETURN=160,TRANSIENT=161,CATCH=162,
    EXTENDS=163,INT=164,SHORT=165,TRY=166,CHAR=167,FINAL=168,
    INTERFACE=169,STATIC=170,VOID=171,CLASS=172,FINALLY=173,LONG=174,
    STRICTFP=175,VOLATILE=176,CONST=177,FLOAT=178,NATIVE=179,SUPER=180,
    WHILE=181,IntegerLiteral=182,FloatingPointLiteral=183,BooleanLiteral=184,CharacterLiteral=185,StringLiteral=186,
    NullLiteral=187,ELLIPSIS=188,DOUBLE_COLON=189,EQUAL=190,GREATER_OR_EQUAL=191,LESS_THAN_OR_EQUAL=192,
    NOT_EQUAL=193,ARROW=194,LOGICAL_AND=195,LOGICAL_OR=196,INCREMENT=197,DECREMENT=198,
    LEFT_SHIFT=199,SIGNED_RIGHT_SHIFT=200,UNSIGNED_RIGHT_SHIFT=201,ADDITION_ASSIGNMENT=202,SUBTRACTION_ASSIGNMENT=203,MULTIPLICATION_ASSIGNMENT=204,
    DIVISION_ASSIGNMENT=205,MODULUS_ASSIGNMENT=206,BITWISE_AND_ASSIGNMENT=207,BITWISE_OR_ASSIGNMENT=208,BITWISE_XOR_ASSIGNMENT=209,LEFT_SHIFT_ASSIGNMENT=210,
    UNSIGNED_RIGHT_SHIFT_ASSIGNMENT=211,SIGNED_RIGHT_SHIFT_ASSIGNMENT=212};

public struct ValueType
#line 8 "parser.y"
{
    public long num;
	public double floatnum;
	public bool boolval;
	public char charval;
    public string name;
	public AST.Statement stmt;
	public AST.Expression expr;
	public AST.Type type;
	public AST.CompilationUnitDeclaration cmpu;
	public System.Collections.Generic.List<AST.Statement> stmts;
}
#line default
// Abstract base class for GPLEX scanners
[GeneratedCodeAttribute( "Gardens Point Parser Generator", "1.5.2")]
public abstract class ScanBase : AbstractScanner<ValueType,LexLocation> {
  private LexLocation __yylloc = new LexLocation();
  public override LexLocation yylloc { get { return __yylloc; } set { __yylloc = value; } }
  protected virtual bool yywrap() { return true; }
}

// Utility class for encapsulating token information
[GeneratedCodeAttribute( "Gardens Point Parser Generator", "1.5.2")]
public class ScanObj {
  public int token;
  public ValueType yylval;
  public LexLocation yylloc;
  public ScanObj( int t, ValueType val, LexLocation loc ) {
    this.token = t; this.yylval = val; this.yylloc = loc;
  }
}

[GeneratedCodeAttribute( "Gardens Point Parser Generator", "1.5.2")]
public class Parser: ShiftReduceParser<ValueType, LexLocation>
{
  // Verbatim content from parser.y - 12/04/2017 6:03:52 PM
#line 5 "parser.y"
public static AST.CompilationUnitDeclaration root;
#line default
  // End verbatim content from parser.y - 12/04/2017 6:03:52 PM

#pragma warning disable 649
  private static Dictionary<int, string> aliases;
#pragma warning restore 649
  private static Rule[] rules = new Rule[124];
  private static State[] states = new State[143];
  private static string[] nonTerms = new string[] {
      "Expression", "Statement", "Type", "StatementList", "CompilationUnit", 
      "Program", "$accept", "StatementWithoutTrailingSubstatement", "AssignmentExpression", 
      "Empty", "PackageDeclaration_opt", "ImportDeclarations", "TypeDeclarations", 
      "TypeDeclaration", "ClassDeclaration", "NormalClassDeclaration", "ClassModifiers", 
      "TypeParameters_opt", "SuperClass_opt", "Superinterfaces_opt", "ClassBody", 
      "ClassModifier", "Annotation", "ClassBodyDeclarations", "ClassBodyDeclaration", 
      "ClassMemberDeclaration", "MethodDeclaration", "MethodModifiers", "MethodHeader", 
      "MethodBody", "MethodModifier", "Result", "MethodDeclarator", "Throws_opt", 
      "UnannType", "FormalParameterList_Opt", "Dims_Opt", "FormalParameterList", 
      "Dims", "FormalParameters", "FormalParameter", "VariableModifiers", "VariableDeclaratorId", 
      "VariableModifier", "Annotations", "UnannReferenceType", "UnannPrimitiveType", 
      "NumbericType", "IntegralType", "FloatingPointType", "UnannArrayType", 
      "UnannTypeVariable", "Block", "BlockStatements_Opt", "BlockStatements", 
      "BlockStatement", "BlockStatement_s", "LocalVariableDeclarationsAndStatement", 
      "LocalVariableDeclaration", "VariableDeclaratorList", "VariableDeclarator", 
      "ExpressionStatement", "StatementExpression", "Assignment", "LeftHandSide", 
      "AssignmentOperator", "ExpressionName", "ArrayAccess", "PrimaryNoNewArray", 
      "Literal", };

  static Parser() {
    states[0] = new State(-20,new int[]{-6,1,-5,3,-11,4});
    states[1] = new State(new int[]{129,2});
    states[2] = new State(-1);
    states[3] = new State(-2);
    states[4] = new State(-22,new int[]{-12,5});
    states[5] = new State(new int[]{172,-31,155,-31,150,-31,145,-31,132,-31,170,-31,168,-31,175,-31,129,-25},new int[]{-13,6,-14,7,-15,9,-16,10,-17,11});
    states[6] = new State(-19);
    states[7] = new State(new int[]{172,-31,155,-31,150,-31,145,-31,132,-31,170,-31,168,-31,175,-31,129,-25},new int[]{-13,8,-14,7,-15,9,-16,10,-17,11});
    states[8] = new State(-24);
    states[9] = new State(-27);
    states[10] = new State(-28);
    states[11] = new State(new int[]{172,12,155,136,150,137,145,138,132,139,170,140,168,141,175,142},new int[]{-22,134,-23,135});
    states[12] = new State(new int[]{131,13});
    states[13] = new State(-41,new int[]{-18,14});
    states[14] = new State(-42,new int[]{-19,15});
    states[15] = new State(-43,new int[]{-20,16});
    states[16] = new State(new int[]{123,18},new int[]{-21,17});
    states[17] = new State(-29);
    states[18] = new State(-46,new int[]{-24,19});
    states[19] = new State(new int[]{125,20,171,-51,131,-51,152,-51,165,-51,164,-51,174,-51,167,-51,178,-51,148,-51,142,-51,155,-51,170,-51},new int[]{-25,21,-26,22,-27,23,-28,24});
    states[20] = new State(-44);
    states[21] = new State(-45);
    states[22] = new State(-47);
    states[23] = new State(-48);
    states[24] = new State(new int[]{171,129,131,126,152,57,165,58,164,59,174,60,167,61,178,63,148,64,142,65,155,132,170,133},new int[]{-29,25,-31,109,-32,110,-35,130,-46,49,-51,50,-52,51,-47,54,-48,55,-49,56,-50,62,-23,131});
    states[25] = new State(new int[]{123,28,59,108},new int[]{-30,26,-53,27});
    states[26] = new State(-49);
    states[27] = new State(-92);
    states[28] = new State(new int[]{131,53,152,57,165,58,164,59,174,60,167,61,178,63,148,64,142,65,139,67,123,74,182,92,184,97,59,-89,125,-98},new int[]{-54,29,-55,31,-56,32,-58,35,-59,36,-35,38,-46,49,-51,50,-52,51,-47,54,-48,55,-49,56,-50,62,-2,66,-1,78,-9,88,-68,89,-69,90,-70,91,-3,94,-8,98,-62,99,-63,100,-64,102,-65,103,-67,107});
    states[29] = new State(new int[]{125,30});
    states[30] = new State(-96);
    states[31] = new State(-97);
    states[32] = new State(-101,new int[]{-57,33});
    states[33] = new State(new int[]{131,53,152,57,165,58,164,59,174,60,167,61,178,63,148,64,142,65,139,67,123,74,182,92,184,97,125,-99,59,-89},new int[]{-56,34,-58,35,-59,36,-35,38,-46,49,-51,50,-52,51,-47,54,-48,55,-49,56,-50,62,-2,66,-1,78,-9,88,-68,89,-69,90,-70,91,-3,94,-8,98,-62,99,-63,100,-64,102,-65,103,-67,107});
    states[34] = new State(-100);
    states[35] = new State(-102);
    states[36] = new State(new int[]{59,37});
    states[37] = new State(-105);
    states[38] = new State(new int[]{131,42,59,-109},new int[]{-60,39,-61,40,-43,41});
    states[39] = new State(-106);
    states[40] = new State(-108);
    states[41] = new State(-110);
    states[42] = new State(new int[]{91,-40,59,-63,131,-63,152,-63,165,-63,164,-63,174,-63,167,-63,178,-63,148,-63,142,-63,168,-63,41,-63},new int[]{-37,43,-39,44,-45,45,-23,48});
    states[43] = new State(-74);
    states[44] = new State(-62);
    states[45] = new State(new int[]{91,46});
    states[46] = new State(new int[]{93,47});
    states[47] = new State(-73);
    states[48] = new State(-94);
    states[49] = new State(-75);
    states[50] = new State(-88);
    states[51] = new State(-40,new int[]{-39,52,-45,45,-23,48});
    states[52] = new State(-90);
    states[53] = new State(new int[]{91,-91,59,-13,61,-13,43,-13,60,-13});
    states[54] = new State(-76);
    states[55] = new State(-77);
    states[56] = new State(-79);
    states[57] = new State(-81);
    states[58] = new State(-82);
    states[59] = new State(-83);
    states[60] = new State(-84);
    states[61] = new State(-85);
    states[62] = new State(-80);
    states[63] = new State(-86);
    states[64] = new State(-87);
    states[65] = new State(-78);
    states[66] = new State(-103);
    states[67] = new State(new int[]{40,68});
    states[68] = new State(new int[]{182,86,131,87},new int[]{-1,69,-9,88,-68,89,-69,90,-70,91});
    states[69] = new State(new int[]{41,70,61,80,43,82,60,84});
    states[70] = new State(new int[]{139,67,123,74,182,92,131,93,184,97},new int[]{-2,71,-1,78,-9,88,-68,89,-69,90,-70,91,-3,94,-8,98,-62,99,-63,100,-64,102,-65,103,-67,107});
    states[71] = new State(new int[]{153,72});
    states[72] = new State(new int[]{139,67,123,74,182,92,131,93,184,97},new int[]{-2,73,-1,78,-9,88,-68,89,-69,90,-70,91,-3,94,-8,98,-62,99,-63,100,-64,102,-65,103,-67,107});
    states[73] = new State(-3);
    states[74] = new State(-11,new int[]{-4,75});
    states[75] = new State(new int[]{125,76,139,67,123,74,182,92,131,93,184,97},new int[]{-2,77,-1,78,-9,88,-68,89,-69,90,-70,91,-3,94,-8,98,-62,99,-63,100,-64,102,-65,103,-67,107});
    states[76] = new State(-4);
    states[77] = new State(-10);
    states[78] = new State(new int[]{59,79,61,80,43,82,60,84});
    states[79] = new State(-5);
    states[80] = new State(new int[]{182,86,131,87},new int[]{-1,81,-9,88,-68,89,-69,90,-70,91});
    states[81] = new State(new int[]{61,-14,43,82,60,84,59,-14,41,-14});
    states[82] = new State(new int[]{182,86,131,87},new int[]{-1,83,-9,88,-68,89,-69,90,-70,91});
    states[83] = new State(-15);
    states[84] = new State(new int[]{182,86,131,87},new int[]{-1,85,-9,88,-68,89,-69,90,-70,91});
    states[85] = new State(new int[]{61,-16,43,82,41,-16,59,-16});
    states[86] = new State(-12);
    states[87] = new State(-13);
    states[88] = new State(-17);
    states[89] = new State(-120);
    states[90] = new State(-121);
    states[91] = new State(-122);
    states[92] = new State(new int[]{59,-12,61,-12,43,-12,60,-12,131,-8});
    states[93] = new State(-13);
    states[94] = new State(new int[]{131,95});
    states[95] = new State(new int[]{59,96});
    states[96] = new State(-6);
    states[97] = new State(-9);
    states[98] = new State(-7);
    states[99] = new State(-113);
    states[100] = new State(new int[]{59,101});
    states[101] = new State(-114);
    states[102] = new State(-115);
    states[103] = new State(new int[]{61,106},new int[]{-66,104});
    states[104] = new State(new int[]{182,86,131,87},new int[]{-1,105,-9,88,-68,89,-69,90,-70,91});
    states[105] = new State(new int[]{61,80,43,82,60,84,59,-116});
    states[106] = new State(-119);
    states[107] = new State(-117);
    states[108] = new State(-93);
    states[109] = new State(-50);
    states[110] = new State(new int[]{131,114},new int[]{-33,111});
    states[111] = new State(-18,new int[]{-34,112,-10,113});
    states[112] = new State(-55);
    states[113] = new State(-58);
    states[114] = new State(new int[]{40,115});
    states[115] = new State(new int[]{131,-67,152,-67,165,-67,164,-67,174,-67,167,-67,178,-67,148,-67,142,-67,168,-67,41,-61},new int[]{-36,116,-38,119,-40,120});
    states[116] = new State(new int[]{41,117});
    states[117] = new State(new int[]{91,-40,123,-63,59,-63},new int[]{-37,118,-39,44,-45,45,-23,48});
    states[118] = new State(-59);
    states[119] = new State(-60);
    states[120] = new State(new int[]{41,-64,131,-70,152,-70,165,-70,164,-70,174,-70,167,-70,178,-70,148,-70,142,-70,168,-70},new int[]{-41,121,-42,122});
    states[121] = new State(-66);
    states[122] = new State(new int[]{131,126,152,57,165,58,164,59,174,60,167,61,178,63,148,64,142,65,168,128},new int[]{-35,123,-44,125,-46,49,-51,50,-52,51,-47,54,-48,55,-49,56,-50,62,-23,127});
    states[123] = new State(new int[]{131,42},new int[]{-43,124});
    states[124] = new State(-68);
    states[125] = new State(-69);
    states[126] = new State(-91);
    states[127] = new State(-71);
    states[128] = new State(-72);
    states[129] = new State(-56);
    states[130] = new State(-57);
    states[131] = new State(-52);
    states[132] = new State(-53);
    states[133] = new State(-54);
    states[134] = new State(-30);
    states[135] = new State(-32);
    states[136] = new State(-33);
    states[137] = new State(-34);
    states[138] = new State(-35);
    states[139] = new State(-36);
    states[140] = new State(-37);
    states[141] = new State(-38);
    states[142] = new State(-39);

    for (int sNo = 0; sNo < states.Length; sNo++) states[sNo].number = sNo;

    rules[1] = new Rule(-7, new int[]{-6,129});
    rules[2] = new Rule(-6, new int[]{-5});
    rules[3] = new Rule(-2, new int[]{139,40,-1,41,-2,153,-2});
    rules[4] = new Rule(-2, new int[]{123,-4,125});
    rules[5] = new Rule(-2, new int[]{-1,59});
    rules[6] = new Rule(-2, new int[]{-3,131,59});
    rules[7] = new Rule(-2, new int[]{-8});
    rules[8] = new Rule(-3, new int[]{182});
    rules[9] = new Rule(-3, new int[]{184});
    rules[10] = new Rule(-4, new int[]{-4,-2});
    rules[11] = new Rule(-4, new int[]{});
    rules[12] = new Rule(-1, new int[]{182});
    rules[13] = new Rule(-1, new int[]{131});
    rules[14] = new Rule(-1, new int[]{-1,61,-1});
    rules[15] = new Rule(-1, new int[]{-1,43,-1});
    rules[16] = new Rule(-1, new int[]{-1,60,-1});
    rules[17] = new Rule(-1, new int[]{-9});
    rules[18] = new Rule(-10, new int[]{});
    rules[19] = new Rule(-5, new int[]{-11,-12,-13});
    rules[20] = new Rule(-11, new int[]{});
    rules[21] = new Rule(-11, new int[]{});
    rules[22] = new Rule(-12, new int[]{});
    rules[23] = new Rule(-12, new int[]{});
    rules[24] = new Rule(-13, new int[]{-14,-13});
    rules[25] = new Rule(-13, new int[]{});
    rules[26] = new Rule(-13, new int[]{});
    rules[27] = new Rule(-14, new int[]{-15});
    rules[28] = new Rule(-15, new int[]{-16});
    rules[29] = new Rule(-16, new int[]{-17,172,131,-18,-19,-20,-21});
    rules[30] = new Rule(-17, new int[]{-17,-22});
    rules[31] = new Rule(-17, new int[]{});
    rules[32] = new Rule(-22, new int[]{-23});
    rules[33] = new Rule(-22, new int[]{155});
    rules[34] = new Rule(-22, new int[]{150});
    rules[35] = new Rule(-22, new int[]{145});
    rules[36] = new Rule(-22, new int[]{132});
    rules[37] = new Rule(-22, new int[]{170});
    rules[38] = new Rule(-22, new int[]{168});
    rules[39] = new Rule(-22, new int[]{175});
    rules[40] = new Rule(-23, new int[]{});
    rules[41] = new Rule(-18, new int[]{});
    rules[42] = new Rule(-19, new int[]{});
    rules[43] = new Rule(-20, new int[]{});
    rules[44] = new Rule(-21, new int[]{123,-24,125});
    rules[45] = new Rule(-24, new int[]{-24,-25});
    rules[46] = new Rule(-24, new int[]{});
    rules[47] = new Rule(-25, new int[]{-26});
    rules[48] = new Rule(-26, new int[]{-27});
    rules[49] = new Rule(-27, new int[]{-28,-29,-30});
    rules[50] = new Rule(-28, new int[]{-28,-31});
    rules[51] = new Rule(-28, new int[]{});
    rules[52] = new Rule(-31, new int[]{-23});
    rules[53] = new Rule(-31, new int[]{155});
    rules[54] = new Rule(-31, new int[]{170});
    rules[55] = new Rule(-29, new int[]{-32,-33,-34});
    rules[56] = new Rule(-32, new int[]{171});
    rules[57] = new Rule(-32, new int[]{-35});
    rules[58] = new Rule(-34, new int[]{-10});
    rules[59] = new Rule(-33, new int[]{131,40,-36,41,-37});
    rules[60] = new Rule(-36, new int[]{-38});
    rules[61] = new Rule(-36, new int[]{});
    rules[62] = new Rule(-37, new int[]{-39});
    rules[63] = new Rule(-37, new int[]{});
    rules[64] = new Rule(-38, new int[]{-40});
    rules[65] = new Rule(-38, new int[]{});
    rules[66] = new Rule(-40, new int[]{-40,-41});
    rules[67] = new Rule(-40, new int[]{});
    rules[68] = new Rule(-41, new int[]{-42,-35,-43});
    rules[69] = new Rule(-42, new int[]{-42,-44});
    rules[70] = new Rule(-42, new int[]{});
    rules[71] = new Rule(-44, new int[]{-23});
    rules[72] = new Rule(-44, new int[]{168});
    rules[73] = new Rule(-39, new int[]{-45,91,93});
    rules[74] = new Rule(-43, new int[]{131,-37});
    rules[75] = new Rule(-35, new int[]{-46});
    rules[76] = new Rule(-35, new int[]{-47});
    rules[77] = new Rule(-47, new int[]{-48});
    rules[78] = new Rule(-47, new int[]{142});
    rules[79] = new Rule(-48, new int[]{-49});
    rules[80] = new Rule(-48, new int[]{-50});
    rules[81] = new Rule(-49, new int[]{152});
    rules[82] = new Rule(-49, new int[]{165});
    rules[83] = new Rule(-49, new int[]{164});
    rules[84] = new Rule(-49, new int[]{174});
    rules[85] = new Rule(-49, new int[]{167});
    rules[86] = new Rule(-50, new int[]{178});
    rules[87] = new Rule(-50, new int[]{148});
    rules[88] = new Rule(-46, new int[]{-51});
    rules[89] = new Rule(-46, new int[]{});
    rules[90] = new Rule(-51, new int[]{-52,-39});
    rules[91] = new Rule(-52, new int[]{131});
    rules[92] = new Rule(-30, new int[]{-53});
    rules[93] = new Rule(-30, new int[]{59});
    rules[94] = new Rule(-45, new int[]{-23});
    rules[95] = new Rule(-45, new int[]{});
    rules[96] = new Rule(-53, new int[]{123,-54,125});
    rules[97] = new Rule(-54, new int[]{-55});
    rules[98] = new Rule(-54, new int[]{});
    rules[99] = new Rule(-55, new int[]{-56,-57});
    rules[100] = new Rule(-57, new int[]{-57,-56});
    rules[101] = new Rule(-57, new int[]{});
    rules[102] = new Rule(-56, new int[]{-58});
    rules[103] = new Rule(-56, new int[]{-2});
    rules[104] = new Rule(-56, new int[]{});
    rules[105] = new Rule(-58, new int[]{-59,59});
    rules[106] = new Rule(-59, new int[]{-35,-60});
    rules[107] = new Rule(-59, new int[]{});
    rules[108] = new Rule(-60, new int[]{-61});
    rules[109] = new Rule(-60, new int[]{});
    rules[110] = new Rule(-61, new int[]{-43});
    rules[111] = new Rule(-61, new int[]{});
    rules[112] = new Rule(-43, new int[]{131,-37});
    rules[113] = new Rule(-8, new int[]{-62});
    rules[114] = new Rule(-62, new int[]{-63,59});
    rules[115] = new Rule(-63, new int[]{-64});
    rules[116] = new Rule(-64, new int[]{-65,-66,-1});
    rules[117] = new Rule(-65, new int[]{-67});
    rules[118] = new Rule(-67, new int[]{131});
    rules[119] = new Rule(-66, new int[]{61});
    rules[120] = new Rule(-9, new int[]{-68});
    rules[121] = new Rule(-68, new int[]{-69});
    rules[122] = new Rule(-69, new int[]{-70});
    rules[123] = new Rule(-70, new int[]{182});
  }

  protected override void Initialize() {
    this.InitSpecialTokens((int)Tokens.error, (int)Tokens.EOF);
    this.InitStates(states);
    this.InitRules(rules);
    this.InitNonTerminals(nonTerms);
  }

  protected override void DoAction(int action)
  {
#pragma warning disable 162, 1522
    switch (action)
    {
      case 2: // Program -> CompilationUnit
#line 71 "parser.y"
                                   {root = ValueStack[ValueStack.Depth-1].cmpu;}
#line default
        break;
      case 3: // Statement -> IF, '(', Expression, ')', Statement, ELSE, Statement
#line 74 "parser.y"
                                                            { CurrentSemanticValue.stmt = new AST.IfStatement(ValueStack[ValueStack.Depth-5].expr, ValueStack[ValueStack.Depth-3].stmt, ValueStack[ValueStack.Depth-1].stmt); }
#line default
        break;
      case 5: // Statement -> Expression, ';'
#line 76 "parser.y"
                                    { CurrentSemanticValue.stmt = new AST.ExpressionStatement(ValueStack[ValueStack.Depth-2].expr); }
#line default
        break;
      case 6: // Statement -> Type, IDENTIFIER, ';'
#line 77 "parser.y"
                                        { CurrentSemanticValue.stmt = new AST.VariableDeclaration(ValueStack[ValueStack.Depth-3].type,ValueStack[ValueStack.Depth-2].name);}
#line default
        break;
      case 8: // Type -> IntegerLiteral
#line 81 "parser.y"
                               { CurrentSemanticValue.type = new AST.IntType();}
#line default
        break;
      case 9: // Type -> BooleanLiteral
#line 82 "parser.y"
                            { CurrentSemanticValue.type = new AST.BoolType(); }
#line default
        break;
      case 10: // StatementList -> StatementList, Statement
#line 86 "parser.y"
                                   { CurrentSemanticValue.stmts = ValueStack[ValueStack.Depth-2].stmts; CurrentSemanticValue.stmts.Add(ValueStack[ValueStack.Depth-1].stmt);}
#line default
        break;
      case 11: // StatementList -> /* empty */
#line 87 "parser.y"
                                { CurrentSemanticValue.stmts = new System.Collections.Generic.List<AST.Statement>();}
#line default
        break;
      case 12: // Expression -> IntegerLiteral
#line 91 "parser.y"
                            { CurrentSemanticValue.expr = new AST.IntegerLiteralExpression(ValueStack[ValueStack.Depth-1].num); }
#line default
        break;
      case 13: // Expression -> IDENTIFIER
#line 92 "parser.y"
                               { CurrentSemanticValue.expr = new AST.VariableExpression(ValueStack[ValueStack.Depth-1].name); }
#line default
        break;
      case 14: // Expression -> Expression, '=', Expression
#line 93 "parser.y"
                                           { CurrentSemanticValue.expr = new AST.AssignmentExpression(ValueStack[ValueStack.Depth-3].expr,ValueStack[ValueStack.Depth-1].expr); }
#line default
        break;
      case 15: // Expression -> Expression, '+', Expression
#line 94 "parser.y"
                                           { CurrentSemanticValue.expr = new AST.BinaryExpression(ValueStack[ValueStack.Depth-3].expr,'+',ValueStack[ValueStack.Depth-1].expr); }
#line default
        break;
      case 16: // Expression -> Expression, '<', Expression
#line 95 "parser.y"
                                           { CurrentSemanticValue.expr = new AST.BinaryExpression(ValueStack[ValueStack.Depth-3].expr,'<',ValueStack[ValueStack.Depth-1].expr); }
#line default
        break;
      case 24: // TypeDeclarations -> TypeDeclaration, TypeDeclarations
#line 118 "parser.y"
                                          { CurrentSemanticValue = ValueStack[ValueStack.Depth-2]; }
#line default
        break;
      case 27: // TypeDeclaration -> ClassDeclaration
#line 123 "parser.y"
                                                            {  }
#line default
        break;
      case 28: // ClassDeclaration -> NormalClassDeclaration
#line 127 "parser.y"
                                                             {  }
#line default
        break;
      case 29: // NormalClassDeclaration -> ClassModifiers, CLASS, IDENTIFIER, TypeParameters_opt, 
               //                           SuperClass_opt, Superinterfaces_opt, ClassBody
#line 131 "parser.y"
                                                                                                    {  }
#line default
        break;
      case 30: // ClassModifiers -> ClassModifiers, ClassModifier
#line 135 "parser.y"
                                       {  }
#line default
        break;
      case 31: // ClassModifiers -> /* empty */
#line 136 "parser.y"
                          {  }
#line default
        break;
      case 32: // ClassModifier -> Annotation
#line 140 "parser.y"
                         {  }
#line default
        break;
      case 33: // ClassModifier -> PUBLIC
#line 141 "parser.y"
                      {  }
#line default
        break;
      case 34: // ClassModifier -> PROTECTED
#line 142 "parser.y"
                         {  }
#line default
        break;
      case 35: // ClassModifier -> PRIVATE
#line 143 "parser.y"
                        {  }
#line default
        break;
      case 36: // ClassModifier -> ABSTRACT
#line 144 "parser.y"
                         {  }
#line default
        break;
      case 37: // ClassModifier -> STATIC
#line 145 "parser.y"
                       {  }
#line default
        break;
      case 38: // ClassModifier -> FINAL
#line 146 "parser.y"
                      {  }
#line default
        break;
      case 39: // ClassModifier -> STRICTFP
#line 147 "parser.y"
                         {  }
#line default
        break;
      case 40: // Annotation -> /* empty */
#line 151 "parser.y"
                          { }
#line default
        break;
      case 41: // TypeParameters_opt -> /* empty */
#line 155 "parser.y"
                                        { }
#line default
        break;
      case 42: // SuperClass_opt -> /* empty */
#line 158 "parser.y"
                                     { }
#line default
        break;
      case 43: // Superinterfaces_opt -> /* empty */
#line 161 "parser.y"
                                         { }
#line default
        break;
      case 44: // ClassBody -> '{', ClassBodyDeclarations, '}'
#line 165 "parser.y"
                                        { }
#line default
        break;
      case 45: // ClassBodyDeclarations -> ClassBodyDeclarations, ClassBodyDeclaration
#line 172 "parser.y"
                                                 { }
#line default
        break;
      case 46: // ClassBodyDeclarations -> /* empty */
#line 173 "parser.y"
                          { }
#line default
        break;
      case 47: // ClassBodyDeclaration -> ClassMemberDeclaration
#line 177 "parser.y"
                                  { }
#line default
        break;
      case 48: // ClassMemberDeclaration -> MethodDeclaration
#line 182 "parser.y"
                               { }
#line default
        break;
      case 49: // MethodDeclaration -> MethodModifiers, MethodHeader, MethodBody
#line 187 "parser.y"
                                               { }
#line default
        break;
      case 50: // MethodModifiers -> MethodModifiers, MethodModifier
#line 191 "parser.y"
                                              { }
#line default
        break;
      case 51: // MethodModifiers -> /* empty */
#line 192 "parser.y"
                          { }
#line default
        break;
      case 52: // MethodModifier -> Annotation
#line 196 "parser.y"
                         { }
#line default
        break;
      case 53: // MethodModifier -> PUBLIC
#line 197 "parser.y"
                      { }
#line default
        break;
      case 54: // MethodModifier -> STATIC
#line 198 "parser.y"
                            { }
#line default
        break;
      case 55: // MethodHeader -> Result, MethodDeclarator, Throws_opt
#line 202 "parser.y"
                                           { }
#line default
        break;
      case 56: // Result -> VOID
#line 210 "parser.y"
                     { }
#line default
        break;
      case 57: // Result -> UnannType
#line 211 "parser.y"
                         { }
#line default
        break;
      case 58: // Throws_opt -> Empty
#line 215 "parser.y"
                      { }
#line default
        break;
      case 59: // MethodDeclarator -> IDENTIFIER, '(', FormalParameterList_Opt, ')', Dims_Opt
#line 220 "parser.y"
                                                        { }
#line default
        break;
      case 60: // FormalParameterList_Opt -> FormalParameterList
#line 230 "parser.y"
                                { }
#line default
        break;
      case 61: // FormalParameterList_Opt -> /* empty */
#line 231 "parser.y"
                          { }
#line default
        break;
      case 62: // Dims_Opt -> Dims
#line 235 "parser.y"
                     { }
#line default
        break;
      case 63: // Dims_Opt -> /* empty */
#line 236 "parser.y"
                          { }
#line default
        break;
      case 64: // FormalParameterList -> FormalParameters
#line 242 "parser.y"
                               { }
#line default
        break;
      case 65: // FormalParameterList -> /* empty */
#line 243 "parser.y"
                        { }
#line default
        break;
      case 66: // FormalParameters -> FormalParameters, FormalParameter
#line 247 "parser.y"
                                           { CurrentSemanticValue = ValueStack[ValueStack.Depth-1]; }
#line default
        break;
      case 71: // VariableModifier -> Annotation
#line 267 "parser.y"
                         { CurrentSemanticValue = ValueStack[ValueStack.Depth-1]; }
#line default
        break;
      case 72: // VariableModifier -> FINAL
#line 268 "parser.y"
                      { CurrentSemanticValue = ValueStack[ValueStack.Depth-1]; }
#line default
        break;
      case 73: // Dims -> Annotations, '[', ']'
#line 274 "parser.y"
                               { CurrentSemanticValue = ValueStack[ValueStack.Depth-3]; }
#line default
        break;
      case 75: // UnannType -> UnannReferenceType
#line 282 "parser.y"
                               { CurrentSemanticValue = ValueStack[ValueStack.Depth-1]; }
#line default
        break;
      case 76: // UnannType -> UnannPrimitiveType
#line 283 "parser.y"
                               { CurrentSemanticValue = ValueStack[ValueStack.Depth-1]; }
#line default
        break;
      case 77: // UnannPrimitiveType -> NumbericType
#line 288 "parser.y"
                           { CurrentSemanticValue = ValueStack[ValueStack.Depth-1]; }
#line default
        break;
      case 78: // UnannPrimitiveType -> BOOLEAN
#line 289 "parser.y"
                       { CurrentSemanticValue = ValueStack[ValueStack.Depth-1]; }
#line default
        break;
      case 79: // NumbericType -> IntegralType
#line 293 "parser.y"
                           { CurrentSemanticValue = ValueStack[ValueStack.Depth-1]; }
#line default
        break;
      case 80: // NumbericType -> FloatingPointType
#line 294 "parser.y"
                               { CurrentSemanticValue = ValueStack[ValueStack.Depth-1]; }
#line default
        break;
      case 81: // IntegralType -> BYTE
#line 298 "parser.y"
                     { CurrentSemanticValue = ValueStack[ValueStack.Depth-1];  }
#line default
        break;
      case 82: // IntegralType -> SHORT
#line 299 "parser.y"
                      { CurrentSemanticValue = ValueStack[ValueStack.Depth-1];  }
#line default
        break;
      case 83: // IntegralType -> INT
#line 300 "parser.y"
                    { }
#line default
        break;
      case 84: // IntegralType -> LONG
#line 301 "parser.y"
                     { }
#line default
        break;
      case 85: // IntegralType -> CHAR
#line 302 "parser.y"
                     { }
#line default
        break;
      case 86: // FloatingPointType -> FLOAT
#line 306 "parser.y"
                      { }
#line default
        break;
      case 87: // FloatingPointType -> DOUBLE
#line 307 "parser.y"
                      { }
#line default
        break;
      case 88: // UnannReferenceType -> UnannArrayType
#line 311 "parser.y"
                            { }
#line default
        break;
      case 89: // UnannReferenceType -> /* empty */
#line 312 "parser.y"
                            { }
#line default
        break;
      case 90: // UnannArrayType -> UnannTypeVariable, Dims
#line 318 "parser.y"
                                  { }
#line default
        break;
      case 91: // UnannTypeVariable -> IDENTIFIER
#line 322 "parser.y"
                         { }
#line default
        break;
      case 92: // MethodBody -> Block
#line 327 "parser.y"
                       { }
#line default
        break;
      case 93: // MethodBody -> ';'
#line 328 "parser.y"
                    { }
#line default
        break;
      case 94: // Annotations -> Annotation
#line 332 "parser.y"
                         { }
#line default
        break;
      case 95: // Annotations -> /* empty */
#line 333 "parser.y"
                          { }
#line default
        break;
      case 96: // Block -> '{', BlockStatements_Opt, '}'
#line 337 "parser.y"
                                      { }
#line default
        break;
      case 97: // BlockStatements_Opt -> BlockStatements
#line 341 "parser.y"
                             { }
#line default
        break;
      case 98: // BlockStatements_Opt -> /* empty */
#line 342 "parser.y"
                          { }
#line default
        break;
      case 99: // BlockStatements -> BlockStatement, BlockStatement_s
#line 346 "parser.y"
                                         { }
#line default
        break;
      case 100: // BlockStatement_s -> BlockStatement_s, BlockStatement
#line 350 "parser.y"
                                         { }
#line default
        break;
      case 101: // BlockStatement_s -> /* empty */
#line 351 "parser.y"
                          { }
#line default
        break;
      case 102: // BlockStatement -> LocalVariableDeclarationsAndStatement
#line 355 "parser.y"
                                              { }
#line default
        break;
      case 103: // BlockStatement -> Statement
#line 356 "parser.y"
                         { }
#line default
        break;
      case 104: // BlockStatement -> /* empty */
#line 357 "parser.y"
                             { }
#line default
        break;
      case 105: // LocalVariableDeclarationsAndStatement -> LocalVariableDeclaration, ';'
#line 361 "parser.y"
                                       { }
#line default
        break;
      case 106: // LocalVariableDeclaration -> UnannType, VariableDeclaratorList
#line 365 "parser.y"
                                          { }
#line default
        break;
      case 107: // LocalVariableDeclaration -> /* empty */
#line 366 "parser.y"
                             { }
#line default
        break;
      case 108: // VariableDeclaratorList -> VariableDeclarator
#line 370 "parser.y"
                               { }
#line default
        break;
      case 109: // VariableDeclaratorList -> /* empty */
#line 371 "parser.y"
                             { }
#line default
        break;
      case 110: // VariableDeclarator -> VariableDeclaratorId
#line 375 "parser.y"
                                 { }
#line default
        break;
      case 111: // VariableDeclarator -> /* empty */
#line 376 "parser.y"
                             { }
#line default
        break;
      case 112: // VariableDeclaratorId -> IDENTIFIER, Dims_Opt
#line 380 "parser.y"
                                { }
#line default
        break;
      case 113: // StatementWithoutTrailingSubstatement -> ExpressionStatement
#line 385 "parser.y"
                                 { }
#line default
        break;
      case 114: // ExpressionStatement -> StatementExpression, ';'
#line 389 "parser.y"
                                   { }
#line default
        break;
      case 115: // StatementExpression -> Assignment
#line 393 "parser.y"
                         { }
#line default
        break;
      case 116: // Assignment -> LeftHandSide, AssignmentOperator, Expression
#line 400 "parser.y"
                                                 { }
#line default
        break;
      case 117: // LeftHandSide -> ExpressionName
#line 404 "parser.y"
                            { }
#line default
        break;
      case 118: // ExpressionName -> IDENTIFIER
#line 408 "parser.y"
                         { }
#line default
        break;
      case 119: // AssignmentOperator -> '='
#line 412 "parser.y"
                    { }
#line default
        break;
      case 120: // AssignmentExpression -> ArrayAccess
#line 416 "parser.y"
                          { CurrentSemanticValue = ValueStack[ValueStack.Depth-1]; }
#line default
        break;
      case 121: // ArrayAccess -> PrimaryNoNewArray
#line 420 "parser.y"
                               { CurrentSemanticValue = ValueStack[ValueStack.Depth-1]; }
#line default
        break;
      case 122: // PrimaryNoNewArray -> Literal
#line 424 "parser.y"
                       { CurrentSemanticValue = ValueStack[ValueStack.Depth-1]; }
#line default
        break;
      case 123: // Literal -> IntegerLiteral
#line 428 "parser.y"
                            {  }
#line default
        break;
    }
#pragma warning restore 162, 1522
  }

  protected override string TerminalToString(int terminal)
  {
    if (aliases != null && aliases.ContainsKey(terminal))
        return aliases[terminal];
    else if (((Tokens)terminal).ToString() != terminal.ToString(CultureInfo.InvariantCulture))
        return ((Tokens)terminal).ToString();
    else
        return CharToString((char)terminal);
  }

#line 434 "parser.y"

public Parser(Scanner scanner) : base(scanner)
{
}
#line default
}
}
