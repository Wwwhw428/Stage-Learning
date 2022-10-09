Shader "StencilTest/Red Shader"
{
    SubShader
    {
        Tags { "RenderType" = "Opaque" "Queue" = "Geometry" }
        pass
        {
            Stencil
            {
                Ref 2
                Comp Always
                Pass replace
            }

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

            v2f vert(a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                return o;
            }

            fixed4 frag(v2f i) : SV_TARGET
            {
                return fixed4(1, 0, 0, 1);
            }
            ENDCG

        }
    }
}