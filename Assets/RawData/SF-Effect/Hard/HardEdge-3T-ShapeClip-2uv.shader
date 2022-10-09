// Shader created with Shader Forge v1.38 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.38;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,lico:1,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:False,mssp:True,bkdf:False,hqlp:True,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:False,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:2,bsrc:0,bdst:1,dpts:2,wrdp:True,dith:0,atcv:False,rfrpo:True,rfrpn:Refraction,coma:15,ufog:False,aust:False,igpj:False,qofs:0,qpre:2,rntp:3,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.2306556,fgcg:0.1892301,fgcb:0.7352941,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False,fsmp:False;n:type:ShaderForge.SFN_Final,id:40,x:32027,y:32574,varname:node_40,prsc:2|emission-3312-OUT,clip-218-OUT;n:type:ShaderForge.SFN_Tex2d,id:217,x:30831,y:32458,ptovrint:False,ptlb:Base-RGB,ptin:_BaseRGB,varname:_BaseRGBA,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Multiply,id:218,x:31775,y:32859,varname:node_218,prsc:2|A-3366-OUT,B-6096-OUT,C-4009-A,D-5145-A;n:type:ShaderForge.SFN_Slider,id:6096,x:31269,y:32880,ptovrint:False,ptlb:EdgeClip,ptin:_EdgeClip,varname:_EdgeClip,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:7.494126,max:30;n:type:ShaderForge.SFN_VertexColor,id:4009,x:31320,y:33029,varname:node_4009,prsc:2;n:type:ShaderForge.SFN_Tex2d,id:5290,x:30836,y:32660,ptovrint:False,ptlb:Dark-RGB,ptin:_DarkRGB,varname:_DarkRGBA,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Multiply,id:3366,x:31372,y:32693,varname:node_3366,prsc:2|A-2735-OUT,B-5290-RGB;n:type:ShaderForge.SFN_Color,id:6223,x:31336,y:32296,ptovrint:False,ptlb:Color,ptin:_Color,varname:_Color,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.9705882,c2:0.9705882,c3:0.9705882,c4:1;n:type:ShaderForge.SFN_Multiply,id:3312,x:31709,y:32453,varname:node_3312,prsc:2|A-217-RGB,B-6223-RGB,C-5145-RGB,D-5670-OUT;n:type:ShaderForge.SFN_Tex2d,id:5145,x:31369,y:33236,ptovrint:False,ptlb:Shape-Alpha(RGBA)),ptin:_ShapeAlphaRGBA,varname:_ShapeAlphaR,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False|UVIN-9323-OUT;n:type:ShaderForge.SFN_SwitchProperty,id:9323,x:31143,y:33236,ptovrint:False,ptlb:Shape-2uv,ptin:_Shape2uv,varname:node_9323,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,on:True|A-1045-UVOUT,B-4617-UVOUT;n:type:ShaderForge.SFN_TexCoord,id:1045,x:30905,y:33159,varname:node_1045,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_TexCoord,id:4617,x:30905,y:33315,varname:node_4617,prsc:2,uv:1,uaff:False;n:type:ShaderForge.SFN_Multiply,id:2735,x:31082,y:32350,varname:node_2735,prsc:2|A-217-RGB,B-5670-OUT;n:type:ShaderForge.SFN_Slider,id:5670,x:30673,y:32264,ptovrint:False,ptlb:BaseClip-Mul,ptin:_BaseClipMul,varname:node_5670,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:1,max:30;proporder:217-5290-5145-9323-6096-5670-6223;pass:END;sub:END;*/

