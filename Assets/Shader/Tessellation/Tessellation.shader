Shader "Tessellation/Tessellation"
{
    Properties
    {
        _Color ("Color Tint", Color) = (1, 1, 1, 1)
        _Tessellation ("Tessellation", Range(1, 164)) = 1
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque" "LightMode" = "ForwardBase" }

        Pass
        {
            CGPROGRAM

            // 使用细分时的最低着色器目标级别为4.6。如果我们不手动设置，Unity将发出警告并自动使用该级别。
            #pragma target 4.6
            #pragma vertex vert
            #pragma fragment frag
            #pragma hull HullProgram
            #pragma domain DomainProgram

            struct a2v
            {
                float4 vertex : POSITION;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
            };

            struct tessellationFactors
            {
                float edges[3] : SV_TESSFACTOR;
                float inside : SV_INSIDETESSFACTOR;
            };

            a2v vert(a2v i)
            {
                return i;
            }

            float _Tessellation;
            
            tessellationFactors PatchConstantFunction(InputPatch < a2v, 3 > patch)
            {
                tessellationFactors f;
                f.edges[0] = _Tessellation;
                f.edges[1] = _Tessellation;
                f.edges[2] = _Tessellation;
                f.inside = _Tessellation;

                return f;
            }

            [UNITY_domain("tri")]
            [UNITY_outputcontrolpoints(3)]
            [UNITY_outputtopology("triangle_cw")]
            [UNITY_partitioning("integer")]
            [UNITY_patchconstantfunc("PatchConstantFunction")]
            a2v HullProgram(InputPatch < a2v, 3 > patch, uint id : SV_OUTPUTCONTROLPOINTID)
            {
                return patch[id];
            }
            
            [UNITY_domain("tri")]
            v2f DomainProgram(
                tessellationFactors factors,
                OutputPatch < a2v, 3 > patch,
                float3 barycentricCoordinates : SV_DOMAINLOCATION)
            {
                v2f o;

                #define DOMAIN_PROGRAM_INTEPOLATE(fieldName) o.fieldName = \
                    patch[0].fieldName * barycentricCoordinates.x + \
                    patch[1].fieldName * barycentricCoordinates.y + \
                    patch[2].fieldName * barycentricCoordinates.z;
                
                DOMAIN_PROGRAM_INTEPOLATE(vertex)

                o.vertex = UnityObjectToClipPos(o.vertex);

                return o;
            }

            fixed4 _Color;

            fixed4 frag(v2f i) : SV_Target
            {
                return _Color;
            }
            ENDCG

        }
    }
}
