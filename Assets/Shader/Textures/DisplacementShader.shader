Shader "Textures/DisplacementShader"
{
    Properties
    {
        _Color ("Color Tint", Color) = (1, 1, 1, 1)
        _MainTex ("Texture", 2D) = "white" { }
        _BumpMap ("Bump Map", 2D) = "bump" { }
        _BumpScale ("Bump Scale", float) = 1.0
        _DispTex ("Displacement Map", 2D) = "black" { }
        _Displacement ("Displacement", Range(0.0, 1.0)) = 1.0
        _Specular ("Specular Color", Color) = (1, 1, 1, 1)
        _Gloss ("Gloss", Range(8.0, 256)) = 20
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque" "LightMode" = "ForwardBase"}

        Pass
        {
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "Lighting.cginc"
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float4 normal : NORMAL;
                float4 tangent : TANGENT;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float4 TtoW0 : TEXCOORD1;
                float4 TtoW1 : TEXCOORD2;
                float4 TtoW2 : TEXCOORD3;
            };

            fixed4 _Color;
            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _BumpMap;
            float4 _BumpMap_ST;
            float _BumpScale;
            sampler2D _DispTex;
            float _Displacement;
            fixed4 _Specular;
            float _Gloss;

            v2f vert(appdata v)
            {
                v2f o;
                float4 vertex = v.vertex;
                float d = tex2Dlod(_DispTex, float4(v.uv, 0, 0)).r * _Displacement;
                vertex += v.normal * d;
                o.vertex = UnityObjectToClipPos(vertex);
                
                float3 worldPos = mul(unity_ObjectToWorld, vertex).xyz;
                float3 worldNormal = UnityObjectToWorldNormal(v.normal);
                float3 worldTangent = UnityObjectToWorldDir(v.tangent.xyz);
                float3 worldBiNormal = cross(worldNormal, worldTangent) * v.tangent.w;
                
                o.TtoW0 = float4(worldTangent.x, worldBiNormal.x, worldNormal.x, worldPos.x);
                o.TtoW1 = float4(worldTangent.y, worldBiNormal.y, worldNormal.y, worldPos.y);
                o.TtoW2 = float4(worldTangent.z, worldBiNormal.z, worldNormal.z, worldPos.z);

                o.uv.xy = _MainTex_ST.xy * v.uv + _MainTex_ST.zw;
                o.uv.zw = _BumpMap_ST.xy * v.uv + _BumpMap_ST.zw;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float3 worldPos = float3(i.TtoW0.w, i.TtoW1.w, i.TtoW2.w);
                fixed3 worldLightDir = normalize(UnityWorldSpaceLightDir(worldPos));
                fixed3 worldViewDir = normalize(UnityWorldSpaceViewDir(worldPos));
                fixed3 halfDir = normalize(worldLightDir + worldViewDir);

                float3 normal = UnpackNormal(tex2D(_BumpMap, i.uv.zw));
                normal.xy *= _BumpScale;
                normal.z = sqrt(1.0 - saturate(dot(normal.xy, normal.xy)));
                fixed3 worldNormal = normalize(float3(dot(i.TtoW0, normal), dot(i.TtoW1, normal), dot(i.TtoW2, normal)));

                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb;

                fixed4 difCol = tex2D(_MainTex, i.uv.xy);
                fixed3 diffuse = _Color.rgb * difCol.rgb * _LightColor0.rgb * saturate(dot(worldNormal, worldLightDir));

                fixed3 specular = _Specular.rgb * _LightColor0.rgb * pow(saturate(dot(worldNormal, halfDir)), _Gloss);

                return fixed4(ambient + diffuse + specular, 1.0);
            }
            ENDCG

        }
    }
}