Shader "EJoyShader/Effect/Hard/HardEdge-3T-ShapeClip-2uv" {
    Properties {
        _BaseRGB ("Base-RGB", 2D) = "white" {}
        _DarkRGB ("Dark-RGB", 2D) = "white" {}
        _ShapeAlphaRGBA ("Shape-Alpha(RGBA))", 2D) = "white" {}
        [MaterialToggle] _Shape2uv ("Shape-2uv", Float ) = 0
        _EdgeClip ("EdgeClip", Range(0, 30)) = 7.494126
        _BaseClipMul ("BaseClip-Mul", Range(0, 30)) = 1
        _Color ("Color", Color) = (0.9705882,0.9705882,0.9705882,1)
        [HideInInspector]_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
    }
    SubShader {
        Tags {
            "Queue"="AlphaTest"
            "RenderType"="TransparentCutout"
        }
        LOD 200
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            Cull Off
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase_fullshadows
            #pragma only_renderers d3d9 glcore gles gles3 metal 
            #pragma target 3.0
            uniform sampler2D _BaseRGB; uniform float4 _BaseRGB_ST;
            uniform float _EdgeClip;
            uniform sampler2D _DarkRGB; uniform float4 _DarkRGB_ST;
            uniform float4 _Color;
            uniform sampler2D _ShapeAlphaRGBA; uniform float4 _ShapeAlphaRGBA_ST;
            uniform fixed _Shape2uv;
            uniform float _BaseClipMul;
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord1 : TEXCOORD1;
                float4 vertexColor : COLOR;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float2 uv1 : TEXCOORD1;
                float4 vertexColor : COLOR;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.uv1 = v.texcoord1;
                o.vertexColor = v.vertexColor;
                o.pos = UnityObjectToClipPos( v.vertex );
                return o;
            }
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
                float4 _BaseRGB_var = tex2D(_BaseRGB,TRANSFORM_TEX(i.uv0, _BaseRGB));
                float4 _DarkRGB_var = tex2D(_DarkRGB,TRANSFORM_TEX(i.uv0, _DarkRGB));
                float2 _Shape2uv_var = lerp( i.uv0, i.uv1, _Shape2uv );
                float4 _ShapeAlphaRGBA_var = tex2D(_ShapeAlphaRGBA,TRANSFORM_TEX(_Shape2uv_var, _ShapeAlphaRGBA));
                clip((((_BaseRGB_var.rgb*_BaseClipMul)*_DarkRGB_var.rgb)*_EdgeClip*i.vertexColor.a*_ShapeAlphaRGBA_var.a) - 0.5);
////// Lighting:
////// Emissive:
                float3 emissive = (_BaseRGB_var.rgb*_Color.rgb*_ShapeAlphaRGBA_var.rgb*_BaseClipMul);
                float3 finalColor = emissive;
                return fixed4(finalColor,1);
            }
            ENDCG
        }
        Pass {
            Name "ShadowCaster"
            Tags {
                "LightMode"="ShadowCaster"
            }
            Offset 1, 1
            Cull Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_SHADOWCASTER
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #pragma fragmentoption ARB_precision_hint_fastest
            #pragma multi_compile_shadowcaster
            #pragma only_renderers d3d9 glcore gles gles3 metal 
            #pragma target 3.0
            uniform sampler2D _BaseRGB; uniform float4 _BaseRGB_ST;
            uniform float _EdgeClip;
            uniform sampler2D _DarkRGB; uniform float4 _DarkRGB_ST;
            uniform sampler2D _ShapeAlphaRGBA; uniform float4 _ShapeAlphaRGBA_ST;
            uniform fixed _Shape2uv;
            uniform float _BaseClipMul;
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord1 : TEXCOORD1;
                float4 vertexColor : COLOR;
            };
            struct VertexOutput {
                V2F_SHADOW_CASTER;
                float2 uv0 : TEXCOORD1;
                float2 uv1 : TEXCOORD2;
                float4 vertexColor : COLOR;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.uv1 = v.texcoord1;
                o.vertexColor = v.vertexColor;
                o.pos = UnityObjectToClipPos( v.vertex );
                TRANSFER_SHADOW_CASTER(o)
                return o;
            }
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
                float4 _BaseRGB_var = tex2D(_BaseRGB,TRANSFORM_TEX(i.uv0, _BaseRGB));
                float4 _DarkRGB_var = tex2D(_DarkRGB,TRANSFORM_TEX(i.uv0, _DarkRGB));
                float2 _Shape2uv_var = lerp( i.uv0, i.uv1, _Shape2uv );
                float4 _ShapeAlphaRGBA_var = tex2D(_ShapeAlphaRGBA,TRANSFORM_TEX(_Shape2uv_var, _ShapeAlphaRGBA));
                clip((((_BaseRGB_var.rgb*_BaseClipMul)*_DarkRGB_var.rgb)*_EdgeClip*i.vertexColor.a*_ShapeAlphaRGBA_var.a) - 0.5);
                SHADOW_CASTER_FRAGMENT(i)
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
