Shader "PBR/MyStandard"
{
    Properties
    {
        _Color("Color", Color) = (1,1,1,1)
        _MainTex("Albedo", 2D) = "white" {}

        _BumpMap("Bump Map", 2D) = "bump" {}
        _BumpScale("Bump Scale", float) = 1.0
        
        _MetallicGlossMap("Metallic", 2D) = "white" {}
        _Metallic("Metallic", Range(0, 1)) = 0.0
        
        _Specalur("Specular Color", Color) = (1,1,1,1)
        _Gloss("Gloss", Range(8.0, 256)) = 20
    }
    SubShader
    {
        pass
        {
            Tags { "LightMode" = "ForwardBase" }
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "Lighting.cginc"

            struct a2v
            {
                float4 vertex : POSITION;
                float4 normal : NORMAL;
                float4 tangent : TANGENT;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float4 TtoW0 : TEXCOORD0;
                float4 TtoW1 : TEXCOORD1;
                float4 TtoW2 : TEXCOORD2;
                float2 uv : TEXCOORD3;
            };

            fixed4 _Color;
            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _BumpMap;
            float4 _BumpMap_ST;
            float _BumpScale;
            float _Metallic;
            sampler2D _MetallicGlossMap;
            float4 _MetallicGlossMap_ST;
            fixed4 _Specalur;
            float _Gloss;

            v2f vert(a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                float3 worldNormal = UnityObjectToWorldNormal(v.normal);
                float3 worldTangent = UnityObjectToWorldDir(v.tangent.xyz);
                float3 biNormal = cross(worldNormal, worldTangent) * v.tangent.w;
                float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;

                o.TtoW0 = (worldTangent.x, biNormal.x, worldNormal.x, worldPos.x);
                o.TtoW1 = (worldTangent.y, biNormal.y, worldNormal.y, worldPos.y);
                o.TtoW2 = (worldTangent.z, biNormal.z, worldNormal.z, worldPos.z);

                return o;
            }

            fixed4 frag(v2f i) : SV_TARGET
            {
                float3 worldPos = float3(i.TtoW0.w, i.TtoW1.w, i.TtoW2.w);
                float3 worldLightDir = normalize(UnityWorldSpaceLightDir(worldPos));
                float3 worldViewDir = normalize(UnityWorldSpaceViewDir(worldPos));
                float3 halfDir = normalize(worldLightDir + worldViewDir);
                fixed3 normal = UnpackNormal(tex2D(_BumpMap, i.uv));
                normal.xy *= _BumpScale;
                normal.z = sqrt(1.0 - saturate(dot(normal.xy, normal.xy)));
                normal = normalize(half3(dot(i.TtoW0.xyz, normal), dot(i.TtoW1.xyz, normal), dot(i.TtoW2.xyz, normal)));

                fixed3 albedo = tex2D(_MainTex, i.uv).rgb * _Color.rgb;

                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb * albedo;
                fixed3 diffuse = _LightColor0.rgb * albedo * saturate(dot(normal, worldLightDir));
                fixed3 specular = _Specalur.rgb * _LightColor0.rgb * pow(saturate(dot(normal, halfDir)), _Gloss);

                return fixed4(ambient + diffuse + specular, 1.0);
            }


            ENDCG

        }
    }
}
