Shader "Fullscreen/Outlines"
{
    Properties
    {
        _KernelSize ("KernelSize", Float) = 15
        _ShapeRatio ("ShapeRatio", Float) = 1.6
        _Alpha ("Alpha", Float) = 2.5
        _EdgeColor ("EdgeColor", Color) = (0,0,0,1)
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline"}
        LOD 100
        ZTest Always ZWrite Off Cull Off

        Pass
        {
            Name "Outlines"
            
            HLSLPROGRAM
            #pragma vertex Vertex
            #pragma fragment Fragment
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DeclareDepthTexture.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DeclareNormalsTexture.hlsl"
            #include "Packages/com.unity.render-pipelines.core/Runtime/Utilities/Blit.hlsl"
            
            float _KernelSize;
            float _ShapeRatio;
            float _Alpha;
            float4 _EdgeColor;
            struct VertexToFragment
            {
                float4 PositionCS : SV_POSITION;
                float2 Texcoord : TEXCOORD0;
                float3 ViewSpaceDir : TEXCOORD1;
            };
            
            VertexToFragment Vertex(Attributes input)
            {
                VertexToFragment output;
                output.PositionCS = GetFullScreenTriangleVertexPosition(input.vertexID);
                output.Texcoord = GetFullScreenTriangleTexCoord(input.vertexID);
                float3 viewPos = ComputeViewSpacePosition(output.Texcoord, 1.0, UNITY_MATRIX_I_P);
                output.ViewSpaceDir = viewPos;
                
                return output;
            }
            float InverseLerp(float a, float b, float v)
            {
                return (v - a) / (b - a);
            }
            float4 Fragment(VertexToFragment input) : SV_Target
            {
                UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input);
                float2 texelSize = _BlitTexture_TexelSize.xy;
                float centerWeight = 0;
                float halfKernelSize = floor(_KernelSize / 2);
                float halfKernelSizeSquared = halfKernelSize * halfKernelSize / 4;
                float3 normalSamples = float3(0, 0, 0);
                float depthSamples = 0;
                float2 rotationVector = float2(cos(_Alpha), sin(_Alpha));
                for (float y = -halfKernelSize; y <= halfKernelSize; y++)
                {
                    for (float x = -halfKernelSize; x <= halfKernelSize; x++)
                    {
                        float2 markerPoint = float2(dot(rotationVector, float2(x, y)), dot(rotationVector, float2(y, -x)) / _ShapeRatio);
                        if (dot(markerPoint, markerPoint) > halfKernelSizeSquared) continue;
                        centerWeight++;
                        float2 samplePosition = input.Texcoord + float2(x, y) * texelSize;
                        normalSamples -= SampleSceneNormals(samplePosition);
                        depthSamples -= LinearEyeDepth(SampleSceneDepth(samplePosition), _ZBufferParams);
                    }
                }
                normalSamples += SampleSceneNormals(input.Texcoord) * centerWeight;
                depthSamples += LinearEyeDepth(SampleSceneDepth(input.Texcoord), _ZBufferParams) * centerWeight;
                centerWeight = 1 / centerWeight;
                normalSamples *= centerWeight;
                depthSamples *= centerWeight;
                float normalEdge = max(normalSamples.x, max(normalSamples.y, normalSamples.z));
                normalEdge = InverseLerp(0.15, 0.2, normalEdge);
                depthSamples = InverseLerp(2, 10, depthSamples);
                float edge = max(normalEdge, depthSamples);
                return lerp(SAMPLE_TEXTURE2D_X(_BlitTexture, sampler_LinearClamp, input.Texcoord), _EdgeColor, saturate(edge));
            }
            ENDHLSL
        }
    }
}