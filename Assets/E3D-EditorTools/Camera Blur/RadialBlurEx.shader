// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "BnH/RadialBlurEx"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_CenterX ("CenterX", Float) = 0.5
		_CenterY ("CenterY", Float) = 0.5
		_SampleDistance ("SampleDistance", Float) = 1.0
		_SampleStrength ("SampleStrength", Float) = 1.0
	}

	SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

		Pass
		{
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			sampler2D _MainTex;
			float _CenterX;
			float _CenterY;
			float _SampleDistance;
			float _SampleStrength;

			fixed4 frag (v2f i) : SV_Target
			{
				float2 dir = float2(_CenterX, _CenterY) - i.uv;
				float len = length(dir);
				dir /= len;
				dir *= _SampleDistance;

				float4 color = tex2D(_MainTex, i.uv); 
				float4 sum = color;
				sum += tex2D(_MainTex, i.uv - dir * 0.08);
				sum += tex2D(_MainTex, i.uv - dir * 0.05);
				sum += tex2D(_MainTex, i.uv - dir * 0.03);
				sum += tex2D(_MainTex, i.uv - dir * 0.02);
				sum += tex2D(_MainTex, i.uv - dir * 0.01);
				sum += tex2D(_MainTex, i.uv + dir * 0.01);
				sum += tex2D(_MainTex, i.uv + dir * 0.02);
				sum += tex2D(_MainTex, i.uv + dir * 0.03);
				sum += tex2D(_MainTex, i.uv + dir * 0.05);
				sum += tex2D(_MainTex, i.uv + dir * 0.08);
				sum /= 11.0;

				float s = saturate(len * _SampleStrength); 
				return lerp(color, sum, s); 
			}

			ENDCG
		}
	}

	FallBack Off
}
