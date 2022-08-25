Shader "Illumination models/Test Shader"
{
    Properties
    {
        _Color ("Color Tint", Color) = (1, 1, 1, 1)
        _Specular ("Specular Color", Color) = (1, 1, 1, 1)
        _Gloss ("Smoothness", Range(8.0, 256)) = 20
        [Toggle(_LAMBERT_ON)] _Lambert ("Lambert", int) = 0
        [Toggle(_HALF_LAMBERT_ON)] _Half_Lambert ("Half Lambert", int) = 0
        [Toggle(_PHONG_ON)] _Phong ("Phong", int) = 0
        [Toggle(_BILLING_PHONG_ON)] _Billing_Phong ("Billing Phong", int) = 0
    }
    SubShader
    {
        pass
        {
            Tags { "LightMode" = "ForwardBase" }

            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag
            #pragma shader_feature _LAMBERT_ON
            #pragma shader_feature _HALF_LAMBERT_ON
            #pragma shader_feature _PHONG_ON
            #pragma shader_feature _BILLING_PHONG_ON

            #include "Lighting.cginc"

            fixed4 _Color;
            fixed4 _Specular;
            float _Gloss;

            struct a2v
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 texcoord : TEXCOORD0;
                float3 tangent : TANGENT;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float3 worldNormal : TEXCOORD0;
                float3 worldPos : TEXCOORD1;
                // float2 uv : TEXCOORD2;

            };

            v2f vert(a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                o.worldPos = UnityObjectToWorldDir(v.vertex.xyz);

                return o;
            }

            fixed4 frag(v2f i) : SV_TARGET
            {
                fixed3 worldNormal = normalize(i.worldNormal);
                fixed3 worldLightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));

                fixed3 diffuse = (0, 0, 0);
                fixed3 ambient = (0, 0, 0);
                fixed3 specular = (0, 0, 0);

                // ############# lambert光照模型 ###############
                #if defined(_LAMBERT_ON)
                    diffuse = _LightColor0.rgb * _Color.rgb * saturate(dot(worldNormal, worldLightDir));
                #endif

                // ############# Half Lambert光照模型 #############
                #if defined(_HALF_LAMBERT_ON)
                    diffuse = _LightColor0.rgb * _Color.rgb * (dot(worldNormal, worldLightDir) * 0.5 + 0.5);
                #endif

                // ############# Phong光照模型 #############
                #if defined(_PHONG_ON)
                    fixed3 worldViewDir = normalize(UnityWorldSpaceViewDir(i.worldPos));
                    fixed3 reflectDir = reflect(-worldLightDir, worldNormal);

                    diffuse = _LightColor0.rgb * _Color.rgb * saturate(dot(worldNormal, worldLightDir));
                    specular = _LightColor0.rgb * _Specular.rgb * pow(saturate(dot(worldViewDir, reflectDir)), _Gloss);
                #endif

                // ############# Billing Phong光照模型 #############
                #if defined(_BILLING_PHONG_ON)
                    fixed3 worldViewDir = normalize(UnityWorldSpaceViewDir(i.worldPos));
                    fixed3 halfDir = normalize(worldViewDir + worldLightDir);

                    diffuse = _LightColor0.rgb * _Color.rgb * saturate(dot(worldNormal, worldLightDir));
                    specular = _LightColor0.rgb * _Specular.rgb * pow(saturate(dot(worldNormal, halfDir)), _Gloss);
                #endif


                return fixed4(ambient + diffuse + specular, 1.0);
            }

            ENDCG

        }
    }
}