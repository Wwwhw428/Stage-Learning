Shader "Textures/DiffuseTextureShader"
{
    Properties
    {
        _Color ("Color Tint", Color) = (1,1,1,1)
        _MainTex ("Texture", 2D) = "white" {}
        _Specular ("Specular Color", Color) = (1, 1, 1, 1)
        _Gloss ("Smoothness", Range(1.0, 256)) = 20
    }
    SubShader
    {
        Pass
        {
            Tags {"LightMode" = "ForwardBase"}

            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "Lighting.cginc"

            struct a2v
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float3 worldNormal : TEXCOORD0;
                float3 worldPos : TEXCOORD1;
                float2 uv : TEXCOORD2;
            };

            fixed4 _Color;
            sampler2D _MainTex;
            float4 _MainTex_ST;
            fixed4 _Specular;
            float _Gloss;

            v2f vert (a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                o.worldPos = UnityObjectToWorldDir(v.vertex.xyz);

                o.uv = v.uv.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                // o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed3 worldNormal = normalize(i.worldNormal);
                fixed3 worldLightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));
                fixed3 worldViewDir = normalize(UnityWorldSpaceViewDir(i.worldPos));
                fixed3 halfDir = normalize(worldLightDir + worldViewDir);

                fixed3 albedo = tex2D(_MainTex, i.uv).rgb * _Color.rgb;
                fixed3 diffuse = albedo * _LightColor0.rgb * saturate(dot(worldNormal, worldLightDir));
                fixed3 specular = _Specular.rgb * _LightColor0.rgb * pow(saturate(dot(worldNormal, halfDir)), _Gloss);
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * albedo;

                return fixed4(diffuse + specular + ambient, 1.0);
            }
            ENDCG
        }
    }
}
