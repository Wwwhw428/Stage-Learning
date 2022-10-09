Shader "StencilTest/Object OutLine"
{
    Properties
    {
        _Color ("Color Tint", Color) = (1, 1, 1, 1)
        _OutLine ("Outline Length", Range(0.1, 1.0)) = 0.2
        _OColor ("OutLine Color", Color) = (1, 0, 0, 1)
    }
    SubShader
    {
        Tags { "RenderType" = "Opeaque" "Queue" = "Transparent"}

        // render model
        pass
        {
            Stencil
            {
                Ref 1
                Comp Always
                Pass replace
            }

            Blend SrcAlpha OneMinusSrcAlpha 

            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            struct a2v
            {
                float4 vertex : POSITION;
            };
            struct v2f
            {
                float4 pos : SV_POSITION;
            };

            fixed4 _Color;

            v2f vert(a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                return o;
            }
            fixed4 frag(v2f i) : SV_TARGET
            {
                return _Color;
            }
            ENDCG

        }

        pass
        {
            Stencil
            {
                Ref 1
                Comp NotEqual
                Pass keep
            }

            Cull Off
            ZWrite Off
            
            Blend SrcAlpha OneMinusSrcAlpha

            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            struct a2v
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };
            struct v2f
            {
                float4 pos : SV_POSITION;
            };

            float _OutLine;
            fixed4 _OColor;

            v2f vert(a2v v)
            {
                v2f o;
                float4 vertex = v.vertex;
                vertex.xyz += normalize(v.normal) * _OutLine;
                o.pos = UnityObjectToClipPos(vertex);
                return o;
            }
            fixed4 frag(v2f i) : SV_TARGET
            {
                return _OColor;
            }

            ENDCG

        }
    }
}